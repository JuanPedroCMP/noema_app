// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_config_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserGlobalConfigOutCWProxy {
  UserGlobalConfigOut id(String id);

  UserGlobalConfigOut idUser(String idUser);

  UserGlobalConfigOut idLanguage(String idLanguage);

  UserGlobalConfigOut idUserColorTheme(String idUserColorTheme);

  UserGlobalConfigOut idUserTypographyTheme(String idUserTypographyTheme);

  UserGlobalConfigOut preferences(Map<String, Object> preferences);

  UserGlobalConfigOut createdAt(DateTime? createdAt);

  UserGlobalConfigOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserGlobalConfigOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserGlobalConfigOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserGlobalConfigOut call({
    String id,
    String idUser,
    String idLanguage,
    String idUserColorTheme,
    String idUserTypographyTheme,
    Map<String, Object> preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserGlobalConfigOut.copyWith(...)` or call `instanceOfUserGlobalConfigOut.copyWith.fieldName(value)` for a single field.
class _$UserGlobalConfigOutCWProxyImpl implements _$UserGlobalConfigOutCWProxy {
  const _$UserGlobalConfigOutCWProxyImpl(this._value);

  final UserGlobalConfigOut _value;

  @override
  UserGlobalConfigOut id(String id) => call(id: id);

  @override
  UserGlobalConfigOut idUser(String idUser) => call(idUser: idUser);

  @override
  UserGlobalConfigOut idLanguage(String idLanguage) =>
      call(idLanguage: idLanguage);

  @override
  UserGlobalConfigOut idUserColorTheme(String idUserColorTheme) =>
      call(idUserColorTheme: idUserColorTheme);

  @override
  UserGlobalConfigOut idUserTypographyTheme(String idUserTypographyTheme) =>
      call(idUserTypographyTheme: idUserTypographyTheme);

  @override
  UserGlobalConfigOut preferences(Map<String, Object> preferences) =>
      call(preferences: preferences);

  @override
  UserGlobalConfigOut createdAt(DateTime? createdAt) =>
      call(createdAt: createdAt);

  @override
  UserGlobalConfigOut updatedAt(DateTime? updatedAt) =>
      call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserGlobalConfigOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserGlobalConfigOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserGlobalConfigOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
    Object? idUserColorTheme = const $CopyWithPlaceholder(),
    Object? idUserTypographyTheme = const $CopyWithPlaceholder(),
    Object? preferences = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return UserGlobalConfigOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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

extension $UserGlobalConfigOutCopyWith on UserGlobalConfigOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserGlobalConfigOut.copyWith(...)` or `instanceOfUserGlobalConfigOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserGlobalConfigOutCWProxy get copyWith =>
      _$UserGlobalConfigOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGlobalConfigOut _$UserGlobalConfigOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserGlobalConfigOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_user',
            'id_language',
            'id_user_color_theme',
            'id_user_typography_theme',
            'preferences',
            'created_at',
            'updated_at',
          ],
        );
        final val = UserGlobalConfigOut(
          id: $checkedConvert('id', (v) => v as String),
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
        'idLanguage': 'id_language',
        'idUserColorTheme': 'id_user_color_theme',
        'idUserTypographyTheme': 'id_user_typography_theme',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$UserGlobalConfigOutToJson(
  UserGlobalConfigOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_user': instance.idUser,
  'id_language': instance.idLanguage,
  'id_user_color_theme': instance.idUserColorTheme,
  'id_user_typography_theme': instance.idUserTypographyTheme,
  'preferences': instance.preferences,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
