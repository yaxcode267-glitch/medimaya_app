import 'package:flutter/material.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

/// Card de información con icono, título y valor (opcional subtítulo).
///
/// Se reutiliza en detalles de entidades (roles, etc.) para mostrar
/// datos con icono destacado y estilo consistente.
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final bool isValueBold;
  final Color iconColor;
  final Color iconBg;
  final Color containerColor;
  final Color borderColor;
  final EdgeInsets padding;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.isValueBold = true,
    this.iconColor = AppColors.colorPrimario,
    this.iconBg = AppColors.colorPrimarioContainer,
    this.containerColor = AppColors.colorFondo,
    this.borderColor = AppColors.colorOutlineVariant,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isValueBold ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.colorTexto,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.colorTextoSecundario,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
