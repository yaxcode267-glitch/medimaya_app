import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'router/router.dart';
import 'shared/api/network/http_client.dart';
import 'shared/ui/themes/app_colors.dart';
import 'shared/ui/themes/button_themes.dart';

// Services
import 'features/auth/service/auth_service.dart';

// Stores
import 'features/dashboard/profile/store/profile_controller.dart';
import 'features/patient/store/patient_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  HttpClient.configure(
    refresh: () => AuthService().refresh(),
    onSessionExpired: () {
      ProfileController.instance.reset();
      PatientController.instance.reset();
      // La sesión caída puede ser de cualquiera de los dos guards, así que se
      // vuelve a la pantalla que pregunta cuál es.
      appRouter.go('/');
    },
  );

  unawaited(ProfileController.instance.load());
  runApp(const MediMayaApp());
}

class MediMayaApp extends StatelessWidget {
  const MediMayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MediMaya',
      theme: ThemeData(
        filledButtonTheme: FilledButtonThemeData(style: ButtonThemes.primary()),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonThemes.primary(),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonThemes.secondary(),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: ButtonThemes.textStyle,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            iconSize: 24,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorPrimario),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.colorFondo,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.colorOutlineVariant),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      locale: const Locale('es'),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es')],
    );
  }
}
