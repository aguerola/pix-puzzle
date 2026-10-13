import 'package:flutter_test/flutter_test.dart';
import 'package:pix_puzzle/data/models/level.dart';
import 'package:pix_puzzle/data/repositories/levels_repository.dart';
import 'package:pix_puzzle/features/home/levels_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FailingRepository extends LevelsRepository {
  @override
  Future<List<Level>> loadLevels() async {
    throw StateError('asset missing');
  }
}

class _EmptyRepository extends LevelsRepository {
  @override
  Future<List<Level>> loadLevels() async => const [];

  @override
  bool get hasLoadedLevels => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('load failure emits a failure kind, not the exception', () async {
    SharedPreferences.setMockInitialValues({});
    final cubit = LevelsCubit(_FailingRepository());
    await cubit.load();
    final state = cubit.state;
    expect(state, isA<LevelsError>());
    expect((state as LevelsError).failure, LevelsFailure.loadFailed);
    await cubit.close();
  });

  test('empty catalog emits a distinct failure', () async {
    SharedPreferences.setMockInitialValues({});
    final cubit = LevelsCubit(_EmptyRepository());
    await cubit.load();
    final state = cubit.state;
    expect(state, isA<LevelsError>());
    expect((state as LevelsError).failure, LevelsFailure.emptyCatalog);
    await cubit.close();
  });
}
