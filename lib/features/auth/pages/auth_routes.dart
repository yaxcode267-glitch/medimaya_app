import 'package:go_router/go_router.dart';

// Pages
import 'login_colaborador_page.dart';
import 'login_paciente_page.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login-colaborador',
    builder: (context, state) => const LoginColaboradorPage(),
  ),
  GoRoute(
    path: '/login/paciente',
    name: 'login-paciente',
    builder: (context, state) => const LoginPacientePage(),
  ),
];
