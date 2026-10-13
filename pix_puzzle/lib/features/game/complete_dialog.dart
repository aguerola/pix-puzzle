import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/pix_theme.dart';

enum CompleteAction { next, restart, main }

class CompleteDialog extends StatelessWidget {
  const CompleteDialog({
    super.key,
    this.hasNext = true,
    this.difficultyComplete = false,
    this.difficultyLabel = '',
  });

  final bool hasNext;
  final bool difficultyComplete;
  final String difficultyLabel;

  static Future<CompleteAction?> show(
    BuildContext context, {
    bool hasNext = true,
    bool difficultyComplete = false,
    String difficultyLabel = '',
  }) {
    return showDialog<CompleteAction>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompleteDialog(
        hasNext: hasNext,
        difficultyComplete: difficultyComplete,
        difficultyLabel: difficultyLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final title = !hasNext && difficultyComplete
        ? l10n.difficultyCompleteTitle
        : l10n.levelCompleteTitle;
    final content = !hasNext
        ? (difficultyComplete
              ? (difficultyLabel.isEmpty
                    ? l10n.difficultyCompleteBodyPlain
                    : l10n.difficultyCompleteBody(difficultyLabel))
              : l10n.groupEndBody)
        : l10n.reproducedGoal;

    return AlertDialog(
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        content,
        style: textTheme.bodyMedium?.copyWith(color: PixColors.inkMuted),
      ),
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        if (hasNext)
          TextButton.icon(
            onPressed: () => Navigator.pop(context, CompleteAction.main),
            icon: const Icon(Icons.home_outlined),
            label: Text(l10n.levels),
          ),
        TextButton.icon(
          onPressed: () => Navigator.pop(context, CompleteAction.restart),
          icon: const Icon(Icons.restart_alt),
          label: Text(l10n.repeat),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(
            context,
            hasNext ? CompleteAction.next : CompleteAction.main,
          ),
          icon: Icon(hasNext ? Icons.skip_next : Icons.home_outlined),
          label: Text(hasNext ? l10n.next : l10n.backToLevels),
        ),
      ],
    );
  }
}
