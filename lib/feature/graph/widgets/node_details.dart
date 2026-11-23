import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/service/learning_path.dart';
import 'package:noema/feature/graph/service/study_resource_recommendation_service.dart';
import 'package:noema/feature/graph/providers/recommended_study_content_provider.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/ai/services/ai_background_work_scheduler.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';
import 'package:noema/feature/review/data/domain_mastery_service.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:url_launcher/url_launcher.dart';

class NodeDetails extends ConsumerStatefulWidget {
  const NodeDetails({
    super.key,
    required this.node,
    required this.progress,
    required this.progressByNodeId,
    this.isRecommended = false,
    this.prerequisiteNodes = const [],
    this.prerequisitePathNodes = const [],
    this.subtopics = const [],
    this.onSelectRelatedNode,
    this.onNodeChanged,
    this.onClose,
    this.scrollController,
  });

  final GraphNodeData node;
  final LearningNodeProgress progress;
  final Map<String, LearningNodeProgress> progressByNodeId;
  final bool isRecommended;
  final List<GraphNodeData> prerequisiteNodes;
  final List<GraphNodeData> prerequisitePathNodes;
  final List<GraphNodeData> subtopics;
  final ValueChanged<GraphNodeData>? onSelectRelatedNode;
  final Future<void> Function()? onNodeChanged;
  final VoidCallback? onClose;
  final ScrollController? scrollController;

  @override
  ConsumerState<NodeDetails> createState() => _NodeDetailsState();
}

class _NodeDetailsState extends ConsumerState<NodeDetails> {
  static final _automaticPackNodes = <String>{};
  final _learningGuidanceKey = GlobalKey();
  final _resourcesKey = GlobalKey();
  late Future<List<LearningResourceData>> _resourcesFuture;
  late Stream<List<DomainLogData>> _domainLogsStream;
  bool _isDescriptionExpanded = false;
  bool _isRecommendingResources = false;
  bool _isGeneratingStudyPack = false;

  @override
  void initState() {
    super.initState();
    _loadResources();
    _loadDomainLogs();
    if (widget.isRecommended && !widget.progress.isContainer) {
      _scheduleRecommendedPackGeneration();
    }
  }

  @override
  void didUpdateWidget(covariant NodeDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node.id != widget.node.id) {
      _isDescriptionExpanded = false;
      _loadResources();
      _loadDomainLogs();
    }
    if (widget.isRecommended &&
        !widget.progress.isContainer &&
        (oldWidget.node.id != widget.node.id || !oldWidget.isRecommended)) {
      _scheduleRecommendedPackGeneration();
    }
  }

  void _scheduleRecommendedPackGeneration() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_generateRecommendedPackIfMissing());
    });
  }

  void _loadResources() {
    _resourcesFuture = LearningResourceDao(
      ref.read(appDatabaseProvider),
    ).getLearningResourcesByNode(nodeId: widget.node.id);
  }

  void _loadDomainLogs() {
    final database = ref.read(appDatabaseProvider);
    _domainLogsStream =
        (database.select(database.domainLog)
              ..where((log) => log.nodeId.equals(widget.node.id))
              ..orderBy([(log) => OrderingTerm.desc(log.loggedAt)])
              ..limit(10))
            .watch();
  }

  void _continueStudyingWithGaps() {
    final targetContext = _resourcesKey.currentContext;
    if (targetContext == null) return;
    unawaited(
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.08,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _recommendResources() async {
    if (_isRecommendingResources) return;
    setState(() => _isRecommendingResources = true);
    try {
      final suggestions = await ref
          .read(studyResourceRecommendationServiceProvider)
          .recommend(
            nodeTitle: widget.node.title,
            nodeDescription: widget.node.description,
          );
      if (!mounted) return;

      if (suggestions.isEmpty) {
        _showResourceMessage(
          'Nenhum material foi encontrado. Verifique as fontes de pesquisa '
          'configuradas e tente novamente.',
        );
        return;
      }

      final selected = await _reviewResourceSuggestions(suggestions);
      if (selected == null || selected.isEmpty || !mounted) return;

      final database = ref.read(appDatabaseProvider);
      final dao = LearningResourceDao(database);
      final existing = await dao.getLearningResourcesByNode(
        nodeId: widget.node.id,
      );
      final existingUrls = {
        for (final resource in existing)
          if (StudyResourceRecommendationService.resourceUrlKey(
            resource.url,
          ).isNotEmpty)
            StudyResourceRecommendationService.resourceUrlKey(resource.url),
      };
      final newResources = selected
          .where(
            (resource) => !existingUrls.contains(
              StudyResourceRecommendationService.resourceUrlKey(resource.url),
            ),
          )
          .toList(growable: false);
      if (newResources.isEmpty) {
        _showResourceMessage(
          'Os materiais selecionados já estão vinculados a este conceito.',
        );
        return;
      }

      await database.transaction(() async {
        for (final resource in newResources) {
          await dao.insertLearningResource(
            nodeId: widget.node.id,
            category: resource.category,
            title: resource.title,
            author: resource.author,
            url: resource.url,
            tier: resource.tier,
            rationale: resource.rationale,
            relevanceScore: resource.relevanceScore,
            reputationScore: resource.reputationScore,
            isAiGenerated: true,
          );
        }
      });
      if (!mounted) return;
      setState(_loadResources);
      _showResourceMessage(
        '${newResources.length} materiais adicionados ao conceito.',
      );
      await _scrollToResources();
    } on DioException catch (error) {
      if (mounted) _showResourceMessage(_resourceApiError(error));
    } on FormatException catch (error) {
      if (mounted) {
        _showResourceMessage(
          'Resposta de recomendações inválida: ${error.message}',
        );
      }
    } catch (error) {
      if (mounted) {
        _showResourceMessage(
          error is StateError
              ? error.message
              : 'Não foi possível recomendar materiais: $error',
        );
      }
    } finally {
      if (mounted) setState(() => _isRecommendingResources = false);
    }
  }

  Future<List<StudyResourceSuggestion>?> _reviewResourceSuggestions(
    List<StudyResourceSuggestion> suggestions,
  ) {
    final selected = {
      for (var index = 0; index < suggestions.length; index++) index,
    };
    return showDialog<List<StudyResourceSuggestion>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: RuntimeLocalizedText(
            'Materiais recomendados para este conceito',
          ),
          content: SizedBox(
            width: 560,
            height: 460,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RuntimeLocalizedText(
                  'Revise e selecione o que deseja adicionar.',
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: suggestions.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final resource = suggestions[index];
                      return CheckboxListTile(
                        value: selected.contains(index),
                        onChanged: (value) => setDialogState(() {
                          if (value == true) {
                            selected.add(index);
                          } else {
                            selected.remove(index);
                          }
                        }),
                        title: Text(resource.title),
                        subtitle: Text(
                          '${_categoryLabel(resource.category)} · '
                          '${_tierLabel(resource.tier)}\n'
                          '${resource.rationale}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const RuntimeLocalizedText('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.pop(dialogContext, [
                      for (final index in selected.toList()..sort())
                        suggestions[index],
                    ]),
              icon: const Icon(Icons.bookmark_add_outlined),
              label: RuntimeLocalizedText('Adicionar ${selected.length}'),
            ),
          ],
        ),
      ),
    );
  }

  String _resourceApiError(DioException error) {
    final status = error.response?.statusCode;
    if (status == 401 || status == 403) {
      return 'Sua sessão expirou ou não está autorizada para recomendar materiais.';
    }
    if (status == 404) {
      return 'O agente de recomendação de materiais não está configurado.';
    }
    if (status == 429) {
      return 'Muitas solicitações. Aguarde e tente novamente.';
    }
    if (status != null && status >= 500) {
      return 'O serviço de recomendações falhou. Tente novamente mais tarde.';
    }
    if (error.response == null) {
      return 'Sem conexão com o serviço de recomendações.';
    }
    return 'Não foi possível buscar materiais (HTTP $status).';
  }

  void _showResourceMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openAiFlashcardCreation() async {
    final node = widget.node;
    await context.push(
      RoutePaths.flashcardsForNode(node.graphId, node.id),
      extra: StudyAssistantHandoff(
        type: StudyAssistantActionType.createFlashcards,
        prompt: 'Crie flashcards de estudo sobre ${node.title}.',
        graphId: node.graphId,
        nodeId: node.id,
      ),
    );
  }

  Future<void> _openAiExerciseCreation() async {
    final type = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const RuntimeLocalizedText('Que tipo de questão deseja gerar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Escolha o formato. A questão será vinculada a este conceito.',
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const RuntimeLocalizedText('Múltipla escolha'),
              onTap: () => Navigator.pop(dialogContext, 'multiple_choice'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: const RuntimeLocalizedText('Dissertativa'),
              onTap: () => Navigator.pop(dialogContext, 'essay'),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline_rounded),
              title: const RuntimeLocalizedText('Método Feynman'),
              onTap: () => Navigator.pop(dialogContext, 'feynman'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const RuntimeLocalizedText('Cancelar'),
          ),
        ],
      ),
    );
    if (type == null || !mounted) return;

    final node = widget.node;
    final prompt = switch (type) {
      'multiple_choice' => 'Crie uma questão de múltipla escolha',
      'feynman' => 'Crie uma questão pelo método Feynman',
      _ => 'Crie uma questão dissertativa',
    };
    final handoff = StudyAssistantHandoff(
      type: StudyAssistantActionType.createExercise,
      prompt:
          '$prompt sobre ${node.title}. '
          '${node.description ?? ''}',
      exerciseType: type,
      graphId: node.graphId,
      nodeId: node.id,
      autoGenerate: true,
    );
    await context.push(
      type == 'multiple_choice'
          ? RoutePaths.multipleChoiceCreate(node.graphId, node.id)
          : RoutePaths.openEndedCreate(node.graphId, node.id),
      extra: handoff,
    );
  }

  Future<({StudyPackRequest request, bool runInBackground})?>
  _askStudyPackRequest() async {
    final multipleChoice = TextEditingController(text: '0');
    final essay = TextEditingController(text: '0');
    final feynman = TextEditingController(text: '0');
    final flashcards = TextEditingController(text: '0');
    final instructions = TextEditingController();
    String? error;
    try {
      return await showDialog<
        ({StudyPackRequest request, bool runInBackground})
      >(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            void submit(bool runInBackground) {
              final counts = StudyPackCounts(
                multipleChoice: int.tryParse(multipleChoice.text) ?? -1,
                essay: int.tryParse(essay.text) ?? -1,
                feynman: int.tryParse(feynman.text) ?? -1,
                flashcards: int.tryParse(flashcards.text) ?? -1,
              );
              try {
                counts.validate();
              } on ArgumentError {
                setDialogState(
                  () => error =
                      'Use valores inteiros de 0 a 20 e inclua ao menos um item (máximo 40).',
                );
                return;
              }
              Navigator.pop(context, (
                request: StudyPackRequest(
                  counts: counts,
                  instructions: instructions.text.trim(),
                ),
                runInBackground: runInBackground,
              ));
            }

            Widget countField(String label, TextEditingController controller) =>
                SizedBox(
                  width: 205,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: label),
                  ),
                );
            return AlertDialog(
              title: const RuntimeLocalizedText('Montar pacote de estudo'),
              content: SizedBox(
                width: 460,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          countField('Múltipla escolha (0-20)', multipleChoice),
                          countField('Dissertativas (0-20)', essay),
                          countField('Feynman (0-20)', feynman),
                          countField('Flashcards (0-20)', flashcards),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: instructions,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 240,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.textAdditionalInstructions,
                        ),
                      ),
                      if (error != null)
                        Text(
                          error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const RuntimeLocalizedText('Cancelar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => submit(true),
                  icon: const Icon(Icons.schedule_send_outlined),
                  label: const RuntimeLocalizedText('Em segundo plano'),
                ),
                FilledButton.icon(
                  onPressed: () => submit(false),
                  icon: const Icon(Icons.auto_awesome),
                  label: const RuntimeLocalizedText('Gerar prévia'),
                ),
              ],
            );
          },
        ),
      );
    } finally {
      multipleChoice.dispose();
      essay.dispose();
      feynman.dispose();
      flashcards.dispose();
      instructions.dispose();
    }
  }

  Future<void> _createStudyPack() async {
    if (_isGeneratingStudyPack || widget.progress.isContainer) return;
    final selection = await _askStudyPackRequest();
    if (selection == null || !mounted) return;
    final request = selection.request;
    setState(() => _isGeneratingStudyPack = true);
    try {
      final database = ref.read(appDatabaseProvider);
      final notifications = ref.read(aiTaskNotificationServiceProvider);
      final runner = ref.read(aiBackgroundTaskRunnerProvider);
      final ai = ref.read(aiContentGenerationServiceProvider);
      await notifications.initialize(requestPermission: true);
      if (selection.runInBackground) {
        final taskId = await AiBackgroundTaskDao(database).enqueueStudyPack(
          nodeId: widget.node.id,
          payload: {
            ...request.toJson(),
            'deck_name': '${widget.node.title} - pacote de estudo',
          },
        );
        await scheduleAiBackgroundQueue(taskId: taskId);
        runner.requestPump();
        if (mounted) {
          _showResourceMessage('Pacote enfileirado para processamento.');
        }
        return;
      }
      final service = StudyPackService(ai: ai, database: database);
      final studyResources = await LearningResourceDao(
        database,
      ).getLearningResourcesByNode(nodeId: widget.node.id);
      final draft = await service.generate(
        nodeTitle: widget.node.title,
        nodeDescription: widget.node.description,
        request: request,
        studyMaterials: StudyPackService.studyMaterialContext(studyResources),
      );
      if (!mounted) {
        await service.save(
          nodeId: widget.node.id,
          flashcardDeckName: '${widget.node.title} - pacote de estudo',
          draft: draft,
        );
        await notifications.show(
          taskId: DateTime.now().microsecondsSinceEpoch.toString(),
          taskType: aiStudyPackTaskType,
          nodeTitle: widget.node.title,
        );
        return;
      }
      final items = <({String title, String subtitle})>[
        for (final question in draft.multipleChoice)
          (
            title: 'Múltipla escolha: ${question.title}',
            subtitle: question.statement,
          ),
        for (final question in draft.openEnded)
          (
            title:
                '${question.type == 'FEYNMAN' ? 'Feynman' : 'Dissertativa'}: ${question.title}',
            subtitle: question.statement,
          ),
        for (final card in draft.flashcards)
          (title: 'Flashcard: ${card.title}', subtitle: card.statement),
      ];
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: RuntimeLocalizedText('Prévia do pacote (${draft.total})'),
          content: SizedBox(
            width: 520,
            height: 420,
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(items[index].title),
                subtitle: Text(items[index].subtitle),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const RuntimeLocalizedText('Descartar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.save_outlined),
              label: const RuntimeLocalizedText('Salvar pacote'),
            ),
          ],
        ),
      );
      if (accepted != true || !mounted) return;
      await service.save(
        nodeId: widget.node.id,
        flashcardDeckName: '${widget.node.title} - pacote de estudo',
        draft: draft,
      );
      if (mounted) {
        _showResourceMessage('Pacote de estudo gerado e salvo.');
      }
    } catch (error) {
      if (mounted) {
        _showResourceMessage('Não foi possível gerar o pacote: $error');
      }
    } finally {
      if (mounted) setState(() => _isGeneratingStudyPack = false);
    }
  }

  Future<void> _generateRecommendedPackIfMissing() async {
    final node = widget.node;
    if (!_automaticPackNodes.add(node.id)) return;
    try {
      final settings = await ref.read(
        recommendedStudyContentSettingsProvider.future,
      );
      if (!mounted ||
          !widget.isRecommended ||
          widget.progress.isContainer ||
          widget.node.id != node.id ||
          !settings.enabled ||
          settings.counts.total == 0) {
        return;
      }
      final database = ref.read(appDatabaseProvider);
      final runner = ref.read(aiBackgroundTaskRunnerProvider);
      final notifications = ref.read(aiTaskNotificationServiceProvider);
      final multipleChoices =
          await (database.select(database.multipleChoice)..where(
                (item) =>
                    item.nodeId.equals(node.id) &
                    item.softDeleted.equals(false),
              ))
              .get();
      final openEnded =
          await (database.select(database.openEnded)..where(
                (item) =>
                    item.nodeId.equals(node.id) &
                    item.softDeleted.equals(false),
              ))
              .get();
      final flashcards =
          await (database.select(database.flashcard)..where(
                (item) =>
                    item.nodeId.equals(node.id) &
                    item.softDeleted.equals(false),
              ))
              .get();
      final resources = await LearningResourceDao(
        database,
      ).getLearningResourcesByNode(nodeId: node.id);
      final hasExistingStudyMaterial =
          multipleChoices.isNotEmpty ||
          openEnded.isNotEmpty ||
          flashcards.isNotEmpty ||
          resources.isNotEmpty;
      if (hasExistingStudyMaterial) {
        if (!mounted ||
            !widget.isRecommended ||
            widget.progress.isContainer ||
            widget.node.id != node.id) {
          return;
        }
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: RuntimeLocalizedText('Este nó já tem material de estudo'),
            content: Text(
              'Encontramos ${multipleChoices.length} questões de múltipla '
              'escolha, ${openEnded.length} questões dissertativas/Feynman, '
              '${flashcards.length} flashcards e ${resources.length} materiais '
              'vinculados. Quer acrescentar o pacote configurado com '
              '${settings.counts.multipleChoice} questões de múltipla escolha, '
              '${settings.counts.essay} dissertativas, '
              '${settings.counts.feynman} Feynman e '
              '${settings.counts.flashcards} flashcards?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const RuntimeLocalizedText('Agora não'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const RuntimeLocalizedText('Gerar conteúdo'),
              ),
            ],
          ),
        );
        if (confirmed != true ||
            !mounted ||
            !widget.isRecommended ||
            widget.progress.isContainer ||
            widget.node.id != node.id) {
          return;
        }
      }
      if (mounted) setState(() => _isGeneratingStudyPack = true);
      final request = StudyPackRequest(counts: settings.counts);
      await notifications.initialize(requestPermission: true);
      final taskId = await AiBackgroundTaskDao(database).enqueueStudyPack(
        nodeId: node.id,
        payload: {
          ...request.toJson(),
          'deck_name': '${node.title} - estudo recomendado',
        },
      );
      await scheduleAiBackgroundQueue(taskId: taskId);
      runner.requestPump();
      if (mounted) {
        _showResourceMessage(
          'Preparação do conteúdo de "${node.title}" iniciada.',
        );
      }
    } catch (error) {
      if (mounted) {
        _showResourceMessage(
          'Não foi possível preparar o conteúdo deste nó: $error',
        );
      }
    } finally {
      _automaticPackNodes.remove(node.id);
      if (mounted) setState(() => _isGeneratingStudyPack = false);
    }
  }

  Future<void> _editNode() async {
    final titleController = TextEditingController(text: widget.node.title);
    final descriptionController = TextEditingController(
      text: widget.node.description ?? '',
    );
    var type = widget.node.type;
    var isSaving = false;
    var savedSuccessfully = false;
    String? error;

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const RuntimeLocalizedText('Editar conceito'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.type,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'AREA',
                        child: RuntimeLocalizedText('Área'),
                      ),
                      DropdownMenuItem(
                        value: 'TOPIC',
                        child: RuntimeLocalizedText('Tópico'),
                      ),
                      DropdownMenuItem(
                        value: 'CONCEPT',
                        child: RuntimeLocalizedText('Conceito'),
                      ),
                      DropdownMenuItem(
                        value: 'SUBCONCEPT',
                        child: RuntimeLocalizedText('Subconceito'),
                      ),
                    ],
                    onChanged: isSaving
                        ? null
                        : (value) {
                            if (value != null) {
                              setDialogState(() => type = value);
                            }
                          },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    enabled: !isSaving,
                    autofocus: true,
                    maxLength: 100,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.textTitle,
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    enabled: !isSaving,
                    maxLines: 4,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.summary,
                      alignLabelWithHint: true,
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving
                    ? null
                    : () => Navigator.pop(dialogContext, false),
                child: const RuntimeLocalizedText('Cancelar'),
              ),
              FilledButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          setDialogState(
                            () => error = 'Informe um título para o conceito.',
                          );
                          return;
                        }
                        setDialogState(() {
                          isSaving = true;
                          error = null;
                        });
                        try {
                          final updatedRows =
                              await GraphNodeDao(
                                ref.read(appDatabaseProvider),
                              ).updateGraphNode(
                                id: widget.node.id,
                                type: type,
                                title: title,
                                description: Value(
                                  descriptionController.text.trim().isEmpty
                                      ? null
                                      : descriptionController.text.trim(),
                                ),
                                updatedAt:
                                    DateTime.now()
                                        .toUtc()
                                        .millisecondsSinceEpoch ~/
                                    1000,
                              );
                          if (updatedRows == 0) {
                            throw StateError('O conceito não existe mais.');
                          }
                          await widget.onNodeChanged?.call();
                          savedSuccessfully = true;
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext, true);
                          }
                        } catch (saveError) {
                          if (dialogContext.mounted) {
                            setDialogState(() {
                              error = 'Não foi possível salvar: $saveError';
                            });
                          }
                        } finally {
                          if (!savedSuccessfully && dialogContext.mounted) {
                            setDialogState(() => isSaving = false);
                          }
                        }
                      },
                child: isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const RuntimeLocalizedText('Salvar'),
              ),
            ],
          ),
        ),
      );
      if (saved == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: RuntimeLocalizedText('Conceito atualizado.')),
        );
      }
    } finally {
      titleController.dispose();
      descriptionController.dispose();
    }
  }

  Future<void> _openResource(LearningResourceData resource) async {
    final rawUrl = resource.url?.trim();
    if (rawUrl == null || rawUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: RuntimeLocalizedText('Este material não tem um link.'),
        ),
      );
      return;
    }
    var uri = Uri.tryParse(rawUrl);
    if (uri != null && uri.scheme.isEmpty) {
      uri = Uri.tryParse('https://$rawUrl');
    }
    if (uri == null || !{'http', 'https'}.contains(uri.scheme)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: RuntimeLocalizedText('O link deste material é inválido.'),
        ),
      );
      return;
    }
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: RuntimeLocalizedText('Não foi possível abrir o material.'),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RuntimeLocalizedText(
            'Não foi possível abrir o material: $error',
          ),
        ),
      );
    }
  }

  Future<void> _scrollToRecommendations() async {
    final targetContext = _learningGuidanceKey.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      alignment: 0.1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _scrollToResources() async {
    final targetContext = _resourcesKey.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      alignment: 0.1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(recommendedStudyContentSettingsProvider, (previous, next) {
      if (widget.isRecommended &&
          previous?.asData?.value.enabled != true &&
          next.asData?.value.enabled == true) {
        _scheduleRecommendedPackGeneration();
      }
    });
    final node = widget.node;
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _nodeIcon(node.type),
                    color: colors.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalhes do conceito',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.editConcept,
                  onPressed: _editNode,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.closeDetails,
                  onPressed:
                      widget.onClose ??
                      ref.read(selectedProvider.notifier).clear,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: Icon(_nodeIcon(node.type), size: 17),
                label: Text(_nodeTypeLabel(node.type)),
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: colors.outlineVariant),
                backgroundColor: colors.surfaceContainerLow,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              node.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    node.description?.trim().isNotEmpty == true
                        ? node.description!
                        : 'Este conceito ainda não tem descrição.',
                    maxLines: _isDescriptionExpanded ? null : 4,
                    overflow: _isDescriptionExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: node.description?.trim().isNotEmpty == true
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  if ((node.description?.length ?? 0) > 160)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(
                          () =>
                              _isDescriptionExpanded = !_isDescriptionExpanded,
                        ),
                        child: Text(
                          _isDescriptionExpanded ? 'Ver menos' : 'Ver mais',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: colors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      RuntimeLocalizedText(
                        'Criar com IA',
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gere conteúdo para este conceito e revise antes de salvar.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: _openAiFlashcardCreation,
                        icon: const Icon(Icons.style_outlined),
                        label: const RuntimeLocalizedText('Gerar flashcards'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _openAiExerciseCreation,
                        icon: const Icon(Icons.quiz_outlined),
                        label: RuntimeLocalizedText(
                          AppLocalizations.of(context)!.generateQuestionWithAi,
                        ),
                      ),
                      if (!widget.progress.isContainer)
                        OutlinedButton.icon(
                          onPressed: _isGeneratingStudyPack
                              ? null
                              : _createStudyPack,
                          icon: _isGeneratingStudyPack
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.library_add_check_outlined),
                          label: RuntimeLocalizedText(
                            _isGeneratingStudyPack
                                ? 'Gerando pacote...'
                                : 'Gerar pacote misto',
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: _isRecommendingResources
                            ? null
                            : _recommendResources,
                        icon: _isRecommendingResources
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.menu_book_outlined),
                        label: Text(
                          _isRecommendingResources
                              ? 'Buscando materiais...'
                              : 'Recomendar materiais',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _MasteryDetails(
              score: widget.progress.masteryScore,
              status: widget.progress.status,
              prerequisiteCount: widget.prerequisiteNodes.length,
              subtopicCount: widget.subtopics.length,
              isContainer: widget.progress.isContainer,
            ),
            const SizedBox(height: 10),
            KeyedSubtree(
              key: _learningGuidanceKey,
              child: _LearningGuidance(
                progress: widget.progress,
                progressByNodeId: widget.progressByNodeId,
                prerequisiteNodes: widget.prerequisiteNodes,
                prerequisitePathNodes: widget.prerequisitePathNodes,
                subtopics: widget.subtopics,
                onSelectRelatedNode: widget.onSelectRelatedNode,
                onStudyAnyway: _continueStudyingWithGaps,
              ),
            ),
            StreamBuilder<List<DomainLogData>>(
              stream: _domainLogsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Não foi possível carregar o histórico de domínio: '
                      '${snapshot.error}',
                      style: textTheme.bodySmall?.copyWith(color: colors.error),
                    ),
                  );
                }
                final logs = snapshot.data;
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 8),
                  title: const RuntimeLocalizedText('Histórico de domínio'),
                  subtitle: logs == null
                      ? const RuntimeLocalizedText('Carregando alterações...')
                      : Text(
                          logs.isEmpty
                              ? 'Ainda não há alterações registradas'
                              : 'Últimas ${logs.length} alterações',
                        ),
                  children: [
                    if (logs != null && logs.isNotEmpty)
                      for (final log in logs)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.history, size: 20),
                          title: Text(
                            '${_levelLabel(log.levelBefore)} '
                            '${log.levelBefore == null ? '' : '${(log.scoreBefore * 100).round()}%'}'
                            ' → ${_levelLabel(log.levelAfter)} '
                            '${(log.scoreAfter * 100).round()}%',
                          ),
                          subtitle: Text(
                            '${_eventLabel(log.eventOrigin)} · '
                            '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(log.loggedAt * 1000).toLocal())}',
                          ),
                        ),
                    if (logs != null && logs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'O domínio é calculado automaticamente quando você '
                          'faz revisões e avaliações deste conceito.',
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            KeyedSubtree(
              key: _resourcesKey,
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Materiais de estudo',
                      style: textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<LearningResourceData>>(
              future: _resourcesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Não foi possível carregar os materiais.',
                    style: textTheme.bodySmall?.copyWith(color: colors.error),
                  );
                }

                final resources = snapshot.data ?? const [];
                if (resources.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Text(
                      'Nenhum material relacionado ainda.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final resource in resources)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _LearningResourceCard(
                          resource: resource,
                          onOpen: () => _openResource(resource),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            RuntimeLocalizedText(
              'Continue aprendendo',
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () =>
                    context.push(RoutePaths.exercises(node.graphId, node.id)),
                icon: const Icon(Icons.play_arrow_rounded),
                label: RuntimeLocalizedText(
                  AppLocalizations.of(context)!.startAssessment,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                FilledButton.tonalIcon(
                  onPressed: _scrollToRecommendations,
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  label: const RuntimeLocalizedText('Próximos passos'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                    RoutePaths.dashboardForNode(node.graphId, node.id),
                  ),
                  icon: const Icon(Icons.analytics_outlined),
                  label: RuntimeLocalizedText(
                    AppLocalizations.of(context)!.report,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                    RoutePaths.exerciseResponses(node.graphId, node.id),
                  ),
                  icon: const Icon(Icons.history_rounded),
                  label: const RuntimeLocalizedText('Histórico de exercícios'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                    RoutePaths.flashcardsForNode(node.graphId, node.id),
                  ),
                  icon: const Icon(Icons.bolt_rounded),
                  label: const RuntimeLocalizedText('Revisão rápida'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _nodeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'AREA':
        return Icons.public_outlined;
      case 'TOPIC':
        return Icons.folder_open_outlined;
      case 'SUBCONCEPT':
        return Icons.account_tree_outlined;
      default:
        return Icons.lightbulb_outline_rounded;
    }
  }

  String _nodeTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'AREA':
        return 'Área';
      case 'TOPIC':
        return 'Tópico';
      case 'SUBCONCEPT':
        return 'Subconceito';
      default:
        return 'Conceito';
    }
  }

  String _levelLabel(String? level) => switch (level) {
    'WEAK' => 'Inicial',
    'PARTIAL' => 'Parcial',
    'ADEQUATE' => 'Adequado',
    'STRONG' => 'Forte',
    _ => 'Sem avaliação',
  };

  String _eventLabel(String eventOrigin) => switch (eventOrigin) {
    'STUDY_SESSION' => 'Sessão de estudo',
    'REVISION' => 'Revisão',
    'AI_RECOMMENDATION' => 'Recomendação da IA',
    'MANUAL' => 'Alteração manual',
    _ => eventOrigin,
  };

  String _categoryLabel(String category) => switch (category.toUpperCase()) {
    'BOOK' => 'Livro',
    'ACADEMIC_ARTICLE' => 'Artigo acadêmico',
    'DOCUMENTATION' => 'Documentação',
    'COURSE' => 'Curso',
    'VIDEO' => 'Vídeo',
    'WEB_ARTICLE' => 'Artigo online',
    'TOOL' => 'Ferramenta',
    'EXERCISE' => 'Exercício',
    'PODCAST' => 'Podcast',
    _ => category,
  };

  String _tierLabel(String tier) => switch (tier.toUpperCase()) {
    'TIER_1' => 'Prioridade alta',
    'TIER_2' => 'Prioridade média',
    'TIER_3' => 'Exploratório',
    _ => tier,
  };
}

class _LearningResourceCard extends StatelessWidget {
  const _LearningResourceCard({required this.resource, required this.onOpen});

  final LearningResourceData resource;
  final VoidCallback onOpen;

  String _categoryLabel(String category) => switch (category.toUpperCase()) {
    'BOOK' => 'Livro',
    'ACADEMIC_ARTICLE' => 'Artigo acadêmico',
    'DOCUMENTATION' => 'Documentação',
    'WEB_ARTICLE' => 'Artigo online',
    'VIDEO' => 'Vídeo',
    'COURSE' => 'Curso',
    'TOOL' => 'Ferramenta',
    'EXERCISE' => 'Exercício',
    'PODCAST' => 'Podcast',
    _ => category,
  };

  String _tierLabel(String tier) => switch (tier.toUpperCase()) {
    'TIER_1' => 'Prioridade alta',
    'TIER_2' => 'Prioridade média',
    'TIER_3' => 'Exploratório',
    _ => tier,
  };

  IconData _categoryIcon(String category) => switch (category.toUpperCase()) {
    'VIDEO' => Icons.play_circle_outline_rounded,
    'ACADEMIC_ARTICLE' || 'WEB_ARTICLE' => Icons.article_outlined,
    'COURSE' => Icons.school_outlined,
    'TOOL' => Icons.build_outlined,
    'EXERCISE' => Icons.quiz_outlined,
    'PODCAST' => Icons.headphones_outlined,
    _ => Icons.menu_book_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasUrl = resource.url?.trim().isNotEmpty == true;
    final tierColor = switch (resource.tier.toUpperCase()) {
      'TIER_1' => colors.tertiaryContainer,
      'TIER_2' => colors.secondaryContainer,
      _ => colors.surfaceContainerHigh,
    };

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: InkWell(
        onTap: hasUrl ? onOpen : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_categoryIcon(resource.category), color: colors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      resource.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (hasUrl)
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                ],
              ),
              if (resource.author?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  resource.author!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              if (resource.rationale.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  resource.rationale,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Chip(
                    label: Text(_categoryLabel(resource.category)),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    label: Text(_tierLabel(resource.tier)),
                    backgroundColor: tierColor,
                    visualDensity: VisualDensity.compact,
                  ),
                  if (resource.isAiGenerated)
                    const Chip(
                      label: RuntimeLocalizedText('IA'),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MasteryDetails extends StatelessWidget {
  const _MasteryDetails({
    required this.score,
    required this.status,
    required this.prerequisiteCount,
    required this.subtopicCount,
    required this.isContainer,
  });

  final double? score;
  final LearningProgressStatus status;
  final int prerequisiteCount;
  final int subtopicCount;
  final bool isContainer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedScore = score?.isFinite == true
        ? score!.clamp(0.0, 1.0).toDouble()
        : null;
    final percentage = normalizedScore == null
        ? null
        : (normalizedScore * 100).round();
    final level = DomainMasteryUpdate.levelForScore(normalizedScore);
    final levelLabel = switch (level) {
      'WEAK' => 'Inicial',
      'PARTIAL' => 'Parcial',
      'ADEQUATE' => 'Adequado',
      'STRONG' => 'Forte',
      _ => 'Sem avaliação',
    };
    final statusLabel = switch (status) {
      LearningProgressStatus.mastered => 'Dominado',
      LearningProgressStatus.ready => 'Pronto',
      LearningProgressStatus.availableWithGaps => 'Disponível com lacunas',
    };
    final statusBackground = switch (status) {
      LearningProgressStatus.mastered => colors.tertiaryContainer,
      LearningProgressStatus.ready => colors.primaryContainer,
      LearningProgressStatus.availableWithGaps => colors.tertiaryContainer,
    };
    final statusForeground = switch (status) {
      LearningProgressStatus.mastered => colors.onTertiaryContainer,
      LearningProgressStatus.ready => colors.onPrimaryContainer,
      LearningProgressStatus.availableWithGaps => colors.onTertiaryContainer,
    };

    return Semantics(
      label: percentage == null
          ? 'Domínio ainda não avaliado'
          : 'Domínio $levelLabel, $percentage por cento',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.insights_outlined, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dados e estatísticas',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Chip(
                  label: Text(statusLabel),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: statusBackground,
                  labelStyle: TextStyle(color: statusForeground),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  percentage == null ? '—' : '$percentage%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    percentage == null
                        ? 'Sem avaliações'
                        : isContainer
                        ? 'média das folhas · $levelLabel'
                        : 'de domínio · $levelLabel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: normalizedScore ?? 0,
              semanticsLabel: 'Domínio estimado do conceito',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatisticTile(
                    icon: Icons.link_rounded,
                    count: prerequisiteCount,
                    label: 'Conexões',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatisticTile(
                    icon: Icons.account_tree_outlined,
                    count: subtopicCount,
                    label: 'Subtópicos',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticTile extends StatelessWidget {
  const _StatisticTile({
    required this.icon,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Text('$count', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningGuidance extends StatelessWidget {
  const _LearningGuidance({
    required this.progress,
    required this.progressByNodeId,
    required this.prerequisiteNodes,
    required this.prerequisitePathNodes,
    required this.subtopics,
    required this.onSelectRelatedNode,
    required this.onStudyAnyway,
  });

  final LearningNodeProgress progress;
  final Map<String, LearningNodeProgress> progressByNodeId;
  final List<GraphNodeData> prerequisiteNodes;
  final List<GraphNodeData> prerequisitePathNodes;
  final List<GraphNodeData> subtopics;
  final ValueChanged<GraphNodeData>? onSelectRelatedNode;
  final VoidCallback onStudyAnyway;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final unmetIds = progress.unmetPrerequisiteIds.toSet();
    final unmetNodes = prerequisiteNodes
        .where((prerequisite) => unmetIds.contains(prerequisite.id))
        .toList();
    final routeNodes = prerequisitePathNodes.isNotEmpty
        ? prerequisitePathNodes
        : unmetNodes;
    final suggestedIds = progress.suggestedPrerequisiteIds.toSet();
    final suggestedNodes = prerequisiteNodes
        .where((prerequisite) => suggestedIds.contains(prerequisite.id))
        .toList();
    final isMastered = progress.status == LearningProgressStatus.mastered;
    final hasGaps = progress.status == LearningProgressStatus.availableWithGaps;
    final title = hasGaps
        ? 'Disponível com lacunas'
        : isMastered
        ? subtopics.isEmpty
              ? 'Tópico dominado'
              : 'Próximo passo: subtópicos'
        : progress.isContainer
        ? 'Progresso agregado'
        : 'Pronto para aprender';
    final description = hasGaps
        ? 'Você pode estudar agora ou revisar os pré-requisitos sugeridos.'
        : isMastered
        ? subtopics.isEmpty
              ? 'Este tópico já está dominado.'
              : 'Muito bem! Agora explore os subtópicos deste tópico. '
                    'Os que ainda tiverem lacunas mostram o que falta.'
        : progress.isContainer
        ? 'O domínio é a média das folhas descendentes. Você pode abrir qualquer subtópico.'
        : 'Os pré-requisitos essenciais estão em dia. Estude este tópico e alcance '
              '80% de domínio para avançar.';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasGaps
            ? colors.tertiaryContainer
            : colors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasGaps
              ? colors.tertiary
              : colors.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasGaps
                    ? Icons.info_outline_rounded
                    : isMastered
                    ? Icons.verified_rounded
                    : Icons.play_circle_outline_rounded,
                color: hasGaps ? colors.onTertiaryContainer : colors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: hasGaps
                            ? colors.onTertiaryContainer
                            : colors.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: hasGaps
                            ? colors.onTertiaryContainer
                            : colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasGaps && routeNodes.isNotEmpty) ...[
            const SizedBox(height: 8),
            if (prerequisitePathNodes.isNotEmpty)
              Text(
                'Caminho sugerido até este conceito:',
                style: textTheme.labelMedium?.copyWith(
                  color: colors.onTertiaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            for (var index = 0; index < routeNodes.length; index++)
              _RelatedTopicTile(
                node: routeNodes[index],
                label: prerequisitePathNodes.isNotEmpty
                    ? 'Etapa ${index + 1} · '
                          '${_masteryLabel(progressByNodeId[routeNodes[index].id]?.masteryScore)}'
                    : '${progress.parentTopicIds.contains(routeNodes[index].id) ? 'Tópico superior' : 'Pré-requisito'} pendente · '
                          '${_masteryLabel(progressByNodeId[routeNodes[index].id]?.masteryScore)}',
                onTap: onSelectRelatedNode == null
                    ? null
                    : () => onSelectRelatedNode!(routeNodes[index]),
              ),
          ],
          if (suggestedNodes.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final prerequisite in suggestedNodes)
              _RelatedTopicTile(
                node: prerequisite,
                label:
                    'Sugestão · revisar pré-requisito fraco · '
                    '${_masteryLabel(progressByNodeId[prerequisite.id]?.masteryScore)}',
                onTap: onSelectRelatedNode == null
                    ? null
                    : () => onSelectRelatedNode!(prerequisite),
              ),
          ],
          if (hasGaps) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                FilledButton.tonal(
                  onPressed: onStudyAnyway,
                  child: const RuntimeLocalizedText('Estudar mesmo assim'),
                ),
                OutlinedButton(
                  onPressed: onSelectRelatedNode == null || routeNodes.isEmpty
                      ? null
                      : () => onSelectRelatedNode!(routeNodes.first),
                  child: const RuntimeLocalizedText(
                    'Revisar pré-requisitos primeiro',
                  ),
                ),
              ],
            ),
          ],
          if (progress.isContainer && subtopics.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final subtopic in subtopics)
              _RelatedTopicTile(
                node: subtopic,
                label: switch (progressByNodeId[subtopic.id]?.status) {
                  LearningProgressStatus.mastered => 'Subtópico dominado',
                  LearningProgressStatus.ready =>
                    'Subtópico pronto para aprender',
                  LearningProgressStatus.availableWithGaps =>
                    'Subtópico disponível com lacunas',
                  null => 'Subtópico',
                },
                onTap: onSelectRelatedNode == null
                    ? null
                    : () => onSelectRelatedNode!(subtopic),
              ),
          ],
        ],
      ),
    );
  }

  String _masteryLabel(double? score) {
    if (score == null) return 'ainda não avaliado';
    final percentage = (score * 100).round();
    return score >= LearningPath.masteryThreshold
        ? 'domínio $percentage%'
        : 'domínio $percentage% · falta alcançar 80%';
  }
}

class _RelatedTopicTile extends StatelessWidget {
  const _RelatedTopicTile({
    required this.node,
    required this.label,
    required this.onTap,
  });

  final GraphNodeData node;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.arrow_forward_rounded, size: 18),
      title: Text(node.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
