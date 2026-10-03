import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

/// Superficie base de contenido (formularios, cabeceras, detalle).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color borderColor;
  final Color? iconBg;
  final Color iconColor;

  /// Si se define, dibuja un contenedor redondeado con el icono
  /// encima de [child].
  final IconData? icon;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = AppColors.colorFondo,
    this.borderColor = AppColors.colorOutlineVariant,
    this.icon,
    this.iconBg = AppColors.colorPrimarioContainer,
    this.iconColor = AppColors.colorPrimario,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: color,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 24, color: iconColor),
                ),
                const SizedBox(height: 16),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
