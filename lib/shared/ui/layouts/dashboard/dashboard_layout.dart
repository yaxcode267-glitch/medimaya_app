import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medimaya_app/features/auth/service/auth_service.dart';
import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/responsive.dart';
import 'package:medimaya_app/shared/ui/widget/common/confirm_dialog.dart';

import 'widgets/sidebar.dart';
import 'widgets/top_bar.dart';

class DashboardLayout extends StatefulWidget {
  final String title;
  final Widget child;
  final FloatingActionButton? fab;

  const DashboardLayout({
    super.key,
    required this.title,
    required this.child,
    this.fab,
  });

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  static const double maxContentWidth = 1200;

  final profile = ProfileController.instance;

  @override
  void initState() {
    super.initState();
    profile.load();
  }

  Future<void> _logout() async {
    final confirmed = await AppConfirm.show(
      context: context,
      title: 'Cerrar sesión',
      message: '¿Seguro que deseas cerrar tu sesión?',
      confirmText: 'Cerrar sesión',
      tone: ConfirmTone.warning,
    );

    if (confirmed != true || !mounted) return;

    await AuthService().logout();
    profile.reset();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: profile,
      builder: (context, _) {
        final isDesktop = Responsive.isDesktop(context);
        final path = GoRouterState.of(context).uri.path;
        final sidebar = Sidebar(path: path, onLogout: _logout);
        final padding = isDesktop ? 24.0 : 16.0;
        final fabReserve = widget.fab != null ? 88.0 : 0.0;
        final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

        return Scaffold(
          floatingActionButton: widget.fab == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: widget.fab,
                ),
          backgroundColor: AppColors.colorFondoBajo,
          drawer: isDesktop
              ? null
              : Drawer(
                  width: Sidebar.widthFor(context),
                  child: SafeArea(child: sidebar),
                ),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isDesktop) sidebar,
                Expanded(
                  child: Column(
                    children: [
                      TopBar(
                        title: widget.title,
                        isDesktop: isDesktop,
                        showBack: path != '/dashboard',
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: maxContentWidth,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                padding,
                                padding,
                                padding,
                                padding + fabReserve,
                              ),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
