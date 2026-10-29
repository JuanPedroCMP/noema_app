import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/notes/data/note_dao.dart';
import 'package:noema/feature/notes/data/note_transfer_service.dart';
import 'package:noema/feature/notes/presentation/note_editor_panel.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

final notesProvider = StreamProvider.autoDispose.family<List<NoteData>, String>(
  (ref, userId) {
    return NoteDao(ref.read(appDatabaseProvider)).watchNotes(userId: userId);
  },
);

final notesPageKey = GlobalKey<NotesPageState>();

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => NotesPageState();
}

class NotesPageState extends ConsumerState<NotesPage> {
  String? _selectedNoteId;
  String _search = '';
  bool _isCreating = false;
  bool _isImporting = false;
  bool _showTrash = false;
  bool _isEditorDirty = false;
  final GlobalKey<NoteEditorPanelState> _editorKey =
      GlobalKey<NoteEditorPanelState>();

  Future<bool> _saveBeforeLeavingEditor() async {
    if (!_isEditorDirty) return true;
    return await _editorKey.currentState?.saveNow() ?? false;
  }

  Future<bool> saveActiveNote() async {
    if (!_isEditorDirty) return true;
    return await _editorKey.currentState?.saveNow() ?? false;
  }

  Future<void> _selectNote(String? noteId) async {
    if (noteId == _selectedNoteId) return;
    if (!await _saveBeforeLeavingEditor() || !mounted) return;
    setState(() {
      _selectedNoteId = noteId;
      _isEditorDirty = false;
    });
  }

  Future<void> _showTrashView(bool showTrash) async {
    if (_showTrash == showTrash) return;
    if (!await _saveBeforeLeavingEditor() || !mounted) return;
    setState(() {
      _showTrash = showTrash;
      _selectedNoteId = null;
      _isEditorDirty = false;
      _search = '';
    });
  }

  Future<void> _createNote(String userId) async {
    if (_isCreating) return;
    final titleController = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar anotação'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          maxLength: 160,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Título',
            hintText: 'Ex.: Resumo de biologia celular',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) Navigator.pop(context, value.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;
              Navigator.pop(context, titleController.text.trim());
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
    titleController.dispose();
    if (title == null || !mounted) return;

    setState(() => _isCreating = true);
    try {
      final initialContent = jsonEncode([
        {'insert': '\n'},
      ]);
      final note = await NoteDao(
        ref.read(appDatabaseProvider),
      ).create(userId: userId, title: title, contentQuillJson: initialContent);
      if (!mounted) return;
      setState(() => _selectedNoteId = note.id);
      ref.invalidate(notesProvider(userId));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().contains('UNIQUE constraint')
                ? 'Você já tem uma nota com esse título.'
                : 'Não foi possível criar a nota: $error',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  Future<void> _importNote(String userId) async {
    if (_isImporting) return;
    setState(() => _isImporting = true);
    try {
      final file = await FilePicker.pickFile(
        dialogTitle: 'Importar anotação',
        type: FileType.custom,
        allowedExtensions: NoteTransferService.importExtensions,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      final imported = NoteTransferService.importNote(
        fileName: file.name,
        bytes: bytes,
      );
      final titleController = TextEditingController(text: imported.title);
      final title = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Importar anotação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'O conteúdo será convertido para Quill Delta e salvo no banco '
                'como uma nova anotação. Compatível com JSON/Quill, Markdown, '
                'TXT, HTML, Word (.docx) e PDFs com texto selecionável. '
                'Arquivo: ${file.name}',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                autofocus: true,
                maxLength: 160,
                decoration: const InputDecoration(
                  labelText: 'Título da anotação',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final value = titleController.text.trim();
                if (value.isNotEmpty) Navigator.pop(context, value);
              },
              child: const Text('Importar'),
            ),
          ],
        ),
      );
      titleController.dispose();
      if (title == null || !mounted) return;
      final initialVersion = await NoteDao(ref.read(appDatabaseProvider))
          .create(
            userId: userId,
            title: title,
            contentQuillJson: imported.contentQuillJson,
          );
      ref.invalidate(notesProvider(userId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('“${initialVersion.title}” foi importada.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível importar a anotação: $error')),
      );
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _exportNote(NoteData note, NoteExportFormat format) async {
    try {
      final bytes = await NoteTransferService.exportNote(
        title: note.title,
        contentQuillJson: note.contentQuillJson,
        format: format,
      );
      final uri = await FilePicker.saveFile(
        fileName: '${_safeFileName(note.title)}.${format.extension}',
        bytes: bytes,
        mimeType: format.mimeType,
        dialogTitle: 'Exportar anotação',
      );
      if (uri == null || !mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anotação exportada em ${format.extension}.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível exportar a anotação: $error')),
      );
    }
  }

  String _safeFileName(String title) {
    final normalized = title
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-')
        .replaceAll(RegExp(r'\s+'), ' ');
    return normalized.isEmpty ? 'anotacao' : normalized;
  }

  Future<void> _deleteNote(NoteData note, String userId) async {
    if (_selectedNoteId == note.id && !await _saveBeforeLeavingEditor()) {
      return;
    }
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mover anotação para a lixeira?'),
        content: Text(
          '“${note.title}” será ocultada da sua lista. O histórico será mantido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mover para lixeira'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final deleted = await NoteDao(
        ref.read(appDatabaseProvider),
      ).delete(noteId: note.id, userId: userId);
      if (!deleted) throw StateError('A nota não foi encontrada.');
      setState(() {
        if (_selectedNoteId == note.id) _selectedNoteId = null;
        if (_selectedNoteId == null) _isEditorDirty = false;
      });
      ref.invalidate(notesProvider(userId));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível remover a nota: $error')),
      );
    }
  }

  Future<void> _restoreNote(NoteData note, String userId) async {
    try {
      final restored = await NoteDao(
        ref.read(appDatabaseProvider),
      ).restore(noteId: note.id, userId: userId);
      if (!restored) throw StateError('A nota não foi encontrada na lixeira.');
      if (!mounted) return;
      setState(() {
        _showTrash = false;
        _selectedNoteId = note.id;
      });
      ref.invalidate(notesProvider(userId));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Anotação restaurada.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível restaurar a anotação: $error'),
        ),
      );
    }
  }

  Future<void> _deletePermanently(NoteData note, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir definitivamente?'),
        content: Text(
          '“${note.title}” e todo o seu histórico serão removidos sem possibilidade de restauração.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir definitivamente'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final deleted = await NoteDao(
        ref.read(appDatabaseProvider),
      ).deletePermanently(noteId: note.id, userId: userId);
      if (!deleted) throw StateError('A nota não foi encontrada na lixeira.');
      ref.invalidate(notesProvider(userId));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível excluir a anotação: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return user.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Não foi possível acessar suas anotações: $error'),
        ),
      ),
      data: (currentUser) => ref
          .watch(notesProvider(currentUser.id))
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Não foi possível carregar as anotações: $error'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.invalidate(notesProvider(currentUser.id)),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
            data: (notes) => _buildWorkspace(notes, currentUser.id),
          ),
    );
  }

  Widget _buildWorkspace(List<NoteData> notes, String userId) {
    final compact = MediaQuery.sizeOf(context).width < 800;
    final activeNotes = notes.where((note) => !note.softDeleted).toList();
    final deletedNotes = notes.where((note) => note.softDeleted).toList();
    final libraryNotes = _showTrash ? deletedNotes : activeNotes;
    final query = _search.trim().toLowerCase();
    final visibleNotes = libraryNotes.where((note) {
      return '${note.title} ${_preview(note.contentQuillJson)}'
          .toLowerCase()
          .contains(query);
    }).toList();
    final selectedNoteId = activeNotes.any((note) => note.id == _selectedNoteId)
        ? _selectedNoteId
        : null;

    return AppResponsiveContent(
      maxWidth: 1400,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: compact && selectedNoteId != null
            ? _buildEditor(userId, selectedNoteId)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: compact ? double.infinity : 320,
                    child: _buildLibrary(
                      visibleNotes,
                      userId,
                      activeNotes.length,
                      deletedNotes.length,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 16),
                    const VerticalDivider(width: 1),
                    const SizedBox(width: 16),
                    Expanded(
                      child: selectedNoteId == null
                          ? const _EditorWelcome()
                          : _buildEditor(userId, selectedNoteId),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildLibrary(
    List<NoteData> notes,
    String userId,
    int totalCount,
    int trashedCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _showTrash ? 'Lixeira' : 'Anotações',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    _showTrash
                        ? '$trashedCount ${trashedCount == 1 ? 'nota removida' : 'notas removidas'}'
                        : '$totalCount ${totalCount == 1 ? 'nota' : 'notas'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (!_showTrash) ...[
              IconButton(
                tooltip: 'Importar anotação',
                onPressed: _isImporting ? null : () => _importNote(userId),
                icon: _isImporting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.file_upload_outlined),
              ),
              FilledButton.tonalIcon(
                onPressed: _isCreating ? null : () => _createNote(userId),
                icon: _isCreating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: const Text('Nova'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.notes_outlined),
              label: Text('Notas ($totalCount)'),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.delete_outline),
              label: Text('Lixeira ($trashedCount)'),
            ),
          ],
          selected: {_showTrash},
          onSelectionChanged: (selection) => _showTrashView(selection.single),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (value) => setState(() => _search = value),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: _showTrash ? 'Buscar na lixeira' : 'Buscar anotações',
            border: const OutlineInputBorder(),
            suffixIcon: _search.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Limpar busca',
                    onPressed: () => setState(() => _search = ''),
                    icon: const Icon(Icons.clear),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: notes.isEmpty
              ? _NotesEmptyState(
                  hasSearch: _search.trim().isNotEmpty,
                  isTrash: _showTrash,
                  onCreate: () => _createNote(userId),
                )
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final selected = note.id == _selectedNoteId;
                    return Card(
                      color: selected
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        selected: selected,
                        onTap: note.softDeleted
                            ? null
                            : () => _selectNote(note.id),
                        leading: const CircleAvatar(
                          child: Icon(Icons.note_alt_outlined),
                        ),
                        title: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _preview(note.contentQuillJson),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note.softDeleted
                                  ? 'Removida em '
                                        '${note.softDeletedAt == null ? 'data desconhecida' : DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(note.softDeletedAt! * 1000).toLocal())}'
                                  : DateFormat('dd/MM · HH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        note.updatedAt * 1000,
                                      ).toLocal(),
                                    ),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Wrap(
                          children: [
                            if (!note.softDeleted)
                              PopupMenuButton<NoteExportFormat>(
                                tooltip: 'Exportar anotação',
                                icon: const Icon(Icons.file_download_outlined),
                                onSelected: (format) =>
                                    _exportNote(note, format),
                                itemBuilder: (_) => [
                                  for (final format in NoteExportFormat.values)
                                    PopupMenuItem(
                                      value: format,
                                      child: Text(format.label),
                                    ),
                                ],
                              ),
                            PopupMenuButton<String>(
                              tooltip: 'Opções da anotação',
                              onSelected: (action) {
                                if (action == 'delete') {
                                  _deleteNote(note, userId);
                                }
                                if (action == 'restore') {
                                  _restoreNote(note, userId);
                                }
                                if (action == 'deletePermanently') {
                                  _deletePermanently(note, userId);
                                }
                              },
                              itemBuilder: (_) => note.softDeleted
                                  ? const [
                                      PopupMenuItem(
                                        value: 'restore',
                                        child: Text('Restaurar'),
                                      ),
                                      PopupMenuItem(
                                        value: 'deletePermanently',
                                        child: Text('Excluir definitivamente'),
                                      ),
                                    ]
                                  : const [
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Mover para lixeira'),
                                      ),
                                    ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEditor(String userId, String noteId) {
    return NoteEditorPanel(
      key: _editorKey,
      noteId: noteId,
      userId: userId,
      onChanged: () => ref.invalidate(notesProvider(userId)),
      onDirtyChanged: (dirty) {
        if (mounted && _isEditorDirty != dirty) {
          setState(() => _isEditorDirty = dirty);
        }
      },
      onBack: () => _selectNote(null),
    );
  }

  String _preview(String content) {
    try {
      final delta = jsonDecode(content);
      if (delta is! List) return 'Sem prévia disponível';
      final text = delta
          .whereType<Map>()
          .map((operation) => operation['insert'])
          .whereType<String>()
          .join()
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      return text.isEmpty ? 'Nota sem conteúdo ainda' : text;
    } on FormatException {
      return 'Sem prévia disponível';
    }
  }
}

class _EditorWelcome extends StatelessWidget {
  const _EditorWelcome();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_note_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Seu espaço de ideias',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecione uma anotação para continuar ou crie uma nova. '
              'Relacione conceitos do grafo, consulte versões e use a IA '
              'como apoio — você mantém o controle de cada alteração.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesEmptyState extends StatelessWidget {
  const _NotesEmptyState({
    required this.hasSearch,
    required this.isTrash,
    required this.onCreate,
  });

  final bool hasSearch;
  final bool isTrash;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSearch ? Icons.search_off : Icons.note_add_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              hasSearch
                  ? 'Nenhuma nota encontrada'
                  : isTrash
                  ? 'A lixeira está vazia'
                  : 'Comece sua biblioteca',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              hasSearch
                  ? 'Experimente outro termo de busca.'
                  : isTrash
                  ? 'Anotações removidas poderão ser restauradas aqui.'
                  : 'Guarde resumos, dúvidas e conexões entre conceitos.',
              textAlign: TextAlign.center,
            ),
            if (!hasSearch && !isTrash) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Criar anotação'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
