import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/core/design/theme/color_theme_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/feature/config/presentation/color_selector.dart';
import 'package:noema/feature/config/providers/color_form_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:noema/shared/pop_up/pop_up.dart';

class ColorThemeSection extends ConsumerStatefulWidget {
  const ColorThemeSection({super.key});

  @override
  ConsumerState<ColorThemeSection> createState() => _ColorThemeSelector();
}

class _ColorThemeSelector extends ConsumerState<ColorThemeSection> {
  Map<String, String> items = {};
  bool isEditingTheme = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      loadGraph();
    });
  }

  Future<void> loadGraph() async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final colorThemeDao = ColorThemeDao(db);

    final themes = await colorThemeDao.getColorThemesByUser(userId: user.id);

    items.clear();

    for (final theme in themes) {
      items.putIfAbsent(theme.id, () => theme.name);
    }
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final brightnessThemeProvider = ref.watch(brightnessProvider);
    final formNotifier = ref.watch(colorFormProvider.notifier);
    final form = ref.watch(colorFormProvider);

    return Center(
      child: SizedBox(
        width: 1000,
        child: Column(
          spacing: 15,
          children: [
            Row(
              spacing: 15,
              children: [
                DropdownButton<String>(
                  value: selectedValue,
                  hint: const Text('Selecione'),
                  items: items.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });

                    print(value);
                  },
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditingTheme = !isEditingTheme;
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
                ElevatedButton(
                  onPressed: () => {
                    ref.read(colorProvider.notifier).change(color: form.color),
                  },
                  child: Text("Mudar Modo"),
                ),
              ],
            ),
            if (isEditingTheme) ...[
              Row(
                children: [
                  Text("Seed Color: "),
                  Container(
                    height: 12,
                    width: 12,
                    color: context.colors.primary,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      showPopup(
                        context,
                        ColorSelector(
                          onSave: (color) {
                            ref
                                .read(colorProvider.notifier)
                                .change(color: color);
                          },
                        ),
                      );
                    },
                    child: Text("Editar"),
                  ),
                ],
              ),
              // TODO Colocar todas as cores, dividir entre normal (Principais cores do app) e  avançado (com todas as corres)
            ],
          ],
        ),
      ),
    );
  }
}
