import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level.dart';
import '../../widgets/board_grid.dart';
import '../home/levels_cubit.dart';
import 'complete_dialog.dart';
import 'game_bloc.dart';

enum GameExitAction { refresh }

class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
    required this.level,
    required this.levelsCubit,
  });

  final Level level;
  final LevelsCubit levelsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(level),
      child: _GameView(levelsCubit: levelsCubit),
    );
  }
}

class _GameView extends StatefulWidget {
  const _GameView({required this.levelsCubit});

  final LevelsCubit levelsCubit;

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  bool _dialogOpen = false;

  Future<void> _handleComplete(BuildContext context, GameState state) async {
    if (_dialogOpen || !state.showCompleteDialog) return;
    _dialogOpen = true;
    await widget.levelsCubit.markDone(state.level.code);
    if (!context.mounted) return;

    final action = await CompleteDialog.show(context);
    if (!context.mounted) return;
    context.read<GameBloc>().add(const CompleteAcknowledged());
    _dialogOpen = false;

    switch (action) {
      case CompleteAction.next:
        final next = widget.levelsCubit.nextLevel(state.level);
        if (next == null) {
          Navigator.of(context).pop(GameExitAction.refresh);
          return;
        }
        context.read<GameBloc>().add(GameStarted(next));
      case CompleteAction.restart:
        context.read<GameBloc>().add(const RestartAfterComplete());
      case CompleteAction.main:
      case null:
        Navigator.of(context).pop(GameExitAction.refresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (prev, next) =>
          next.showCompleteDialog && !prev.showCompleteDialog,
      listener: (context, state) => _handleComplete(context, state),
      builder: (context, state) {
        final level = state.level;
        return Scaffold(
          backgroundColor: const Color(0xFFF0F0F0),
          appBar: AppBar(
            title: Text(level.name),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.of(context).pop(GameExitAction.refresh),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final side = constraints.maxWidth < 500;
              final boardSize = side
                  ? (constraints.maxWidth - 96).clamp(120.0, 280.0)
                  : ((constraints.maxHeight - 48) / 2).clamp(160.0, 320.0);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: BoardGrid(
                                table: level.tableModel,
                                size: boardSize,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Center(
                              child: BoardGrid(
                                table: level.tableBoard,
                                size: boardSize,
                                onCellTap: state.isComplete
                                    ? null
                                    : (x, y) => context
                                        .read<GameBloc>()
                                        .add(CellTapped(x, y)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 56,
                      child: Column(
                        children: [
                          BoardGrid(table: level.tableBrush, size: 48),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Undo',
                            onPressed: state.undoStack.isEmpty ||
                                    state.isComplete
                                ? null
                                : () => context
                                    .read<GameBloc>()
                                    .add(const UndoPressed()),
                            icon: const Icon(Icons.undo),
                          ),
                          IconButton(
                            tooltip: 'Reset',
                            onPressed: state.isComplete
                                ? null
                                : () => context
                                    .read<GameBloc>()
                                    .add(const ResetPressed()),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
