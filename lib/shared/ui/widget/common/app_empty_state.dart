import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

/// Estado vacío estándar de la app: icono circular y mensaje centrado.
class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.colorFondoBajo,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: AppColors.colorTextoSecundario),
          ),
          const SizedBox(height: 14),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.colorTextoSecundario,
              fontSize: 14,
            ),
          ),
        ),
        if (action != null) ...[const SizedBox(height: 16), action!],
      ],
    );
  }
}
