import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/data/models/board_cell.dart';
import 'package:pix_puzzle/l10n/app_localizations.dart';
import 'package:pix_puzzle/widgets/board_grid.dart';

void main() {
  testWidgets('BoardGrid paints and reports taps', (tester) async {
    final taps = <(int, int)>[];
    final table = List.generate(
      3,
      (_) => List.generate(3, (_) => const BoardCell()),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: BoardGrid(
              table: table,
              size: 90,
              onCellTap: (x, y) => taps.add((x, y)),
            ),
          ),
        ),
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(BoardGrid)));
    await tester.pump();

    expect(taps, isNotEmpty);
    expect(taps.first.$1, inInclusiveRange(0, 2));
    expect(taps.first.$2, inInclusiveRange(0, 2));
  });
}
