import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/home/providers/color_form_state.dart';

class ColorFormNotifier extends Notifier<ColorUpFormState> {
  @override
  ColorUpFormState build() {
    return const ColorUpFormState();
  }

  void colorChanged(String color) {
    state = state.copyWith(color: int.parse(color));
  }
}

final colorFormProvider = NotifierProvider<ColorFormNotifier, ColorUpFormState>(ColorFormNotifier.new);