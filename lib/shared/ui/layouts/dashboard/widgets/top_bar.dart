import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    required this.isDesktop,
    required this.showBack,
  });

  final String title;
  final bool isDesktop;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.colorFondo,
        border: Border(
          bottom: BorderSide(color: AppColors.colorOutlineVariant),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop && !showBack) _menuButton(),
          if (showBack)
            IconButton(
              tooltip: 'Regresar',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.colorPrimario.withValues(alpha: 0.7),
              ),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/dashboard');
                }
              },
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorPrimario,
                ),
              ),
            ),
          ),
          if (!isDesktop && showBack) _menuButton(),
        ],
      ),
    );
  }

  Widget _menuButton() {
    return Builder(
      builder: (context) => IconButton(
        tooltip: 'Abrir menú',
        style: IconButton.styleFrom(
          backgroundColor: AppColors.colorPrimario.withValues(alpha: 0.7),
        ),
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}
