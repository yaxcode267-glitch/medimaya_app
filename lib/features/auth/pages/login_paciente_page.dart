import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../service/auth_service.dart';
import '../widget/auth_divider.dart';

// Api
import 'package:medimaya_app/shared/api/error/api_error.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/auth_layout.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widgets
import 'package:medimaya_app/shared/ui/widget/common/app_alert.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
// Stores
import 'package:medimaya_app/features/patient/store/patient_controller.dart';

/// Longitud del PIN, en correspondencia con `PatientPin::LENGTH` en la API.
const _pinLength = 6;

/// Página de acceso al portal de paciente: fecha de nacimiento + PIN.
class LoginPacientePage extends StatefulWidget {
  const LoginPacientePage({super.key});

  @override
  State<LoginPacientePage> createState() => _LoginPacientePageState();
}

class _LoginPacientePageState extends State<LoginPacientePage> {
  final _formKey = GlobalKey<FormState>();

  final _birthDateController = TextEditingController();
  final _pinController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _birthDateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      await AuthService().patientLogin(
        birthDate: _birthDateController.text.trim(),
        pin: _pinController.text,
      );

      if (!mounted) return;
      await PatientController.instance.load();

      if (!mounted) return;
      context.go('/paciente');
    } on ApiError catch (e) {
      AppAlert.error(e.message);
    } catch (_) {
      AppAlert.error('Ha ocurrido un error inesperado.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validatePin(String? value) {
    final pin = value?.trim() ?? '';
    if (pin.isEmpty) return null;

    return RegExp('^\\d{$_pinLength}\$').hasMatch(pin)
        ? null
        : 'El PIN tiene $_pinLength dígitos';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      body: AuthLayout(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Column(
                children: [
                  Text(
                    'Portal de paciente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorTexto,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ingresa con tu fecha de nacimiento y tu PIN.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.colorTextoSecundario,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              AppInput(
                name: 'Fecha de nacimiento',
                hint: 'AAAA-MM-DD',
                controller: _birthDateController,
                date: true,
                required: true,
                // La API rechaza fechas futuras.
                dateRange: DateTimeRange(
                  start: DateTime(now.year - 100),
                  end: now,
                ),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              AppInput(
                name: 'PIN',
                hint: List.filled(_pinLength, '•').join(),
                controller: _pinController,
                password: true,
                required: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_pinLength),
                ],
                helperText:
                    'PIN de $_pinLength dígitos entregado por la clínica.',
                textInputAction: TextInputAction.done,
                validator: _validatePin,
                onFieldSubmitted: (_) => _handleLogin(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  onPressed: _loading ? null : _handleLogin,
                  style: ButtonThemes.primary(),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Entrar al portal',
                          style: TextStyle(fontSize: 26),
                        ),
                ),
              ),

              const SizedBox(height: 28),

              const AuthDivider(
                pregunta: '¿Eres colaborador?',
                accion: 'Acceder como colaborador',
                href: '/login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
