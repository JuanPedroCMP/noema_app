import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/theme/color_theme_provider.dart';
import 'package:noema/feature/home/providers/color_form_provider.dart';

class HomePage extends ConsumerWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
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
                  child:  TextField(
                    onChanged: formNotifier.colorChanged,
                    decoration: InputDecoration(
                      labelText: "Cor do app",
                    ),
                  ),
                ),
               
                ElevatedButton(onPressed: () => {
                  ref.read(colorProvider.notifier).change(color: form.color)
                }, 
                child: Text("mudar cor")
                ),
                ElevatedButton(onPressed: () async {
                  if(brightnessThemeProvider == Brightness.light) {
                    ref.read(brightnessProvider.notifier).change(brightness: Brightness.dark);
                  }
                  else {
                    ref.read(brightnessProvider.notifier).change(brightness: Brightness.light);
                  }
                }, 
                child: Text("Alternar tema")
                )
              ],
            )
          ],
        ),
      )
      );
  }
}