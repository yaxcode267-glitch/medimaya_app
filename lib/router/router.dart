import 'package:go_router/go_router.dart';

// Routers
import '../features/home/pages/home_page.dart';
import '../features/auth/model/auth_model.dart';
import '../features/auth/pages/auth_routes.dart';
import '../features/auth/service/auth_service.dart';
import '../features/dashboard/dashboard_routes.dart';
import '../features/patient/pages/patient_routes.dart';

// Stores
import '../features/dashboard/profile/store/profile_controller.dart';

//Const
import 'package:medimaya_app/router/const.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    ...authRoutes,
    ...patientRoutes,
    ...dashboardRoutes,
  ],
  redirect: (context, state) async {
    final path = state.matchedLocation;
    final session = await AuthService.currentSession();

    if (_isGuest(path)) {
      return switch (session) {
        null => null,
        SessionKind.patient => '/paciente',
        // El personal necesita la ficha para entrar. Si no se puede cargar, se
        // queda en el login: reenviarlo a /dashboard volvería a rebotar aquí.
        SessionKind.staff => await _canUseDashboard() ? '/dashboard' : null,
      };
    }

    final isPatientArea = path == '/paciente' || path.startsWith('/paciente/');
    final isStaffArea = path == '/dashboard' || path.startsWith('/dashboard/');

    if (isPatientArea || isStaffArea) {
      if (session == null) return isPatientArea ? '/login/paciente' : '/login';

      // Cada guard sirve solo a su área: el paciente no entra al dashboard del
      // personal, ni al revés.
      if (isPatientArea && session != SessionKind.patient) return '/dashboard';
      if (isStaffArea && session != SessionKind.staff) return '/paciente';
    }

    if (isStaffArea && !await _canUseDashboard()) return '/login';

    return null;
  },
);

bool _isGuest(String path) => path == '/login' || path == '/login/paciente';

Future<bool> _canUseDashboard() async {
  await ProfileController.instance.load();
  return ProfileController.instance.loaded;
}
