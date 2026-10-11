import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pix_puzzle/app.dart';
import 'package:pix_puzzle/data/models/board_cell.dart';
import 'package:pix_puzzle/data/repositories/levels_repository.dart';
import 'package:pix_puzzle/widgets/board_grid.dart';

void main() {
  testWidgets(
    'Cancelled drag does not stamp; release maps asymmetric coordinates',
    (tester) async {
      final taps = <(int, int)>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardGrid(
              size: 240,
              table: List.generate(
                4,
                (_) => List.generate(4, (_) => const BoardCell()),
              ),
              onCellTap: (x, y) => taps.add((x, y)),
            ),
          ),
        ),
      );
      final origin = tester.getTopLeft(find.byType(BoardGrid));
      final gesture = await tester.startGesture(origin + const Offset(150, 30));
      await gesture.moveBy(const Offset(0, 100));
      await gesture.cancel();
      expect(taps, isEmpty);
      await tester.tapAt(origin + const Offset(150, 30));
      expect(taps, [(2, 0)]);
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets('Catalogue and game fit 320px at text scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      SharedPreferences.setMockInitialValues({});
      final repository = LevelsRepository();
      await tester.runAsync(() => repository.loadLevels());
      await tester.pumpWidget(PixPuzzleApp(repository: repository));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (
        var i = 0;
        i < 8 && tester.getCenter(find.text('Jugar primeros pasos')).dy > 650;
        i++
      ) {
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -250));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Jugar primeros pasos'));
      await tester.pumpAndSettle();
      expect(find.text('Nivel 1 · Primeros pasos'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Reiniciar'));
      expect(tester.takeException(), isNull);
    });
  }
}
