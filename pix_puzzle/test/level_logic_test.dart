import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/data/models/level.dart';

void main() {
  test('recalcFills + validate solves 1_001 with center taps matching model', () {
    final file = File('assets/levels.json');
    final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final levels = (decoded['levelList'] as List<dynamic>)
        .map((e) => Level.fromJson(e as Map<String, dynamic>))
        .toList();
    final base = levels.firstWhere((l) => l.name == '1_001_super_facil');
    var level = base.forPlay();

    // Single-cell brush: tapping a filled model cell paints that cell.
    for (var j = 0; j < level.size; j++) {
      for (var i = 0; i < level.size; i++) {
        if (level.tableModel[i][j].fill) {
          level = level.toggleSelected(i, j);
        }
      }
    }

    expect(level.validate(), isTrue);
  });

  test('undo toggles selection back', () {
    final file = File('assets/levels.json');
    final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final base = Level.fromJson(
      (decoded['levelList'] as List<dynamic>).first as Map<String, dynamic>,
    );
    var level = base.forPlay();
    level = level.toggleSelected(2, 2);
    expect(level.tableBoard[2][2].selected, isTrue);
    level = level.toggleSelected(2, 2);
    expect(level.tableBoard[2][2].selected, isFalse);
  });
}
