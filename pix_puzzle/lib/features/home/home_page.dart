import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level.dart';
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
            LevelsError(:final message) => Center(child: Text(message)),
            LevelsLoaded(:final difficulty, :final levels) => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DifficultyColumn(selected: difficulty),
                  Expanded(
                    child: levels.isEmpty
                        ? const Center(child: Text('No levels'))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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

class _DifficultyColumn extends StatelessWidget {
  const _DifficultyColumn({required this.selected});

  final Difficulty selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final d in Difficulty.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                width: 100,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: d == selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    foregroundColor: d == selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () =>
                      context.read<LevelsCubit>().setDifficulty(d),
                  child: Text(d.label),
                ),
              ),
            ),
        ],
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            BoardGrid(table: level.tableModel, size: 72),
            const SizedBox(width: 12),
            BoardGrid(table: level.tableBrush, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                level.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (level.done)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
