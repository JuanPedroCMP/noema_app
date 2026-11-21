import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/core/design/theme/typography_theme_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/l10n/app_localizations.dart';

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
      if (!mounted) return;
      _message(AppLocalizations.of(context)!.applyTypographyFailed);
    }
  }

  Future<void> _edit({TypographyThemeData? theme}) async {
    final draft = await showDialog<_TypographyDraft>(
      context: context,
      builder: (_) => _TypographyEditor(
        theme: theme,
        activeFontScale: AppTheme.normalizeFontScale(
          _selected?.fontScale ?? 100,
        ),
      ),
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
        ref.invalidate(activeTypographyThemeProvider);
        await _load();
      }
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      _message(theme == null ? l10n.createdTypography : l10n.updatedTypography);
    } catch (_) {
      if (!mounted) return;
      _message(AppLocalizations.of(context)!.saveTypographyFailed);
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.typographyThemes,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : () => _edit(),
              icon: const Icon(Icons.add),
              label: Text(l10n.newTypographyTheme),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(l10n.typographyDescription),
        const SizedBox(height: 16),
        if (_themes.isEmpty)
          Text(l10n.noTypographyThemes)
        else
          DropdownButtonFormField<String>(
            initialValue: _selectedId,
            decoration: InputDecoration(
              labelText: l10n.activeTypographyTheme,
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
                '${l10n.scale}: ${AppTheme.normalizeFontScale(_selected!.fontScale)}%'
                '${_selected!.bodyFont == null ? '' : ' • Corpo: ${_selected!.bodyFont}'}',
              ),
              leading: const Icon(Icons.font_download_outlined),
              trailing: _selected!.systemDefault
                  ? const Icon(Icons.lock_outline)
                  : IconButton(
                      tooltip: l10n.editTypographyThemeTooltip,
                      onPressed: _saving ? null : () => _edit(theme: _selected),
                      icon: const Icon(Icons.edit_outlined),
                    ),
            ),
          ),
          if (_selected!.systemDefault)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(l10n.defaultTypographyNote),
            ),
        ],
      ],
    );
  }
}

class _GoogleFontField extends StatelessWidget {
  const _GoogleFontField({
    required this.controller,
    required this.families,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final List<String> families;
  final String label;
  final String hint;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          _GoogleFontPicker(families: families, initialValue: controller.text),
    );
    if (selected != null) {
      controller.text = selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: IconButton(
          tooltip: l10n.searchGoogleFonts,
          onPressed: () => _openPicker(context),
          icon: const Icon(Icons.search),
        ),
      ),
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
    );
  }
}

class _GoogleFontPicker extends StatefulWidget {
  const _GoogleFontPicker({required this.families, required this.initialValue});

  final List<String> families;
  final String initialValue;

  @override
  State<_GoogleFontPicker> createState() => _GoogleFontPickerState();
}

class _GoogleFontPickerState extends State<_GoogleFontPicker> {
  late String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final normalized = _query.trim().toLowerCase();
    final matches = widget.families
        .where(
          (family) =>
              normalized.isEmpty || family.toLowerCase().contains(normalized),
        )
        .take(200)
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.searchGoogleFonts,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: matches.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final family = matches[index];
                final selected =
                    family.toLowerCase() ==
                    widget.initialValue.trim().toLowerCase();
                return ListTile(
                  selected: selected,
                  title: Text(
                    family,
                    style: _fontPreview(family, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Aa 0123456789 · $family',
                    style: _fontPreview(family, fontSize: 13),
                  ),
                  trailing: selected
                      ? const Icon(Icons.check_circle)
                      : const Icon(Icons.download_outlined),
                  onTap: () => Navigator.pop(context, family),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _fontPreview(String family, {required double fontSize}) {
    final style = TextStyle(fontSize: fontSize);
    if (!GoogleFonts.asMap().containsKey(family)) {
      return style.copyWith(fontFamily: family);
    }
    try {
      return GoogleFonts.getFont(family, textStyle: style);
    } on Object {
      return style;
    }
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
  const _TypographyEditor({this.theme, required this.activeFontScale});

  final TypographyThemeData? theme;
  final int activeFontScale;

  @override
  State<_TypographyEditor> createState() => _TypographyEditorState();
}

class _TypographyEditorState extends State<_TypographyEditor> {
  late final TextEditingController _name;
  late final TextEditingController _display;
  late final TextEditingController _body;
  late final TextEditingController _mono;
  late double _scale;
  List<String> _fontFamilies = const [];

  @override
  void initState() {
    super.initState();
    final theme = widget.theme;
    _name = TextEditingController(text: theme?.name ?? '');
    _display = TextEditingController(text: theme?.displayFont ?? '');
    _body = TextEditingController(text: theme?.bodyFont ?? '');
    _mono = TextEditingController(text: theme?.monoFont ?? '');
    _scale = AppTheme.normalizeFontScale(theme?.fontScale ?? 100).toDouble();
    _fontFamilies = <String>{
      ...AppTheme.systemFontFamilies,
      ...GoogleFonts.asMap().keys,
    }.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    for (final controller in [_display, _body, _mono]) {
      controller.addListener(_onDraftChanged);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _display.dispose();
    _body.dispose();
    _mono.dispose();
    super.dispose();
  }

  void _onDraftChanged() {
    if (mounted) setState(() {});
  }

  TextStyle _previewStyle({required TextStyle style, required String? family}) {
    final selected = family?.trim();
    if (selected == null || selected.isEmpty) return style;
    if (!GoogleFonts.asMap().containsKey(selected)) {
      return style.copyWith(fontFamily: selected);
    }
    try {
      return GoogleFonts.getFont(selected, textStyle: style);
    } on Object {
      return style;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.theme == null
            ? l10n.createTypographyTheme
            : l10n.editTypographyTheme,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              maxLength: 40,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            _GoogleFontField(
              controller: _display,
              families: _fontFamilies,
              label: l10n.displayFont,
              hint: l10n.fontFamilyHint,
            ),
            const SizedBox(height: 12),
            _GoogleFontField(
              controller: _body,
              families: _fontFamilies,
              label: l10n.bodyFont,
              hint: l10n.fontFamilyHint,
            ),
            const SizedBox(height: 12),
            _GoogleFontField(
              controller: _mono,
              families: _fontFamilies,
              label: l10n.monoFont,
              hint: '${l10n.fontFamilyHint} · ${l10n.optional.toLowerCase()}',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(l10n.scale),
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
                RuntimeLocalizedText('${_scale.round()}%'),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.readingPreview),
                    Text(
                      'Noema',
                      style: _previewStyle(
                        family: _display.text,
                        style: const TextStyle(fontWeight: FontWeight.w700)
                            .copyWith(
                              fontSize: 24 * _scale / widget.activeFontScale,
                            ),
                      ),
                    ),
                    Text(
                      l10n.readingPreview,
                      style: _previewStyle(
                        family: _body.text,
                        style: TextStyle(
                          fontSize: 16 * _scale / widget.activeFontScale,
                        ),
                      ),
                    ),
                    Text(
                      'Aa 0123456789',
                      style: _previewStyle(
                        family: _mono.text,
                        style: TextStyle(
                          fontSize: 14 * _scale / widget.activeFontScale,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
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
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
