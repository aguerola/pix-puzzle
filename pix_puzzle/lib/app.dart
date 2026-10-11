import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/levels_repository.dart';
import 'features/home/home_page.dart';
import 'features/home/levels_cubit.dart';

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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
