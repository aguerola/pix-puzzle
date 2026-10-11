import 'package:flutter/material.dart';
import '../data/models/board_cell.dart';
import '../theme/pix_theme.dart';

/// Tables retain [x][y] indexing. Native buttons commit on release.
class BoardGrid extends StatelessWidget {
  const BoardGrid({
    super.key,
    required this.table,
    this.onCellTap,
    this.size = 120,
    this.semanticLabel,
    this.highlight,
  });
  final List<List<BoardCell>> table;
  final void Function(int x, int y)? onCellTap;
  final double size;
  final String? semanticLabel;
  final (int, int)? highlight;

  @override
  Widget build(BuildContext context) {
    if (table.isEmpty) return SizedBox.square(dimension: size);
    final n = table.length;
    return Semantics(
      label: semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: Column(
          children: [
            for (var y = 0; y < n; y++)
              Expanded(
                child: Row(
                  children: [
                    for (var x = 0; x < n; x++)
                      Expanded(
                        child: onCellTap == null
                            ? ExcludeSemantics(
                                child: _face(table[x][y].fill, false),
                              )
                            : _InteractiveCell(
                                key: ValueKey((x, y)),
                                filled: table[x][y].fill,
                                highlighted: highlight == (x, y),
                                label:
                                    'Fila ${y + 1}, columna ${x + 1}, ${table[x][y].fill ? 'llena' : 'vacía'}',
                                onPressed: () => onCellTap!(x, y),
                              ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _face(bool filled, bool highlighted) => Container(
  decoration: BoxDecoration(
    color: filled ? PixColors.ink : PixColors.cellEmpty,
    border: Border.all(color: PixColors.cellBorder, width: .4),
  ),
  foregroundDecoration: highlighted
      ? BoxDecoration(border: Border.all(color: PixColors.focus, width: 2.5))
      : null,
);

class _InteractiveCell extends StatefulWidget {
  const _InteractiveCell({
    super.key,
    required this.filled,
    required this.highlighted,
    required this.label,
    required this.onPressed,
  });
  final bool filled;
  final bool highlighted;
  final String label;
  final VoidCallback onPressed;
  @override
  State<_InteractiveCell> createState() => _InteractiveCellState();
}

class _InteractiveCellState extends State<_InteractiveCell> {
  bool focused = false;
  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label,
    button: true,
    child: TextButton(
      onFocusChange: (value) => setState(() => focused = value),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(),
        overlayColor: PixColors.focus,
      ),
      onPressed: widget.onPressed,
      child: SizedBox.expand(
        child: _face(widget.filled, focused || widget.highlighted),
      ),
    ),
  );
}
