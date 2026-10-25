// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_color_theme_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserColorThemeOutCWProxy {
  UserColorThemeOut id(String id);

  UserColorThemeOut idUser(String idUser);

  UserColorThemeOut name(String name);

  UserColorThemeOut seedColor(int seedColor);

  UserColorThemeOut overrideJson(Map<String, Object> overrideJson);

  UserColorThemeOut createdAt(DateTime? createdAt);

  UserColorThemeOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserColorThemeOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserColorThemeOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserColorThemeOut call({
    String id,
    String idUser,
    String name,
    int seedColor,
    Map<String, Object> overrideJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserColorThemeOut.copyWith(...)` or call `instanceOfUserColorThemeOut.copyWith.fieldName(value)` for a single field.
class _$UserColorThemeOutCWProxyImpl implements _$UserColorThemeOutCWProxy {
  const _$UserColorThemeOutCWProxyImpl(this._value);

  final UserColorThemeOut _value;

  @override
  UserColorThemeOut id(String id) => call(id: id);

  @override
  UserColorThemeOut idUser(String idUser) => call(idUser: idUser);

  @override
  UserColorThemeOut name(String name) => call(name: name);

  @override
  UserColorThemeOut seedColor(int seedColor) => call(seedColor: seedColor);

  @override
  UserColorThemeOut overrideJson(Map<String, Object> overrideJson) =>
      call(overrideJson: overrideJson);

  @override
  UserColorThemeOut createdAt(DateTime? createdAt) =>
      call(createdAt: createdAt);

  @override
  UserColorThemeOut updatedAt(DateTime? updatedAt) =>
      call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserColorThemeOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserColorThemeOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserColorThemeOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? seedColor = const $CopyWithPlaceholder(),
    Object? overrideJson = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return UserColorThemeOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      seedColor: seedColor == const $CopyWithPlaceholder() || seedColor == null
          ? _value.seedColor
          // ignore: cast_nullable_to_non_nullable
          : seedColor as int,
      overrideJson:
          overrideJson == const $CopyWithPlaceholder() || overrideJson == null
          ? _value.overrideJson
          // ignore: cast_nullable_to_non_nullable
          : overrideJson as Map<String, Object>,
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

extension $UserColorThemeOutCopyWith on UserColorThemeOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserColorThemeOut.copyWith(...)` or `instanceOfUserColorThemeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserColorThemeOutCWProxy get copyWith =>
      _$UserColorThemeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserColorThemeOut _$UserColorThemeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserColorThemeOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_user',
            'name',
            'seed_color',
            'override_json',
            'created_at',
            'updated_at',
          ],
        );
        final val = UserColorThemeOut(
          id: $checkedConvert('id', (v) => v as String),
          idUser: $checkedConvert('id_user', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          seedColor: $checkedConvert('seed_color', (v) => (v as num).toInt()),
          overrideJson: $checkedConvert(
            'override_json',
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
        'seedColor': 'seed_color',
        'overrideJson': 'override_json',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$UserColorThemeOutToJson(UserColorThemeOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'name': instance.name,
      'seed_color': instance.seedColor,
      'override_json': instance.overrideJson,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
