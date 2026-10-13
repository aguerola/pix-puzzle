// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get back => 'Back';

  @override
  String get howToPlay => 'How to play';

  @override
  String get helpTitle => 'Each tap flips';

  @override
  String get helpBody =>
      'Match the goal pattern on your board.\n\nThe center of the stamp lands on the cell you tap. Each filled cell of the stamp flips the board: an empty cell fills and a filled cell empties.\n\nTwo stamps on the same cell cancel out. At the edges, the stamp is clipped. You can undo any tap.';

  @override
  String get gotIt => 'Got it';

  @override
  String levelHeading(int number, String name) {
    return 'Level $number · $name';
  }

  @override
  String levelHeadingUntitled(int number) {
    return 'Level $number';
  }

  @override
  String playLabelUntitled(int number) {
    return 'level $number';
  }

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get tagline => 'One tap.\nAnother pattern.';

  @override
  String get subtitle => 'Pick a challenge and find its balance.';

  @override
  String completedCount(int done, int total) {
    return '$done of $total completed';
  }

  @override
  String playLevel(String label) {
    return 'Play $label';
  }

  @override
  String get noLevelsInDifficulty =>
      'No levels in this difficulty. Try another.';

  @override
  String get yourChallenges => 'Your challenges';

  @override
  String levelGoal(int number) {
    return 'Goal for level $number';
  }

  @override
  String levelMeta(int size) {
    return '$size × $size';
  }

  @override
  String levelMetaDone(int size) {
    return '$size × $size · Done';
  }

  @override
  String get stamp => 'Stamp';

  @override
  String get retry => 'Retry';

  @override
  String get loadFailed => 'We couldn\'t load the levels.';

  @override
  String get emptyCatalog => 'No levels available.';

  @override
  String get progressNotSaved =>
      'Level complete. We couldn\'t save your progress.';

  @override
  String get resetTitle => 'Reset the board?';

  @override
  String get resetBody => 'The taps in this game will be removed.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get expandedBoard => 'Expanded board';

  @override
  String get closeExpanded => 'Close expanded view';

  @override
  String get expandedHint => 'Drag to move. Tap to apply the stamp.';

  @override
  String get undo => 'Undo';

  @override
  String get levels => 'Levels';

  @override
  String get goal => 'Goal';

  @override
  String goalSize(int size) {
    return 'Goal $size by $size';
  }

  @override
  String get stampSemantic => 'Three-by-three stamp';

  @override
  String get stampHint => 'Flips the cells in the stamp.';

  @override
  String get yourBoard => 'Your board';

  @override
  String tapCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taps',
      one: '1 tap',
    );
    return '$_temp0';
  }

  @override
  String get matchGoal => 'Match the goal pattern.';

  @override
  String get expandBoard => 'Expand board';

  @override
  String progressFraction(int done, int total) {
    return '$done of $total';
  }

  @override
  String get difficultyCompleteTitle => 'Difficulty complete!';

  @override
  String get levelCompleteTitle => 'Level complete!';

  @override
  String difficultyCompleteBody(String difficulty) {
    return 'You finished every $difficulty level.';
  }

  @override
  String get difficultyCompleteBodyPlain => 'You finished every level.';

  @override
  String get groupEndBody =>
      'You\'ve reached the end of this group. Some levels are still unfinished.';

  @override
  String get reproducedGoal => 'You matched the goal.';

  @override
  String get repeat => 'Replay';

  @override
  String get next => 'Next';

  @override
  String get backToLevels => 'Back to levels';

  @override
  String cellFilled(int row, int column) {
    return 'Row $row, column $column, filled';
  }

  @override
  String cellEmpty(int row, int column) {
    return 'Row $row, column $column, empty';
  }
}
