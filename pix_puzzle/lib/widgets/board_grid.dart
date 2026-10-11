import 'package:flutter/material.dart';

import '../data/models/board_cell.dart';

/// Black/white grid matching the original BoardView painting.
class BoardGrid extends StatelessWidget {
  const BoardGrid({
    super.key,
    required this.table,
    this.onCellTap,
    this.size = 120,
  });

  final List<List<BoardCell>> table;
  final void Function(int x, int y)? onCellTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: onCellTap == null
            ? null
            : (details) {
                final n = table.length;
                if (n == 0) return;
                final local = details.localPosition;
                final x = (n * local.dx / size).floor();
                final y = (n * local.dy / size).floor();
                if (x >= 0 && y >= 0 && x < n && y < n) {
                  onCellTap!(x, y);
                }
              },
        child: CustomPaint(
          painter: _BoardPainter(table),
          size: Size.square(size),
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  _BoardPainter(this.table);

  final List<List<BoardCell>> table;

  static const _black = Color(0xFF000000);
  static const _white = Color(0xFFFFFFFF);
  static const _border = Color(0xFF888888);

  @override
  void paint(Canvas canvas, Size size) {
    final n = table.isEmpty ? 9 : table.length;
    final iGap = size.width / n;
    final jGap = size.height / n;
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = _border
      ..strokeWidth = 1;

    for (var j = 0; j < n; j++) {
      for (var i = 0; i < n; i++) {
        final x = i * iGap;
        final y = j * jGap;
        final rect = Rect.fromLTWH(x, y, iGap, jGap);
        final filled = table.isEmpty ? false : table[i][j].fill;
        fillPaint.color = filled ? _black : _white;
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) =>
      oldDelegate.table != table;
}
