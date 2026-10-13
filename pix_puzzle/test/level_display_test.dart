import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/data/models/board_cell.dart';
import 'package:pix_puzzle/data/models/level.dart';
import 'package:pix_puzzle/l10n/app_localizations_en.dart';
import 'package:pix_puzzle/l10n/app_localizations_es.dart';
import 'package:pix_puzzle/widgets/pix_chrome.dart';

Level _level({
  int difficulty = 1,
  int number = 1,
  Map<String, String> title = const {},
}) => Level(
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
  final es = AppLocalizationsEs();
  final en = AppLocalizationsEn();
  final named = _level(
    number: 2,
    title: const {'es': 'Pajarita', 'en': 'Bow tie'},
  );

  test('levelNumber is the catalog number', () {
    expect(levelNumber(_level(number: 2)), '2');
    expect(levelNumber(_level(number: 20)), '20');
  });

  test('localizedTitle falls back to Spanish', () {
    expect(named.localizedTitle('en'), 'Bow tie');
    expect(named.localizedTitle('fr'), 'Pajarita');
    expect(_level().localizedTitle('es'), isEmpty);
  });

  test('levelTitle joins number and title', () {
    expect(levelTitle(es, named, 'es'), 'Nivel 2 · Pajarita');
    expect(levelTitle(en, named, 'en'), 'Level 2 · Bow tie');
    expect(levelTitle(es, _level(number: 2), 'es'), 'Nivel 2');
    expect(levelPlayLabel(es, named, 'es'), 'pajarita');
    expect(levelPlayLabel(es, _level(number: 2), 'es'), 'nivel 2');
    expect(levelPlayLabel(en, _level(number: 2), 'en'), 'level 2');
    expect(levelDifficulty(es, _level(difficulty: 1)), 'Fácil');
    expect(levelDifficulty(es, _level(difficulty: 2)), 'Media');
    expect(levelDifficulty(es, _level(difficulty: 3)), 'Difícil');
    expect(levelDifficulty(en, _level(difficulty: 1)), 'Easy');
  });
}
