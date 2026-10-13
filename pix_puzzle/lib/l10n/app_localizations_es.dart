// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get back => 'Volver';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get helpTitle => 'Cada toque invierte';

  @override
  String get helpBody =>
      'Reproduce el patrón del objetivo en tu tablero.\n\nEl centro del sello se coloca en la casilla que tocas. Cada casilla negra del sello invierte el tablero: una vacía se llena y una llena se vacía.\n\nDos aplicaciones sobre una misma casilla se cancelan. En los bordes, el sello se recorta. Puedes deshacer cualquier toque.';

  @override
  String get gotIt => 'Entendido';

  @override
  String levelHeading(int number, String name) {
    return 'Nivel $number · $name';
  }

  @override
  String levelHeadingUntitled(int number) {
    return 'Nivel $number';
  }

  @override
  String playLabelUntitled(int number) {
    return 'nivel $number';
  }

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get tagline => 'Un toque.\nOtro patrón.';

  @override
  String get subtitle => 'Elige un reto y encuentra su equilibrio.';

  @override
  String completedCount(int done, int total) {
    return '$done de $total completados';
  }

  @override
  String playLevel(String label) {
    return 'Jugar $label';
  }

  @override
  String get noLevelsInDifficulty =>
      'No hay niveles en esta dificultad. Prueba otra.';

  @override
  String get yourChallenges => 'Tus retos';

  @override
  String levelGoal(int number) {
    return 'Objetivo del nivel $number';
  }

  @override
  String levelMeta(int size) {
    return '$size × $size';
  }

  @override
  String levelMetaDone(int size) {
    return '$size × $size · Completado';
  }

  @override
  String get stamp => 'Sello';

  @override
  String get retry => 'Reintentar';

  @override
  String get loadFailed => 'No pudimos cargar los niveles.';

  @override
  String get emptyCatalog => 'No hay niveles disponibles.';

  @override
  String get progressNotSaved =>
      'Nivel completado. No pudimos guardar el progreso.';

  @override
  String get resetTitle => '¿Reiniciar el tablero?';

  @override
  String get resetBody => 'Se eliminarán los toques de esta partida.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get expandedBoard => 'Tablero ampliado';

  @override
  String get closeExpanded => 'Cerrar ampliación';

  @override
  String get expandedHint =>
      'Arrastra para moverte. Toca para aplicar el sello.';

  @override
  String get undo => 'Deshacer';

  @override
  String get levels => 'Niveles';

  @override
  String get goal => 'Objetivo';

  @override
  String goalSize(int size) {
    return 'Objetivo $size por $size';
  }

  @override
  String get stampSemantic => 'Sello de tres por tres';

  @override
  String get stampHint => 'Invierte las casillas del sello.';

  @override
  String get yourBoard => 'Tu tablero';

  @override
  String tapCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count toques',
      one: '1 toque',
    );
    return '$_temp0';
  }

  @override
  String get matchGoal => 'Reproduce el patrón del objetivo.';

  @override
  String get expandBoard => 'Ampliar tablero';

  @override
  String progressFraction(int done, int total) {
    return '$done de $total';
  }

  @override
  String get difficultyCompleteTitle => '¡Dificultad completada!';

  @override
  String get levelCompleteTitle => '¡Nivel completado!';

  @override
  String difficultyCompleteBody(String difficulty) {
    return 'Has terminado todos los niveles de $difficulty.';
  }

  @override
  String get difficultyCompleteBodyPlain => 'Has terminado todos los niveles.';

  @override
  String get groupEndBody =>
      'Has llegado al final del grupo. Aún quedan niveles pendientes.';

  @override
  String get reproducedGoal => 'Has reproducido el objetivo.';

  @override
  String get repeat => 'Repetir';

  @override
  String get next => 'Siguiente';

  @override
  String get backToLevels => 'Volver a niveles';

  @override
  String cellFilled(int row, int column) {
    return 'Fila $row, columna $column, llena';
  }

  @override
  String cellEmpty(int row, int column) {
    return 'Fila $row, columna $column, vacía';
  }
}
