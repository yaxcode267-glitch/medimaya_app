import 'package:go_router/go_router.dart';

import 'administration/roles/pages/roles_routes.dart';
import 'administration/users/users_routes.dart';
import 'pos/inventory/categories/pages/category_routes.dart';
import 'pos/inventory/products/pages/product_routes.dart';

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
  ...rolesRoutes,
  ...categoryRoutes,
  ...productRoutes,
];
