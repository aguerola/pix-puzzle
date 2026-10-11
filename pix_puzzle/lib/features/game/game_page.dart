import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/level.dart';
import '../../theme/pix_theme.dart';
import '../../widgets/board_grid.dart';
import '../../widgets/pix_chrome.dart';
import '../home/levels_cubit.dart';
import 'complete_dialog.dart';
import 'game_bloc.dart';

enum GameExitAction { refresh }

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.level, required this.levelsCubit});
  final Level level;
  final LevelsCubit levelsCubit;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => GameBloc(level),
    child: _GameView(levelsCubit: levelsCubit),
  );
}

class _GameView extends StatefulWidget {
  const _GameView({required this.levelsCubit});
  final LevelsCubit levelsCubit;
  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  bool _dialogOpen = false;
  static const completeRevealDelay = Duration(milliseconds: 700);

  Future<void> _handleComplete(BuildContext context, GameState state) async {
    if (_dialogOpen || !state.showCompleteDialog) return;
    _dialogOpen = true;
    try {
      // Always pause so the last stamp is visible before the dialog.
      await Future<void>.delayed(completeRevealDelay);
      if (!context.mounted) return;

      try {
        await widget.levelsCubit.markDone(state.level.code);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Nivel completado. No pudimos guardar el progreso.',
              ),
            ),
          );
        }
      }
      if (!context.mounted) return;
      final next = widget.levelsCubit.nextLevel(state.level);
      final difficultyComplete =
          next == null && widget.levelsCubit.isDifficultyComplete(state.level);
      final action = await CompleteDialog.show(
        context,
        hasNext: next != null,
        difficultyComplete: difficultyComplete,
        difficultyLabel: levelDifficulty(state.level),
      );
      if (!context.mounted) return;
      context.read<GameBloc>().add(const CompleteAcknowledged());
      switch (action) {
        case CompleteAction.next:
          if (next == null) {
            Navigator.pop(context, GameExitAction.refresh);
          } else {
            context.read<GameBloc>().add(GameStarted(next));
          }
        case CompleteAction.restart:
          context.read<GameBloc>().add(const RestartAfterComplete());
        case CompleteAction.main:
        case null:
          Navigator.pop(context, GameExitAction.refresh);
      }
    } finally {
      _dialogOpen = false;
    }
  }

  Future<void> _reset(BuildContext context, GameState state) async {
    if (state.undoStack.isNotEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Reiniciar el tablero?'),
          content: const Text('Se eliminarán los toques de esta partida.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }
    context.read<GameBloc>().add(const ResetPressed());
  }

  void _expand(BuildContext context, GameState state) {
    final bloc = context.read<GameBloc>();
    showDialog<void>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Tablero ampliado'),
              leading: IconButton(
                tooltip: 'Cerrar ampliación',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: BlocConsumer<GameBloc, GameState>(
              listenWhen: (previous, current) =>
                  current.isComplete && !previous.isComplete,
              listener: (context, current) => Navigator.pop(context),
              builder: (context, current) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Arrastra para moverte. Toca para aplicar el sello.',
                    ),
                  ),
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 3,
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(24),
                      child: BoardGrid(
                        table: current.level.tableBoard,
                        size: math.max(480, current.level.size * 48),
                        semanticLabel: 'Tablero ampliado',
                        onCellTap: current.isComplete
                            ? null
                            : (x, y) => bloc.add(CellTapped(x, y)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton.icon(
                      onPressed: current.undoStack.isEmpty || current.isComplete
                          ? null
                          : () => bloc.add(const UndoPressed()),
                      icon: const Icon(Icons.undo),
                      label: const Text('Deshacer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<GameBloc, GameState>(
    listenWhen: (prev, next) =>
        next.showCompleteDialog && !prev.showCompleteDialog,
    listener: _handleComplete,
    builder: (context, state) {
      final level = state.level;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    child: LayoutBuilder(
                      builder: (context, inner) {
                        final boardSize = inner.maxWidth;
                        final targetSize = math.min(
                          120.0,
                          inner.maxWidth * .38,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              levelTitle(level),
                              style: Theme.of(
                                context,
                              ).textTheme.displaySmall?.copyWith(fontSize: 36),
                            ),
                            const SizedBox(height: 10),
                            PixLabel(levelDifficulty(level)),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const PixLabel('Objetivo'),
                                      const SizedBox(height: 8),
                                      BoardGrid(
                                        table: level.tableModel,
                                        size: targetSize,
                                        semanticLabel:
                                            'Objetivo ${level.size} por ${level.size}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const PixLabel('Sello'),
                                      const SizedBox(height: 8),
                                      BoardGrid(
                                        table: level.tableBrush,
                                        size: 56,
                                        semanticLabel: 'Sello de tres por tres',
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Invierte las casillas del sello.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.3,
                                          color: PixColors.inkMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                const PixLabel('Tu tablero'),
                                Text(
                                  '${state.undoStack.length} ${state.undoStack.length == 1 ? 'toque' : 'toques'}',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    color: PixColors.ink,
                                    width: 1.5,
                                  ),
                                ),
                                child: BoardGrid(
                                  table: level.tableBoard,
                                  size: boardSize,
                                  semanticLabel: 'Tu tablero',
                                  highlight: state.undoStack.isEmpty
                                      ? null
                                      : (
                                          state.undoStack.first.x,
                                          state.undoStack.first.y,
                                        ),
                                  onCellTap: state.isComplete
                                      ? null
                                      : (x, y) => context.read<GameBloc>().add(
                                          CellTapped(x, y),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Center(
                              child: Text(
                                'Reproduce el patrón del objetivo.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (level.size > 7)
                              Align(
                                alignment: Alignment.center,
                                child: TextButton.icon(
                                  onPressed: () => _expand(context, state),
                                  icon: const Icon(Icons.zoom_in),
                                  label: const Text('Ampliar tablero'),
                                ),
                              ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, c) {
                                final buttons = [
                                  OutlinedButton.icon(
                                    onPressed:
                                        state.undoStack.isEmpty ||
                                            state.isComplete
                                        ? null
                                        : () => context.read<GameBloc>().add(
                                            const UndoPressed(),
                                          ),
                                    icon: const Icon(Icons.undo),
                                    label: const Text('Deshacer'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: state.isComplete
                                        ? null
                                        : () => _reset(context, state),
                                    icon: const Icon(Icons.restart_alt),
                                    label: const Text('Reiniciar'),
                                  ),
                                ];
                                if (MediaQuery.textScalerOf(context).scale(16) >
                                        24 ||
                                    c.maxWidth < 260) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      buttons[0],
                                      const SizedBox(height: 8),
                                      buttons[1],
                                    ],
                                  );
                                }
                                return Row(
                                  children: [
                                    Expanded(child: buttons[0]),
                                    const SizedBox(width: 12),
                                    Expanded(child: buttons[1]),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 16,
                              children: [
                                TextButton.icon(
                                  onPressed: () => Navigator.pop(
                                    context,
                                    GameExitAction.refresh,
                                  ),
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Niveles'),
                                ),
                                BlocBuilder<LevelsCubit, LevelsState>(
                                  bloc: widget.levelsCubit,
                                  builder: (context, loaded) => Text(
                                    loaded is LevelsLoaded
                                        ? '${loaded.levels.where((l) => l.done).length} de ${loaded.levels.length}'
                                        : '',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
