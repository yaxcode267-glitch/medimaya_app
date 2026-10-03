import 'package:flutter/material.dart' hide DateUtils;
import 'package:go_router/go_router.dart';

// Auth
import 'package:medimaya_app/features/auth/service/auth_service.dart';

// Model / Store
import '../model/patient_profile.dart';
import '../store/patient_controller.dart';

// Utils
import 'package:medimaya_app/shared/utils/date_utils.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widgets
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/common/confirm_dialog.dart';
import 'package:medimaya_app/shared/ui/widget/common/info_card.dart';

/// Portal de paciente: la ficha de sesión. Los módulos clínicos (citas,
/// historial) se cuelgan de aquí.
class PatientPortalPage extends StatefulWidget {
  const PatientPortalPage({super.key});

  @override
  State<PatientPortalPage> createState() => _PatientPortalPageState();
}

class _PatientPortalPageState extends State<PatientPortalPage> {
  final _patient = PatientController.instance;

  @override
  void initState() {
    super.initState();
    _patient.load();
  }

  Future<void> _logout() async {
    final confirmed = await AppConfirm.show(
      context: context,
      title: 'Cerrar sesión',
      message: '¿Seguro que deseas salir del portal de paciente?',
      confirmText: 'Cerrar sesión',
      tone: ConfirmTone.warning,
    );

    if (confirmed != true || !mounted) return;

    await AuthService().patientLogout();
    _patient.reset();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorFondoBajo,
      appBar: AppBar(
        title: const Text('Portal de paciente'),
        backgroundColor: AppColors.colorFondo,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _patient,
          builder: (context, _) {
            if (_patient.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = _patient.profile;
            if (profile == null) {
              return Center(
                child: AppEmptyState(
                  icon: Icons.person_off_outlined,
                  message: 'No pudimos cargar tu ficha. Revisa tu conexión e inténtalo de nuevo.',
                  action: FilledButton(
                    onPressed: _patient.fetch,
                    style: ButtonThemes.primary(),
                    child: const Text('Reintentar'),
                  ),
                ),
              );
            }

            return _buildContent(profile);
          },
        ),
      ),
    );
  }

  Widget _buildContent(PatientProfile profile) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                icon: Icons.favorite_outline,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, ${profile.firstName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.colorTexto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aquí verás tus citas y tu historial clínico.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.colorTextoSecundario,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Mis datos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.colorTexto,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGrid(profile),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _logout,
                style: ButtonThemes.secondary(),
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(PatientProfile profile) {
    final items = [
      (
        icon: Icons.badge_outlined,
        label: 'Nombre completo',
        value: profile.fullName.isEmpty ? '-' : profile.fullName,
      ),
      (
        icon: Icons.cake_outlined,
        label: 'Fecha de nacimiento',
        value: profile.age > 0
            ? '${DateUtils.formatDate(profile.birthDate)} (${profile.age} años)'
            : DateUtils.formatDate(profile.birthDate),
      ),
      (icon: Icons.wc_outlined, label: 'Género', value: profile.gender),
      (
        icon: Icons.history,
        label: 'Último acceso',
        value: profile.lastLoginAt == null
            ? 'Primer acceso'
            : DateUtils.formatDateTime(profile.lastLoginAt),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final single = constraints.maxWidth < 560;
        final width = single
            ? constraints.maxWidth
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: InfoCard(
                  icon: item.icon,
                  label: item.label,
                  value: item.value,
                ),
              ),
          ],
        );
      },
    );
  }
}
