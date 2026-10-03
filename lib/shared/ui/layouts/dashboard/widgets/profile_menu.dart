import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  final MenuController _controller = MenuController();

  void _openProfile() {
    _controller.close();
    context.go('/dashboard/profile');
  }

  @override
  Widget build(BuildContext context) {
    final profile = ProfileController.instance;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      child: MenuAnchor(
        controller: _controller,
        alignmentOffset: const Offset(8, -4),
        style: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.colorFondo),
          elevation: const WidgetStatePropertyAll(2),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.colorOutlineVariant),
            ),
          ),
        ),
        menuChildren: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName.isEmpty ? 'Usuario' : profile.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorTexto,
                  ),
                ),
                Text(
                  profile.email.isNotEmpty ? profile.email : profile.roleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.colorOutlineVariant),
          MenuItemButton(
            leadingIcon: const Icon(Icons.person_outline, size: 20),
            onPressed: _openProfile,
            child: const Text('Editar perfil'),
          ),
          MenuItemButton(
            style: ButtonStyle(
              foregroundColor: const WidgetStatePropertyAll(AppColors.error),
            ),
            leadingIcon: const Icon(Icons.logout, size: 20),
            onPressed: () {
              _controller.close();
              widget.onLogout();
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
        builder: (context, controller, child) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.colorPrimario,
                    child: Text(
                      profile.initials,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          profile.fullName.isEmpty
                              ? 'Usuario'
                              : profile.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorTexto,
                          ),
                        ),
                        Text(
                          profile.roleName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.colorTextoSecundario,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_more,
                    size: 20,
                    color: AppColors.colorTextoSecundario,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
