import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/color_theme_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

const _colorKeys = <String>[
  'primary',
  'onPrimary',
  'primaryContainer',
  'onPrimaryContainer',
  'secondary',
  'onSecondary',
  'secondaryContainer',
  'onSecondaryContainer',
  'tertiary',
  'onTertiary',
  'tertiaryContainer',
  'onTertiaryContainer',
  'error',
  'onError',
  'errorContainer',
  'onErrorContainer',
  'surface',
  'onSurface',
  'surfaceVariant',
  'outline',
  'shadow',
  'scrim',
  'customAccent',
  'customSuccess',
  'customWarning',
  'customInfo',
  'customHighlight',
];

class ColorThemeSection extends ConsumerStatefulWidget {
  const ColorThemeSection({super.key});

  @override
  ConsumerState<ColorThemeSection> createState() => _ColorThemeSectionState();
}

class _ColorThemeSectionState extends ConsumerState<ColorThemeSection> {
  List<ColorThemeData> _themes = [];
  String? _selectedId;
  bool _loading = true;
  bool _saving = false;

  ColorThemeData? get _selected =>
      _themes.where((theme) => theme.id == _selectedId).firstOrNull;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    try {
      final user = await ref.read(userProvider.notifier).getUser();
      final themes = await ColorThemeDao(
        ref.read(appDatabaseProvider),
      ).getColorThemesByUser(userId: user.id);
      final active = await ref.read(activeColorThemeProvider.future);
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
      await ref.read(colorProvider.notifier).applyTheme(themeId: id);
      if (mounted) setState(() => _selectedId = id);
      ref.invalidate(activeColorThemeProvider);
    } catch (_) {
      _message('Não foi possível aplicar o tema.');
    }
  }

  Future<void> _toggleBrightness() async {
    final theme = _selected;
    if (theme == null) return;
    final data = _decode(theme.overridesJson);
    final current = data['__brightness'] == 'dark'
        ? Brightness.dark
        : Brightness.light;
    final result = await _saveEditor(
      theme,
      initialBrightness: current == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      advanced: false,
    );
    if (result != null) await _saveTheme(theme, result);
  }

  Future<void> _createTheme() async {
    final result = await _saveEditor(null);
    if (result == null) return;
    setState(() => _saving = true);
    try {
      final id = await ref
          .read(colorProvider.notifier)
          .newTheme(
            name: result.name,
            seedColor: result.seedColor,
            overrides: result.overrides,
            brightness: result.brightness,
          );
      await _loadThemes();
      await _apply(id);
      _message('Tema criado e aplicado.');
    } catch (_) {
      _message('Não foi possível criar o tema. Verifique se o nome já existe.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _editTheme({bool advanced = true}) async {
    final theme = _selected;
    if (theme == null) return;
    final result = await _saveEditor(theme, advanced: advanced);
    if (result != null) await _saveTheme(theme, result);
  }

  Future<_ThemeDraft?> _saveEditor(
    ColorThemeData? theme, {
    Brightness? initialBrightness,
    bool advanced = true,
  }) {
    return showDialog<_ThemeDraft>(
      context: context,
      builder: (_) => _ThemeEditorDialog(
        theme: theme,
        initialBrightness: initialBrightness,
        advanced: advanced,
      ),
    );
  }

  Future<void> _saveTheme(ColorThemeData theme, _ThemeDraft draft) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(colorProvider.notifier)
          .updateTheme(
            themeId: theme.id,
            name: draft.name,
            seedColor: draft.seedColor,
            brightness: draft.brightness,
            overrides: draft.overrides,
          );
      await _loadThemes();
      _message('Tema atualizado.');
    } catch (_) {
      _message('Não foi possível salvar as alterações.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    final theme = _selected;
    final brightness = _brightnessOf(theme);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Temas de cores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : _createTheme,
              icon: const Icon(Icons.add),
              label: const Text('Novo tema'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Personalize o tema do app e escolha entre modo claro e escuro.',
        ),
        const SizedBox(height: 16),
        if (_themes.isEmpty)
          const Text('Nenhum tema disponível.')
        else
          DropdownButtonFormField<String>(
            initialValue: _selectedId,
            decoration: const InputDecoration(
              labelText: 'Tema ativo',
              prefixIcon: Icon(Icons.palette_outlined),
            ),
            items: _themes
                .map(
                  (item) =>
                      DropdownMenuItem(value: item.id, child: Text(item.name)),
                )
                .toList(),
            onChanged: _apply,
          ),
        if (theme != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ThemePreview(theme: theme),
                  SegmentedButton<Brightness>(
                    segments: const [
                      ButtonSegment(
                        value: Brightness.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text('Claro'),
                      ),
                      ButtonSegment(
                        value: Brightness.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text('Escuro'),
                      ),
                    ],
                    selected: {brightness},
                    onSelectionChanged: (_) => _toggleBrightness(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _saving ? null : () => _editTheme(advanced: false),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar tema'),
              ),
              OutlinedButton.icon(
                onPressed: _saving ? null : () => _editTheme(),
                icon: const Icon(Icons.tune),
                label: const Text('Modo avançado'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

Brightness _brightnessOf(ColorThemeData? theme) {
  final values = _decode(theme?.overridesJson);
  return values['__brightness'] == 'dark' ? Brightness.dark : Brightness.light;
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme});
  final ColorThemeData theme;

  @override
  Widget build(BuildContext context) {
    final brightness = _brightnessOf(theme);
    final scheme = ColorScheme.fromSeed(
      seedColor: Color(theme.seedColor),
      brightness: brightness,
    );
    final values = _decode(theme.overridesJson);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(backgroundColor: scheme.primary, radius: 18),
        const SizedBox(width: 6),
        CircleAvatar(
          backgroundColor: Color(
            values['secondary'] ?? scheme.secondary.toARGB32(),
          ),
          radius: 18,
        ),
        const SizedBox(width: 8),
        Text(theme.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ThemeDraft {
  const _ThemeDraft({
    required this.name,
    required this.seedColor,
    required this.brightness,
    required this.overrides,
  });
  final String name;
  final int seedColor;
  final Brightness brightness;
  final Map<String, int> overrides;
}

class _ThemeEditorDialog extends StatefulWidget {
  const _ThemeEditorDialog({
    this.theme,
    this.initialBrightness,
    this.advanced = true,
  });
  final ColorThemeData? theme;
  final Brightness? initialBrightness;
  final bool advanced;

  @override
  State<_ThemeEditorDialog> createState() => _ThemeEditorDialogState();
}

class _ThemeEditorDialogState extends State<_ThemeEditorDialog> {
  late final TextEditingController _name;
  late Brightness _brightness;
  late int _seedColor;
  late final Map<String, int> _overrides;

  @override
  void initState() {
    super.initState();
    final values = _decode(widget.theme?.overridesJson);
    _name = TextEditingController(text: widget.theme?.name ?? '');
    _seedColor = widget.theme?.seedColor ?? 0xFF3F51B5;
    _brightness =
        widget.initialBrightness ??
        (values['__brightness'] == 'dark' ? Brightness.dark : Brightness.light);
    _overrides = {
      for (final key in _colorKeys)
        if (values[key] is int) key: values[key] as int,
    };
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      _error('Informe um nome para o tema.');
      return;
    }
    Navigator.pop(
      context,
      _ThemeDraft(
        name: name,
        seedColor: _seedColor,
        brightness: _brightness,
        overrides: _overrides,
      ),
    );
  }

  void _error(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.theme == null ? 'Criar tema' : 'Editar tema'),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _name,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Nome do tema'),
              ),
              _ColorField(
                label: 'Seed color',
                color: Color(_seedColor),
                onChanged: (color) {
                  setState(() {
                    _seedColor = color.toARGB32();
                  });
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Modo do tema',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<Brightness>(
                segments: const [
                  ButtonSegment(value: Brightness.light, label: Text('Claro')),
                  ButtonSegment(value: Brightness.dark, label: Text('Escuro')),
                ],
                selected: {_brightness},
                onSelectionChanged: (value) =>
                    setState(() => _brightness = value.first),
              ),
              if (widget.advanced) ...[
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Cores do Material 3',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _overrides.clear()),
                      icon: const Icon(Icons.restore),
                      label: const Text('Restaurar originais'),
                    ),
                  ],
                ),
                const Text(
                  'Somente cores alteradas são salvas. Cores restauradas usam o valor gerado pela seed.',
                ),
                const SizedBox(height: 8),
                for (final key in _colorKeys)
                  _ColorField(
                    label: _label(key),
                    color: _effectiveColor(key),
                    changed: _overrides.containsKey(key),
                    onRestore: _overrides.containsKey(key)
                        ? () => setState(() => _overrides.remove(key))
                        : null,
                    onChanged: (color) => setState(() => _setOverride(key, color)),
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Salvar')),
      ],
    );
  }

  Color _effectiveColor(String key) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Color(_seedColor),
      brightness: _brightness,
    );
    final generated = <String, Color>{
      'primary': scheme.primary,
      'onPrimary': scheme.onPrimary,
      'primaryContainer': scheme.primaryContainer,
      'onPrimaryContainer': scheme.onPrimaryContainer,
      'secondary': scheme.secondary,
      'onSecondary': scheme.onSecondary,
      'secondaryContainer': scheme.secondaryContainer,
      'onSecondaryContainer': scheme.onSecondaryContainer,
      'tertiary': scheme.tertiary,
      'onTertiary': scheme.onTertiary,
      'tertiaryContainer': scheme.tertiaryContainer,
      'onTertiaryContainer': scheme.onTertiaryContainer,
      'error': scheme.error,
      'onError': scheme.onError,
      'errorContainer': scheme.errorContainer,
      'onErrorContainer': scheme.onErrorContainer,
      'surface': scheme.surface,
      'onSurface': scheme.onSurface,
      'surfaceVariant': scheme.surfaceContainerHighest,
      'outline': scheme.outline,
      'shadow': scheme.shadow,
      'scrim': scheme.scrim,
    };
    final fallback = switch (key) {
      'customSuccess' => const Color(0xFF2E7D32),
      'customWarning' => const Color(0xFFF9A825),
      'customInfo' => const Color(0xFF0277BD),
      'customHighlight' => const Color(0xFFFFC107),
      _ => generated[key] ?? scheme.primary,
    };
    return Color(_overrides[key] ?? fallback.toARGB32());
  }

  void _setOverride(String key, Color color) {
    final generated = _generatedColors()[key];
    if (generated?.toARGB32() == color.toARGB32()) {
      _overrides.remove(key);
    } else {
      _overrides[key] = color.toARGB32();
    }
  }

  Map<String, Color> _generatedColors() {
    final scheme = ColorScheme.fromSeed(
      seedColor: Color(_seedColor),
      brightness: _brightness,
    );
    return {
      'primary': scheme.primary,
      'onPrimary': scheme.onPrimary,
      'primaryContainer': scheme.primaryContainer,
      'onPrimaryContainer': scheme.onPrimaryContainer,
      'secondary': scheme.secondary,
      'onSecondary': scheme.onSecondary,
      'secondaryContainer': scheme.secondaryContainer,
      'onSecondaryContainer': scheme.onSecondaryContainer,
      'tertiary': scheme.tertiary,
      'onTertiary': scheme.onTertiary,
      'tertiaryContainer': scheme.tertiaryContainer,
      'error': scheme.error,
      'onError': scheme.onError,
      'errorContainer': scheme.errorContainer,
      'onErrorContainer': scheme.onErrorContainer,
      'surface': scheme.surface,
      'onSurface': scheme.onSurface,
      'surfaceVariant': scheme.surfaceContainerHighest,
      'outline': scheme.outline,
      'shadow': scheme.shadow,
      'scrim': scheme.scrim,
    };
  }
}

class _ColorField extends StatefulWidget {
  const _ColorField({
    required this.label,
    required this.color,
    required this.onChanged,
    this.changed = false,
    this.onRestore,
  });
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;
  final bool changed;
  final VoidCallback? onRestore;

  @override
  State<_ColorField> createState() => _ColorFieldState();
}

class _ColorFieldState extends State<_ColorField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _hex(widget.color.toARGB32()));
  }

  @override
  void didUpdateWidget(covariant _ColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color.toARGB32() != widget.color.toARGB32() &&
        _parseHex(_controller.text) != widget.color.toARGB32()) {
      _controller.text = _hex(widget.color.toARGB32());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                final parsed = _parseHex(value);
                if (parsed != null) {
                  widget.onChanged(Color(parsed));
                  _controller.text = _hex(parsed);
                }
              },
              decoration: InputDecoration(
                labelText: widget.label,
                prefixIcon: CircleAvatar(
                  backgroundColor: widget.color,
                  radius: 12,
                ),
                suffixIcon: IconButton(
                  tooltip: 'Copiar cor',
                  icon: const Icon(Icons.copy),
                  onPressed: () => Clipboard.setData(
                    ClipboardData(text: '#${_hex(widget.color.toARGB32())}'),
                  ),
                ),
                suffix: IconButton(
                  tooltip: 'Colar cor',
                  icon: const Icon(Icons.content_paste),
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    final text = data?.text;
                    if (text == null) return;
                    final parsed = _parseHex(text);
                    if (parsed == null) return;
                    widget.onChanged(Color(parsed));
                    _controller.text = _hex(parsed);
                  },
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Escolher cor',
            icon: const Icon(Icons.colorize),
            onPressed: () async {
              var selected = widget.color;
              final ok = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(widget.label),
                  content: ColorPicker(
                    color: selected,
                    onColorChanged: (value) => selected = value,
                    pickersEnabled: const {
                      ColorPickerType.wheel: true,
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.both: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.customSecondary: false,
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Usar cor'),
                    ),
                  ],
                ),
              );
              if (ok == true) widget.onChanged(selected);
            },
          ),
          if (widget.changed)
            IconButton(
              tooltip: 'Restaurar cor original',
              onPressed: widget.onRestore,
              icon: const Icon(Icons.restore),
            ),
        ],
      ),
    );
  }
}

String _label(String key) =>
    key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');

String _hex(int color) => color.toRadixString(16).padLeft(8, '0').toUpperCase();

int? _parseHex(String value) {
  final normalized = value.trim().replaceFirst('#', '');
  final parsed = int.tryParse(normalized, radix: 16);
  if (parsed == null || (normalized.length != 6 && normalized.length != 8)) {
    return null;
  }
  return normalized.length == 6 ? parsed | 0xFF000000 : parsed;
}

Map<String, dynamic> _decode(String? value) {
  if (value == null || value.isEmpty) return {};
  try {
    final decoded = jsonDecode(value);
    return decoded is Map<String, dynamic> ? decoded : {};
  } catch (_) {
    return {};
  }
}
