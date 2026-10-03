import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.value(
              context,
              mobile: 24,
              tablet: 40,
              desktop: 80,
            ),
            vertical: Responsive.value(
              context,
              mobile: 40,
              tablet: 60,
              desktop: 0,
            ),
          ),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: _buildLogo(context))),
                    SizedBox(
                      width: Responsive.value(
                        context,
                        mobile: 24,
                        tablet: 40,
                        desktop: 80,
                      ),
                    ),
                    Expanded(child: _buildOptions(context)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(context),
                    SizedBox(
                      height: Responsive.value(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                    ),
                    _buildOptions(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final maxWidth = Responsive.value(
      context,
      mobile: 180,
      tablet: 220,
      desktop: 320,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        cacheWidth: (maxWidth * MediaQuery.devicePixelRatioOf(context)).round(),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final cards = [
      (
        onTap: () => context.go('/login/paciente'),
        icon: Icons.person_outline,
        title: 'Paciente',
        subtitle: 'Agenda tus citas y consulta tu historial.',
        bgColor: AppColors.colorPrimario,
        iconBgColor: Colors.white.withValues(alpha: 0.15),
        iconColor: Colors.white,
        titleColor: Colors.white,
        subtitleColor: Colors.white.withValues(alpha: 0.75),
        arrowColor: Colors.white,
        border: null,
      ),
      (
        onTap: () => context.go('/login'),
        icon: Icons.business_center_outlined,
        title: 'Colaborador',
        subtitle: 'Gestiona pacientes, consultas y agendas.',
        bgColor: AppColors.colorFondo,
        iconBgColor: AppColors.colorPrimario.withValues(alpha: 0.1),
        iconColor: AppColors.colorSecundario,
        titleColor: AppColors.colorTexto,
        subtitleColor: AppColors.colorTextoSecundario,
        arrowColor: AppColors.colorOutlineVariant,
        border: Border.all(color: AppColors.colorOutlineVariant),
      ),
    ];

    return Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          '¿Cómo quieres continuar?',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.value(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 28,
            ),
            fontWeight: FontWeight.bold,
            color: AppColors.colorTexto,
          ),
        ),
        SizedBox(
          height: Responsive.value(context, mobile: 6, tablet: 8, desktop: 10),
        ),
        Text(
          'Selecciona una opción para ingresar.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.value(
              context,
              mobile: 13,
              tablet: 14,
              desktop: 16,
            ),
            color: AppColors.colorTextoSecundario,
          ),
        ),
        SizedBox(
          height: Responsive.value(
            context,
            mobile: 28,
            tablet: 32,
            desktop: 36,
          ),
        ),
        for (final (i, card) in cards.indexed) ...[
          if (i > 0)
            SizedBox(
              height: Responsive.value(
                context,
                mobile: 10,
                tablet: 12,
                desktop: 14,
              ),
            ),
          _buildCard(context, card),
        ],
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    ({
      VoidCallback onTap,
      IconData icon,
      String title,
      String subtitle,
      Color bgColor,
      Color iconBgColor,
      Color iconColor,
      Color titleColor,
      Color subtitleColor,
      Color arrowColor,
      BoxBorder? border,
    })
    card,
  ) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: card.onTap,
        child: Container(
          padding: EdgeInsets.all(
            Responsive.value(context, mobile: 14, tablet: 16, desktop: 18),
          ),
          decoration: BoxDecoration(
            color: card.bgColor,
            borderRadius: BorderRadius.circular(16),
            border: card.border,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  Responsive.value(
                    context,
                    mobile: 10,
                    tablet: 12,
                    desktop: 14,
                  ),
                ),
                decoration: BoxDecoration(
                  color: card.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  card.icon,
                  color: card.iconColor,
                  size: Responsive.value(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
              ),
              SizedBox(
                width: Responsive.value(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: TextStyle(
                        fontSize: Responsive.value(
                          context,
                          mobile: 15,
                          tablet: 16,
                          desktop: 18,
                        ),
                        fontWeight: FontWeight.bold,
                        color: card.titleColor,
                      ),
                    ),
                    SizedBox(
                      height: Responsive.value(
                        context,
                        mobile: 3,
                        tablet: 4,
                        desktop: 5,
                      ),
                    ),
                    Text(
                      card.subtitle,
                      style: TextStyle(
                        fontSize: Responsive.value(
                          context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                        color: card.subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: card.arrowColor,
                size: Responsive.value(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
