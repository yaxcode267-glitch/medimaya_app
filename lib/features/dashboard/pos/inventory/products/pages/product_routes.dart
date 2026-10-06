import 'package:go_router/go_router.dart';

// Pages
import 'product_form_page.dart';
import 'product_list_page.dart';
import 'product_show_page.dart';

final List<GoRoute> productRoutes = [
  GoRoute(
    path: '/dashboard/pos/inventory/products',
    name: 'Productos',
    builder: (context, state) => const ProductListPage(),
  ),
  GoRoute(
    path: '/dashboard/pos/inventory/products/create',
    builder: (context, state) => const ProductFormPage(),
  ),
  GoRoute(
    path: '/dashboard/pos/inventory/products/:id',
    builder: (context, state) =>
        ProductShowPage(id: state.pathParameters['id'] ?? ''),
  ),
  GoRoute(
    path: '/dashboard/pos/inventory/products/:id/edit',
    builder: (context, state) =>
        ProductFormPage(id: state.pathParameters['id'] ?? ''),
  ),
];
