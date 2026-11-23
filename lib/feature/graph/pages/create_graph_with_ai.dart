import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_background_work_scheduler.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart';
import 'package:noema/feature/graph/providers/graph_prompt_preferences_provider.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

String graphGenerationApiErrorMessage(DioException error) {
  final status = error.response?.statusCode;
  if (error.type == DioExceptionType.receiveTimeout) {
    return 'A geração demorou mais que o esperado. Tente novamente.';
  }
  final responseBody = error.response?.data;
  final detail = responseBody is Map ? responseBody['detail'] : null;
  if (status == 422 && detail is String) {
    final normalizedDetail = detail.toLowerCase();
    if (normalizedDetail.contains('no active api keys')) {
      return 'Nenhuma chave de API ativa está disponível para este agente. '
          'Cadastre ou ative uma chave nas configurações de IA.';
    }
    if (normalizedDetail.contains('response language')) {
      return 'O idioma de resposta solicitado não está disponível. '
          'Atualize sua preferência de idioma e tente novamente.';
    }
    return 'A API rejeitou o grafo gerado: $detail';
  }
  if (status == 401 || status == 403) {
    return 'Sua sessão não está autorizada para usar a IA. Entre novamente.';
  }
  if (status == 404) {
    return 'O agente de geração de grafos não está disponível.';
  }
  if (status == 429) {
    return 'Muitas solicitações. Aguarde um pouco e tente novamente.';
  }
  if (status == 504) {
    return 'O serviço de IA excedeu o tempo limite. Tente novamente; '
        'se persistir, verifique os modelos e provedores configurados.';
  }
  if (status == 502 && detail is String) {
    final normalizedDetail = detail.toLowerCase();
    if (normalizedDetail.contains('graph planning stage failed')) {
      return 'O provedor de IA falhou durante o planejamento do grafo. '
          'Verifique os modelos e as chaves configurados e tente novamente.';
    }
    if (normalizedDetail.contains('graph creation stage failed')) {
      return 'O provedor de IA falhou durante a construção do grafo. '
          'Verifique os modelos e as chaves configurados e tente novamente.';
    }
  }
  if (status != null && status >= 500) {
    return 'O serviço de IA falhou. Tente novamente mais tarde.';
  }
  if (error.response == null) {
    return 'Não foi possível conectar à IA. Verifique sua internet.';
  }
  return 'Não foi possível gerar o grafo (HTTP $status).';
}

class CreateGraphWithAi extends ConsumerStatefulWidget {
  const CreateGraphWithAi({
    super.key,
    this.initialPrompt = '',
    this.autoGenerate = false,
  });

  final String initialPrompt;
  final bool autoGenerate;

  @override
  ConsumerState<CreateGraphWithAi> createState() => _CreateGraphWithAiState();
}

class _CreateGraphWithAiState extends ConsumerState<CreateGraphWithAi> {
  final _promptController = TextEditingController();
  bool _isGenerating = false;
  bool _isImproving = false;
  bool _isSaving = false;
  bool _promptIsImproved = false;
  String? _generationStatus;
  GraphResponse? _draft;
  String? _error;
  String? _promptNotice;
  String? _previousPrompt;

  @override
  void initState() {
    super.initState();
    _promptController.text = widget.initialPrompt;
    if (widget.autoGenerate && widget.initialPrompt.trim().length >= 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _generate();
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    var prompt = _promptController.text.trim();
    if (prompt.length < 5) {
      setState(() {
        _error = 'Descreva o tema com um pouco mais de detalhe.';
        _draft = null;
      });
      return;
    }

    final mode = await ref.read(graphPromptEnhancementModeProvider.future);
    if (!mounted) return;
    if (mode == GraphPromptEnhancementMode.automatic && !_promptIsImproved) {
      setState(() {
        _isImproving = true;
        _error = null;
        _promptNotice = null;
      });
      try {
        final improved = await _improvePrompt(prompt);
        if (!mounted) return;
        prompt = improved;
        _promptController.text = improved;
        _promptIsImproved = true;
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _promptNotice =
              'Não foi possível aprimorar. O grafo será criado com seu texto original.';
        });
      } finally {
        if (mounted) setState(() => _isImproving = false);
      }
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isGenerating = true;
      _generationStatus = 'Planejando e construindo a trilha no servidor...';
      _error = null;
      _draft = null;
    });

    try {
      final ai = ref.read(aiContentGenerationServiceProvider);
      final agentId = await ai.resolveAgentId(AiAgentTask.manipulateGraph);
      final graph = await ai.generateGraphWithServerPipeline(
        prompt: prompt,
        agentId: agentId,
      );
      if (!mounted) return;
      setState(() => _draft = graph);
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _error = graphGenerationApiErrorMessage(error));
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'A IA retornou uma estrutura incompleta: ${error.message}';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _generationError(error));
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _generationStatus = null;
        });
      }
    }
  }

  Future<void> _enhancePromptManually() async {
    final prompt = _promptController.text.trim();
    if (prompt.length < 5) {
      setState(() {
        _error = 'Escreva um tema antes de aprimorá-lo com IA.';
        _draft = null;
      });
      return;
    }

    setState(() {
      _isImproving = true;
      _error = null;
      _promptNotice = null;
      _previousPrompt = null;
      _draft = null;
    });
    try {
      final improved = await _improvePrompt(prompt);
      if (!mounted) return;
      _previousPrompt = prompt;
      _promptIsImproved = true;
      _promptController.text = improved;
      setState(
        () => _promptNotice =
            'Prompt aprimorado. Revise ou desfaça antes de gerar.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error =
            'Não foi possível aprimorar o prompt. ${_generationError(error)}';
      });
    } finally {
      if (mounted) setState(() => _isImproving = false);
    }
  }

  void _restorePreviousPrompt() {
    final previousPrompt = _previousPrompt;
    if (previousPrompt == null) return;
    _promptController.text = previousPrompt;
    _promptIsImproved = false;
    setState(() {
      _previousPrompt = null;
      _promptNotice = 'Prompt original restaurado.';
      _draft = null;
    });
  }

  Future<String> _improvePrompt(String prompt) async {
    final ai = ref.read(aiContentGenerationServiceProvider);
    final payload = await ai.generate(
      task: AiAgentTask.studyAssistant,
      prompt:
          'Melhore o seguinte pedido para gerar um mapa de conhecimento. '
          'Preserve o tema e não invente requisitos que não foram pedidos. '
          'Defina resultado de aprendizagem, público/nível, conhecimento prévio '
          'explicitamente informado, escopo e granulação adequados. Identifique '
          'o que precisa ser aprendido para alcançar o resultado e preserve '
          'subtemas necessários sem ampliar para tópicos apenas relacionados. '
          'Coloque somente o prompt aprimorado no campo feedback do schema de resposta, sem explicações adicionais, títulos ou aspas.\n\n'
          'Pedido original: $prompt',
    );
    for (final key in const [
      'feedback',
      'improved_prompt',
      'prompt',
      'text',
      'response',
    ]) {
      final value = payload[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is Map) {
        for (final nestedKey in const [
          'improved_prompt',
          'prompt',
          'text',
          'response',
        ]) {
          final nested = value[nestedKey];
          if (nested is String && nested.trim().isNotEmpty) {
            return nested.trim();
          }
        }
      }
    }
    throw const FormatException(
      'A IA não retornou o prompt aprimorado em um formato válido.',
    );
  }

  Future<void> _saveDraft() async {
    final draft = _draft;
    if (draft == null || _isSaving) return;
    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final db = ref.read(appDatabaseProvider);
      final user = await AppUserDao(db).getActiveUser();
      if (user == null) {
        throw StateError('Não foi possível identificar o usuário atual.');
      }
      final graphId = await importGraphFromJson(
        db: db,
        userId: user.id,
        jsonString: jsonEncode(draft.toJson()),
        isAiGenerated: true,
        regenerateAiDescriptions: true,
      );
      await ref
          .read(aiTaskNotificationServiceProvider)
          .initialize(requestPermission: true);
      await scheduleAiBackgroundQueue(taskId: graphId);
      ref.read(aiBackgroundTaskRunnerProvider).requestPump();
      if (mounted) context.go(RoutePaths.graph(graphId));
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Não foi possível salvar o grafo: $error');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _generationError(Object error) {
    if (error is StateError) return error.message;
    return 'Não foi possível gerar o grafo. Confira se há um agente de IA '
        'e uma chave de provedor configurados e tente novamente.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descreva o que quer aprender e o que já sabe. O servidor planeja '
          'os resultados e constrói o grafo automaticamente antes de mostrar '
          'a prévia.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _promptController,
          enabled: !_isImproving && !_isGenerating && !_isSaving,
          onChanged: (_) {
            setState(() {
              _promptIsImproved = false;
              _previousPrompt = null;
              _promptNotice = null;
              _draft = null;
              _error = null;
              _generationStatus = null;
            });
          },
          maxLines: 4,
          maxLength: 1000,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.wantLearn,
            hintText: AppLocalizations.of(
              context,
            )!.exIntroductionGeneticsBeginners,
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.auto_awesome),
            helperText: AppLocalizations.of(context)!.editTextGenerating,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _isImproving || _isGenerating || _isSaving
                ? null
                : _enhancePromptManually,
            icon: _isImproving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_fix_high_outlined),
            label: Text(
              _isImproving ? 'Aprimorando...' : 'Melhorar texto com IA',
            ),
          ),
        ),
        if (_promptNotice != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _promptNotice!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                if (_previousPrompt != null)
                  TextButton(
                    onPressed: _restorePreviousPrompt,
                    child: const RuntimeLocalizedText('Desfazer'),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isImproving || _isGenerating || _isSaving
                ? null
                : _generate,
            icon: _isImproving || _isGenerating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(
              _isImproving
                  ? 'Melhorando prompt...'
                  : _isGenerating
                  ? 'Planejando e gerando grafo...'
                  : 'Gerar trilha de estudo',
            ),
          ),
        ),
        if (_isGenerating) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Text(
            _generationStatus ??
                'A IA está planejando o escopo, cobrindo os resultados e '
                    'conferindo pré-requisitos.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
        if (_draft case final draft?) ...[
          const SizedBox(height: 24),
          _GraphDraftPreview(graph: draft),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed:
                  _isSaving || draft.blocksSaveForCoverage
                  ? null
                  : _saveDraft,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _isSaving
                    ? 'Criando grafo...'
                    : draft.blocksSaveForCoverage
                    ? 'Complete a cobertura antes de criar'
                    : draft.qualityFallback
                    ? 'Salvar grafo com avisos e refinar as descrições em segundo plano'
                    : 'Criar grafo e refinar todas as descrições em segundo plano',
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _GraphDraftPreview extends StatelessWidget {
  const _GraphDraftPreview({required this.graph});

  final GraphResponse graph;

  String _coverageNodeTitles(
    GraphCoverageItem item,
    Map<int, GraphNode> nodesById,
  ) {
    final titles = item.nodeIds
        .map((id) => nodesById[id]?.title)
        .whereType<String>()
        .toList();
    return titles.isEmpty ? 'Conceitos não identificados' : titles.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final problems = graph.validate();
    final blueprint = graph.blueprint;
    final coverageProblems = problems
        .where(
          (problem) =>
              problem.code == 'missing_scope_plan' ||
              problem.code.startsWith('coverage_') ||
              problem.code.startsWith('blueprint_') ||
              problem.code == 'leaf_without_coverage',
        )
        .toList();
    final displayedCoverageProblems = coverageProblems.take(8).toList();
    final otherProblems = problems
        .where((problem) => !coverageProblems.contains(problem))
        .take(8 - displayedCoverageProblems.length)
        .toList();
    final displayedProblems = [...displayedCoverageProblems, ...otherProblems];
    final nodesById = {for (final node in graph.nodes) node.nodeId: node};
    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    graph.graphTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            if (graph.graphDescription.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(graph.graphDescription),
            ],
            if (graph.qualityFallback) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Após três tentativas, o servidor enviou a melhor versão '
                  'compatível que conseguiu montar. Revise os avisos antes '
                  'de salvar; você ainda pode editá-la depois.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'As descrições dos nós são provisórias. Depois de criar o grafo, '
              'cada uma será gerada novamente considerando os conceitos e '
              'pré-requisitos próximos.',
              style: theme.textTheme.bodySmall,
            ),
            if (graph.plan.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Plano e limites do escopo',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(graph.plan),
            ],
            if (blueprint != null) ...[
              const SizedBox(height: 12),
              Text(
                'Blueprint pedagógico (etapa de planejamento)',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(blueprint.scope),
              if (blueprint.priorKnowledge.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Conhecimento prévio informado: '
                  '${blueprint.priorKnowledge.join('; ')}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (blueprint.assumptions.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Pressupostos: ${blueprint.assumptions.join('; ')}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 6),
              Text(
                'Pontos de partida: ${blueprint.startingOutcomes.map((item) => item.outcome).join(' · ')}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              for (final outcome in blueprint.outcomes.take(12))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    '• ${outcome.outcome}\n'
                    '  Evidência: ${outcome.evidence}'
                    '${outcome.prerequisiteIds.isEmpty ? '' : '\n  Pré-requisitos: ${outcome.prerequisiteIds.map((id) => blueprint.outcomes.where((item) => item.id == id).firstOrNull?.outcome ?? id).join('; ')}'}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              if (blueprint.outcomes.length > 12)
                Text(
                  'e mais ${blueprint.outcomes.length - 12} resultados…',
                  style: theme.textTheme.bodySmall,
                ),
            ],
            if (coverageProblems.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  graph.qualityFallback
                      ? 'A cobertura está incompleta ou inconsistente. '
                            'O servidor enviou um fallback; confira os '
                            'resultados e os conceitos antes de salvar.'
                      : 'A cobertura está incompleta ou inconsistente. '
                            'Revise os avisos e gere novamente; o grafo não '
                            'pode ser salvo sem um plano e um vínculo '
                            'verificável entre cada resultado e seus conceitos.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
            if (graph.coverage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Resultados cobertos pelo grafo',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Compare esta lista com o que você quer aprender. A checagem '
                'confirma os vínculos entre resultados e conceitos, mas não '
                'substitui sua revisão do escopo.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              for (final item in graph.coverage)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.outcome),
                            Text(
                              _coverageNodeTitles(item, nodesById),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (problems.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avisos de qualidade',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (final problem in displayedProblems)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          '• ${problem.message}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CountChip(label: 'Nós', count: graph.nodes.length),
                _CountChip(label: 'Relações', count: graph.edges.length),
              ],
            ),
            const SizedBox(height: 12),
            RuntimeLocalizedText(
              'Estrutura inicial',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            for (final node in graph.nodes.take(12))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.subdirectory_arrow_right,
                      size: 18,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(node.title),
                          if (node.description.trim().isNotEmpty)
                            Text(
                              node.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(node.type.value, style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            if (graph.nodes.length > 12)
              Text(
                'e mais ${graph.nodes.length - 12} nós…',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check_circle_outline, size: 16),
      label: RuntimeLocalizedText('$count $label'),
      visualDensity: VisualDensity.compact,
    );
  }
}
