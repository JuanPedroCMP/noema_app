import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
  ];

  /// No description provided for @appLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma do aplicativo'**
  String get appLanguage;

  /// No description provided for @deviceLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Usar idioma do dispositivo'**
  String get deviceLanguage;

  /// No description provided for @portugueseBrazil.
  ///
  /// In pt, this message translates to:
  /// **'Português (Brasil)'**
  String get portugueseBrazil;

  /// No description provided for @english.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In pt, this message translates to:
  /// **'Japonês'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In pt, this message translates to:
  /// **'Coreano'**
  String get korean;

  /// No description provided for @spanish.
  ///
  /// In pt, this message translates to:
  /// **'Espanhol'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In pt, this message translates to:
  /// **'Francês'**
  String get french;

  /// No description provided for @german.
  ///
  /// In pt, this message translates to:
  /// **'Alemão'**
  String get german;

  /// No description provided for @typographyThemes.
  ///
  /// In pt, this message translates to:
  /// **'Temas de tipografia'**
  String get typographyThemes;

  /// No description provided for @newTypographyTheme.
  ///
  /// In pt, this message translates to:
  /// **'Novo tema'**
  String get newTypographyTheme;

  /// No description provided for @typographyDescription.
  ///
  /// In pt, this message translates to:
  /// **'Defina fontes e escala para melhorar a leitura do aplicativo.'**
  String get typographyDescription;

  /// No description provided for @noTypographyThemes.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum tema de tipografia disponível.'**
  String get noTypographyThemes;

  /// No description provided for @activeTypographyTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema ativo'**
  String get activeTypographyTheme;

  /// No description provided for @scale.
  ///
  /// In pt, this message translates to:
  /// **'Escala'**
  String get scale;

  /// No description provided for @createTypographyTheme.
  ///
  /// In pt, this message translates to:
  /// **'Criar tema de tipografia'**
  String get createTypographyTheme;

  /// No description provided for @editTypographyTheme.
  ///
  /// In pt, this message translates to:
  /// **'Editar tipografia'**
  String get editTypographyTheme;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @displayFont.
  ///
  /// In pt, this message translates to:
  /// **'Fonte de títulos'**
  String get displayFont;

  /// No description provided for @bodyFont.
  ///
  /// In pt, this message translates to:
  /// **'Fonte do corpo'**
  String get bodyFont;

  /// No description provided for @monoFont.
  ///
  /// In pt, this message translates to:
  /// **'Fonte monoespaçada'**
  String get monoFont;

  /// No description provided for @fontFamilyHint.
  ///
  /// In pt, this message translates to:
  /// **'Família disponível neste dispositivo'**
  String get fontFamilyHint;

  /// No description provided for @optional.
  ///
  /// In pt, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// No description provided for @readingPreview.
  ///
  /// In pt, this message translates to:
  /// **'Aa  Exemplo de leitura'**
  String get readingPreview;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @applyTypographyFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível aplicar o tema de tipografia.'**
  String get applyTypographyFailed;

  /// No description provided for @createdTypography.
  ///
  /// In pt, this message translates to:
  /// **'Tema criado e aplicado.'**
  String get createdTypography;

  /// No description provided for @updatedTypography.
  ///
  /// In pt, this message translates to:
  /// **'Tema atualizado.'**
  String get updatedTypography;

  /// No description provided for @saveTypographyFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível salvar o tema. Verifique o nome e a escala.'**
  String get saveTypographyFailed;

  /// No description provided for @editTypographyThemeTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Editar tema'**
  String get editTypographyThemeTooltip;

  /// No description provided for @defaultTypographyNote.
  ///
  /// In pt, this message translates to:
  /// **'Tipografia padrão do Noema · não pode ser editada nem sincronizada.'**
  String get defaultTypographyNote;

  /// No description provided for @scaleRangeError.
  ///
  /// In pt, this message translates to:
  /// **'A escala deve estar entre 75% e 200%.'**
  String get scaleRangeError;

  /// No description provided for @nativeTranslation.
  ///
  /// In pt, this message translates to:
  /// **'Tradução nativa'**
  String get nativeTranslation;

  /// No description provided for @automaticTranslation.
  ///
  /// In pt, this message translates to:
  /// **'Tradução automática'**
  String get automaticTranslation;

  /// No description provided for @preferences.
  ///
  /// In pt, this message translates to:
  /// **'Preferências'**
  String get preferences;

  /// No description provided for @synchronizeAutomatically.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizar automaticamente'**
  String get synchronizeAutomatically;

  /// No description provided for @updateOtherDevices.
  ///
  /// In pt, this message translates to:
  /// **'Atualiza seus outros dispositivos.'**
  String get updateOtherDevices;

  /// No description provided for @preferredResponseLanguages.
  ///
  /// In pt, this message translates to:
  /// **'Idiomas preferidos para respostas'**
  String get preferredResponseLanguages;

  /// No description provided for @addLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar idioma'**
  String get addLanguage;

  /// No description provided for @automaticCorrectionMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo de correção automático'**
  String get automaticCorrectionMode;

  /// No description provided for @correctionFrequency.
  ///
  /// In pt, this message translates to:
  /// **'Frequência de correção'**
  String get correctionFrequency;

  /// No description provided for @exerciseCorrections.
  ///
  /// In pt, this message translates to:
  /// **'Correção de exercícios'**
  String get exerciseCorrections;

  /// No description provided for @aiTaskQueue.
  ///
  /// In pt, this message translates to:
  /// **'Fila de tarefas de IA'**
  String get aiTaskQueue;

  /// No description provided for @searchGoogleFonts.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar Google Fonts'**
  String get searchGoogleFonts;

  /// No description provided for @fontPreview.
  ///
  /// In pt, this message translates to:
  /// **'Prévia da fonte'**
  String get fontPreview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
