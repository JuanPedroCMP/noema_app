import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/typography_theme_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';

class TypographyThemeSection extends ConsumerStatefulWidget {
  const TypographyThemeSection({super.key});

  @override
  ConsumerState<TypographyThemeSection> createState() =>
      _TypographyThemeSectionState();
}

class _TypographyThemeSectionState
    extends ConsumerState<TypographyThemeSection> {
  List<TypographyThemeData> _themes = [];
  String? _selectedId;
  bool _loading = true;
  bool _saving = false;

  TypographyThemeData? get _selected =>
      _themes.where((theme) => theme.id == _selectedId).firstOrNull;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await ref.read(userProvider.notifier).getUser();
      final db = ref.read(appDatabaseProvider);
      final themes = await TypographyThemeDao(
        db,
      ).getTypographyThemesByUser(userId: user.id);
      final active = await ref.read(activeTypographyThemeProvider.future);
      if (!mounted) return;
      setState(() {
        _themes = themes;
        _selectedId = active?.id ?? (themes.isEmpty ? null : themes.first.id);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _apply(String? id) async {
    if (id == null) return;
    try {
      await ref.read(typographyThemeControllerProvider).apply(id);
      ref.invalidate(activeTypographyThemeProvider);
      if (mounted) setState(() => _selectedId = id);
    } catch (_) {
      _message('Não foi possível aplicar o tema de tipografia.');
    }
  }

  Future<void> _edit({TypographyThemeData? theme}) async {
    final draft = await showDialog<_TypographyDraft>(
      context: context,
      builder: (_) => _TypographyEditor(theme: theme),
    );
    if (draft == null) return;
    setState(() => _saving = true);
    try {
      final controller = ref.read(typographyThemeControllerProvider);
      if (theme == null) {
        final id = await controller.create(
          name: draft.name,
          displayFont: draft.displayFont,
          bodyFont: draft.bodyFont,
          monoFont: draft.monoFont,
          fontScale: draft.fontScale,
        );
        await _load();
        await _apply(id);
      } else {
        await controller.update(
          theme: theme,
          name: draft.name,
          displayFont: draft.displayFont,
          bodyFont: draft.bodyFont,
          monoFont: draft.monoFont,
          fontScale: draft.fontScale,
        );
        await _load();
      }
      _message(theme == null ? 'Tema criado e aplicado.' : 'Tema atualizado.');
    } catch (_) {
      _message('Não foi possível salvar o tema. Verifique o nome e a escala.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String value) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Temas de tipografia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : () => _edit(),
              icon: const Icon(Icons.add),
              label: const Text('Novo tema'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Defina fontes e escala para melhorar a leitura do aplicativo.',
        ),
        const SizedBox(height: 16),
        if (_themes.isEmpty)
          const Text('Nenhum tema de tipografia disponível.')
        else
          DropdownButtonFormField<String>(
            initialValue: _selectedId,
            decoration: const InputDecoration(
              labelText: 'Tema ativo',
              prefixIcon: Icon(Icons.text_fields),
            ),
            items: _themes
                .map(
                  (theme) => DropdownMenuItem(
                    value: theme.id,
                    child: Text(theme.name),
                  ),
                )
                .toList(),
            onChanged: _apply,
          ),
        if (_selected != null) ...[
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text(_selected!.name),
              subtitle: Text(
                'Escala: ${_selected!.fontScale}%'
                '${_selected!.bodyFont == null ? '' : ' • Corpo: ${_selected!.bodyFont}'}',
              ),
              leading: const Icon(Icons.font_download_outlined),
              trailing: IconButton(
                tooltip: 'Editar tema',
                onPressed: _saving ? null : () => _edit(theme: _selected),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TypographyDraft {
  const _TypographyDraft({
    required this.name,
    required this.displayFont,
    required this.bodyFont,
    required this.monoFont,
    required this.fontScale,
  });
  final String name;
  final String? displayFont;
  final String? bodyFont;
  final String? monoFont;
  final int fontScale;
}

class _TypographyEditor extends StatefulWidget {
  const _TypographyEditor({this.theme});
  final TypographyThemeData? theme;
  @override
  State<_TypographyEditor> createState() => _TypographyEditorState();
}

class _TypographyEditorState extends State<_TypographyEditor> {
  late final TextEditingController _name;
  late final TextEditingController _display;
  late final TextEditingController _body;
  late final TextEditingController _mono;
  late double _scale;

  @override
  void initState() {
    super.initState();
    final theme = widget.theme;
    _name = TextEditingController(text: theme?.name ?? '');
    _display = TextEditingController(text: theme?.displayFont ?? '');
    _body = TextEditingController(text: theme?.bodyFont ?? '');
    _mono = TextEditingController(text: theme?.monoFont ?? '');
    _scale = (theme?.fontScale ?? 100).clamp(75, 200).toDouble();
  }

  @override
  void dispose() {
    _name.dispose();
    _display.dispose();
    _body.dispose();
    _mono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.theme == null ? 'Criar tema de tipografia' : 'Editar tipografia',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              maxLength: 40,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _display,
              decoration: const InputDecoration(
                labelText: 'Fonte de títulos',
                hintText: 'Nome da fonte instalada',
              ),
            ),
            TextField(
              controller: _body,
              decoration: const InputDecoration(
                labelText: 'Fonte do corpo',
                hintText: 'Nome da fonte instalada',
              ),
            ),
            TextField(
              controller: _mono,
              decoration: const InputDecoration(
                labelText: 'Fonte monoespaçada',
                hintText: 'Opcional',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Escala'),
                Expanded(
                  child: Slider(
                    min: 75,
                    max: 200,
                    divisions: 25,
                    value: _scale,
                    label: '${_scale.round()}%',
                    onChanged: (value) => setState(() => _scale = value),
                  ),
                ),
                Text('${_scale.round()}%'),
              ],
            ),
            Text(
              'Aa  Exemplo de leitura',
              style: TextStyle(fontSize: 16 * _scale / 100),
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
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              _TypographyDraft(
                name: _name.text.trim(),
                displayFont: _display.text,
                bodyFont: _body.text,
                monoFont: _mono.text,
                fontScale: _scale.round(),
              ),
            );
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
