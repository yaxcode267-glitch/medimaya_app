import 'package:flutter/material.dart';

// Themes
import '../../themes/app_colors.dart';
import '../../themes/button_themes.dart';

enum ConfirmTone { warning, danger }

class AppConfirm {
  static Future<bool?> show({
    required BuildContext context,
    String title = '¿Estás seguro?',
    String? message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    ConfirmTone tone = ConfirmTone.warning,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => _ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        tone: tone,
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;
  final ConfirmTone tone;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final isDanger = tone == ConfirmTone.danger;
    final confirmColor = isDanger ? AppColors.error : AppColors.colorPrimario;
    final iconBgColor = isDanger
        ? AppColors.error.withValues(alpha: 0.12)
        : AppColors.colorPrimarioContainer;
    final iconColor = isDanger ? AppColors.error : AppColors.colorPrimario;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 400,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.colorFondo,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.colorOutlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorTexto,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.colorTextoSecundario,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: ButtonThemes.minimumSize,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        foregroundColor: AppColors.colorTexto,
                        side: const BorderSide(
                          color: AppColors.colorOutlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(cancelText),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        minimumSize: ButtonThemes.minimumSize,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(confirmText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
