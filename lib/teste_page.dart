// m3_showcase_page.dart
//
// A single-file reference page that showcases the Material 3 color
// roles (via `context.colorScheme`), the full `TextTheme` (via
// `context.textTheme`), and a broad set of M3 widgets — everything
// except navigation widgets (NavigationBar, NavigationRail,
// BottomNavigationBar, Drawer/NavigationDrawer, TabBar) and widgets
// that don't fit well on a single scrollable page (Stepper, full-screen
// pickers with custom routes, etc.).
//
// Run standalone with `flutter run` on this file, or copy just
// [M3ShowcasePage] (and the extension, if you don't already have one)
// into your own project.

import 'package:flutter/material.dart';

void main() {
  runApp(const M3ShowcaseApp());
}

/// Root app. Holds the [ThemeMode] so the whole page can be flipped
/// between light and dark to see every color role adapt automatically.
class M3ShowcaseApp extends StatefulWidget {
  const M3ShowcaseApp({super.key});

  @override
  State<M3ShowcaseApp> createState() => _M3ShowcaseAppState();
}

class _M3ShowcaseAppState extends State<M3ShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material 3 Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: M3ShowcasePage(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Convenience extension so the rest of this file can use the
/// `context.colorScheme` / `context.textTheme` style.
///
/// If your project already declares an extension like this (a very
/// common pattern), delete this block and import your own instead —
/// having two identical extensions in scope will conflict.
extension BuildContextThemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// The showcase page itself.
class M3ShowcasePage extends StatefulWidget {
  const M3ShowcasePage({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  @override
  State<M3ShowcasePage> createState() => _M3ShowcasePageState();
}

class _M3ShowcasePageState extends State<M3ShowcasePage> {
  // ---------------------------------------------------------------------
  // State for the interactive widgets below.
  // ---------------------------------------------------------------------
  bool _switchValue = true;
  bool? _checkboxValue = true;
  int _radioValue = 0;
  double _sliderValue = 0.4;
  RangeValues _rangeValues = const RangeValues(0.2, 0.8);
  bool _choiceChipSelected = true;
  bool _filterChipSelected = false;
  Set<int> _segmentedSelection = <int>{0};

  // ---------------------------------------------------------------------
  // Overlay / dialog demos.
  // ---------------------------------------------------------------------
  void _showSnackBarDemo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This is a Material 3 SnackBar'),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }

  Future<void> _showDialogDemo(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Dialog'),
        content: const Text(
          'This is a Material 3 styled AlertDialog, opened from a button.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBottomSheetDemo(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SizedBox(
        height: 200,
        child: Center(
          child: Text('Modal Bottom Sheet', style: context.textTheme.titleMedium),
        ),
      ),
    );
  }

  Future<void> _showDatePickerDemo(BuildContext context) async {
    final now = DateTime.now();
    await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
  }

  Future<void> _showTimePickerDemo(BuildContext context) async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  // ---------------------------------------------------------------------
  // Build.
  // ---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Showcase'),
        actions: [
          IconButton(
            tooltip: 'Toggle light / dark',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Every swatch, style and widget below reads its values from '
            'context.colorScheme and context.textTheme, so this whole '
            'page restyles itself when the theme changes.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          //region Color Scheme
          const _SectionTitle('Color Scheme'),

          const _GroupLabel('Primary'),
          _demoWrap([
            _ColorSample(role: 'primary', onRole: 'onPrimary', color: cs.primary, onColor: cs.onPrimary),
            _ColorSample(role: 'primaryContainer', onRole: 'onPrimaryContainer', color: cs.primaryContainer, onColor: cs.onPrimaryContainer),
            _ColorSample(role: 'primaryFixed', onRole: 'onPrimaryFixed', color: cs.primaryFixed, onColor: cs.onPrimaryFixed),
            _ColorSample(role: 'primaryFixedDim', onRole: 'onPrimaryFixed', color: cs.primaryFixedDim, onColor: cs.onPrimaryFixed),
            _ColorSample(role: 'primaryFixed', onRole: 'onPrimaryFixedVariant', color: cs.primaryFixed, onColor: cs.onPrimaryFixedVariant),
            _ColorSample(role: 'inverseSurface', onRole: 'inversePrimary', color: cs.inverseSurface, onColor: cs.inversePrimary),
          ]),

          const _GroupLabel('Secondary'),
          _demoWrap([
            _ColorSample(role: 'secondary', onRole: 'onSecondary', color: cs.secondary, onColor: cs.onSecondary),
            _ColorSample(role: 'secondaryContainer', onRole: 'onSecondaryContainer', color: cs.secondaryContainer, onColor: cs.onSecondaryContainer),
            _ColorSample(role: 'secondaryFixed', onRole: 'onSecondaryFixed', color: cs.secondaryFixed, onColor: cs.onSecondaryFixed),
            _ColorSample(role: 'secondaryFixedDim', onRole: 'onSecondaryFixed', color: cs.secondaryFixedDim, onColor: cs.onSecondaryFixed),
            _ColorSample(role: 'secondaryFixed', onRole: 'onSecondaryFixedVariant', color: cs.secondaryFixed, onColor: cs.onSecondaryFixedVariant),
          ]),

          const _GroupLabel('Tertiary'),
          _demoWrap([
            _ColorSample(role: 'tertiary', onRole: 'onTertiary', color: cs.tertiary, onColor: cs.onTertiary),
            _ColorSample(role: 'tertiaryContainer', onRole: 'onTertiaryContainer', color: cs.tertiaryContainer, onColor: cs.onTertiaryContainer),
            _ColorSample(role: 'tertiaryFixed', onRole: 'onTertiaryFixed', color: cs.tertiaryFixed, onColor: cs.onTertiaryFixed),
            _ColorSample(role: 'tertiaryFixedDim', onRole: 'onTertiaryFixed', color: cs.tertiaryFixedDim, onColor: cs.onTertiaryFixed),
            _ColorSample(role: 'tertiaryFixed', onRole: 'onTertiaryFixedVariant', color: cs.tertiaryFixed, onColor: cs.onTertiaryFixedVariant),
          ]),

          const _GroupLabel('Error'),
          _demoWrap([
            _ColorSample(role: 'error', onRole: 'onError', color: cs.error, onColor: cs.onError),
            _ColorSample(role: 'errorContainer', onRole: 'onErrorContainer', color: cs.errorContainer, onColor: cs.onErrorContainer),
          ]),

          const _GroupLabel('Surface'),
          _demoWrap([
            _ColorSample(role: 'surface', onRole: 'onSurface', color: cs.surface, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceDim', onRole: 'onSurface', color: cs.surfaceDim, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceBright', onRole: 'onSurface', color: cs.surfaceBright, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceContainerLowest', onRole: 'onSurface', color: cs.surfaceContainerLowest, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceContainerLow', onRole: 'onSurface', color: cs.surfaceContainerLow, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceContainer', onRole: 'onSurface', color: cs.surfaceContainer, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceContainerHigh', onRole: 'onSurface', color: cs.surfaceContainerHigh, onColor: cs.onSurface),
            _ColorSample(role: 'surfaceContainerHighest', onRole: 'onSurface', color: cs.surfaceContainerHighest, onColor: cs.onSurface),
            _ColorSample(role: 'surface', onRole: 'onSurfaceVariant', color: cs.surface, onColor: cs.onSurfaceVariant),
            _ColorSample(role: 'inverseSurface', onRole: 'onInverseSurface', color: cs.inverseSurface, onColor: cs.onInverseSurface),
          ]),

          const _GroupLabel('Outline & Effects'),
          _demoWrap([
            _ColorChip(role: 'outline', color: cs.outline),
            _ColorChip(role: 'outlineVariant', color: cs.outlineVariant),
            _ColorChip(role: 'shadow', color: cs.shadow),
            _ColorChip(role: 'scrim', color: cs.scrim),
            _ColorChip(role: 'surfaceTint', color: cs.surfaceTint),
          ]),
          const SizedBox(height: 32),
          //endregion

          //region Text Theme
          const _SectionTitle('Text Theme'),
          _TextStyleSample('Display Large', 'displayLarge', context.textTheme.displayLarge),
          _TextStyleSample('Display Medium', 'displayMedium', context.textTheme.displayMedium),
          _TextStyleSample('Display Small', 'displaySmall', context.textTheme.displaySmall),
          _TextStyleSample('Headline Large', 'headlineLarge', context.textTheme.headlineLarge),
          _TextStyleSample('Headline Medium', 'headlineMedium', context.textTheme.headlineMedium),
          _TextStyleSample('Headline Small', 'headlineSmall', context.textTheme.headlineSmall),
          _TextStyleSample('Title Large', 'titleLarge', context.textTheme.titleLarge),
          _TextStyleSample('Title Medium', 'titleMedium', context.textTheme.titleMedium),
          _TextStyleSample('Title Small', 'titleSmall', context.textTheme.titleSmall),
          _TextStyleSample('Body Large', 'bodyLarge', context.textTheme.bodyLarge),
          _TextStyleSample('Body Medium', 'bodyMedium', context.textTheme.bodyMedium),
          _TextStyleSample('Body Small', 'bodySmall', context.textTheme.bodySmall),
          _TextStyleSample('Label Large', 'labelLarge', context.textTheme.labelLarge),
          _TextStyleSample('Label Medium', 'labelMedium', context.textTheme.labelMedium),
          _TextStyleSample('Label Small', 'labelSmall', context.textTheme.labelSmall),
          const SizedBox(height: 32),
          //endregion

          //region Buttons
          const _SectionTitle('Buttons'),
          _demoWrap([
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            FilledButton.tonal(onPressed: () {}, child: const Text('Filled Tonal')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
          ]),
          const SizedBox(height: 16),
          _demoWrap([
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            IconButton.filled(onPressed: () {}, icon: const Icon(Icons.favorite)),
            IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.favorite)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          ]),
          const SizedBox(height: 16),
          _demoWrap([
            FloatingActionButton.small(onPressed: () {}, heroTag: 'fabSmall', child: const Icon(Icons.add)),
            FloatingActionButton(onPressed: () {}, heroTag: 'fabRegular', child: const Icon(Icons.add)),
            FloatingActionButton.large(onPressed: () {}, heroTag: 'fabLarge', child: const Icon(Icons.add)),
            FloatingActionButton.extended(
              onPressed: () {},
              heroTag: 'fabExtended',
              icon: const Icon(Icons.add),
              label: const Text('Extended'),
            ),
          ]),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Day'), icon: Icon(Icons.calendar_view_day)),
              ButtonSegment(value: 1, label: Text('Week'), icon: Icon(Icons.calendar_view_week)),
              ButtonSegment(value: 2, label: Text('Month'), icon: Icon(Icons.calendar_view_month)),
            ],
            selected: _segmentedSelection,
            onSelectionChanged: (selection) => setState(() => _segmentedSelection = selection),
          ),
          const SizedBox(height: 32),
          //endregion

          //region Selection Controls
          const _SectionTitle('Selection Controls'),
          _demoWrap([
            Switch(value: _switchValue, onChanged: (v) => setState(() => _switchValue = v)),
            Checkbox(
              value: _checkboxValue,
              tristate: true,
              onChanged: (v) => setState(() => _checkboxValue = v),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Radio<int>(value: 0, groupValue: _radioValue, onChanged: (v) => setState(() => _radioValue = v!)),
              const Text('Option A'),
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Radio<int>(value: 1, groupValue: _radioValue, onChanged: (v) => setState(() => _radioValue = v!)),
              const Text('Option B'),
            ]),
          ]),
          const SizedBox(height: 8),
          Slider(value: _sliderValue, onChanged: (v) => setState(() => _sliderValue = v)),
          RangeSlider(values: _rangeValues, onChanged: (v) => setState(() => _rangeValues = v)),
          const SizedBox(height: 24),
          //endregion

          //region Chips
          const _SectionTitle('Chips'),
          _demoWrap([
            const Chip(label: Text('Chip'), avatar: CircleAvatar(child: Icon(Icons.tag, size: 16))),
            InputChip(label: const Text('Input'), onDeleted: () {}),
            ChoiceChip(
              label: const Text('Choice'),
              selected: _choiceChipSelected,
              onSelected: (v) => setState(() => _choiceChipSelected = v),
            ),
            FilterChip(
              label: const Text('Filter'),
              selected: _filterChipSelected,
              onSelected: (v) => setState(() => _filterChipSelected = v),
            ),
            ActionChip(label: const Text('Action'), onPressed: () {}),
          ]),
          const SizedBox(height: 32),
          //endregion

          //region Cards
          const _SectionTitle('Cards'),
          _demoWrap([
            SizedBox(width: 220, child: Card(child: _cardBody(context, 'Elevated Card', 'Card() default'))),
            SizedBox(width: 220, child: Card.filled(child: _cardBody(context, 'Filled Card', 'Card.filled()'))),
            SizedBox(width: 220, child: Card.outlined(child: _cardBody(context, 'Outlined Card', 'Card.outlined()'))),
          ]),
          const SizedBox(height: 32),
          //endregion

          //region Text Fields
          const _SectionTitle('Text Fields'),
          _demoWrap([
            SizedBox(
              width: 260,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Filled',
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
              width: 260,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Outlined',
                  helperText: 'Helper text',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 32),
          //endregion

          //region Progress Indicators
          const _SectionTitle('Progress Indicators'),
          _demoWrap([
            const SizedBox(width: 220, child: LinearProgressIndicator(value: 0.6)),
            const SizedBox(width: 220, child: LinearProgressIndicator()),
            const CircularProgressIndicator(value: 0.6),
            const CircularProgressIndicator(),
          ]),
          const SizedBox(height: 32),
          //endregion

          //region Feedback & Overlays
          const _SectionTitle('Feedback & Overlays'),
          _demoWrap([
            FilledButton(onPressed: () => _showSnackBarDemo(context), child: const Text('Show SnackBar')),
            FilledButton.tonal(onPressed: () => _showDialogDemo(context), child: const Text('Show Dialog')),
            OutlinedButton(onPressed: () => _showBottomSheetDemo(context), child: const Text('Show Bottom Sheet')),
            OutlinedButton(onPressed: () => _showDatePickerDemo(context), child: const Text('Show Date Picker')),
            OutlinedButton(onPressed: () => _showTimePickerDemo(context), child: const Text('Show Time Picker')),
          ]),
          const SizedBox(height: 16),
          _demoWrap([
            Tooltip(
              message: 'This is a Tooltip',
              child: Icon(Icons.info_outline, color: cs.onSurfaceVariant),
            ),
            Badge(
              label: const Text('3'),
              child: Icon(Icons.notifications_outlined, color: cs.onSurfaceVariant),
            ),
            Badge(
              backgroundColor: cs.error,
              child: Icon(Icons.mail_outline, color: cs.onSurfaceVariant),
            ),
          ]),
          const SizedBox(height: 32),
          //endregion

          //region Menus
          const _SectionTitle('Menus'),
          const DropdownMenu<String>(
            label: Text('Favorite fruit'),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: 'apple', label: 'Apple'),
              DropdownMenuEntry(value: 'banana', label: 'Banana'),
              DropdownMenuEntry(value: 'cherry', label: 'Cherry'),
            ],
          ),
          const SizedBox(height: 32),
          //endregion

          //region Data Table
          const _SectionTitle('Data Table'),
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: const [
                    DataRow(cells: [DataCell(Text('Ana')), DataCell(Text('Dev')), DataCell(Text('Active'))]),
                    DataRow(cells: [DataCell(Text('Bruno')), DataCell(Text('Design')), DataCell(Text('Away'))]),
                    DataRow(cells: [DataCell(Text('Carla')), DataCell(Text('QA')), DataCell(Text('Active'))]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          //endregion

          //region Lists
          const _SectionTitle('Lists'),
          Card.outlined(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('List Tile'),
                  subtitle: const Text('Supporting text'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  value: _checkboxValue ?? false,
                  onChanged: (v) => setState(() => _checkboxValue = v),
                  title: const Text('Checkbox List Tile'),
                ),
                SwitchListTile(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                  title: const Text('Switch List Tile'),
                ),
                ExpansionTile(
                  title: const Text('Expansion Tile'),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Expanded content goes here.'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          //endregion
        ],
      ),
    );
  }

  Widget _cardBody(BuildContext context, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: context.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Reusable private widgets / helpers.
// ---------------------------------------------------------------------

Widget _demoWrap(List<Widget> children) {
  return Wrap(
    spacing: 16,
    runSpacing: 16,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: context.textTheme.headlineSmall),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A swatch demonstrating a background color role paired with the text
/// (or icon) color role meant to be used on top of it — e.g. `primary`
/// with `onPrimary`. This is "the way it should be used" in M3: never
/// hardcode a foreground color, always pull the matching `on*` role.
class _ColorSample extends StatelessWidget {
  const _ColorSample({
    required this.role,
    required this.onRole,
    required this.color,
    required this.onColor,
  });

  final String role;
  final String onRole;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            role,
            style: context.textTheme.labelLarge?.copyWith(
              color: onColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            onRole,
            style: context.textTheme.labelSmall?.copyWith(color: onColor),
          ),
        ],
      ),
    );
  }
}

/// A standalone color role with no matching "on" text color (outline,
/// shadow, scrim, surfaceTint...). Shown as a swatch with the label
/// placed outside it, so legibility never depends on guessing contrast.
class _ColorChip extends StatelessWidget {
  const _ColorChip({required this.role, required this.color});

  final String role;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
          ),
          const SizedBox(height: 6),
          Text(role, style: context.textTheme.labelMedium),
        ],
      ),
    );
  }
}

/// One row in the TextTheme section: the style name rendered *in* its
/// own style, plus the `context.textTheme.<field>` reference below it.
class _TextStyleSample extends StatelessWidget {
  const _TextStyleSample(this.label, this.fieldName, this.style);

  final String label;
  final String fieldName;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: style),
          Text(
            'context.textTheme.$fieldName',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}