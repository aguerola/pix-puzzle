import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/features/game/complete_dialog.dart';

void main() {
  Future<void> pumpDialog(
    WidgetTester tester, {
    required bool hasNext,
    required bool difficultyComplete,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => CompleteDialog.show(
                context,
                hasNext: hasNext,
                difficultyComplete: difficultyComplete,
                difficultyLabel: 'Fácil',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('with next level shows Siguiente and Niveles', (tester) async {
    await pumpDialog(tester, hasNext: true, difficultyComplete: false);
    expect(find.text('¡Nivel completado!'), findsOneWidget);
    expect(find.text('Has reproducido el objetivo.'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);
    expect(find.text('Niveles'), findsOneWidget);
    expect(find.text('Repetir'), findsOneWidget);
  });

  testWidgets('last level with pending keeps fin-de-grupo copy', (tester) async {
    await pumpDialog(tester, hasNext: false, difficultyComplete: false);
    expect(find.text('¡Nivel completado!'), findsOneWidget);
    expect(
      find.text('Has llegado al final del grupo. Aún quedan niveles pendientes.'),
      findsOneWidget,
    );
    expect(find.text('Volver a niveles'), findsOneWidget);
    expect(find.text('Niveles'), findsNothing);
    expect(find.text('Repetir'), findsOneWidget);
  });

  testWidgets('difficulty complete celebrates the group', (tester) async {
    await pumpDialog(tester, hasNext: false, difficultyComplete: true);
    expect(find.text('¡Dificultad completada!'), findsOneWidget);
    expect(
      find.text('Has terminado todos los niveles de Fácil.'),
      findsOneWidget,
    );
    expect(find.text('Volver a niveles'), findsOneWidget);
    expect(find.text('Niveles'), findsNothing);
  });
}
