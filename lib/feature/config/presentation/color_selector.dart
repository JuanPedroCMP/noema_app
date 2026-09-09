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
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Expanded(
                  child: ColorPicker(         
                    color: Color(form.color),
                    onColorChanged: (Color color) =>
                        formNotifier.colorChanged(color.toARGB32().toString()),
                    wheelDiameter: 150,
                    copyPasteBehavior: ColorPickerCopyPasteBehavior(),
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.wheel: true, // Roda de cores
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.both: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.customSecondary: false,
                    },

                    enableShadesSelection: false,
                    colorCodeHasColor: true,
                    colorCodeReadOnly: false,
                  ),
                ),

               
                ElevatedButton(
                  onPressed: () async {
                    if (brightnessThemeProvider == Brightness.light) {
                      ref
                          .read(brightnessProvider.notifier)
                          .change(brightness: Brightness.dark);
                    } else {
                      ref
                          .read(brightnessProvider.notifier)
                          .change(brightness: Brightness.light);
                    }
                  },
                  child: Text("Alternar tema"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
