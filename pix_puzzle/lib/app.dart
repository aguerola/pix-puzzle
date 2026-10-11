import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/levels_repository.dart';
import 'features/home/home_page.dart';
import 'features/home/levels_cubit.dart';
import 'theme/pix_theme.dart';

class PixPuzzleApp extends StatelessWidget {
  const PixPuzzleApp({super.key, required this.repository});

  final LevelsRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => LevelsCubit(repository)..load(),
        child: MaterialApp(
          title: 'Pix-Puzzle',
          debugShowCheckedModeBanner: false,
          theme: buildPixTheme(),
          home: const HomePage(),
        ),
      ),
    );
  }
}
