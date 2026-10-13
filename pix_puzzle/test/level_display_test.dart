import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/data/models/board_cell.dart';
import 'package:pix_puzzle/data/models/level.dart';
import 'package:pix_puzzle/widgets/pix_chrome.dart';

Level _level({int difficulty = 1, int number = 1, String title = ''}) => Level(
  code: 1,
  size: 1,
  difficulty: difficulty,
  number: number,
  title: title,
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
  test('levelNumber is the catalog number', () {
    expect(levelNumber(_level(number: 2)), '2');
    expect(levelNumber(_level(number: 20)), '20');
  });

  test('levelTitle joins number and title', () {
    expect(
      levelTitle(_level(number: 2, title: 'Pajarita')),
      'Nivel 2 · Pajarita',
    );
    expect(levelTitle(_level(number: 2)), 'Nivel 2');
    expect(levelPlayLabel(_level(number: 2, title: 'Pajarita')), 'pajarita');
    expect(levelPlayLabel(_level(number: 2)), 'nivel 2');
    expect(levelDifficulty(_level(difficulty: 1)), 'Fácil');
    expect(levelDifficulty(_level(difficulty: 2)), 'Media');
    expect(levelDifficulty(_level(difficulty: 3)), 'Difícil');
  });
}
