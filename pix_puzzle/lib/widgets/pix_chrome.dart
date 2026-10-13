import 'package:flutter/material.dart';
import '../data/models/board_cell.dart';
import '../data/models/level.dart';
import '../l10n/app_localizations.dart';
import 'board_grid.dart';

String levelLanguage(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

String levelNumber(Level level) => level.number.toString();

/// Visible headline: `Nivel 2 · Pajarita`, or `Nivel 2` when the level has no name.
String levelTitle(AppLocalizations l10n, Level level, String languageCode) {
  final name = level.localizedTitle(languageCode);
  if (name.isEmpty) return l10n.levelHeadingUntitled(level.number);
  return l10n.levelHeading(level.number, name);
}

/// Short label for CTAs (e.g. "pajarita", "nivel 2").
String levelPlayLabel(AppLocalizations l10n, Level level, String languageCode) {
  final name = level.localizedTitle(languageCode);
  if (name.isEmpty) return l10n.playLabelUntitled(level.number);
  return name.toLowerCase();
}

String levelDifficulty(AppLocalizations l10n, Level level) =>
    switch (level.difficulty) {
      1 => l10n.difficultyEasy,
      2 => l10n.difficultyMedium,
      _ => l10n.difficultyHard,
    };

/// Center-only 3×3 stamp — same table shape as the in-game brush widget.
final List<List<BoardCell>> pixBrandStamp = List.generate(
  3,
  (x) => List.generate(3, (y) => BoardCell(fill: x == 1 && y == 1)),
);

/// Left chevron in a 3×3 stamp grid:
/// · ■ ·
/// ■ · ·
/// · ■ ·
final List<List<BoardCell>> pixBackStamp = List.generate(
  3,
  (x) => List.generate(
    3,
    (y) => BoardCell(
      fill: (x == 1 && y == 0) || (x == 0 && y == 1) || (x == 1 && y == 2),
    ),
  ),
);

/// Stamp [BoardGrid] + wordmark. Optional [onPressed] (e.g. back on game).
class PixBrand extends StatelessWidget {
  const PixBrand({super.key, this.mark, this.onPressed, this.tooltip});

  /// Defaults to [pixBrandStamp]; use [pixBackStamp] for a back control.
  final List<List<BoardCell>>? mark;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: BoardGrid(table: mark ?? pixBrandStamp, size: 24),
        ),
        const SizedBox(width: 8),
        const Flexible(
          child: Text(
            'pix puzzle',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -.6,
            ),
          ),
        ),
      ],
    );
    if (onPressed == null) return row;
    return Semantics(
      button: true,
      label: tooltip ?? AppLocalizations.of(context).back,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: row,
        ),
      ),
    );
  }
}

class PixLabel extends StatelessWidget {
  const PixLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      letterSpacing: 1.8,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Help control for title rows (no AppBar brand chrome).
class PixHelpButton extends StatelessWidget {
  const PixHelpButton({super.key});
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: AppLocalizations.of(context).howToPlay,
    icon: const Icon(Icons.help_outline),
    onPressed: () => showPixHelp(context),
  );
}

Future<void> showPixHelp(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.helpTitle),
      content: SingleChildScrollView(child: Text(l10n.helpBody)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.gotIt),
        ),
      ],
    );
  },
);
