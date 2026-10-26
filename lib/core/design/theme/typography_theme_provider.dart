import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

final activeTypographyThemeProvider =
    FutureProvider.autoDispose<TypographyThemeData?>((ref) async {
      final user = await ref.read(userProvider.notifier).getUser();
      final db = ref.read(appDatabaseProvider);
      final config = await ConfigDao(db).getConfigByUser(userId: user.id);
      if (config == null) return null;
      return TypographyThemeDao(
        db,
      ).getTypographyTheme(id: config.typographyThemeId);
    });

class TypographyThemeController {
  TypographyThemeController(this.ref);
  final Ref ref;

  Future<String> create({
    required String name,
    required String? displayFont,
    required String? bodyFont,
    required String? monoFont,
    required int fontScale,
  }) async {
    _validate(name, fontScale);
    final user = await ref.read(userProvider.notifier).getUser();
    final dao = TypographyThemeDao(ref.read(appDatabaseProvider));
    return dao.insertTypographyTheme(
      userId: user.id,
      name: name.trim(),
      displayFont: _clean(displayFont),
      bodyFont: _clean(bodyFont),
      monoFont: _clean(monoFont),
      fontScale: fontScale,
    );
  }

  Future<void> update({
    required TypographyThemeData theme,
    required String name,
    required String? displayFont,
    required String? bodyFont,
    required String? monoFont,
    required int fontScale,
  }) async {
    _validate(name, fontScale);
    final db = ref.read(appDatabaseProvider);
    await TypographyThemeDao(db).updateTypographyTheme(
      id: theme.id,
      name: name.trim(),
      displayFont: _clean(displayFont),
      bodyFont: _clean(bodyFont),
      monoFont: _clean(monoFont),
      fontScale: fontScale,
    );
  }

  Future<void> apply(String themeId) async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final theme = await TypographyThemeDao(db).getTypographyTheme(id: themeId);
    final config = await ConfigDao(db).getConfigByUser(userId: user.id);
    if (theme == null || theme.userId != user.id || config == null) {
      throw StateError('Tema de tipografia não encontrado.');
    }
    await ConfigDao(
      db,
    ).updateConfig(id: config.id, typographyThemeId: theme.id);
  }

  void _validate(String name, int scale) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Informe um nome para o tema.');
    }
    if (scale < 75 || scale > 200) {
      throw ArgumentError('A escala deve estar entre 75% e 200%.');
    }
  }

  String? _clean(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();
}

final typographyThemeControllerProvider = Provider(
  (ref) => TypographyThemeController(ref),
);
