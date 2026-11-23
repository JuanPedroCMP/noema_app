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

  /// No description provided for @retry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get retry;

  /// No description provided for @understood.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get understood;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @archive.
  ///
  /// In pt, this message translates to:
  /// **'Arquivar'**
  String get archive;

  /// No description provided for @newStudySession.
  ///
  /// In pt, this message translates to:
  /// **'Nova sessão'**
  String get newStudySession;

  /// No description provided for @studySessions.
  ///
  /// In pt, this message translates to:
  /// **'Sessões de estudo'**
  String get studySessions;

  /// No description provided for @noStudySessions.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma sessão criada'**
  String get noStudySessions;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @sessionActions.
  ///
  /// In pt, this message translates to:
  /// **'Ações da sessão'**
  String get sessionActions;

  /// No description provided for @exitSession.
  ///
  /// In pt, this message translates to:
  /// **'Sair da sessão'**
  String get exitSession;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @continueAction.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @interrupt.
  ///
  /// In pt, this message translates to:
  /// **'Interromper'**
  String get interrupt;

  /// No description provided for @viewSessionHistory.
  ///
  /// In pt, this message translates to:
  /// **'Ver histórico da sessão'**
  String get viewSessionHistory;

  /// No description provided for @openQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Questão aberta'**
  String get openQuestion;

  /// No description provided for @flashcard.
  ///
  /// In pt, this message translates to:
  /// **'Flashcard'**
  String get flashcard;

  /// No description provided for @note.
  ///
  /// In pt, this message translates to:
  /// **'Nota'**
  String get note;

  /// No description provided for @studySession.
  ///
  /// In pt, this message translates to:
  /// **'Sessão de estudo'**
  String get studySession;

  /// No description provided for @archivedGraph.
  ///
  /// In pt, this message translates to:
  /// **'Grafo · Arquivado'**
  String get archivedGraph;

  /// No description provided for @graph.
  ///
  /// In pt, this message translates to:
  /// **'Grafo'**
  String get graph;

  /// No description provided for @graphTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título do grafo'**
  String get graphTitle;

  /// No description provided for @description.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get description;

  /// No description provided for @createRelation.
  ///
  /// In pt, this message translates to:
  /// **'Criar relação'**
  String get createRelation;

  /// No description provided for @generateQuestionWithAi.
  ///
  /// In pt, this message translates to:
  /// **'Gerar questão com IA'**
  String get generateQuestionWithAi;

  /// No description provided for @saveCard.
  ///
  /// In pt, this message translates to:
  /// **'Salvar cartão'**
  String get saveCard;

  /// No description provided for @searchHistory.
  ///
  /// In pt, this message translates to:
  /// **'Buscar no histórico'**
  String get searchHistory;

  /// No description provided for @startAssessment.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar avaliação'**
  String get startAssessment;

  /// No description provided for @report.
  ///
  /// In pt, this message translates to:
  /// **'Relatório'**
  String get report;

  /// No description provided for @createNote.
  ///
  /// In pt, this message translates to:
  /// **'Criar anotação'**
  String get createNote;

  /// No description provided for @title.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get title;

  /// No description provided for @relationType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de relação'**
  String get relationType;

  /// No description provided for @additionalInstructions.
  ///
  /// In pt, this message translates to:
  /// **'Instruções adicionais'**
  String get additionalInstructions;

  /// No description provided for @optionalDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição (opcional)'**
  String get optionalDescription;

  /// No description provided for @clearSearch.
  ///
  /// In pt, this message translates to:
  /// **'Limpar busca'**
  String get clearSearch;

  /// No description provided for @moreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções'**
  String get moreOptions;

  /// No description provided for @quantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de questões'**
  String get quantity;

  /// No description provided for @toggleLightDark.
  ///
  /// In pt, this message translates to:
  /// **'Toggle light / dark'**
  String get toggleLightDark;

  /// No description provided for @filled.
  ///
  /// In pt, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @outlined.
  ///
  /// In pt, this message translates to:
  /// **'Outlined'**
  String get outlined;

  /// No description provided for @helpText.
  ///
  /// In pt, this message translates to:
  /// **'Helper text'**
  String get helpText;

  /// No description provided for @moreInformation.
  ///
  /// In pt, this message translates to:
  /// **'Mais informações'**
  String get moreInformation;

  /// No description provided for @graphsTopicsTasksFlashcards.
  ///
  /// In pt, this message translates to:
  /// **'Grafos, tópicos, tarefas, flashcards…'**
  String get graphsTopicsTasksFlashcards;

  /// No description provided for @searchNoema.
  ///
  /// In pt, this message translates to:
  /// **'Buscar no Noema'**
  String get searchNoema;

  /// No description provided for @exPhysiologyReview.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Revisão de fisiologia'**
  String get exPhysiologyReview;

  /// No description provided for @plannedDuration.
  ///
  /// In pt, this message translates to:
  /// **'Duração planejada'**
  String get plannedDuration;

  /// No description provided for @moveUp.
  ///
  /// In pt, this message translates to:
  /// **'Mover para cima'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In pt, this message translates to:
  /// **'Mover para baixo'**
  String get moveDown;

  /// No description provided for @removeSession.
  ///
  /// In pt, this message translates to:
  /// **'Remover da sessão'**
  String get removeSession;

  /// No description provided for @sourceGraph.
  ///
  /// In pt, this message translates to:
  /// **'Grafo de origem (opcional)'**
  String get sourceGraph;

  /// Busca questões dentro de um grafo
  ///
  /// In pt, this message translates to:
  /// **'Buscar questões em {graphName}'**
  String searchQuestions(String graphName);

  /// No description provided for @textClearSearch.
  ///
  /// In pt, this message translates to:
  /// **'Limpar busca'**
  String get textClearSearch;

  /// No description provided for @archiveSession.
  ///
  /// In pt, this message translates to:
  /// **'Arquivar sessão'**
  String get archiveSession;

  /// No description provided for @editExercise.
  ///
  /// In pt, this message translates to:
  /// **'Editar exercício'**
  String get editExercise;

  /// No description provided for @leaveSession.
  ///
  /// In pt, this message translates to:
  /// **'Sair da sessão'**
  String get leaveSession;

  /// No description provided for @textSessionActions.
  ///
  /// In pt, this message translates to:
  /// **'Ações da sessão'**
  String get textSessionActions;

  /// No description provided for @exLearningCalculusDecemberTest.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Aprender cálculo para a prova de dezembro'**
  String get exLearningCalculusDecemberTest;

  /// No description provided for @defineStudyObjective.
  ///
  /// In pt, this message translates to:
  /// **'Definir objetivo de estudo'**
  String get defineStudyObjective;

  /// No description provided for @clearConversation.
  ///
  /// In pt, this message translates to:
  /// **'Limpar conversa'**
  String get clearConversation;

  /// No description provided for @closeWizard.
  ///
  /// In pt, this message translates to:
  /// **'Fechar assistente'**
  String get closeWizard;

  /// No description provided for @askAssistant.
  ///
  /// In pt, this message translates to:
  /// **'Pergunte ao assistente...'**
  String get askAssistant;

  /// No description provided for @sendMessage.
  ///
  /// In pt, this message translates to:
  /// **'Enviar mensagem'**
  String get sendMessage;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get tryAgain;

  /// No description provided for @customizeLayout.
  ///
  /// In pt, this message translates to:
  /// **'Personalizar layout'**
  String get customizeLayout;

  /// No description provided for @exportDashboard.
  ///
  /// In pt, this message translates to:
  /// **'Exportar painel'**
  String get exportDashboard;

  /// No description provided for @versionDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição da versão (opcional)'**
  String get versionDescription;

  /// No description provided for @reviewTest.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Revisão antes da prova'**
  String get reviewTest;

  /// No description provided for @want.
  ///
  /// In pt, this message translates to:
  /// **'O que deseja fazer?'**
  String get want;

  /// No description provided for @organizeTopicsHighlightKeyConcepts.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: organize em tópicos e destaque os conceitos-chave'**
  String get organizeTopicsHighlightKeyConcepts;

  /// No description provided for @backNotes.
  ///
  /// In pt, this message translates to:
  /// **'Voltar para notas'**
  String get backNotes;

  /// No description provided for @noteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título da nota'**
  String get noteTitle;

  /// No description provided for @annotationActions.
  ///
  /// In pt, this message translates to:
  /// **'Ações da anotação'**
  String get annotationActions;

  /// No description provided for @createVersion.
  ///
  /// In pt, this message translates to:
  /// **'Criar versão'**
  String get createVersion;

  /// No description provided for @previousVersions.
  ///
  /// In pt, this message translates to:
  /// **'Versões anteriores'**
  String get previousVersions;

  /// No description provided for @relateConcepts.
  ///
  /// In pt, this message translates to:
  /// **'Relacionar conceitos'**
  String get relateConcepts;

  /// No description provided for @improveAI.
  ///
  /// In pt, this message translates to:
  /// **'Aprimorar com IA'**
  String get improveAI;

  /// No description provided for @saveNote.
  ///
  /// In pt, this message translates to:
  /// **'Salvar nota'**
  String get saveNote;

  /// No description provided for @searchConcept.
  ///
  /// In pt, this message translates to:
  /// **'Buscar conceito'**
  String get searchConcept;

  /// No description provided for @exCellBiologySummary.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Resumo de biologia celular'**
  String get exCellBiologySummary;

  /// No description provided for @importAnnotation.
  ///
  /// In pt, this message translates to:
  /// **'Importar anotação'**
  String get importAnnotation;

  /// No description provided for @exportAnnotation.
  ///
  /// In pt, this message translates to:
  /// **'Exportar anotação'**
  String get exportAnnotation;

  /// No description provided for @annotationOptions.
  ///
  /// In pt, this message translates to:
  /// **'Opções da anotação'**
  String get annotationOptions;

  /// No description provided for @exFlutterLearningTrail.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Trilha de aprendizado em Flutter'**
  String get exFlutterLearningTrail;

  /// No description provided for @explainPurposeKnowledgeMap.
  ///
  /// In pt, this message translates to:
  /// **'Explique o objetivo deste mapa de conhecimento.'**
  String get explainPurposeKnowledgeMap;

  /// No description provided for @graphJSON.
  ///
  /// In pt, this message translates to:
  /// **'JSON do grafo'**
  String get graphJSON;

  /// No description provided for @wantLearn.
  ///
  /// In pt, this message translates to:
  /// **'O que você quer aprender?'**
  String get wantLearn;

  /// No description provided for @exIntroductionGeneticsBeginners.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Introdução à genética para iniciantes'**
  String get exIntroductionGeneticsBeginners;

  /// No description provided for @editTextGenerating.
  ///
  /// In pt, this message translates to:
  /// **'Você pode editar o texto antes de gerar.'**
  String get editTextGenerating;

  /// No description provided for @dismiss.
  ///
  /// In pt, this message translates to:
  /// **'Dispensar'**
  String get dismiss;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @graphActions.
  ///
  /// In pt, this message translates to:
  /// **'Ações do grafo'**
  String get graphActions;

  /// No description provided for @shouldChange.
  ///
  /// In pt, this message translates to:
  /// **'O que deve mudar?'**
  String get shouldChange;

  /// No description provided for @exRenameNode2AddTwoPrerequisites.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Renomeie o nó 2 e adicione dois pré-requisitos.'**
  String get exRenameNode2AddTwoPrerequisites;

  /// No description provided for @relationshipStyle.
  ///
  /// In pt, this message translates to:
  /// **'Estilo das relações'**
  String get relationshipStyle;

  /// No description provided for @type.
  ///
  /// In pt, this message translates to:
  /// **'Tipo'**
  String get type;

  /// No description provided for @origin.
  ///
  /// In pt, this message translates to:
  /// **'Origem'**
  String get origin;

  /// No description provided for @destiny.
  ///
  /// In pt, this message translates to:
  /// **'Destino'**
  String get destiny;

  /// No description provided for @weight.
  ///
  /// In pt, this message translates to:
  /// **'Peso (opcional)'**
  String get weight;

  /// No description provided for @enterNameConcept.
  ///
  /// In pt, this message translates to:
  /// **'Digite o nome de um conceito'**
  String get enterNameConcept;

  /// No description provided for @cancelCreation.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar criação'**
  String get cancelCreation;

  /// No description provided for @graphOptions.
  ///
  /// In pt, this message translates to:
  /// **'Opções do grafo'**
  String get graphOptions;

  /// No description provided for @zoomFraming.
  ///
  /// In pt, this message translates to:
  /// **'Zoom e enquadramento'**
  String get zoomFraming;

  /// No description provided for @closeRelationshipDetails.
  ///
  /// In pt, this message translates to:
  /// **'Fechar detalhes da relação'**
  String get closeRelationshipDetails;

  /// No description provided for @textWeight.
  ///
  /// In pt, this message translates to:
  /// **'Peso'**
  String get textWeight;

  /// No description provided for @textAdditionalInstructions.
  ///
  /// In pt, this message translates to:
  /// **'Instruções adicionais'**
  String get textAdditionalInstructions;

  /// No description provided for @textTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get textTitle;

  /// No description provided for @summary.
  ///
  /// In pt, this message translates to:
  /// **'Resumo'**
  String get summary;

  /// No description provided for @editConcept.
  ///
  /// In pt, this message translates to:
  /// **'Editar conceito'**
  String get editConcept;

  /// No description provided for @closeDetails.
  ///
  /// In pt, this message translates to:
  /// **'Fechar detalhes'**
  String get closeDetails;

  /// No description provided for @closeGeneration.
  ///
  /// In pt, this message translates to:
  /// **'Fechar geração'**
  String get closeGeneration;

  /// No description provided for @themeInstructions.
  ///
  /// In pt, this message translates to:
  /// **'Tema e instruções'**
  String get themeInstructions;

  /// No description provided for @linkNode.
  ///
  /// In pt, this message translates to:
  /// **'Vincular ao nó'**
  String get linkNode;

  /// No description provided for @numberFlashcards.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de flashcards'**
  String get numberFlashcards;

  /// No description provided for @updateDecks.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar decks'**
  String get updateDecks;

  /// No description provided for @searchCardNode.
  ///
  /// In pt, this message translates to:
  /// **'Buscar cartão ou nó'**
  String get searchCardNode;

  /// No description provided for @deleteFlashcard.
  ///
  /// In pt, this message translates to:
  /// **'Excluir flashcard'**
  String get deleteFlashcard;

  /// No description provided for @returnDecksEsc.
  ///
  /// In pt, this message translates to:
  /// **'Voltar aos decks (Esc)'**
  String get returnDecksEsc;

  /// No description provided for @deckOptions.
  ///
  /// In pt, this message translates to:
  /// **'Opções do deck'**
  String get deckOptions;

  /// No description provided for @relatedNode.
  ///
  /// In pt, this message translates to:
  /// **'Nó relacionado'**
  String get relatedNode;

  /// No description provided for @frontCard.
  ///
  /// In pt, this message translates to:
  /// **'Frente do cartão'**
  String get frontCard;

  /// No description provided for @questionConceptTerm.
  ///
  /// In pt, this message translates to:
  /// **'Pergunta, conceito ou termo'**
  String get questionConceptTerm;

  /// No description provided for @backCard.
  ///
  /// In pt, this message translates to:
  /// **'Verso do cartão'**
  String get backCard;

  /// No description provided for @answerExplanation.
  ///
  /// In pt, this message translates to:
  /// **'Resposta ou explicação'**
  String get answerExplanation;

  /// No description provided for @skill.
  ///
  /// In pt, this message translates to:
  /// **'Habilidade (opcional)'**
  String get skill;

  /// No description provided for @deckName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do deck'**
  String get deckName;

  /// No description provided for @searchCardsAnyGraph.
  ///
  /// In pt, this message translates to:
  /// **'Buscar cartões de qualquer grafo'**
  String get searchCardsAnyGraph;

  /// No description provided for @fixFeedback.
  ///
  /// In pt, this message translates to:
  /// **'Feedback da correção'**
  String get fixFeedback;

  /// No description provided for @explainSuccessesGapsNextSteps.
  ///
  /// In pt, this message translates to:
  /// **'Explique acertos, lacunas e próximos passos.'**
  String get explainSuccessesGapsNextSteps;

  /// No description provided for @demonstratedDominance.
  ///
  /// In pt, this message translates to:
  /// **'Domínio demonstrado'**
  String get demonstratedDominance;

  /// No description provided for @fsrsScheduling.
  ///
  /// In pt, this message translates to:
  /// **'Agendamento FSRS'**
  String get fsrsScheduling;

  /// No description provided for @chooseRecallWasCalculateNextInterval.
  ///
  /// In pt, this message translates to:
  /// **'Escolha como foi a recordação para calcular o próximo intervalo.'**
  String get chooseRecallWasCalculateNextInterval;

  /// No description provided for @personalNotes.
  ///
  /// In pt, this message translates to:
  /// **'Anotações pessoais (opcional)'**
  String get personalNotes;

  /// No description provided for @textMoreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções'**
  String get textMoreOptions;

  /// No description provided for @updateList.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar lista'**
  String get updateList;

  /// No description provided for @searchTitleStatement.
  ///
  /// In pt, this message translates to:
  /// **'Buscar por título ou enunciado'**
  String get searchTitleStatement;

  /// No description provided for @updateHistory.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar histórico'**
  String get updateHistory;

  /// No description provided for @additionalGuidance.
  ///
  /// In pt, this message translates to:
  /// **'Orientação adicional (opcional)'**
  String get additionalGuidance;

  /// No description provided for @exAdvancedLevelFocusComparison.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: nível avançado, foco em comparação'**
  String get exAdvancedLevelFocusComparison;

  /// No description provided for @statement.
  ///
  /// In pt, this message translates to:
  /// **'Enunciado'**
  String get statement;

  /// No description provided for @typeQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de questão'**
  String get typeQuestion;

  /// No description provided for @referenceAnswer.
  ///
  /// In pt, this message translates to:
  /// **'Resposta de referência'**
  String get referenceAnswer;

  /// No description provided for @answer.
  ///
  /// In pt, this message translates to:
  /// **'Sua resposta'**
  String get answer;

  /// No description provided for @explainReasoning.
  ///
  /// In pt, this message translates to:
  /// **'Explique seu raciocínio. Você pode usar várias linhas.'**
  String get explainReasoning;

  /// No description provided for @useMultipleLines.
  ///
  /// In pt, this message translates to:
  /// **'Sua tentativa ficará disponível no Histórico.'**
  String get useMultipleLines;

  /// No description provided for @attemptWillAvailableHistory.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: nível intermediário, foco em aplicação'**
  String get attemptWillAvailableHistory;

  /// No description provided for @exIntermediateLevelFocusApplication.
  ///
  /// In pt, this message translates to:
  /// **'Excluir alternativa'**
  String get exIntermediateLevelFocusApplication;

  /// No description provided for @deleteAlternative.
  ///
  /// In pt, this message translates to:
  /// **'Alternativa'**
  String get deleteAlternative;

  /// No description provided for @alternative.
  ///
  /// In pt, this message translates to:
  /// **'Explicação (opcional)'**
  String get alternative;

  /// No description provided for @explanation.
  ///
  /// In pt, this message translates to:
  /// **'Modelos permitidos'**
  String get explanation;

  /// No description provided for @allowedModels.
  ///
  /// In pt, this message translates to:
  /// **'Buscar modelo'**
  String get allowedModels;

  /// No description provided for @searchModel.
  ///
  /// In pt, this message translates to:
  /// **'Nome ou identificador'**
  String get searchModel;

  /// No description provided for @nameIdentifier.
  ///
  /// In pt, this message translates to:
  /// **'Provedor'**
  String get nameIdentifier;

  /// No description provided for @provider.
  ///
  /// In pt, this message translates to:
  /// **'Nome para exibir'**
  String get provider;

  /// No description provided for @displayName.
  ///
  /// In pt, this message translates to:
  /// **'Cor Atual'**
  String get displayName;

  /// No description provided for @currentColor.
  ///
  /// In pt, this message translates to:
  /// **'Tema ativo'**
  String get currentColor;

  /// No description provided for @activeTheme.
  ///
  /// In pt, this message translates to:
  /// **'Nome do tema'**
  String get activeTheme;

  /// No description provided for @themeName.
  ///
  /// In pt, this message translates to:
  /// **'Copiar cor'**
  String get themeName;

  /// No description provided for @pasteColor.
  ///
  /// In pt, this message translates to:
  /// **'Colar cor'**
  String get pasteColor;

  /// No description provided for @chooseColor.
  ///
  /// In pt, this message translates to:
  /// **'Escolher cor'**
  String get chooseColor;

  /// No description provided for @restoreOriginalColor.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar cor original'**
  String get restoreOriginalColor;

  /// No description provided for @configurationSection.
  ///
  /// In pt, this message translates to:
  /// **'Seção de configuração'**
  String get configurationSection;

  /// No description provided for @filterSettings.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar configurações…'**
  String get filterSettings;

  /// No description provided for @cleanFilter.
  ///
  /// In pt, this message translates to:
  /// **'Limpar filtro'**
  String get cleanFilter;

  /// No description provided for @updateStatus.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar status'**
  String get updateStatus;

  /// No description provided for @frequency.
  ///
  /// In pt, this message translates to:
  /// **'Frequência'**
  String get frequency;

  /// No description provided for @every.
  ///
  /// In pt, this message translates to:
  /// **'A cada'**
  String get every;

  /// No description provided for @saveRange.
  ///
  /// In pt, this message translates to:
  /// **'Salvar intervalo'**
  String get saveRange;

  /// No description provided for @updateFilesHistory.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar arquivos e histórico'**
  String get updateFilesHistory;

  /// No description provided for @customKey.
  ///
  /// In pt, this message translates to:
  /// **'Chave personalizada'**
  String get customKey;

  /// No description provided for @keyMinimum12Characters.
  ///
  /// In pt, this message translates to:
  /// **'Chave (mínimo de 12 caracteres)'**
  String get keyMinimum12Characters;

  /// No description provided for @confirmKey.
  ///
  /// In pt, this message translates to:
  /// **'Confirme a chave'**
  String get confirmKey;

  /// No description provided for @exLmStudioOllamaMyServer.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: lm-studio, ollama ou meu-servidor'**
  String get exLmStudioOllamaMyServer;

  /// No description provided for @enterFullAPIURLNormallyEndingV1.
  ///
  /// In pt, this message translates to:
  /// **'Informe a URL completa da API, normalmente terminada em /v1.'**
  String get enterFullAPIURLNormallyEndingV1;

  /// No description provided for @enterFullURLNormallyEndingV1.
  ///
  /// In pt, this message translates to:
  /// **'Informe a URL completa, normalmente terminada em /v1.'**
  String get enterFullURLNormallyEndingV1;

  /// No description provided for @useExactEndpointIDSlashesTagsLike14bValid.
  ///
  /// In pt, this message translates to:
  /// **'Use o ID exato do endpoint; barras e tags como :14b são válidas.'**
  String get useExactEndpointIDSlashesTagsLike14bValid;

  /// No description provided for @totalContextCapacityReportedProvider.
  ///
  /// In pt, this message translates to:
  /// **'Capacidade total de contexto informada pelo provedor.'**
  String get totalContextCapacityReportedProvider;

  /// No description provided for @fullContextCapabilityReportedProvider.
  ///
  /// In pt, this message translates to:
  /// **'Máximo de tokens que o modelo aceita como entrada.'**
  String get fullContextCapabilityReportedProvider;

  /// No description provided for @maximumTokensModelGeneratesResponse.
  ///
  /// In pt, this message translates to:
  /// **'Máximo de tokens que o modelo gera como resposta.'**
  String get maximumTokensModelGeneratesResponse;

  /// No description provided for @definesTypeWorkAgentPerforms.
  ///
  /// In pt, this message translates to:
  /// **'Define o tipo de trabalho que este agente executa.'**
  String get definesTypeWorkAgentPerforms;

  /// No description provided for @valueBetween02LeaveEmptyUseDefault.
  ///
  /// In pt, this message translates to:
  /// **'Valor entre 0 e 2; deixe vazio para usar o padrão.'**
  String get valueBetween02LeaveEmptyUseDefault;

  /// No description provided for @valueBetween02.
  ///
  /// In pt, this message translates to:
  /// **'Valor entre 0 e 2.'**
  String get valueBetween02;

  /// Erro exibido quando um destino de navegação não pode ser carregado
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar o destino: {error}'**
  String couldNotLoadDestination(String error);

  /// No description provided for @responseDetailLevel.
  ///
  /// In pt, this message translates to:
  /// **'Nível de detalhe das respostas'**
  String get responseDetailLevel;

  /// No description provided for @improvePromptsWhenCreatingGraphs.
  ///
  /// In pt, this message translates to:
  /// **'Melhorar prompt ao criar grafos'**
  String get improvePromptsWhenCreatingGraphs;

  /// No description provided for @taskCorrectionMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo de correção das tarefas'**
  String get taskCorrectionMode;

  /// No description provided for @concurrentAutomaticGenerations.
  ///
  /// In pt, this message translates to:
  /// **'Gerações automáticas simultâneas'**
  String get concurrentAutomaticGenerations;

  /// No description provided for @newPassword.
  ///
  /// In pt, this message translates to:
  /// **'Nova senha'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirme a nova senha'**
  String get confirmNewPassword;

  /// No description provided for @nameIdentifyKey.
  ///
  /// In pt, this message translates to:
  /// **'Nome para identificar a chave'**
  String get nameIdentifyKey;

  /// No description provided for @apiKey.
  ///
  /// In pt, this message translates to:
  /// **'Chave de API'**
  String get apiKey;

  /// No description provided for @usernameEmail.
  ///
  /// In pt, this message translates to:
  /// **'Usuário ou e-mail'**
  String get usernameEmail;

  /// No description provided for @recoveryCode.
  ///
  /// In pt, this message translates to:
  /// **'Código de recuperação'**
  String get recoveryCode;

  /// No description provided for @username.
  ///
  /// In pt, this message translates to:
  /// **'Nome de usuário'**
  String get username;

  /// No description provided for @mariaSilva.
  ///
  /// In pt, this message translates to:
  /// **'ex.: maria.silva'**
  String get mariaSilva;

  /// No description provided for @text332Characterschangedlater.
  ///
  /// In pt, this message translates to:
  /// **'De 3 a 32 caracteres; pode ser alterado depois.'**
  String get text332Characterschangedlater;

  /// No description provided for @textDisplayName.
  ///
  /// In pt, this message translates to:
  /// **'Nome de exibição'**
  String get textDisplayName;

  /// No description provided for @wouldLikeAddressed.
  ///
  /// In pt, this message translates to:
  /// **'Como gostaria de ser chamada(o)'**
  String get wouldLikeAddressed;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirme a senha'**
  String get confirmPassword;

  /// No description provided for @user.
  ///
  /// In pt, this message translates to:
  /// **'Usuário'**
  String get user;

  /// No description provided for @clearCompletedTasks.
  ///
  /// In pt, this message translates to:
  /// **'Limpar tarefas concluídas'**
  String get clearCompletedTasks;

  /// No description provided for @updateQueue.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar fila'**
  String get updateQueue;

  /// No description provided for @requeueTask.
  ///
  /// In pt, this message translates to:
  /// **'Reenfileirar tarefa'**
  String get requeueTask;

  /// No description provided for @cancelTask.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar tarefa'**
  String get cancelTask;

  /// Rótulo de acessibilidade para abrir o menu do usuário
  ///
  /// In pt, this message translates to:
  /// **'Abrir menu de {displayName}'**
  String openMenu(String displayName);

  /// No description provided for @dashboardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Painel'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu domínio e evolução nos estudos'**
  String get dashboardSubtitle;

  /// No description provided for @createSessionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar sessão'**
  String get createSessionTitle;

  /// No description provided for @activeStudySessionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sessão em andamento'**
  String get activeStudySessionTitle;

  /// No description provided for @studySessionsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Planeje e acompanhe seu progresso'**
  String get studySessionsSubtitle;

  /// No description provided for @nodeFlashcardsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Flashcards do nó'**
  String get nodeFlashcardsTitle;

  /// No description provided for @answerHistoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de respostas'**
  String get answerHistoryTitle;

  /// No description provided for @exercisesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Exercícios'**
  String get exercisesTitle;

  /// No description provided for @graphsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Grafos'**
  String get graphsTitle;

  /// No description provided for @graphsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Conecte ideias e explore conceitos'**
  String get graphsSubtitle;

  /// No description provided for @notesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Anotações'**
  String get notesTitle;

  /// No description provided for @notesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Organize suas ideias e materiais'**
  String get notesSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Personalize sua experiência no Noema'**
  String get settingsSubtitle;

  /// No description provided for @flashcardsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Flashcards'**
  String get flashcardsTitle;

  /// No description provided for @aiQueueSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe tarefas em segundo plano'**
  String get aiQueueSubtitle;

  /// No description provided for @homeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu espaço de aprendizagem'**
  String get homeSubtitle;

  /// No description provided for @flashcardDeckEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Este deck ainda não tem flashcards.'**
  String get flashcardDeckEmpty;

  /// No description provided for @nextReviewDate.
  ///
  /// In pt, this message translates to:
  /// **'Próxima revisão: {date}.'**
  String nextReviewDate(Object date);

  /// No description provided for @reviewRecordFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível registrar a revisão.'**
  String get reviewRecordFailed;

  /// No description provided for @createNodeBeforeCards.
  ///
  /// In pt, this message translates to:
  /// **'Crie um nó antes de adicionar cartões.'**
  String get createNodeBeforeCards;

  /// No description provided for @flashcardCreated.
  ///
  /// In pt, this message translates to:
  /// **'Flashcard criado.'**
  String get flashcardCreated;

  /// No description provided for @flashcardSaved.
  ///
  /// In pt, this message translates to:
  /// **'Flashcard salvo.'**
  String get flashcardSaved;

  /// No description provided for @flashcardSaveFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível salvar o flashcard.'**
  String get flashcardSaveFailed;

  /// No description provided for @deckCreated.
  ///
  /// In pt, this message translates to:
  /// **'Deck criado.'**
  String get deckCreated;

  /// No description provided for @deckUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Deck atualizado.'**
  String get deckUpdated;

  /// No description provided for @deckSaveFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível salvar o deck.'**
  String get deckSaveFailed;

  /// No description provided for @deleteFlashcardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir flashcard?'**
  String get deleteFlashcardTitle;

  /// No description provided for @cardRemovedFromDecks.
  ///
  /// In pt, this message translates to:
  /// **'“{title}” será removido dos decks que o contêm.'**
  String cardRemovedFromDecks(Object title);

  /// No description provided for @deleteFlashcardFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível excluir o flashcard.'**
  String get deleteFlashcardFailed;

  /// No description provided for @deleteDeckTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir deck?'**
  String get deleteDeckTitle;

  /// No description provided for @deckRemovedCardsRemain.
  ///
  /// In pt, this message translates to:
  /// **'O deck “{name}” será removido. Os flashcards continuarão disponíveis.'**
  String deckRemovedCardsRemain(Object name);

  /// No description provided for @deleteDeckFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível excluir o deck.'**
  String get deleteDeckFailed;

  /// No description provided for @topicAndNodeRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe o tema e escolha um nó para gerar cartões.'**
  String get topicAndNodeRequired;

  /// No description provided for @chooseAvailableNode.
  ///
  /// In pt, this message translates to:
  /// **'Escolha um nó disponível no seu grafo.'**
  String get chooseAvailableNode;

  /// No description provided for @suggestedFlashcards.
  ///
  /// In pt, this message translates to:
  /// **'{count} flashcards sugeridos'**
  String suggestedFlashcards(Object count);

  /// No description provided for @savedFlashcards.
  ///
  /// In pt, this message translates to:
  /// **'{count} flashcards salvos.'**
  String savedFlashcards(Object count);

  /// No description provided for @generateFlashcardsFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível gerar os flashcards: {error}'**
  String generateFlashcardsFailed(Object error);

  /// No description provided for @createNodeBeforeGenerate.
  ///
  /// In pt, this message translates to:
  /// **'Crie um nó antes de gerar flashcards.'**
  String get createNodeBeforeGenerate;

  /// No description provided for @noNodeCardsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Crie um nó antes de gerar flashcards'**
  String get noNodeCardsTitle;

  /// No description provided for @noNodeCardsMessage.
  ///
  /// In pt, this message translates to:
  /// **'Os cartões precisam estar vinculados a um conceito do seu grafo.'**
  String get noNodeCardsMessage;

  /// No description provided for @createFlashcardsWithAi.
  ///
  /// In pt, this message translates to:
  /// **'Criar flashcards com IA'**
  String get createFlashcardsWithAi;

  /// No description provided for @reviewThemeBeforeGenerate.
  ///
  /// In pt, this message translates to:
  /// **'Revise o tema e escolha o nó. A geração cria uma prévia; nada será salvo sem sua confirmação.'**
  String get reviewThemeBeforeGenerate;

  /// No description provided for @generatingPreview.
  ///
  /// In pt, this message translates to:
  /// **'Gerando prévia...'**
  String get generatingPreview;

  /// No description provided for @generatePreview.
  ///
  /// In pt, this message translates to:
  /// **'Gerar prévia'**
  String get generatePreview;

  /// No description provided for @createWithAi.
  ///
  /// In pt, this message translates to:
  /// **'Criar com IA'**
  String get createWithAi;

  /// No description provided for @flashcardsLoading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando flashcards...'**
  String get flashcardsLoading;

  /// No description provided for @flashcardsLoadFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar seus flashcards.'**
  String get flashcardsLoadFailed;

  /// No description provided for @flashcardLibrarySummary.
  ///
  /// In pt, this message translates to:
  /// **'{cards} {cards, plural, =1 {cartão} other {cartões}} · {due} para revisar agora'**
  String flashcardLibrarySummary(num cards, Object due);

  /// No description provided for @newCard.
  ///
  /// In pt, this message translates to:
  /// **'Novo cartão'**
  String get newCard;

  /// No description provided for @createDeck.
  ///
  /// In pt, this message translates to:
  /// **'Criar deck'**
  String get createDeck;

  /// No description provided for @emptyFlashcardLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Sua biblioteca está vazia'**
  String get emptyFlashcardLibrary;

  /// No description provided for @emptyFlashcardLibraryMessage.
  ///
  /// In pt, this message translates to:
  /// **'Crie flashcards nos detalhes de um nó ou adicione o primeiro cartão aqui.'**
  String get emptyFlashcardLibraryMessage;

  /// No description provided for @createFirstCard.
  ///
  /// In pt, this message translates to:
  /// **'Criar primeiro cartão'**
  String get createFirstCard;

  /// No description provided for @automaticDecks.
  ///
  /// In pt, this message translates to:
  /// **'Decks automáticos'**
  String get automaticDecks;

  /// No description provided for @generatedFromGraphs.
  ///
  /// In pt, this message translates to:
  /// **'Gerados a partir dos seus grafos e nós.'**
  String get generatedFromGraphs;

  /// No description provided for @byGraph.
  ///
  /// In pt, this message translates to:
  /// **'Por grafo'**
  String get byGraph;

  /// No description provided for @automaticGraphDeck.
  ///
  /// In pt, this message translates to:
  /// **'{count} cartões · deck automático do grafo'**
  String automaticGraphDeck(Object count);

  /// No description provided for @byNode.
  ///
  /// In pt, this message translates to:
  /// **'Por nó'**
  String get byNode;

  /// No description provided for @graphFallback.
  ///
  /// In pt, this message translates to:
  /// **'Grafo'**
  String get graphFallback;

  /// No description provided for @myDecks.
  ///
  /// In pt, this message translates to:
  /// **'Meus decks'**
  String get myDecks;

  /// No description provided for @customDecksDescription.
  ///
  /// In pt, this message translates to:
  /// **'Combinações personalizadas de cartões.'**
  String get customDecksDescription;

  /// No description provided for @allCards.
  ///
  /// In pt, this message translates to:
  /// **'Todos os cartões ({count})'**
  String allCards(Object count);

  /// No description provided for @searchEditRemoveCards.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar, editar ou remover cartões'**
  String get searchEditRemoveCards;

  /// No description provided for @noCardsMatchSearch.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum cartão corresponde à busca.'**
  String get noCardsMatchSearch;

  /// No description provided for @studyDeck.
  ///
  /// In pt, this message translates to:
  /// **'Estudar deck'**
  String get studyDeck;

  /// No description provided for @nodeNoCardsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Este nó ainda não tem flashcards'**
  String get nodeNoCardsTitle;

  /// No description provided for @nodeNoCardsMessage.
  ///
  /// In pt, this message translates to:
  /// **'Crie um cartão; ele será incluído automaticamente neste deck.'**
  String get nodeNoCardsMessage;

  /// No description provided for @nodeCards.
  ///
  /// In pt, this message translates to:
  /// **'Cartões do nó'**
  String get nodeCards;

  /// No description provided for @allCardsUpToDate.
  ///
  /// In pt, this message translates to:
  /// **'Tudo em dia. Os cartões já revisados voltarão na data programada.'**
  String get allCardsUpToDate;

  /// No description provided for @reviewNow.
  ///
  /// In pt, this message translates to:
  /// **'Revisar agora'**
  String get reviewNow;

  /// No description provided for @cardProgress.
  ///
  /// In pt, this message translates to:
  /// **'Cartão {current} de {total} · {reviewed} revisados'**
  String cardProgress(Object current, Object reviewed, Object total);

  /// No description provided for @reviewProgress.
  ///
  /// In pt, this message translates to:
  /// **'Progresso da revisão'**
  String get reviewProgress;

  /// No description provided for @showAnswerSpace.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar resposta · Espaço'**
  String get showAnswerSpace;

  /// No description provided for @flashcardAnswer.
  ///
  /// In pt, this message translates to:
  /// **'Resposta do flashcard'**
  String get flashcardAnswer;

  /// No description provided for @flashcardQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Pergunta do flashcard'**
  String get flashcardQuestion;

  /// No description provided for @revealCardHint.
  ///
  /// In pt, this message translates to:
  /// **'Toque, pressione espaço ou deslize para revelar'**
  String get revealCardHint;

  /// No description provided for @answerLabel.
  ///
  /// In pt, this message translates to:
  /// **'RESPOSTA'**
  String get answerLabel;

  /// No description provided for @questionLabel.
  ///
  /// In pt, this message translates to:
  /// **'PERGUNTA'**
  String get questionLabel;

  /// No description provided for @tapToQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Toque para voltar à pergunta'**
  String get tapToQuestion;

  /// No description provided for @tapToReveal.
  ///
  /// In pt, this message translates to:
  /// **'Toque ou deslize para cima para revelar'**
  String get tapToReveal;

  /// No description provided for @ratingAgain.
  ///
  /// In pt, this message translates to:
  /// **'Não lembrei'**
  String get ratingAgain;

  /// No description provided for @ratingHard.
  ///
  /// In pt, this message translates to:
  /// **'Difícil'**
  String get ratingHard;

  /// No description provided for @ratingGood.
  ///
  /// In pt, this message translates to:
  /// **'Lembrei'**
  String get ratingGood;

  /// No description provided for @ratingEasy.
  ///
  /// In pt, this message translates to:
  /// **'Fácil'**
  String get ratingEasy;

  /// No description provided for @keyboardKey.
  ///
  /// In pt, this message translates to:
  /// **'Tecla {key}'**
  String keyboardKey(Object key);

  /// No description provided for @reviewComplete.
  ///
  /// In pt, this message translates to:
  /// **'Revisão concluída'**
  String get reviewComplete;

  /// No description provided for @allCaughtUp.
  ///
  /// In pt, this message translates to:
  /// **'Tudo em dia'**
  String get allCaughtUp;

  /// No description provided for @reviewTime.
  ///
  /// In pt, this message translates to:
  /// **'Tempo de revisão: {duration}'**
  String reviewTime(Object duration);

  /// No description provided for @cardsReviewed.
  ///
  /// In pt, this message translates to:
  /// **'{count} cartões revisados em “{deck}”.'**
  String cardsReviewed(Object count, Object deck);

  /// No description provided for @noPendingCards.
  ///
  /// In pt, this message translates to:
  /// **'Não há cartões pendentes neste deck agora.'**
  String get noPendingCards;

  /// No description provided for @backToDecks.
  ///
  /// In pt, this message translates to:
  /// **'Voltar aos decks'**
  String get backToDecks;

  /// No description provided for @studyAllAnyway.
  ///
  /// In pt, this message translates to:
  /// **'Estudar todos mesmo assim'**
  String get studyAllAnyway;

  /// No description provided for @newFlashcard.
  ///
  /// In pt, this message translates to:
  /// **'Novo flashcard'**
  String get newFlashcard;

  /// No description provided for @editFlashcard.
  ///
  /// In pt, this message translates to:
  /// **'Editar flashcard'**
  String get editFlashcard;

  /// No description provided for @selectNode.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um nó.'**
  String get selectNode;

  /// No description provided for @frontRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe a frente do cartão.'**
  String get frontRequired;

  /// No description provided for @answerRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe a resposta.'**
  String get answerRequired;

  /// No description provided for @createDeckTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar deck'**
  String get createDeckTitle;

  /// No description provided for @editDeckTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar deck'**
  String get editDeckTitle;

  /// No description provided for @selectedCards.
  ///
  /// In pt, this message translates to:
  /// **'{count} selecionados'**
  String selectedCards(Object count);

  /// No description provided for @selectVisible.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar visíveis'**
  String get selectVisible;

  /// No description provided for @clearVisible.
  ///
  /// In pt, this message translates to:
  /// **'Limpar visíveis'**
  String get clearVisible;

  /// No description provided for @nodeUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Nó indisponível'**
  String get nodeUnavailable;

  /// No description provided for @deckNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe um nome para o deck.'**
  String get deckNameRequired;

  /// No description provided for @atLeastOneCard.
  ///
  /// In pt, this message translates to:
  /// **'Selecione pelo menos um cartão.'**
  String get atLeastOneCard;

  /// No description provided for @saveDeck.
  ///
  /// In pt, this message translates to:
  /// **'Salvar deck'**
  String get saveDeck;

  /// No description provided for @dueCardsNow.
  ///
  /// In pt, this message translates to:
  /// **'{count} para revisar agora'**
  String dueCardsNow(Object count);

  /// No description provided for @cardCountInDeck.
  ///
  /// In pt, this message translates to:
  /// **'{count} cartões · {kind}'**
  String cardCountInDeck(Object count, Object kind);

  /// No description provided for @customDeckKind.
  ///
  /// In pt, this message translates to:
  /// **'deck personalizado'**
  String get customDeckKind;

  /// No description provided for @reviewedCardsSummary.
  ///
  /// In pt, this message translates to:
  /// **'Revise em um único fluxo · {count} no total'**
  String reviewedCardsSummary(Object count);
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
