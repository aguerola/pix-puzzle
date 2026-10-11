import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level.dart';

class BoardCoord extends Equatable {
  const BoardCoord(this.x, this.y);
  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];
}

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  const GameStarted(this.level);
  final Level level;

  @override
  List<Object?> get props => [level];
}

class CellTapped extends GameEvent {
  const CellTapped(this.x, this.y);
  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];
}

class UndoPressed extends GameEvent {
  const UndoPressed();
}

class ResetPressed extends GameEvent {
  const ResetPressed();
}

class RestartAfterComplete extends GameEvent {
  const RestartAfterComplete();
}

class CompleteAcknowledged extends GameEvent {
  const CompleteAcknowledged();
}

class GameState extends Equatable {
  const GameState({
    required this.level,
    this.undoStack = const [],
    this.isComplete = false,
    this.showCompleteDialog = false,
  });

  final Level level;
  final List<BoardCoord> undoStack;
  final bool isComplete;
  final bool showCompleteDialog;

  GameState copyWith({
    Level? level,
    List<BoardCoord>? undoStack,
    bool? isComplete,
    bool? showCompleteDialog,
  }) {
    return GameState(
      level: level ?? this.level,
      undoStack: undoStack ?? this.undoStack,
      isComplete: isComplete ?? this.isComplete,
      showCompleteDialog: showCompleteDialog ?? this.showCompleteDialog,
    );
  }

  @override
  List<Object?> get props =>
      [level, undoStack, isComplete, showCompleteDialog];
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(Level level)
      : super(GameState(level: level.forPlay())) {
    on<GameStarted>(_onStarted);
    on<CellTapped>(_onCellTapped);
    on<UndoPressed>(_onUndo);
    on<ResetPressed>(_onReset);
    on<RestartAfterComplete>(_onRestart);
    on<CompleteAcknowledged>(_onCompleteAcknowledged);
  }

  void _onStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameState(level: event.level.forPlay()));
  }

  void _onCellTapped(CellTapped event, Emitter<GameState> emit) {
    if (state.isComplete) return;
    final x = event.x;
    final y = event.y;
    if (x < 0 || y < 0 || x >= state.level.size || y >= state.level.size) {
      return;
    }

    final next = state.level.toggleSelected(x, y);
    final stack = [BoardCoord(x, y), ...state.undoStack];
    final complete = next.validate();
    emit(
      state.copyWith(
        level: complete ? next.copyWith(done: true) : next,
        undoStack: stack,
        isComplete: complete,
        showCompleteDialog: complete,
      ),
    );
  }

  void _onUndo(UndoPressed event, Emitter<GameState> emit) {
    if (state.isComplete || state.undoStack.isEmpty) return;
    final coord = state.undoStack.first;
    final next = state.level.toggleSelected(coord.x, coord.y);
    emit(
      state.copyWith(
        level: next,
        undoStack: state.undoStack.sublist(1),
        isComplete: false,
        showCompleteDialog: false,
      ),
    );
  }

  void _onReset(ResetPressed event, Emitter<GameState> emit) {
    emit(GameState(level: state.level.reset()));
  }

  void _onRestart(RestartAfterComplete event, Emitter<GameState> emit) {
    emit(GameState(level: state.level.reset()));
  }

  void _onCompleteAcknowledged(
    CompleteAcknowledged event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(showCompleteDialog: false));
  }
}
