// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_color_theme_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserColorThemeUpdateCWProxy {
  UserColorThemeUpdate idUser(String? idUser);

  UserColorThemeUpdate name(String? name);

  UserColorThemeUpdate seedColor(int? seedColor);

  UserColorThemeUpdate overrideJson(String? overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserColorThemeUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserColorThemeUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserColorThemeUpdate call({
    String? idUser,
    String? name,
    int? seedColor,
    String? overrideJson,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserColorThemeUpdate.copyWith(...)` or call `instanceOfUserColorThemeUpdate.copyWith.fieldName(value)` for a single field.
class _$UserColorThemeUpdateCWProxyImpl
    implements _$UserColorThemeUpdateCWProxy {
  const _$UserColorThemeUpdateCWProxyImpl(this._value);

  final UserColorThemeUpdate _value;

  @override
  UserColorThemeUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  UserColorThemeUpdate name(String? name) => call(name: name);

  @override
  UserColorThemeUpdate seedColor(int? seedColor) => call(seedColor: seedColor);

  @override
  UserColorThemeUpdate overrideJson(String? overrideJson) =>
      call(overrideJson: overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserColorThemeUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserColorThemeUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserColorThemeUpdate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? seedColor = const $CopyWithPlaceholder(),
    Object? overrideJson = const $CopyWithPlaceholder(),
  }) {
    return UserColorThemeUpdate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      seedColor: seedColor == const $CopyWithPlaceholder()
          ? _value.seedColor
          // ignore: cast_nullable_to_non_nullable
          : seedColor as int?,
      overrideJson: overrideJson == const $CopyWithPlaceholder()
          ? _value.overrideJson
          // ignore: cast_nullable_to_non_nullable
          : overrideJson as String?,
    );
  }
}

extension $UserColorThemeUpdateCopyWith on UserColorThemeUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserColorThemeUpdate.copyWith(...)` or `instanceOfUserColorThemeUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserColorThemeUpdateCWProxy get copyWith =>
      _$UserColorThemeUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserColorThemeUpdate _$UserColorThemeUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserColorThemeUpdate',
  json,
  ($checkedConvert) {
    final val = UserColorThemeUpdate(
      idUser: $checkedConvert('id_user', (v) => v as String?),
      name: $checkedConvert('name', (v) => v as String?),
      seedColor: $checkedConvert('seed_color', (v) => (v as num?)?.toInt()),
      overrideJson: $checkedConvert('override_json', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'idUser': 'id_user',
    'seedColor': 'seed_color',
    'overrideJson': 'override_json',
  },
);

Map<String, dynamic> _$UserColorThemeUpdateToJson(
  UserColorThemeUpdate instance,
) => <String, dynamic>{
  'id_user': ?instance.idUser,
  'name': ?instance.name,
  'seed_color': ?instance.seedColor,
  'override_json': ?instance.overrideJson,
};
