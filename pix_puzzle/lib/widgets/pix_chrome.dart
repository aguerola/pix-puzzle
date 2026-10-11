import 'package:flutter/material.dart';
import '../data/models/board_cell.dart';
import '../data/models/level.dart';
import 'board_grid.dart';

String levelNumber(Level level) =>
    int.tryParse(level.name.split('_').elementAtOrNull(1) ?? '')?.toString() ??
    '—';

/// Meaningful display title from the name suffix, or null if none.
String? levelMeaningfulTitle(Level level) {
  final suffix = level.name.split('_').skip(2).join(' ').trim();
  if (suffix.isEmpty || suffix.contains('name')) return null;
  if (suffix == 'super facil') return 'Primeros pasos';
  return '${suffix[0].toUpperCase()}${suffix.substring(1)}';
}

/// Visible headline: `Nivel 1 · Primeros pasos` or `Nivel 2`.
String levelTitle(Level level) {
  final number = levelNumber(level);
  final meaningful = levelMeaningfulTitle(level);
  if (meaningful == null) return 'Nivel $number';
  return 'Nivel $number · $meaningful';
}

/// Short label for CTAs (e.g. "primeros pasos", "nivel 2").
String levelPlayLabel(Level level) =>
    (levelMeaningfulTitle(level) ?? 'nivel ${levelNumber(level)}').toLowerCase();

String levelDifficulty(Level level) => switch (level.name.split('_').first) {
  '1' => 'Fácil',
  '2' => 'Media',
  _ => 'Difícil',
};

/// Center-only 3×3 stamp — same table shape as the in-game brush widget.
final List<List<BoardCell>> pixBrandStamp = List.generate(
  3,
  (x) => List.generate(3, (y) => BoardCell(fill: x == 1 && y == 1)),
);

/// Stamp [BoardGrid] + wordmark.
class PixBrand extends StatelessWidget {
  const PixBrand({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: BoardGrid(table: pixBrandStamp, size: 28),
      ),
      const SizedBox(width: 10),
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
