import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @howToPlay.
  ///
  /// In es, this message translates to:
  /// **'Cómo jugar'**
  String get howToPlay;

  /// No description provided for @helpTitle.
  ///
  /// In es, this message translates to:
  /// **'Cada toque invierte'**
  String get helpTitle;

  /// No description provided for @helpBody.
  ///
  /// In es, this message translates to:
  /// **'Reproduce el patrón del objetivo en tu tablero.\n\nEl centro del sello se coloca en la casilla que tocas. Cada casilla negra del sello invierte el tablero: una vacía se llena y una llena se vacía.\n\nDos aplicaciones sobre una misma casilla se cancelan. En los bordes, el sello se recorta. Puedes deshacer cualquier toque.'**
  String get helpBody;

  /// No description provided for @gotIt.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get gotIt;

  /// No description provided for @levelHeading.
  ///
  /// In es, this message translates to:
  /// **'Nivel {number} · {name}'**
  String levelHeading(int number, String name);

  /// No description provided for @levelHeadingUntitled.
  ///
  /// In es, this message translates to:
  /// **'Nivel {number}'**
  String levelHeadingUntitled(int number);

  /// No description provided for @playLabelUntitled.
  ///
  /// In es, this message translates to:
  /// **'nivel {number}'**
  String playLabelUntitled(int number);

  /// No description provided for @difficultyEasy.
  ///
  /// In es, this message translates to:
  /// **'Fácil'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In es, this message translates to:
  /// **'Difícil'**
  String get difficultyHard;

  /// No description provided for @tagline.
  ///
  /// In es, this message translates to:
  /// **'Un toque.\nOtro patrón.'**
  String get tagline;

  /// No description provided for @subtitle.
  ///
  /// In es, this message translates to:
  /// **'Elige un reto y encuentra su equilibrio.'**
  String get subtitle;

  /// No description provided for @completedCount.
  ///
  /// In es, this message translates to:
  /// **'{done} de {total} completados'**
  String completedCount(int done, int total);

  /// No description provided for @playLevel.
  ///
  /// In es, this message translates to:
  /// **'Jugar {label}'**
  String playLevel(String label);

  /// No description provided for @noLevelsInDifficulty.
  ///
  /// In es, this message translates to:
  /// **'No hay niveles en esta dificultad. Prueba otra.'**
  String get noLevelsInDifficulty;

  /// No description provided for @yourChallenges.
  ///
  /// In es, this message translates to:
  /// **'Tus retos'**
  String get yourChallenges;

  /// No description provided for @levelGoal.
  ///
  /// In es, this message translates to:
  /// **'Objetivo del nivel {number}'**
  String levelGoal(int number);

  /// No description provided for @levelMeta.
  ///
  /// In es, this message translates to:
  /// **'{size} × {size}'**
  String levelMeta(int size);

  /// No description provided for @levelMetaDone.
  ///
  /// In es, this message translates to:
  /// **'{size} × {size} · Completado'**
  String levelMetaDone(int size);

  /// No description provided for @stamp.
  ///
  /// In es, this message translates to:
  /// **'Sello'**
  String get stamp;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @loadFailed.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar los niveles.'**
  String get loadFailed;

  /// No description provided for @emptyCatalog.
  ///
  /// In es, this message translates to:
  /// **'No hay niveles disponibles.'**
  String get emptyCatalog;

  /// No description provided for @progressNotSaved.
  ///
  /// In es, this message translates to:
  /// **'Nivel completado. No pudimos guardar el progreso.'**
  String get progressNotSaved;

  /// No description provided for @resetTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Reiniciar el tablero?'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán los toques de esta partida.'**
  String get resetBody;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar'**
  String get reset;

  /// No description provided for @expandedBoard.
  ///
  /// In es, this message translates to:
  /// **'Tablero ampliado'**
  String get expandedBoard;

  /// No description provided for @closeExpanded.
  ///
  /// In es, this message translates to:
  /// **'Cerrar ampliación'**
  String get closeExpanded;

  /// No description provided for @expandedHint.
  ///
  /// In es, this message translates to:
  /// **'Arrastra para moverte. Toca para aplicar el sello.'**
  String get expandedHint;

  /// No description provided for @undo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get undo;

  /// No description provided for @levels.
  ///
  /// In es, this message translates to:
  /// **'Niveles'**
  String get levels;

  /// No description provided for @goal.
  ///
  /// In es, this message translates to:
  /// **'Objetivo'**
  String get goal;

  /// No description provided for @goalSize.
  ///
  /// In es, this message translates to:
  /// **'Objetivo {size} por {size}'**
  String goalSize(int size);

  /// No description provided for @stampSemantic.
  ///
  /// In es, this message translates to:
  /// **'Sello de tres por tres'**
  String get stampSemantic;

  /// No description provided for @stampHint.
  ///
  /// In es, this message translates to:
  /// **'Invierte las casillas del sello.'**
  String get stampHint;

  /// No description provided for @yourBoard.
  ///
  /// In es, this message translates to:
  /// **'Tu tablero'**
  String get yourBoard;

  /// No description provided for @tapCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 toque} other{{count} toques}}'**
  String tapCount(int count);

  /// No description provided for @matchGoal.
  ///
  /// In es, this message translates to:
  /// **'Reproduce el patrón del objetivo.'**
  String get matchGoal;

  /// No description provided for @expandBoard.
  ///
  /// In es, this message translates to:
  /// **'Ampliar tablero'**
  String get expandBoard;

  /// No description provided for @progressFraction.
  ///
  /// In es, this message translates to:
  /// **'{done} de {total}'**
  String progressFraction(int done, int total);

  /// No description provided for @difficultyCompleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Dificultad completada!'**
  String get difficultyCompleteTitle;

  /// No description provided for @levelCompleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Nivel completado!'**
  String get levelCompleteTitle;

  /// No description provided for @difficultyCompleteBody.
  ///
  /// In es, this message translates to:
  /// **'Has terminado todos los niveles de {difficulty}.'**
  String difficultyCompleteBody(String difficulty);

  /// No description provided for @difficultyCompleteBodyPlain.
  ///
  /// In es, this message translates to:
  /// **'Has terminado todos los niveles.'**
  String get difficultyCompleteBodyPlain;

  /// No description provided for @groupEndBody.
  ///
  /// In es, this message translates to:
  /// **'Has llegado al final del grupo. Aún quedan niveles pendientes.'**
  String get groupEndBody;

  /// No description provided for @reproducedGoal.
  ///
  /// In es, this message translates to:
  /// **'Has reproducido el objetivo.'**
  String get reproducedGoal;

  /// No description provided for @repeat.
  ///
  /// In es, this message translates to:
  /// **'Repetir'**
  String get repeat;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @backToLevels.
  ///
  /// In es, this message translates to:
  /// **'Volver a niveles'**
  String get backToLevels;

  /// No description provided for @cellFilled.
  ///
  /// In es, this message translates to:
  /// **'Fila {row}, columna {column}, llena'**
  String cellFilled(int row, int column);

  /// No description provided for @cellEmpty.
  ///
  /// In es, this message translates to:
  /// **'Fila {row}, columna {column}, vacía'**
  String cellEmpty(int row, int column);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
