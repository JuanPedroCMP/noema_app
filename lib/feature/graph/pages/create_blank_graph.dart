import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/feature/graph/provider/graph_form_provider.dart';
import 'package:noema/feature/graph/provider/temp_json_graph_provider.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

class CreateBlankGraph extends ConsumerStatefulWidget {
  const CreateBlankGraph({super.key});

  @override
  ConsumerState<CreateBlankGraph> createState() => _CreateBlankGraphState();
}

class _CreateBlankGraphState extends ConsumerState<CreateBlankGraph> {
  bool _isCreating = false;
  bool _isImporting = false;
  bool _showAdvancedImport = false;

  Future<void> _createGraph() async {
    final form = ref.read(graphFormProvider);
    if (form.title.trim().isEmpty) {
      _showMessage('Informe um título para o grafo.');
      return;
    }
    setState(() => _isCreating = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final user = await AppUserDao(db).getActiveUser();
      if (user == null) {
        _showMessage('Não foi possível identificar o usuário atual.');
        return;
      }
      final id = await KnowledgeGraphDao(db).insertKnowledgeGraph(
        userId: user.id,
        title: form.title.trim(),
        description: form.description.trim().isEmpty
            ? null
            : form.description.trim(),
      );
      if (mounted) context.go(RoutePaths.graph(id));
    } catch (_) {
      _showMessage('Não foi possível criar o grafo.');
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  Future<void> _importGraph() async {
    final json = ref.read(tempJsonGraphProvider).trim();
    if (json.isEmpty) {
      _showMessage('Cole um JSON válido para importar um grafo.');
      return;
    }
    setState(() => _isImporting = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final user = await AppUserDao(db).getActiveUser();
      if (user == null) {
        _showMessage('Não foi possível identificar o usuário atual.');
        return;
      }
      final id = await importGraphFromJson(
        db: db,
        userId: user.id,
        jsonString: json,
      );
      if (mounted) context.go(RoutePaths.graph(id));
    } catch (_) {
      _showMessage('O JSON não pôde ser importado. Verifique o formato.');
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final formNotifier = ref.read(graphFormProvider.notifier);
    final jsonNotifier = ref.read(tempJsonGraphProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: formNotifier.titleChagend,
          textInputAction: TextInputAction.next,
          maxLength: 80,
          decoration: const InputDecoration(
            labelText: 'Título do grafo',
            hintText: 'Ex.: Trilha de aprendizado em Flutter',
            prefixIcon: Icon(Icons.title),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: formNotifier.descriptionChagend,
          maxLines: 3,
          maxLength: 240,
          decoration: const InputDecoration(
            labelText: 'Descrição (opcional)',
            hintText: 'Explique o objetivo deste mapa de conhecimento.',
            prefixIcon: Icon(Icons.notes_outlined),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isCreating ? null : _createGraph,
            icon: _isCreating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(_isCreating ? 'Criando...' : 'Criar grafo vazio'),
          ),
        ),
        const SizedBox(height: 16),
        ExpansionTile(
          initiallyExpanded: _showAdvancedImport,
          onExpansionChanged: (value) =>
              setState(() => _showAdvancedImport = value),
          tilePadding: EdgeInsets.zero,
          title: const Text('Importar estrutura JSON'),
          subtitle: const Text('Opção avançada para dados já estruturados'),
          children: [
            TextField(
              onChanged: jsonNotifier.jsonChanged,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'JSON do grafo',
                alignLabelWithHint: true,
                hintText: '{"graphTitle": "...", "nodes": [...]}',
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _isImporting ? null : _importGraph,
                icon: _isImporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file),
                label: Text(_isImporting ? 'Importando...' : 'Importar JSON'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
