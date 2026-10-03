import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';
import 'package:medimaya_app/shared/config/siderbar_config.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/model/sidebar_model.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';

import 'profile_menu.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.path, required this.onLogout});

  static const double maxWidth = 280;

  /// En pantallas estrechas el menú no debe tapar casi todo el contenido.
  static double widthFor(BuildContext context) {
    final available = MediaQuery.sizeOf(context).width;
    return math.min(maxWidth, available * 0.85);
  }

  final String path;
  final VoidCallback onLogout;

  List<SidebarSection> _sections(ProfileController profile) {
    final result = <SidebarSection>[];

    for (final entry in sidebarMenu) {
      if (entry is SidebarSection) {
        final items = entry.items
            .where(
              (item) =>
                  item.permission == null ||
                  profile.hasPermission(item.permission!),
            )
            .toList();

        if (items.isNotEmpty) {
          result.add(SidebarSection(label: entry.label, items: items));
        }
      }

      if (entry is SidebarItem) {
        if (entry.permission != null &&
            !profile.hasPermission(entry.permission!)) {
          continue;
        }

        result.add(SidebarSection(items: [entry]));
      }
    }

    return result;
  }

  bool _isActive(String route, {bool exact = false}) {
    if (exact) return path == route;
    return path == route || path.startsWith('$route/');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthFor(context),
      decoration: const BoxDecoration(
        color: AppColors.colorFondo,
        border: Border(right: BorderSide(color: AppColors.colorOutlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          Expanded(child: _menu(context)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: AppColors.colorOutlineVariant),
          ),
          ProfileMenu(onLogout: onLogout),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 55,
            cacheWidth: (55 * MediaQuery.devicePixelRatioOf(context)).round(),
          ),
          const SizedBox(width: 10),
          const Text(
            'MediMaya',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.colorPrimario,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context) {
    final profile = ProfileController.instance;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _menuItem(
          icon: Icons.home_outlined,
          title: 'Inicio',
          active: _isActive('/dashboard', exact: true),
          onTap: () => context.go('/dashboard'),
        ),
        for (final section in _sections(profile)) ...[
          if (section.label != null) _sectionLabel(section.label!),
          for (final item in section.items)
            _menuItem(
              icon: item.icon,
              title: item.title,
              badge: item.badge,
              comingSoon: item.comingSoon,
              active:
                  !item.comingSoon &&
                  item.route != null &&
                  _isActive(item.route!),
              onTap: item.comingSoon || item.route == null
                  ? null
                  : () => context.go(item.route!),
            ),
        ],
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: AppColors.colorTextoSecundario,
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required bool active,
    int? badge,
    bool comingSoon = false,
    VoidCallback? onTap,
  }) {
    final iconColor = active
        ? AppColors.colorPrimario
        : AppColors.colorTextoSecundario;
    final textColor = active ? AppColors.colorPrimario : AppColors.colorTexto;

    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: active
              ? Colors.transparent
              : AppColors.colorSuperficieAlta,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.colorPrimarioContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.colorPrimario
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Icon(icon, size: 22, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: active || badge != null
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: comingSoon
                          ? iconColor.withValues(alpha: 0.6)
                          : textColor,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimario,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (comingSoon)
                  const AppBadge(
                    label: 'Pronto',
                    color: AppColors.colorSuperficieAlta,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (comingSoon) {
      return Tooltip(message: '$title todavía no está disponible', child: row);
    }

    return row;
  }
}
