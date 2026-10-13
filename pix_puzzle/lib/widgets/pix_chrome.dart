import 'package:flutter/material.dart';
import '../data/models/board_cell.dart';
import '../data/models/level.dart';
import 'board_grid.dart';

String levelNumber(Level level) => level.number.toString();

/// Visible headline: `Nivel 2 · Pajarita`, or `Nivel 2` when [Level.title] is empty.
String levelTitle(Level level) {
  final number = levelNumber(level);
  if (level.title.isEmpty) return 'Nivel $number';
  return 'Nivel $number · ${level.title}';
}

/// Short label for CTAs (e.g. "pajarita", "nivel 2").
String levelPlayLabel(Level level) => level.title.isEmpty
    ? 'nivel ${levelNumber(level)}'
    : level.title.toLowerCase();

String levelDifficulty(Level level) => switch (level.difficulty) {
  1 => 'Fácil',
  2 => 'Media',
  _ => 'Difícil',
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
      label: tooltip ?? 'Volver',
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
    tooltip: 'Cómo jugar',
    icon: const Icon(Icons.help_outline),
    onPressed: () => showPixHelp(context),
  );
}

Future<void> showPixHelp(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Cada toque invierte'),
    content: const SingleChildScrollView(
      child: Text(
        'Reproduce el patrón del objetivo en tu tablero.\n\nEl centro del sello se coloca en la casilla que tocas. Cada casilla negra del sello invierte el tablero: una vacía se llena y una llena se vacía.\n\nDos aplicaciones sobre una misma casilla se cancelan. En los bordes, el sello se recorta. Puedes deshacer cualquier toque.',
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Entendido'),
      ),
    ],
  ),
);
