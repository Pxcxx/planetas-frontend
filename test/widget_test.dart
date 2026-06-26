import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:planetas_app/main.dart';

void main() {
  testWidgets('La aplicación carga y muestra el título de la pantalla principal',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PlanetasApp());

    // Antes de que responda el backend se debe mostrar un indicador de carga.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // El AppBar con el título debe estar presente.
    expect(find.text('Catálogo de Planetas'), findsOneWidget);
  });
}
