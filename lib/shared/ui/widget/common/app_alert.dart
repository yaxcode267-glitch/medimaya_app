import 'package:flutter/material.dart';
// Const
import 'package:medimaya_app/router/const.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

enum AlertType { info, error, warning, success }

class AppAlert {
  static const _config = {
    AlertType.info: (
      color: AppColors.informacion,
      icon: Icons.info_outline_rounded,
    ),
    AlertType.error: (
      color: AppColors.error,
      icon: Icons.error_outline_rounded,
    ),
    AlertType.warning: (
      color: AppColors.advertencia,
      icon: Icons.warning_amber_rounded,
    ),
    AlertType.success: (
      color: AppColors.exito,
      icon: Icons.check_circle_outline_rounded,
    ),
  };

  static void success(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) => show(
    type: AlertType.success,
    title: '¡Éxito!',
    message: message,
    duration: duration,
  );

  static void error(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) => show(
    type: AlertType.error,
    title: '¡Ha ocurrido un error!',
    message: message,
    duration: duration,
  );

  static void warning(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) => show(
    type: AlertType.warning,
    title: '¡Atención!',
    message: message,
    duration: duration,
  );

  static void info(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) => show(
    type: AlertType.info,
    title: 'Información',
    message: message,
    duration: duration,
  );

  /// Muestra un toast centrado en la parte superior con ancho máximo,
  /// estilo y colores del sistema (success / error / warning / info).
  static void show({
    AlertType type = AlertType.success,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = appNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    final (:color, :icon) = _config[type]!;
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 16,
        right: 16,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              builder: (context, t, child) => Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * -16),
                  child: child,
                ),
              ),
              child: _AlertCard(
                color: color,
                icon: icon,
                title: title,
                message: message,
                onClose: () => entry.remove(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _AlertCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String? title;
  final String message;
  final VoidCallback onClose;

  const _AlertCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.colorOutlineVariant),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.10),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title ?? '',
                              style: const TextStyle(
                                color: AppColors.colorTexto,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message,
                              style: const TextStyle(
                                color: AppColors.colorTextoSecundario,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.colorOutlineVariant,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
