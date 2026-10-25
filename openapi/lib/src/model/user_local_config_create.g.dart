// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_config_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserLocalConfigCreateCWProxy {
  UserLocalConfigCreate idUser(String idUser);

  UserLocalConfigCreate idDevice(String? idDevice);

  UserLocalConfigCreate idLanguage(String idLanguage);

  UserLocalConfigCreate idUserColorTheme(String idUserColorTheme);

  UserLocalConfigCreate idUserTypographyTheme(String idUserTypographyTheme);

  UserLocalConfigCreate preferences(String preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserLocalConfigCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserLocalConfigCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserLocalConfigCreate call({
    String idUser,
    String? idDevice,
    String idLanguage,
    String idUserColorTheme,
    String idUserTypographyTheme,
    String preferences,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserLocalConfigCreate.copyWith(...)` or call `instanceOfUserLocalConfigCreate.copyWith.fieldName(value)` for a single field.
class _$UserLocalConfigCreateCWProxyImpl
    implements _$UserLocalConfigCreateCWProxy {
  const _$UserLocalConfigCreateCWProxyImpl(this._value);

  final UserLocalConfigCreate _value;

  @override
  UserLocalConfigCreate idUser(String idUser) => call(idUser: idUser);

  @override
  UserLocalConfigCreate idDevice(String? idDevice) => call(idDevice: idDevice);

  @override
  UserLocalConfigCreate idLanguage(String idLanguage) =>
      call(idLanguage: idLanguage);

  @override
  UserLocalConfigCreate idUserColorTheme(String idUserColorTheme) =>
      call(idUserColorTheme: idUserColorTheme);

  @override
  UserLocalConfigCreate idUserTypographyTheme(String idUserTypographyTheme) =>
      call(idUserTypographyTheme: idUserTypographyTheme);

  @override
  UserLocalConfigCreate preferences(String preferences) =>
      call(preferences: preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserLocalConfigCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserLocalConfigCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserLocalConfigCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idDevice = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
    Object? idUserColorTheme = const $CopyWithPlaceholder(),
    Object? idUserTypographyTheme = const $CopyWithPlaceholder(),
    Object? preferences = const $CopyWithPlaceholder(),
  }) {
    return UserLocalConfigCreate(
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      idDevice: idDevice == const $CopyWithPlaceholder()
          ? _value.idDevice
          // ignore: cast_nullable_to_non_nullable
          : idDevice as String?,
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

extension $UserLocalConfigCreateCopyWith on UserLocalConfigCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserLocalConfigCreate.copyWith(...)` or `instanceOfUserLocalConfigCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserLocalConfigCreateCWProxy get copyWith =>
      _$UserLocalConfigCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocalConfigCreate _$UserLocalConfigCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserLocalConfigCreate',
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
    final val = UserLocalConfigCreate(
      idUser: $checkedConvert('id_user', (v) => v as String),
      idDevice: $checkedConvert('id_device', (v) => v as String?),
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
    'idDevice': 'id_device',
    'idLanguage': 'id_language',
    'idUserColorTheme': 'id_user_color_theme',
    'idUserTypographyTheme': 'id_user_typography_theme',
  },
);

Map<String, dynamic> _$UserLocalConfigCreateToJson(
  UserLocalConfigCreate instance,
) => <String, dynamic>{
  'id_user': instance.idUser,
  'id_device': ?instance.idDevice,
  'id_language': instance.idLanguage,
  'id_user_color_theme': instance.idUserColorTheme,
  'id_user_typography_theme': instance.idUserTypographyTheme,
  'preferences': instance.preferences,
};
