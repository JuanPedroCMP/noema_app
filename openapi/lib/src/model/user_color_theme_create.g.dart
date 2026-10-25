// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_color_theme_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserColorThemeCreateCWProxy {
  UserColorThemeCreate idUser(String idUser);

  UserColorThemeCreate name(String name);

  UserColorThemeCreate seedColor(int seedColor);

  UserColorThemeCreate overrideJson(String overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserColorThemeCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserColorThemeCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserColorThemeCreate call({
    String idUser,
    String name,
    int seedColor,
    String overrideJson,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserColorThemeCreate.copyWith(...)` or call `instanceOfUserColorThemeCreate.copyWith.fieldName(value)` for a single field.
class _$UserColorThemeCreateCWProxyImpl
    implements _$UserColorThemeCreateCWProxy {
  const _$UserColorThemeCreateCWProxyImpl(this._value);

  final UserColorThemeCreate _value;

  @override
  UserColorThemeCreate idUser(String idUser) => call(idUser: idUser);

  @override
  UserColorThemeCreate name(String name) => call(name: name);

  @override
  UserColorThemeCreate seedColor(int seedColor) => call(seedColor: seedColor);

  @override
  UserColorThemeCreate overrideJson(String overrideJson) =>
      call(overrideJson: overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserColorThemeCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserColorThemeCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserColorThemeCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? seedColor = const $CopyWithPlaceholder(),
    Object? overrideJson = const $CopyWithPlaceholder(),
  }) {
    return UserColorThemeCreate(
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
          : overrideJson as String,
    );
  }
}

extension $UserColorThemeCreateCopyWith on UserColorThemeCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserColorThemeCreate.copyWith(...)` or `instanceOfUserColorThemeCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserColorThemeCreateCWProxy get copyWith =>
      _$UserColorThemeCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserColorThemeCreate _$UserColorThemeCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserColorThemeCreate',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['id_user', 'name', 'seed_color', 'override_json'],
    );
    final val = UserColorThemeCreate(
      idUser: $checkedConvert('id_user', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      seedColor: $checkedConvert('seed_color', (v) => (v as num).toInt()),
      overrideJson: $checkedConvert('override_json', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'idUser': 'id_user',
    'seedColor': 'seed_color',
    'overrideJson': 'override_json',
  },
);

Map<String, dynamic> _$UserColorThemeCreateToJson(
  UserColorThemeCreate instance,
) => <String, dynamic>{
  'id_user': instance.idUser,
  'name': instance.name,
  'seed_color': instance.seedColor,
  'override_json': instance.overrideJson,
};
