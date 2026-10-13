import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level.dart';
import '../../data/repositories/levels_repository.dart';

enum Difficulty {
  easy(1),
  medium(2),
  hard(3);

  const Difficulty(this.id);
  final int id;
}

enum LevelsFailure { loadFailed, emptyCatalog }

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
  const LevelsError(this.failure);
  final LevelsFailure failure;

  @override
  List<Object?> get props => [failure];
}

class LevelsCubit extends Cubit<LevelsState> {
  LevelsCubit(this._repository) : super(const LevelsLoading());

  final LevelsRepository _repository;
  Difficulty _difficulty = Difficulty.easy;

  Future<void> load() async {
    emit(const LevelsLoading());
    try {
      await _repository.loadLevels();
      if (!_repository.hasLoadedLevels) {
        emit(const LevelsError(LevelsFailure.emptyCatalog));
        return;
      }
      _emitLoaded();
    } catch (e, st) {
      debugPrint('LevelsCubit.load failed: $e\n$st');
      emit(const LevelsError(LevelsFailure.loadFailed));
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

  bool isDifficultyComplete(Level current) =>
      _repository.isDifficultyComplete(current);

  void _emitLoaded() {
    emit(
      LevelsLoaded(
        difficulty: _difficulty,
        levels: _repository.levelsForDifficulty(_difficulty.id),
      ),
    );
  }
}
