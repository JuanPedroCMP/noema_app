// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_config_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserLocalConfigUpdateCWProxy {
  UserLocalConfigUpdate idUser(String? idUser);

  UserLocalConfigUpdate idDevice(String? idDevice);

  UserLocalConfigUpdate idLanguage(String? idLanguage);

  UserLocalConfigUpdate idUserColorTheme(String? idUserColorTheme);

  UserLocalConfigUpdate idUserTypographyTheme(String? idUserTypographyTheme);

  UserLocalConfigUpdate preferences(String? preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserLocalConfigUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserLocalConfigUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserLocalConfigUpdate call({
    String? idUser,
    String? idDevice,
    String? idLanguage,
    String? idUserColorTheme,
    String? idUserTypographyTheme,
    String? preferences,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserLocalConfigUpdate.copyWith(...)` or call `instanceOfUserLocalConfigUpdate.copyWith.fieldName(value)` for a single field.
class _$UserLocalConfigUpdateCWProxyImpl
    implements _$UserLocalConfigUpdateCWProxy {
  const _$UserLocalConfigUpdateCWProxyImpl(this._value);

  final UserLocalConfigUpdate _value;

  @override
  UserLocalConfigUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  UserLocalConfigUpdate idDevice(String? idDevice) => call(idDevice: idDevice);

  @override
  UserLocalConfigUpdate idLanguage(String? idLanguage) =>
      call(idLanguage: idLanguage);

  @override
  UserLocalConfigUpdate idUserColorTheme(String? idUserColorTheme) =>
      call(idUserColorTheme: idUserColorTheme);

  @override
  UserLocalConfigUpdate idUserTypographyTheme(String? idUserTypographyTheme) =>
      call(idUserTypographyTheme: idUserTypographyTheme);

  @override
  UserLocalConfigUpdate preferences(String? preferences) =>
      call(preferences: preferences);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserLocalConfigUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserLocalConfigUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserLocalConfigUpdate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idDevice = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
    Object? idUserColorTheme = const $CopyWithPlaceholder(),
    Object? idUserTypographyTheme = const $CopyWithPlaceholder(),
    Object? preferences = const $CopyWithPlaceholder(),
  }) {
    return UserLocalConfigUpdate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      idDevice: idDevice == const $CopyWithPlaceholder()
          ? _value.idDevice
          // ignore: cast_nullable_to_non_nullable
          : idDevice as String?,
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

extension $UserLocalConfigUpdateCopyWith on UserLocalConfigUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserLocalConfigUpdate.copyWith(...)` or `instanceOfUserLocalConfigUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserLocalConfigUpdateCWProxy get copyWith =>
      _$UserLocalConfigUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocalConfigUpdate _$UserLocalConfigUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserLocalConfigUpdate',
  json,
  ($checkedConvert) {
    final val = UserLocalConfigUpdate(
      idUser: $checkedConvert('id_user', (v) => v as String?),
      idDevice: $checkedConvert('id_device', (v) => v as String?),
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
    'idDevice': 'id_device',
    'idLanguage': 'id_language',
    'idUserColorTheme': 'id_user_color_theme',
    'idUserTypographyTheme': 'id_user_typography_theme',
  },
);

Map<String, dynamic> _$UserLocalConfigUpdateToJson(
  UserLocalConfigUpdate instance,
) => <String, dynamic>{
  'id_user': ?instance.idUser,
  'id_device': ?instance.idDevice,
  'id_language': ?instance.idLanguage,
  'id_user_color_theme': ?instance.idUserColorTheme,
  'id_user_typography_theme': ?instance.idUserTypographyTheme,
  'preferences': ?instance.preferences,
};
