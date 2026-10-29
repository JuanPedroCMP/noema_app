import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

const _graphManipulatorAgentId = 'c85e5671-a9bb-4c68-9734-3b8f492e5aff';

class CreateGraphWithAi extends ConsumerStatefulWidget {
  const CreateGraphWithAi({super.key});

  @override
  ConsumerState<CreateGraphWithAi> createState() => _CreateGraphWithAiState();
}

class _CreateGraphWithAiState extends ConsumerState<CreateGraphWithAi> {
  final _promptController = TextEditingController();
  bool _isGenerating = false;
  bool _isSaving = false;
  GraphResponse? _draft;
  String? _error;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.length < 5) {
      setState(() {
        _error = 'Descreva o tema com um pouco mais de detalhe.';
        _draft = null;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isGenerating = true;
      _error = null;
      _draft = null;
    });

    try {
      final ai = ref.read(aiContentGenerationServiceProvider);
      final response = await ai.generate(
        task: AiAgentTask.manipulateGraph,
        prompt: prompt,
        agentId: _graphManipulatorAgentId,
      );
      response.putIfAbsent('graph_description', () => prompt);
      final generatedGraph = GraphResponse.fromJson(response);
      final draft = GraphResponse(
        graphTitle: generatedGraph.graphTitle,
        graphDescription: generatedGraph.graphDescription,
        nodes: generatedGraph.nodes
            .map(
              (node) => GraphNode(
                nodeId: node.nodeId,
                title: node.title,
                description: '',
                type: node.type,
              ),
            )
            .toList(growable: false),
        edges: generatedGraph.edges,
      );
      draft.validate();
      if (!mounted) return;
      setState(() => _draft = draft);
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _error = _apiError(error));
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'A IA retornou uma estrutura incompleta: ${error.message}';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _generationError(error));
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
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
        queueMissingAiDescriptions: true,
      );
      if (mounted) context.go(RoutePaths.graph(graphId));
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Não foi possível salvar o grafo: $error');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _apiError(DioException error) {
    final status = error.response?.statusCode;
    if (error.type == DioExceptionType.receiveTimeout) {
      return 'A geração demorou mais que o esperado. Tente novamente.';
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
    if (status != null && status >= 500) {
      return 'O serviço de IA falhou. Tente novamente mais tarde.';
    }
    if (error.response == null) {
      return 'Não foi possível conectar à IA. Verifique sua internet.';
    }
    return 'Não foi possível gerar o grafo (HTTP $status).';
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
        const Text(
          'Descreva o que você quer aprender. Revise a estrutura e crie o grafo '
          'sem esperar pelas descrições; elas serão geradas em segundo plano '
          'e você poderá acompanhar o progresso na fila de IA.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _promptController,
          enabled: !_isGenerating && !_isSaving,
          maxLines: 4,
          maxLength: 1000,
          decoration: const InputDecoration(
            labelText: 'Tema e objetivo de aprendizagem',
            hintText: 'Ex.: Quero aprender machine learning do zero',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.auto_awesome),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isGenerating || _isSaving ? null : _generate,
            icon: _isGenerating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(
              _isGenerating ? 'Gerando estrutura...' : 'Gerar estrutura',
            ),
          ),
        ),
        if (_isGenerating) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Text(
            'A IA está organizando os conceitos e suas relações.',
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
              onPressed: _isSaving ? null : _saveDraft,
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
                    : 'Criar grafo e gerar descrições em segundo plano',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            Text('Estrutura inicial', style: theme.textTheme.titleSmall),
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
                    Expanded(child: Text(node.title)),
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
      label: Text('$count $label'),
      visualDensity: VisualDensity.compact,
    );
  }
}
