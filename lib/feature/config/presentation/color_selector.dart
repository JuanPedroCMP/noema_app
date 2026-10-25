import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/providers/color_form_provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ColorSelector extends ConsumerStatefulWidget {
  const ColorSelector({super.key, required this.onSave});

  final void Function(int) onSave;

  @override
  ConsumerState<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends ConsumerState<ColorSelector> {
  late final TextEditingController colorController;

  @override
  void initState() {
    super.initState();
    final form = ref.read(colorFormProvider);
    colorController = TextEditingController(text: form.color.toString());
  }

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formNotifier = ref.read(colorFormProvider.notifier);
    final form = ref.watch(colorFormProvider);
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              color: Color(form.color),
              onColorChanged: (Color color) {
                formNotifier.colorChanged(color.toARGB32().toString());
                colorController.text = color.toARGB32().toString();
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
                SizedBox(
                  width: 180,
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
                    widget.onSave(form.color);
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
