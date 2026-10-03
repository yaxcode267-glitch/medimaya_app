import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Themes
import '../themes/app_colors.dart';
import '../themes/responsive.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final logoCacheWidth = (200 * MediaQuery.devicePixelRatioOf(context))
        .round();

    return Scaffold(
      body: Row(
        children: [
          // Panel izquierdo
          if (isDesktop)
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/login.jpg'),

                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.colorSecundario.withValues(alpha: 0.9),
                        AppColors.colorPrimario.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                        cacheWidth: logoCacheWidth,
                      ),

                      const Spacer(),

                      const Text(
                        'Plataforma médica digital',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Tu salud, nuestra prioridad.\n'
                        'Gestión médica inteligente al alcance de tu mano.',
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        '✓  Citas médicas en línea',
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        '✓  Historial clínico centralizado',
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        '✓  Recetas y resultados digitales',
                        style: TextStyle(color: Colors.white70),
                      ),

                      const Spacer(),

                      const Text(
                        'Disponible en',
                        style: TextStyle(color: Colors.white54),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Image.asset(
                            'assets/images/icons/google_play.png',
                            height: 45,
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'assets/images/icons/app_store.png',
                            height: 45,
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '© ${DateTime.now().year} MediMaya. '
                        'Todos los derechos reservados.',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Panel derecho
          Expanded(
            flex: 6,
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.colorPrimario.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: Column(
                            children: [
                              if (!isDesktop) ...[
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 200,
                                  cacheWidth: logoCacheWidth,
                                ),
                                const SizedBox(height: 20),
                              ],

                              child,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
