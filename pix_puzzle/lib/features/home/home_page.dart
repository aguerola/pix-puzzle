import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/level.dart';
import '../../l10n/app_localizations.dart';
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
                final l10n = AppLocalizations.of(context);
                final canRetry = state.failure == LevelsFailure.loadFailed;
                final message = switch (state.failure) {
                  LevelsFailure.loadFailed => l10n.loadFailed,
                  LevelsFailure.emptyCatalog => l10n.emptyCatalog,
                };
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(message, textAlign: TextAlign.center),
                        if (canRetry) ...[
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => context.read<LevelsCubit>().load(),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
              final l10n = AppLocalizations.of(context);
              final languageCode = levelLanguage(context);
              final loaded = state as LevelsLoaded;
              final done = loaded.levels.where((l) => l.done).length;
              final next = loaded.levels.where((l) => !l.done).firstOrNull;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Expanded(child: PixBrand()),
                              PixHelpButton(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              l10n.tagline,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(l10n.subtitle),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final d in Difficulty.values)
                                  ChoiceChip(
                                    label: Text(switch (d) {
                                      Difficulty.easy => l10n.difficultyEasy,
                                      Difficulty.medium =>
                                        l10n.difficultyMedium,
                                      Difficulty.hard => l10n.difficultyHard,
                                    }),
                                    selected: loaded.difficulty == d,
                                    showCheckmark: true,
                                    onSelected: (_) => context
                                        .read<LevelsCubit>()
                                        .setDifficulty(d),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              l10n.completedCount(done, loaded.levels.length),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (next != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => _open(context, next),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: Text(
                                    l10n.playLevel(
                                      levelPlayLabel(l10n, next, languageCode),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (loaded.levels.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(l10n.noLevelsInDifficulty),
                            ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: PixLabel(l10n.yourChallenges),
                          ),
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
                                      semanticLabel: l10n.levelGoal(
                                        level.number,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            levelTitle(
                                              l10n,
                                              level,
                                              languageCode,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            level.done
                                                ? l10n.levelMetaDone(level.size)
                                                : l10n.levelMeta(level.size),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    BoardGrid(
                                      table: level.tableBrush,
                                      size: 30,
                                      semanticLabel: l10n.stamp,
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
