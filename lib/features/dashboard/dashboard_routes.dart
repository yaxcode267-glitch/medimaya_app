import 'package:go_router/go_router.dart';

import 'administration/users/users_routes.dart';

// Pages
import 'home/pages/dashboard_home_page.dart';
import 'profile/pages/profile_page.dart';

final List<GoRoute> dashboardRoutes = [
  GoRoute(
    path: '/dashboard',
    name: 'Inicio',
    builder: (context, state) => const DashboardHomePage(),
  ),
  GoRoute(
    path: '/dashboard/profile',
    name: 'Perfil',
    builder: (context, state) => const ProfilePage(),
  ),
  ...usersRoutes,
];
