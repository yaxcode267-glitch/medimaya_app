import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimaya_app/features/auth/pages/login_colaborador_page.dart';
import 'package:medimaya_app/features/auth/pages/login_paciente_page.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

Widget _host(Widget page) => MaterialApp(home: page);

void main() {
  group('Login de paciente', () {
    testWidgets('pide fecha de nacimiento y PIN', (tester) async {
      await tester.pumpWidget(_host(const LoginPacientePage()));

      expect(find.text('Portal de paciente'), findsOneWidget);
      expect(
        find.widgetWithText(AppInput, 'Fecha de nacimiento *'),
        findsOneWidget,
      );
      expect(find.widgetWithText(AppInput, 'PIN *'), findsOneWidget);
      expect(find.text('Entrar al portal'), findsOneWidget);
    });

    testWidgets('no deja enviar sin los dos campos', (tester) async {
      await tester.pumpWidget(_host(const LoginPacientePage()));

      final submit = find.text('Entrar al portal');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();

      expect(find.text('Fecha de nacimiento es requerido'), findsOneWidget);
      expect(find.text('PIN es requerido'), findsOneWidget);
    });

    // La fecha solo se escribe con el selector, que no aplica en un test de
    // widget; aquí importa el PIN, que sí es texto libre.
    testWidgets('rechaza un PIN que no tiene 6 dígitos', (tester) async {
      await tester.pumpWidget(_host(const LoginPacientePage()));

      final pin = find.widgetWithText(AppInput, 'PIN *');
      final submit = find.text('Entrar al portal');

      await tester.enterText(pin, '123');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();

      expect(find.text('El PIN tiene 6 dígitos'), findsOneWidget);

      await tester.enterText(pin, '123456');
      await tester.tap(submit);
      await tester.pump();

      expect(find.text('El PIN tiene 6 dígitos'), findsNothing);
    });

    testWidgets('enlaza con el acceso del colaborador', (tester) async {
      await tester.pumpWidget(_host(const LoginPacientePage()));

      expect(find.text('¿Eres colaborador?'), findsOneWidget);
      expect(find.text('Acceder como colaborador'), findsOneWidget);
    });
  });

  group('Login de colaborador', () {
    testWidgets('pide correo y contraseña', (tester) async {
      await tester.pumpWidget(_host(const LoginColaboradorPage()));

      expect(find.text('Bienvenido, colaborador'), findsOneWidget);
      expect(
        find.widgetWithText(AppInput, 'Correo electrónico *'),
        findsOneWidget,
      );
      expect(find.widgetWithText(AppInput, 'Contraseña *'), findsOneWidget);
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('rechaza un correo mal escrito', (tester) async {
      await tester.pumpWidget(_host(const LoginColaboradorPage()));

      await tester.enterText(
        find.widgetWithText(AppInput, 'Correo electrónico *'),
        'correo-sin-arroba',
      );
      await tester.enterText(
        find.widgetWithText(AppInput, 'Contraseña *'),
        'secreto',
      );

      final submit = find.text('Iniciar sesión');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();

      expect(find.text('Ingresa un correo electrónico válido'), findsOneWidget);
      expect(find.text('Contraseña es requerido'), findsNothing);
    });

    testWidgets('enlaza con el portal de paciente', (tester) async {
      await tester.pumpWidget(_host(const LoginColaboradorPage()));

      expect(find.text('¿Eres paciente?'), findsOneWidget);
      expect(find.text('Acceder como paciente'), findsOneWidget);
    });
  });
}
