import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/app/app.dart';
import 'package:mobile/app/routes.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/core/session/app_session.dart';
import 'package:mobile/modules/home/pages/home_page.dart';
import 'package:mobile/modules/profile/pages/profile_page.dart';
import 'package:mobile/modules/tiles_calculator/models/tile_calculation.dart';
import 'package:mobile/modules/tiles_calculator/services/tile_calculator_service.dart';

void main() {
  testWidgets('Hogar360 shows welcome screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const Hogar360App());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Registrarme'), findsOneWidget);
  });

  test('tile calculator rounds pieces before boxes', () {
    final result = TileCalculatorService().calculate(
      const TileCalculationInput(
        floorLength: 4,
        floorWidth: 4,
        tileLengthCm: 20,
        tileWidthCm: 20,
        tilesPerBox: 10,
        wastePercentage: 10,
      ),
    );

    expect(result.floorArea, 16);
    expect(result.baseTiles, 400);
    expect(result.wasteTiles, 40);
    expect(result.totalTiles, 440);
    expect(result.boxes, 44);
  });

  testWidgets('profile save button enables only when name changes', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    AppSession.instance.token = null;
    AppSession.instance.userName = 'Fernando Mas';
    AppSession.instance.userEmail = 'fernando@example.com';

    await tester.pumpWidget(
      MaterialApp(theme: HogarTheme.light, home: const ProfilePage()),
    );

    await tester.tap(find.text('Editar Perfil'));
    await tester.pumpAndSettle();

    ElevatedButton saveButton() {
      return tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Guardar'),
      );
    }

    expect(saveButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Fernando Mas');
    await tester.pump();
    expect(saveButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Fernando Mas Actualizado');
    await tester.pump();
    expect(saveButton().onPressed, isNotNull);
  });

  testWidgets('home does not show an app bar back button', (
    WidgetTester tester,
  ) async {
    AppSession.instance.userName = 'Fernando Mas';

    await tester.pumpWidget(
      MaterialApp(
        theme: HogarTheme.light,
        routes: {AppRoutes.profile: (_) => const ProfilePage()},
        home: const HomePage(),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    expect(find.byTooltip('Back'), findsNothing);
  });
}
