import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level.dart';
import '../../data/repositories/levels_repository.dart';

enum Difficulty {
  easy('1_', 'Fácil'),
  medium('2_', 'Media'),
  hard('3_', 'Difícil');

  const Difficulty(this.prefix, this.label);
  final String prefix;
  final String label;
}

sealed class LevelsState extends Equatable {
  const LevelsState();

  @override
  List<Object?> get props => [];
}

class LevelsLoading extends LevelsState {
  const LevelsLoading();
}

class LevelsLoaded extends LevelsState {
  const LevelsLoaded({required this.difficulty, required this.levels});

  final Difficulty difficulty;
  final List<Level> levels;

  @override
  List<Object?> get props => [difficulty, levels];
}

class LevelsError extends LevelsState {
  const LevelsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class LevelsCubit extends Cubit<LevelsState> {
  LevelsCubit(this._repository) : super(const LevelsLoading());

  final LevelsRepository _repository;
  Difficulty _difficulty = Difficulty.easy;

  Future<void> load() async {
    emit(const LevelsLoading());
    try {
      await _repository.loadLevels();
      _emitLoaded();
    } catch (e) {
      emit(LevelsError(e.toString()));
    }
  }

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    _emitLoaded();
  }

  Future<void> markDone(int code) async {
    await _repository.markDone(code);
    _emitLoaded();
  }

  Level? nextLevel(Level current) => _repository.nextLevel(current);

  void _emitLoaded() {
    emit(
      LevelsLoaded(
        difficulty: _difficulty,
        levels: _repository.levelsForDifficulty(_difficulty.prefix),
      ),
    );
  }
}
