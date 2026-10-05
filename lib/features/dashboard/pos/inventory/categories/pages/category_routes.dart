import 'package:go_router/go_router.dart';

// Pages
import 'category_form_page.dart';
import 'category_list_page.dart';
import 'category_show_page.dart';

final List<GoRoute> categoryRoutes = [
  GoRoute(
    path: '/dashboard/pos/inventory/categories',
    name: 'Categorías',
    builder: (context, state) => const CategoryListPage(),
  ),
  GoRoute(
    path: '/dashboard/pos/inventory/categories/create',
    builder: (context, state) => const CategoryFormPage(),
  ),
  GoRoute(
    path: '/dashboard/pos/inventory/categories/:id',
    builder: (context, state) =>
        CategoryShowPage(id: state.pathParameters['id'] ?? ''),
  ),
  GoRoute(
    path: '/dashboard/pos/inventory/categories/:id/edit',
    builder: (context, state) =>
        CategoryFormPage(id: state.pathParameters['id'] ?? ''),
  ),
];
