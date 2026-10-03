import 'package:flutter/material.dart';
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
import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';

/// Página donde el colaborador escribe su correo y contraseña.
class LoginColaboradorPage extends StatefulWidget {
  const LoginColaboradorPage({super.key});

  @override
  State<LoginColaboradorPage> createState() => _LoginColaboradorPageState();
}

class _LoginColaboradorPageState extends State<LoginColaboradorPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Corta los envíos dobles por doble toque.
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      await ProfileController.instance.load();

      if (!mounted) return;
      context.go('/dashboard');
    } on ApiError catch (e) {
      AppAlert.error(e.message);
    } catch (_) {
      AppAlert.error('Ha ocurrido un error inesperado.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(value.trim());
    return isValid ? null : 'Ingresa un correo electrónico válido';
  }

  @override
  Widget build(BuildContext context) {
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
                    'Bienvenido, colaborador',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorTexto,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ingresa con tu correo electrónico y contraseña.',
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
                name: 'Correo electrónico',
                hint: 'tu@correo.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                required: true,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),

              const SizedBox(height: 16),

              AppInput(
                name: 'Contraseña',
                hint: '••••••••',
                controller: _passwordController,
                password: true,
                required: true,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleLogin(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 55,
                width: double.infinity,
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
                          'Iniciar sesión',
                          style: TextStyle(fontSize: 26),
                        ),
                ),
              ),

              const SizedBox(height: 28),

              const AuthDivider(
                pregunta: '¿Eres paciente?',
                accion: 'Acceder como paciente',
                href: '/login/paciente',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
