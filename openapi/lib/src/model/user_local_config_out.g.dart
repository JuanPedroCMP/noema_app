// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_config_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserLocalConfigOutCWProxy {
  UserLocalConfigOut id(String id);

  UserLocalConfigOut idUser(String idUser);

  UserLocalConfigOut idDevice(String idDevice);

  UserLocalConfigOut idLanguage(String idLanguage);

  UserLocalConfigOut idUserColorTheme(String idUserColorTheme);

  UserLocalConfigOut idUserTypographyTheme(String idUserTypographyTheme);

  UserLocalConfigOut preferences(Map<String, Object> preferences);

  UserLocalConfigOut createdAt(DateTime? createdAt);

  UserLocalConfigOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserLocalConfigOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserLocalConfigOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserLocalConfigOut call({
    String id,
    String idUser,
    String idDevice,
    String idLanguage,
    String idUserColorTheme,
    String idUserTypographyTheme,
    Map<String, Object> preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserLocalConfigOut.copyWith(...)` or call `instanceOfUserLocalConfigOut.copyWith.fieldName(value)` for a single field.
class _$UserLocalConfigOutCWProxyImpl implements _$UserLocalConfigOutCWProxy {
  const _$UserLocalConfigOutCWProxyImpl(this._value);

  final UserLocalConfigOut _value;

  @override
  UserLocalConfigOut id(String id) => call(id: id);

  @override
  UserLocalConfigOut idUser(String idUser) => call(idUser: idUser);

  @override
  UserLocalConfigOut idDevice(String idDevice) => call(idDevice: idDevice);

  @override
  UserLocalConfigOut idLanguage(String idLanguage) =>
      call(idLanguage: idLanguage);

  @override
  UserLocalConfigOut idUserColorTheme(String idUserColorTheme) =>
      call(idUserColorTheme: idUserColorTheme);

  @override
  UserLocalConfigOut idUserTypographyTheme(String idUserTypographyTheme) =>
      call(idUserTypographyTheme: idUserTypographyTheme);

  @override
  UserLocalConfigOut preferences(Map<String, Object> preferences) =>
      call(preferences: preferences);

  @override
  UserLocalConfigOut createdAt(DateTime? createdAt) =>
      call(createdAt: createdAt);

  @override
  UserLocalConfigOut updatedAt(DateTime? updatedAt) =>
      call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserLocalConfigOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserLocalConfigOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserLocalConfigOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idDevice = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
    Object? idUserColorTheme = const $CopyWithPlaceholder(),
    Object? idUserTypographyTheme = const $CopyWithPlaceholder(),
    Object? preferences = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return UserLocalConfigOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      idDevice: idDevice == const $CopyWithPlaceholder() || idDevice == null
          ? _value.idDevice
          // ignore: cast_nullable_to_non_nullable
          : idDevice as String,
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
          : preferences as Map<String, Object>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $UserLocalConfigOutCopyWith on UserLocalConfigOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserLocalConfigOut.copyWith(...)` or `instanceOfUserLocalConfigOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserLocalConfigOutCWProxy get copyWith =>
      _$UserLocalConfigOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocalConfigOut _$UserLocalConfigOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserLocalConfigOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_user',
            'id_device',
            'id_language',
            'id_user_color_theme',
            'id_user_typography_theme',
            'preferences',
            'created_at',
            'updated_at',
          ],
        );
        final val = UserLocalConfigOut(
          id: $checkedConvert('id', (v) => v as String),
          idUser: $checkedConvert('id_user', (v) => v as String),
          idDevice: $checkedConvert('id_device', (v) => v as String),
          idLanguage: $checkedConvert('id_language', (v) => v as String),
          idUserColorTheme: $checkedConvert(
            'id_user_color_theme',
            (v) => v as String,
          ),
          idUserTypographyTheme: $checkedConvert(
            'id_user_typography_theme',
            (v) => v as String,
          ),
          preferences: $checkedConvert(
            'preferences',
            (v) => (v as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, e as Object),
            ),
          ),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          updatedAt: $checkedConvert(
            'updated_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'idUser': 'id_user',
        'idDevice': 'id_device',
        'idLanguage': 'id_language',
        'idUserColorTheme': 'id_user_color_theme',
        'idUserTypographyTheme': 'id_user_typography_theme',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$UserLocalConfigOutToJson(UserLocalConfigOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'id_device': instance.idDevice,
      'id_language': instance.idLanguage,
      'id_user_color_theme': instance.idUserColorTheme,
      'id_user_typography_theme': instance.idUserTypographyTheme,
      'preferences': instance.preferences,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
