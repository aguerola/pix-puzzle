import 'package:flutter/material.dart';

import '../../theme/pix_theme.dart';

enum CompleteAction { next, restart, main }

class CompleteDialog extends StatelessWidget {
  const CompleteDialog({super.key, this.hasNext = true});

  final bool hasNext;

  static Future<CompleteAction?> show(
    BuildContext context, {
    bool hasNext = true,
  }) {
    return showDialog<CompleteAction>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompleteDialog(hasNext: hasNext),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(
        '¡Nivel completado!',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Has reproducido el objetivo.',
        style: textTheme.bodyMedium?.copyWith(color: PixColors.inkMuted),
      ),
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.main),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Niveles'),
        ),
        TextButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.restart),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Repetir'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.next),
          icon: const Icon(Icons.skip_next),
          label: Text(hasNext ? 'Siguiente' : 'Volver a niveles'),
        ),
      ],
    );
  }
}
