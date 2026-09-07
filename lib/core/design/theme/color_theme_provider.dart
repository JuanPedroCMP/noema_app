import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

class SwitchColor extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);

    final theme = await (db.select(
      db.colorTheme,
    )..where((theme) => theme.userId.equals(user.id))).getSingleOrNull();

    if (theme == null) {
    //TODO Caso não exista adicionar novo
    //TODO Dps fazer verificação se tem config específica para esse device
    }

    return theme?.seedColor ?? 0x22FF;
  }

  void change({required int color}) {
    // TODO, update
    state = AsyncData(color);
  }
}

final colorProvider = AsyncNotifierProvider<SwitchColor, int>(SwitchColor.new);

class SwithBrightness extends Notifier<Brightness> {
  @override
  Brightness build() {
    return Brightness.dark; // Pegar por padrão o modo do sistema
  }

  void change({required Brightness brightness}) {
    state = brightness;
  }
}

final brightnessProvider = NotifierProvider<SwithBrightness, Brightness>(
  SwithBrightness.new,
);
