import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text('         CONGRATULATIONS!!!         '),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'WELL DONE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 8),
          Text('LEVEL COMPLETE'),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        IconButton(
          tooltip: 'Main',
          onPressed: () => Navigator.pop(context, CompleteAction.main),
          icon: const Icon(Icons.home),
        ),
        IconButton(
          tooltip: 'Restart',
          onPressed: () => Navigator.pop(context, CompleteAction.restart),
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          tooltip: 'Next',
          onPressed: () => Navigator.pop(context, CompleteAction.next),
          icon: const Icon(Icons.skip_next),
        ),
      ],
    );
  }
}
