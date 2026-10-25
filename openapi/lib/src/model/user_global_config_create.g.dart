// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_config_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserGlobalConfigCreateCWProxy {
  UserGlobalConfigCreate idUser(String idUser);

  UserGlobalConfigCreate idLanguage(String idLanguage);

  UserGlobalConfigCreate idUserColorTheme(String idUserColorTheme);

  UserGlobalConfigCreate idUserTypographyTheme(String idUserTypographyTheme);

  UserGlobalConfigCreate preferences(String preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserGlobalConfigCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserGlobalConfigCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserGlobalConfigCreate call({
    String idUser,
    String idLanguage,
    String idUserColorTheme,
    String idUserTypographyTheme,
    String preferences,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserGlobalConfigCreate.copyWith(...)` or call `instanceOfUserGlobalConfigCreate.copyWith.fieldName(value)` for a single field.
class _$UserGlobalConfigCreateCWProxyImpl
    implements _$UserGlobalConfigCreateCWProxy {
  const _$UserGlobalConfigCreateCWProxyImpl(this._value);

  final UserGlobalConfigCreate _value;

  @override
  UserGlobalConfigCreate idUser(String idUser) => call(idUser: idUser);

  @override
  UserGlobalConfigCreate idLanguage(String idLanguage) =>
      call(idLanguage: idLanguage);

  @override
  UserGlobalConfigCreate idUserColorTheme(String idUserColorTheme) =>
      call(idUserColorTheme: idUserColorTheme);

  @override
  UserGlobalConfigCreate idUserTypographyTheme(String idUserTypographyTheme) =>
      call(idUserTypographyTheme: idUserTypographyTheme);

  @override
  UserGlobalConfigCreate preferences(String preferences) =>
      call(preferences: preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserGlobalConfigCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserGlobalConfigCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserGlobalConfigCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
    Object? idUserColorTheme = const $CopyWithPlaceholder(),
    Object? idUserTypographyTheme = const $CopyWithPlaceholder(),
    Object? preferences = const $CopyWithPlaceholder(),
  }) {
    return UserGlobalConfigCreate(
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      idLanguage:
          idLanguage == const $CopyWithPlaceholder() || idLanguage == null
          ? _value.idLanguage
          // ignore: cast_nullable_to_non_nullable
          : idLanguage as String,
      idUserColorTheme:
          idUserColorTheme == const $CopyWithPlaceholder() ||
              idUserColorTheme == null
          ? _value.idUserColorTheme
          // ignore: cast_nullable_to_non_nullable
          : idUserColorTheme as String,
      idUserTypographyTheme:
          idUserTypographyTheme == const $CopyWithPlaceholder() ||
              idUserTypographyTheme == null
          ? _value.idUserTypographyTheme
          // ignore: cast_nullable_to_non_nullable
          : idUserTypographyTheme as String,
      preferences:
          preferences == const $CopyWithPlaceholder() || preferences == null
          ? _value.preferences
          // ignore: cast_nullable_to_non_nullable
          : preferences as String,
    );
  }
}

extension $UserGlobalConfigCreateCopyWith on UserGlobalConfigCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserGlobalConfigCreate.copyWith(...)` or `instanceOfUserGlobalConfigCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserGlobalConfigCreateCWProxy get copyWith =>
      _$UserGlobalConfigCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGlobalConfigCreate _$UserGlobalConfigCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserGlobalConfigCreate',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id_user',
        'id_language',
        'id_user_color_theme',
        'id_user_typography_theme',
        'preferences',
      ],
    );
    final val = UserGlobalConfigCreate(
      idUser: $checkedConvert('id_user', (v) => v as String),
      idLanguage: $checkedConvert('id_language', (v) => v as String),
      idUserColorTheme: $checkedConvert(
        'id_user_color_theme',
        (v) => v as String,
      ),
      idUserTypographyTheme: $checkedConvert(
        'id_user_typography_theme',
        (v) => v as String,
      ),
      preferences: $checkedConvert('preferences', (v) => v as String),
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

Map<String, dynamic> _$UserGlobalConfigCreateToJson(
  UserGlobalConfigCreate instance,
) => <String, dynamic>{
  'id_user': instance.idUser,
  'id_language': instance.idLanguage,
  'id_user_color_theme': instance.idUserColorTheme,
  'id_user_typography_theme': instance.idUserTypographyTheme,
  'preferences': instance.preferences,
};
