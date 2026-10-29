import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/notes/data/note_dao.dart';

class NoteEditorPanel extends ConsumerStatefulWidget {
  const NoteEditorPanel({
    required this.noteId,
    required this.userId,
    required this.onChanged,
    required this.onDirtyChanged,
    required this.onBack,
    super.key,
  });

  final String noteId;
  final String userId;
  final VoidCallback onChanged;
  final ValueChanged<bool> onDirtyChanged;
  final VoidCallback onBack;

  @override
  ConsumerState<NoteEditorPanel> createState() => NoteEditorPanelState();
}

class NoteEditorPanelState extends ConsumerState<NoteEditorPanel>
    with WidgetsBindingObserver {
  final _titleController = TextEditingController();
  QuillController? _editorController;
  StreamSubscription<DocChange>? _documentChanges;
  NoteData? _note;
  List<GraphNodeData> _nodes = [];
  List<GraphNodeData> _allNodes = [];
  Set<String> _linkedNodeIds = {};
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isAiWorking = false;
  bool _isDirty = false;
  String? _saveError;
  Timer? _autoSaveTimer;
  Completer<void>? _saveCompleter;
  int _editRevision = 0;
  String? _error;
  late AppDatabase _database;

  NoteDao get _dao => NoteDao(_database);

  @override
  void initState() {
    super.initState();
    _database = ref.read(appDatabaseProvider);
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didUpdateWidget(covariant NoteEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.noteId != widget.noteId ||
        oldWidget.userId != widget.userId) {
      _load();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoSaveTimer?.cancel();
    _documentChanges?.cancel();
    if (_isDirty) unawaited(_persistOnDispose());
    _titleController.dispose();
    _editorController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (_isDirty) unawaited(_saveAfterBackgrounding());
    }
  }

  Future<void> _saveAfterBackgrounding() async {
    final pendingSave = _saveCompleter?.future;
    if (pendingSave != null) await pendingSave;
    if (mounted && _isDirty && !_isSaving) {
      await _save(automatic: true);
    }
  }

  Future<void> _persistOnDispose() async {
    final note = _note;
    final editor = _editorController;
    if (note == null || editor == null) return;
    final title = _titleController.text;
    final content = jsonEncode(editor.document.toDelta().toJson());
    final nodeIds = List<String>.of(_linkedNodeIds);
    try {
      await _dao.save(
        noteId: note.id,
        userId: widget.userId,
        title: title,
        contentQuillJson: content,
        nodeIds: nodeIds,
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'note editor',
          context: ErrorDescription(
            'while saving a note as its editor was disposed',
          ),
        ),
      );
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _dao.getNote(
        noteId: widget.noteId,
        userId: widget.userId,
      );
      if (result == null) {
        throw StateError('Esta nota não existe ou não está mais disponível.');
      }
      final nodes = await _dao.getNodesForUser(userId: widget.userId);
      final document = _parseDocument(result.note.contentQuillJson);
      final controller = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
      await _documentChanges?.cancel();
      _editorController?.dispose();
      _documentChanges = controller.changes.listen((_) => _markDirty());
      _titleController.text = result.note.title;
      _editorController = controller;
      _note = result.note;
      _nodes = result.nodes;
      _allNodes = nodes;
      _linkedNodeIds = result.nodes.map((node) => node.id).toSet();
      _isDirty = false;
      widget.onDirtyChanged(false);
      if (mounted) setState(() => _isLoading = false);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = 'Não foi possível abrir a nota: $error';
          _isLoading = false;
        });
      }
    }
  }

  Document _parseDocument(String json) {
    final decoded = jsonDecode(json);
    if (decoded is! List) {
      throw const FormatException('O conteúdo salvo da nota está inválido.');
    }
    return Document.fromJson(decoded);
  }

  void _markDirty() {
    if (!mounted) return;
    _editRevision++;
    final dirtyStateChanged = !_isDirty;
    if (dirtyStateChanged || _saveError != null) {
      setState(() {
        _isDirty = true;
        _saveError = null;
      });
    }
    if (dirtyStateChanged) widget.onDirtyChanged(true);
    _autoSaveTimer ??= Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted && _isDirty && !_isSaving) {
        unawaited(_save(automatic: true));
      }
    });
  }

  Future<bool> saveNow() async {
    if (_isSaving) {
      await _saveCompleter?.future;
      if (_saveError != null) return false;
    }
    if (!_isDirty) return true;
    await _save();
    return !_isDirty && _saveError == null;
  }

  Future<void> _createVersion() async {
    final descriptionController = TextEditingController();
    final description = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar versão'),
        content: TextField(
          controller: descriptionController,
          autofocus: true,
          maxLength: 160,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Descrição da versão (opcional)',
            hintText: 'Ex.: Revisão antes da prova',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, descriptionController.text.trim()),
            child: const Text('Salvar versão'),
          ),
        ],
      ),
    );
    descriptionController.dispose();
    if (description == null || !mounted) return;
    await _save(
      createVersion: true,
      changeDescription: description.isEmpty ? 'Versão criada' : description,
    );
  }

  Future<void> _save({
    String author = 'USER',
    String? changeDescription,
    bool automatic = false,
    bool createVersion = false,
  }) async {
    final note = _note;
    final editor = _editorController;
    if (note == null || editor == null || _isSaving) return;
    final titleSnapshot = _titleController.text;
    final contentSnapshot = jsonEncode(editor.document.toDelta().toJson());
    final nodeIdsSnapshot = Set<String>.of(_linkedNodeIds);
    final revisionSnapshot = _editRevision;
    final saveCompleter = Completer<void>();
    _saveCompleter = saveCompleter;
    setState(() => _isSaving = true);
    try {
      final updated = await _dao.save(
        noteId: note.id,
        userId: widget.userId,
        title: titleSnapshot,
        contentQuillJson: contentSnapshot,
        nodeIds: nodeIdsSnapshot.toList(),
        author: author,
        changeDescription: changeDescription,
        createVersion: createVersion,
      );
      if (!mounted) return;
      final stillDirty = revisionSnapshot != _editRevision;
      setState(() {
        _note = updated;
        _isDirty = stillDirty;
        _saveError = null;
        _isSaving = false;
      });
      widget.onDirtyChanged(stillDirty);
      widget.onChanged();
      if (stillDirty) {
        _autoSaveTimer ??= Timer.periodic(const Duration(seconds: 10), (_) {
          if (mounted && _isDirty && !_isSaving) {
            unawaited(_save(automatic: true));
          }
        });
      } else {
        _autoSaveTimer?.cancel();
        _autoSaveTimer = null;
      }
      if (!automatic && !createVersion) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Nota salva.'),
              duration: Duration(seconds: 2),
            ),
          );
      } else if (createVersion && !automatic) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Versão ${updated.currentVersion} criada.'),
              duration: const Duration(seconds: 2),
            ),
          );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _saveError = error.toString();
      });
      if (!automatic) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar a nota: $error')),
        );
      }
    } finally {
      if (!saveCompleter.isCompleted) saveCompleter.complete();
      if (identical(_saveCompleter, saveCompleter)) _saveCompleter = null;
    }
  }

  Future<void> _editNodeLinks() async {
    final selected = await showDialog<Set<String>>(
      context: context,
      builder: (context) =>
          _NodeLinkDialog(nodes: _allNodes, selectedIds: _linkedNodeIds),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _linkedNodeIds = selected;
      _nodes = _allNodes.where((node) => selected.contains(node.id)).toList();
    });
    _markDirty();
  }

  Future<void> _showHistory() async {
    if (!await saveNow()) return;
    late final List<NoteVersionData> versions;
    try {
      versions = await _dao.getVersions(
        noteId: widget.noteId,
        userId: widget.userId,
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível carregar as versões: $error'),
          ),
        );
      }
      return;
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Histórico da nota'),
        content: SizedBox(
          width: 520,
          child: versions.isEmpty
              ? const Text('Ainda não há versões salvas.')
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: versions.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final version = versions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Text('${version.versionNumber}'),
                      ),
                      title: Text(
                        version.changeDescription ?? 'Alteração',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${version.author == 'AI' ? 'Assistida por IA' : 'Você'} · '
                        '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(version.createdAt * 1000).toLocal())}',
                      ),
                      trailing: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final shouldRestore = await showDialog<bool>(
                            context: this.context,
                            builder: (context) => AlertDialog(
                              title: const Text('Restaurar versão?'),
                              content: Text(
                                'A versão ${version.versionNumber} será aplicada '
                                'como uma nova versão. As alterações atuais '
                                'continuarão no histórico.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Restaurar'),
                                ),
                              ],
                            ),
                          );
                          if (shouldRestore == true && mounted) {
                            try {
                              await _dao.restoreVersion(
                                noteId: widget.noteId,
                                userId: widget.userId,
                                versionNumber: version.versionNumber,
                              );
                              await _load();
                              widget.onChanged();
                            } catch (error) {
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Não foi possível restaurar: $error',
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Restaurar'),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editWithAi() async {
    if (_isAiWorking || _editorController == null || _note == null) return;
    final instructionController = TextEditingController();
    final instruction = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aprimorar nota com IA'),
        content: TextField(
          controller: instructionController,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'O que deseja fazer?',
            hintText: 'Ex.: organize em tópicos e destaque os conceitos-chave',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (instructionController.text.trim().isEmpty) return;
              Navigator.pop(context, instructionController.text.trim());
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    instructionController.dispose();
    if (instruction == null || !mounted) return;

    setState(() => _isAiWorking = true);
    try {
      final noteContent = _editorController!.document.toPlainText().trim();
      final response = await ref
          .read(aiContentGenerationServiceProvider)
          .generate(
            task: AiAgentTask.studyAssistant,
            prompt:
                '''
Revise o conteúdo da nota respeitando a solicitação do estudante.
Mantenha os fatos e a intenção original. Não invente informações.
Retorne apenas um objeto JSON com a chave "content" contendo a nota revisada em texto simples.

Solicitação: $instruction
Título: ${_titleController.text.trim()}
Conteúdo atual:
$noteContent
''',
            context: {
              'title': _titleController.text.trim(),
              'linked_concepts': [
                for (final node in _nodes)
                  {
                    'title': node.title,
                    'type': node.type,
                    'description': node.description,
                  },
              ],
            },
          );
      final content = response['content'];
      if (content is! String || content.trim().isEmpty) {
        throw const FormatException(
          'A IA não retornou o texto revisado da nota.',
        );
      }
      if (!mounted) return;
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Prévia da alteração'),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(child: SelectableText(content.trim())),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Descartar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.check),
              label: const Text('Aplicar e salvar'),
            ),
          ],
        ),
      );
      if (accepted != true || !mounted) return;

      final formattedContent = content.trim().endsWith('\n')
          ? content.trim()
          : '${content.trim()}\n';
      final document = Document.fromJson([
        {'insert': formattedContent},
      ]);
      final updated = await _dao.save(
        noteId: _note!.id,
        userId: widget.userId,
        title: _titleController.text,
        contentQuillJson: jsonEncode(document.toDelta().toJson()),
        nodeIds: _linkedNodeIds.toList(),
        author: 'AI',
        changeDescription: 'Revisão por IA: $instruction',
      );
      if (!mounted) return;
      await _documentChanges?.cancel();
      if (!mounted) return;
      _editorController?.dispose();
      final controller = QuillController(
        document: document,
        selection: TextSelection.collapsed(
          offset: document.toPlainText().length.clamp(
            0,
            document.toPlainText().length,
          ),
        ),
      );
      _editorController = controller;
      _documentChanges = controller.changes.listen((_) => _markDirty());
      _autoSaveTimer?.cancel();
      _autoSaveTimer = null;
      _editRevision++;
      setState(() {
        _note = updated;
        _isDirty = false;
        _saveError = null;
      });
      widget.onDirtyChanged(false);
      widget.onChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alteração da IA aplicada e salva.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível aprimorar a nota: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAiWorking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _editorController == null || _note == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 36),
              const SizedBox(height: 8),
              Text(_error ?? 'Não foi possível abrir esta nota.'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 700;
    final useOverflowActions = width < 900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (compact)
              IconButton(
                tooltip: 'Voltar para notas',
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
            Expanded(
              child: TextField(
                controller: _titleController,
                onChanged: (_) => _markDirty(),
                maxLength: 160,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: const InputDecoration(
                  hintText: 'Título da nota',
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (useOverflowActions)
              PopupMenuButton<String>(
                tooltip: 'Ações da anotação',
                onSelected: (action) {
                  switch (action) {
                    case 'version':
                      unawaited(_createVersion());
                    case 'history':
                      unawaited(_showHistory());
                    case 'links':
                      unawaited(_editNodeLinks());
                    case 'ai':
                      unawaited(_editWithAi());
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'version',
                    child: Text('Criar versão'),
                  ),
                  const PopupMenuItem(
                    value: 'history',
                    child: Text('Versões anteriores'),
                  ),
                  const PopupMenuItem(
                    value: 'links',
                    child: Text('Relacionar conceitos'),
                  ),
                  PopupMenuItem(
                    value: 'ai',
                    enabled: !_isAiWorking && !_isSaving,
                    child: const Text('Aprimorar com IA'),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.more_vert),
                ),
              )
            else ...[
              IconButton(
                tooltip: 'Criar versão',
                onPressed: _isSaving ? null : _createVersion,
                icon: const Icon(Icons.bookmark_add_outlined),
              ),
              IconButton(
                tooltip: 'Versões anteriores',
                onPressed: _showHistory,
                icon: const Icon(Icons.history),
              ),
              IconButton(
                tooltip: 'Relacionar conceitos',
                onPressed: _editNodeLinks,
                icon: const Icon(Icons.account_tree_outlined),
              ),
              IconButton(
                tooltip: 'Aprimorar com IA',
                onPressed: _isAiWorking || _isSaving ? null : _editWithAi,
                icon: _isAiWorking
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome_outlined),
              ),
            ],
            if (width >= 500)
              FilledButton.icon(
                onPressed: !_isDirty || _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Salvando' : 'Salvar'),
              )
            else
              IconButton(
                tooltip: 'Salvar nota',
                onPressed: !_isDirty || _isSaving ? null : _save,
                icon: const Icon(Icons.save_outlined),
              ),
          ],
        ),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              _saveError != null
                  ? 'Falha ao salvar · $_saveError'
                  : _isSaving
                  ? 'Salvando…'
                  : _isDirty
                  ? 'Alterações pendentes · salvamento automático em até 10 s'
                  : 'Salvo',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _isDirty
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (_note!.currentVersion > 0)
              Text('· v${_note!.currentVersion}')
            else
              const Text('· Sem versões'),
            for (final node in _nodes.take(3))
              Chip(
                label: Text(node.title),
                visualDensity: VisualDensity.compact,
                onDeleted: () {
                  setState(() {
                    _linkedNodeIds.remove(node.id);
                    _nodes.removeWhere((item) => item.id == node.id);
                  });
                  _markDirty();
                },
              ),
            if (_nodes.length > 3) Text('+${_nodes.length - 3} conceitos'),
            if (_nodes.isEmpty)
              Text(
                'Sem conceitos relacionados',
                style: Theme.of(context).textTheme.labelSmall,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: QuillSimpleToolbar(
                    controller: _editorController!,
                    config: const QuillSimpleToolbarConfig(
                      buttonOptions: QuillSimpleToolbarButtonOptions(
                        fontFamily: QuillToolbarFontFamilyButtonOptions(
                          items: {
                            'Sem serifa': 'sans-serif',
                            'Serifada': 'serif',
                            'Monoespaçada': 'monospace',
                            'Padrão': 'Clear',
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: QuillEditor.basic(
                    controller: _editorController!,
                    config: const QuillEditorConfig(
                      padding: EdgeInsets.all(20),
                      placeholder:
                          'Escreva suas ideias, resumos e perguntas...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (MediaQuery.sizeOf(context).width < 500 && _isDirty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Salvar alterações'),
            ),
          ),
      ],
    );
  }
}

class _NodeLinkDialog extends StatefulWidget {
  const _NodeLinkDialog({required this.nodes, required this.selectedIds});

  final List<GraphNodeData> nodes;
  final Set<String> selectedIds;

  @override
  State<_NodeLinkDialog> createState() => _NodeLinkDialogState();
}

class _NodeLinkDialogState extends State<_NodeLinkDialog> {
  late final Set<String> _selected = Set.of(widget.selectedIds);
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final nodes = widget.nodes
        .where(
          (node) => '${node.title} ${node.type}'.toLowerCase().contains(
            _query.trim().toLowerCase(),
          ),
        )
        .toList();
    return AlertDialog(
      title: const Text('Conceitos relacionados'),
      content: SizedBox(
        width: 520,
        height: 480,
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar conceito',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: nodes.isEmpty
                  ? const Center(
                      child: Text('Nenhum conceito corresponde à busca.'),
                    )
                  : ListView.builder(
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {
                        final node = nodes[index];
                        return CheckboxListTile(
                          value: _selected.contains(node.id),
                          onChanged: (checked) => setState(() {
                            if (checked == true) {
                              _selected.add(node.id);
                            } else {
                              _selected.remove(node.id);
                            }
                          }),
                          title: Text(node.title),
                          subtitle: Text(node.type),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selected),
          child: Text('Aplicar (${_selected.length})'),
        ),
      ],
    );
  }
}
