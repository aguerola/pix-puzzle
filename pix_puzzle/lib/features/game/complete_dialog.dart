import 'package:flutter/material.dart';

import '../../theme/pix_theme.dart';

enum CompleteAction { next, restart, main }

class CompleteDialog extends StatelessWidget {
  const CompleteDialog({super.key});

  static Future<CompleteAction?> show(BuildContext context) {
    return showDialog<CompleteAction>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CompleteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(
        'Level complete',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Nice stamp work. What next?',
        style: textTheme.bodyMedium?.copyWith(color: PixColors.inkMuted),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.main),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Home'),
        ),
        TextButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.restart),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Restart'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.next),
          icon: const Icon(Icons.skip_next),
          label: const Text('Next'),
        ),
      ],
    );
  }
}
