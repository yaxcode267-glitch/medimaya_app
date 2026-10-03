import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

/// Separador "¿Eres X?" que enlaza con el otro tipo de acceso.
class AuthDivider extends StatelessWidget {
  final String pregunta;
  final String accion;
  final String href;

  const AuthDivider({
    super.key,
    required this.pregunta,
    required this.accion,
    required this.href,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.colorOutlineVariant),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'o',
                style: TextStyle(
                  color: AppColors.colorTextoSecundario.withValues(alpha: 0.8),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.colorOutlineVariant),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pregunta,
              style: const TextStyle(color: AppColors.colorTextoSecundario),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () => context.go(href),
              child: Text(
                accion,
                style: const TextStyle(
                  color: AppColors.colorPrimario,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
