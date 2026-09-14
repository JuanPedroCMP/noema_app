import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/core/design/theme/color_theme_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/feature/config/providers/color_form_provider.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ColorSelector extends ConsumerWidget {
  const ColorSelector({super.key, required this.onSave});

  final void Function(int) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNotifier = ref.watch(colorFormProvider.notifier);
    final form = ref.watch(colorFormProvider);
    TextEditingController colorController = TextEditingController(
      text: form.color.toString(),
    );
    return  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              color: Color(form.color),
              onColorChanged: (Color color) {
                formNotifier.colorChanged(color.toARGB32().toString());
              },
              wheelDiameter: 125,
              copyPasteBehavior: ColorPickerCopyPasteBehavior(),
              pickersEnabled: const {
                ColorPickerType.wheel: true,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.both: false,
                ColorPickerType.custom: false,
                ColorPickerType.bw: false,
                ColorPickerType.customSecondary: false,
              },
              enableShadesSelection: false,
              colorCodeHasColor: false,
              colorCodeReadOnly: false,
            ),

            Row(
              mainAxisSize: MainAxisSize.min,

              spacing: 15,
              children: [
                Expanded(
                  child: TextField(
                    controller: colorController,

                    onChanged: (value) {
                      final color = int.tryParse(value);

                      if (color != null) {
                        formNotifier.colorChanged(color.toString());
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cor Atual',
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    onSave(form.color);
                  },
                  child: const Text('Selecionar'),
                ),
              ],
            ),
          ],
      
      ),
    );
  }
}
