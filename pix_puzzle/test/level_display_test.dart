import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/data/models/board_cell.dart';
import 'package:pix_puzzle/data/models/level.dart';
import 'package:pix_puzzle/widgets/pix_chrome.dart';

Level _level(String name) => Level(
  code: 1,
  size: 1,
  name: name,
  tableBoard: const [
    [BoardCell()],
  ],
  tableModel: const [
    [BoardCell()],
  ],
  tableBrush: const [
    [BoardCell()],
  ],
);

void main() {
  test('levelNumber drops internal zero padding', () {
    expect(levelNumber(_level('1_001_super_facil')), '1');
    expect(levelNumber(_level('1_002')), '2');
    expect(levelNumber(_level('3_019_name')), '19');
  });

  test('levelTitle hides technical suffixes and keeps meaningful names', () {
    expect(levelTitle(_level('1_001_super_facil')), 'Nivel 1 · Primeros pasos');
    expect(levelTitle(_level('1_002')), 'Nivel 2');
    expect(levelTitle(_level('3_019_name')), 'Nivel 19');
    expect(levelTitle(_level('1_005_ajedrez')), 'Nivel 5 · Ajedrez');
    expect(levelMeaningfulTitle(_level('1_007_name')), isNull);
    expect(levelPlayLabel(_level('1_001_super_facil')), 'primeros pasos');
    expect(levelPlayLabel(_level('1_002')), 'nivel 2');
  });
}
