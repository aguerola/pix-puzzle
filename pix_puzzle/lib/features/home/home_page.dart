import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level.dart';
import '../../theme/pix_theme.dart';
import '../../widgets/board_grid.dart';
import '../game/game_page.dart';
import 'levels_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pix-Puzzle')),
      body: BlocBuilder<LevelsCubit, LevelsState>(
        builder: (context, state) {
          return switch (state) {
            LevelsLoading() => const Center(child: CircularProgressIndicator()),
            LevelsError(:final message) => _ErrorBody(message: message),
            LevelsLoaded(:final difficulty, :final levels) => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DifficultyColumn(selected: difficulty),
                  Expanded(
                    child: levels.isEmpty
                        ? Center(
                            child: Text(
                              'No levels',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: PixColors.inkMuted),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(0, 8, 12, 16),
                            itemCount: levels.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final level = levels[index];
                              return _LevelTile(
                                level: level,
                                onTap: () => _openLevel(context, level),
                              );
                            },
                          ),
                  ),
                ],
              ),
          };
        },
      ),
    );
  }

  Future<void> _openLevel(BuildContext context, Level level) async {
    final cubit = context.read<LevelsCubit>();
    final result = await Navigator.of(context).push<GameExitAction>(
      MaterialPageRoute(
        builder: (_) => GamePage(
          level: level,
          levelsCubit: cubit,
        ),
      ),
    );
    if (!context.mounted) return;
    if (result == GameExitAction.refresh) {
      // Progress already marked via cubit inside GamePage.
    }
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<LevelsCubit>().load(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyColumn extends StatelessWidget {
  const _DifficultyColumn({required this.selected});

  final Difficulty selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Difficulty',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final d in Difficulty.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                  width: 104,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: d == selected
                          ? PixColors.stamp
                          : PixColors.raised,
                      foregroundColor: d == selected
                          ? PixColors.onStamp
                          : PixColors.ink,
                      side: BorderSide(
                        color: d == selected
                            ? PixColors.stamp
                            : PixColors.cellBorder,
                      ),
                    ),
                    onPressed: () =>
                        context.read<LevelsCubit>().setDifficulty(d),
                    child: Text(d.label),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({required this.level, required this.onTap});

  final Level level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: PixColors.raised,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: PixColors.cellBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: BoardGrid(table: level.tableModel, size: 64),
                  ),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: 'Stamp brush',
                  child: BoardGrid(table: level.tableBrush, size: 36),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        level.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          color: PixColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (level.done) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Done',
                          style: textTheme.labelMedium?.copyWith(
                            color: PixColors.done,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (level.done)
                  const Icon(
                    Icons.check_circle,
                    color: PixColors.done,
                    semanticLabel: 'Completed',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
