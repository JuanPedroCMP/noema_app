import 'dart:convert';

abstract final class AppThemeDefaults {
  static const seedColor = 0xFF326D62;

  static bool isUntouchedLegacyDefault({
    required String name,
    required int seedColor,
    String? overridesJson,
  }) {
    if (name != 'Default' ||
        !const {0xFF3F51B5, 0xFF0000FF}.contains(seedColor)) {
      return false;
    }

    if (overridesJson == null || overridesJson.trim().isEmpty) return true;
    try {
      final values = jsonDecode(overridesJson);
      return values is Map<String, dynamic> &&
          values.keys.every((key) => key == '__brightness');
    } catch (_) {
      return false;
    }
  }
}
