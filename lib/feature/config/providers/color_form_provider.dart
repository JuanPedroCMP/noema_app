import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/providers/color_form_state.dart';

class ColorFormNotifier extends Notifier<ColorUpFormState> {
  @override
  ColorUpFormState build() {
    return const ColorUpFormState();
  }

  void colorChanged(String color) {
    final parsed = int.tryParse(color);
    if (parsed == null || parsed < 0 || parsed > 0xFFFFFFFF) {
      return;
    }
    state = state.copyWith(color: parsed);
  }
}

final colorFormProvider = NotifierProvider<ColorFormNotifier, ColorUpFormState>(ColorFormNotifier.new);