import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwithColor extends Notifier<int>{

  @override
  int build()
  {
    return 0xeeff50A4;
  }

  void change({required int color,}){
    state = color;
  }
}

final colorProvider = NotifierProvider<SwithColor, int>(SwithColor.new);

class SwithBrightness extends Notifier<Brightness>{

  @override
  Brightness build()
  {
    return Brightness.dark; // Pegar por padrão o modo do sistema
  }

  void change({required Brightness brightness,}){
    state = brightness;
  }
}

final brightnessProvider = NotifierProvider<SwithBrightness, Brightness>(SwithBrightness.new);
