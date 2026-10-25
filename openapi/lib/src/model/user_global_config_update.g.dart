// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_config_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserGlobalConfigUpdateCWProxy {
  UserGlobalConfigUpdate idUser(String? idUser);

  UserGlobalConfigUpdate idLanguage(String? idLanguage);

  UserGlobalConfigUpdate idUserColorTheme(String? idUserColorTheme);

  UserGlobalConfigUpdate idUserTypographyTheme(String? idUserTypographyTheme);

  UserGlobalConfigUpdate preferences(String? preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserGlobalConfigUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserGlobalConfigUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserGlobalConfigUpdate call({
    String? idUser,
    String? idLanguage,
    String? idUserColorTheme,
    String? idUserTypographyTheme,
    String? preferences,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserGlobalConfigUpdate.copyWith(...)` or call `instanceOfUserGlobalConfigUpdate.copyWith.fieldName(value)` for a single field.
class _$UserGlobalConfigUpdateCWProxyImpl
    implements _$UserGlobalConfigUpdateCWProxy {
  const _$UserGlobalConfigUpdateCWProxyImpl(this._value);

  final UserGlobalConfigUpdate _value;

  @override
  UserGlobalConfigUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  UserGlobalConfigUpdate idLanguage(String? idLanguage) =>
      call(idLanguage: idLanguage);

  @override
  UserGlobalConfigUpdate idUserColorTheme(String? idUserColorTheme) =>
      call(idUserColorTheme: idUserColorTheme);

  @override
  UserGlobalConfigUpdate idUserTypographyTheme(String? idUserTypographyTheme) =>
      call(idUserTypographyTheme: idUserTypographyTheme);

  @override
  UserGlobalConfigUpdate preferences(String? preferences) =>
      call(preferences: preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserGlobalConfigUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserGlobalConfigUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserGlobalConfigUpdate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
    Object? idUserColorTheme = const $CopyWithPlaceholder(),
    Object? idUserTypographyTheme = const $CopyWithPlaceholder(),
    Object? preferences = const $CopyWithPlaceholder(),
  }) {
    return UserGlobalConfigUpdate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      idLanguage: idLanguage == const $CopyWithPlaceholder()
          ? _value.idLanguage
          // ignore: cast_nullable_to_non_nullable
          : idLanguage as String?,
      idUserColorTheme: idUserColorTheme == const $CopyWithPlaceholder()
          ? _value.idUserColorTheme
          // ignore: cast_nullable_to_non_nullable
          : idUserColorTheme as String?,
      idUserTypographyTheme:
          idUserTypographyTheme == const $CopyWithPlaceholder()
          ? _value.idUserTypographyTheme
          // ignore: cast_nullable_to_non_nullable
          : idUserTypographyTheme as String?,
      preferences: preferences == const $CopyWithPlaceholder()
          ? _value.preferences
          // ignore: cast_nullable_to_non_nullable
          : preferences as String?,
    );
  }
}

extension $UserGlobalConfigUpdateCopyWith on UserGlobalConfigUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserGlobalConfigUpdate.copyWith(...)` or `instanceOfUserGlobalConfigUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserGlobalConfigUpdateCWProxy get copyWith =>
      _$UserGlobalConfigUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGlobalConfigUpdate _$UserGlobalConfigUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserGlobalConfigUpdate',
  json,
  ($checkedConvert) {
    final val = UserGlobalConfigUpdate(
      idUser: $checkedConvert('id_user', (v) => v as String?),
      idLanguage: $checkedConvert('id_language', (v) => v as String?),
      idUserColorTheme: $checkedConvert(
        'id_user_color_theme',
        (v) => v as String?,
      ),
      idUserTypographyTheme: $checkedConvert(
        'id_user_typography_theme',
        (v) => v as String?,
      ),
      preferences: $checkedConvert('preferences', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'idUser': 'id_user',
    'idLanguage': 'id_language',
    'idUserColorTheme': 'id_user_color_theme',
    'idUserTypographyTheme': 'id_user_typography_theme',
  },
);

Map<String, dynamic> _$UserGlobalConfigUpdateToJson(
  UserGlobalConfigUpdate instance,
) => <String, dynamic>{
  'id_user': ?instance.idUser,
  'id_language': ?instance.idLanguage,
  'id_user_color_theme': ?instance.idUserColorTheme,
  'id_user_typography_theme': ?instance.idUserTypographyTheme,
  'preferences': ?instance.preferences,
};
