import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/levels_repository.dart';
import 'features/home/home_page.dart';
import 'features/home/levels_cubit.dart';
import 'l10n/app_localizations.dart';
import 'theme/pix_theme.dart';

class PixPuzzleApp extends StatelessWidget {
  const PixPuzzleApp({super.key, required this.repository, this.locale});

  final LevelsRepository repository;

  /// Overrides the device locale. Tests use this to pin a language.
  final Locale? locale;

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
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );
  }
}
