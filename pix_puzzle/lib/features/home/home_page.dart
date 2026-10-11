import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/level.dart';
import '../../theme/pix_theme.dart';
import '../../widgets/board_grid.dart';
import '../../widgets/pix_chrome.dart';
import '../game/game_page.dart';
import 'levels_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void _open(BuildContext context, Level level) {
    final cubit = context.read<LevelsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<GameExitAction>(
        builder: (_) => GamePage(level: level, levelsCubit: cubit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const PixBrand(),
      actions: [
        IconButton(
          tooltip: 'Cómo jugar',
          icon: const Icon(Icons.help_outline),
          onPressed: () => showPixHelp(context),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: BlocBuilder<LevelsCubit, LevelsState>(
            builder: (context, state) {
              if (state is LevelsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LevelsError) {
                final canRetry = state.message == LevelsCubit.loadFailedMessage;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        if (canRetry) ...[
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => context.read<LevelsCubit>().load(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
              final loaded = state as LevelsLoaded;
              final done = loaded.levels.where((l) => l.done).length;
              final next = loaded.levels.where((l) => !l.done).firstOrNull;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Un toque.\nOtro patrón.',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Elige un reto y encuentra su equilibrio.',
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final d in Difficulty.values)
                                ChoiceChip(
                                  label: Text(d.label),
                                  selected: loaded.difficulty == d,
                                  showCheckmark: true,
                                  onSelected: (_) => context
                                      .read<LevelsCubit>()
                                      .setDifficulty(d),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$done de ${loaded.levels.length} completados',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          if (next != null)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () => _open(context, next),
                                icon: const Icon(Icons.arrow_forward),
                                label: Text('Jugar ${levelPlayLabel(next)}'),
                              ),
                            ),
                          if (loaded.levels.isEmpty)
                            const Text(
                              'No hay niveles en esta dificultad. Prueba otra.',
                            ),
                          const SizedBox(height: 20),
                          const PixLabel('Tus retos'),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    sliver: SliverList.builder(
                      itemCount: loaded.levels.length,
                      itemBuilder: (context, index) {
                        final level = loaded.levels[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => _open(context, level),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Row(
                                  children: [
                                    BoardGrid(
                                      table: level.tableModel,
                                      size: 64,
                                      semanticLabel:
                                          'Objetivo del nivel ${levelNumber(level)}',
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            levelTitle(level),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${level.size} × ${level.size}${level.done ? ' · Completado' : ''}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    BoardGrid(
                                      table: level.tableBrush,
                                      size: 30,
                                      semanticLabel: 'Sello',
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      level.done
                                          ? Icons.check_circle_outline
                                          : Icons.arrow_forward,
                                      size: 20,
                                      color: level.done
                                          ? PixColors.done
                                          : PixColors.ink,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
