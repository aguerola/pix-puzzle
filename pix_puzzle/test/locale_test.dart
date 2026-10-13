import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/app.dart';
import 'package:pix_puzzle/data/repositories/levels_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('English locale shows translated title and play button', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final repository = LevelsRepository();
    await tester.runAsync(() => repository.loadLevels());
    await tester.pumpWidget(
      PixPuzzleApp(repository: repository, locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Play diamond'), findsOneWidget);

    await tester.tap(find.text('Play diamond'));
    await tester.pumpAndSettle();

    expect(find.text('Level 1 · Diamond'), findsOneWidget);
    expect(find.text('Undo'), findsWidgets);
  });
}
