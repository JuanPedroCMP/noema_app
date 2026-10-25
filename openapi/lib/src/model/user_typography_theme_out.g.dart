// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_typography_theme_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserTypographyThemeOutCWProxy {
  UserTypographyThemeOut id(String id);

  UserTypographyThemeOut idUser(String idUser);

  UserTypographyThemeOut name(String name);

  UserTypographyThemeOut displayFont(String displayFont);

  UserTypographyThemeOut bodyFont(String bodyFont);

  UserTypographyThemeOut monoFont(String monoFont);

  UserTypographyThemeOut overrideJson(Map<String, Object> overrideJson);

  UserTypographyThemeOut createdAt(DateTime? createdAt);

  UserTypographyThemeOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserTypographyThemeOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserTypographyThemeOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserTypographyThemeOut call({
    String id,
    String idUser,
    String name,
    String displayFont,
    String bodyFont,
    String monoFont,
    Map<String, Object> overrideJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserTypographyThemeOut.copyWith(...)` or call `instanceOfUserTypographyThemeOut.copyWith.fieldName(value)` for a single field.
class _$UserTypographyThemeOutCWProxyImpl
    implements _$UserTypographyThemeOutCWProxy {
  const _$UserTypographyThemeOutCWProxyImpl(this._value);

  final UserTypographyThemeOut _value;

  @override
  UserTypographyThemeOut id(String id) => call(id: id);

  @override
  UserTypographyThemeOut idUser(String idUser) => call(idUser: idUser);

  @override
  UserTypographyThemeOut name(String name) => call(name: name);

  @override
  UserTypographyThemeOut displayFont(String displayFont) =>
      call(displayFont: displayFont);

  @override
  UserTypographyThemeOut bodyFont(String bodyFont) => call(bodyFont: bodyFont);

  @override
  UserTypographyThemeOut monoFont(String monoFont) => call(monoFont: monoFont);

  @override
  UserTypographyThemeOut overrideJson(Map<String, Object> overrideJson) =>
      call(overrideJson: overrideJson);

  @override
  UserTypographyThemeOut createdAt(DateTime? createdAt) =>
      call(createdAt: createdAt);

  @override
  UserTypographyThemeOut updatedAt(DateTime? updatedAt) =>
      call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserTypographyThemeOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserTypographyThemeOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserTypographyThemeOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? displayFont = const $CopyWithPlaceholder(),
    Object? bodyFont = const $CopyWithPlaceholder(),
    Object? monoFont = const $CopyWithPlaceholder(),
    Object? overrideJson = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return UserTypographyThemeOut(
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
      displayFont:
          displayFont == const $CopyWithPlaceholder() || displayFont == null
          ? _value.displayFont
          // ignore: cast_nullable_to_non_nullable
          : displayFont as String,
      bodyFont: bodyFont == const $CopyWithPlaceholder() || bodyFont == null
          ? _value.bodyFont
          // ignore: cast_nullable_to_non_nullable
          : bodyFont as String,
      monoFont: monoFont == const $CopyWithPlaceholder() || monoFont == null
          ? _value.monoFont
          // ignore: cast_nullable_to_non_nullable
          : monoFont as String,
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

extension $UserTypographyThemeOutCopyWith on UserTypographyThemeOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserTypographyThemeOut.copyWith(...)` or `instanceOfUserTypographyThemeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserTypographyThemeOutCWProxy get copyWith =>
      _$UserTypographyThemeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTypographyThemeOut _$UserTypographyThemeOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserTypographyThemeOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'id_user',
        'name',
        'display_font',
        'body_font',
        'mono_font',
        'override_json',
        'created_at',
        'updated_at',
      ],
    );
    final val = UserTypographyThemeOut(
      id: $checkedConvert('id', (v) => v as String),
      idUser: $checkedConvert('id_user', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      displayFont: $checkedConvert('display_font', (v) => v as String),
      bodyFont: $checkedConvert('body_font', (v) => v as String),
      monoFont: $checkedConvert('mono_font', (v) => v as String),
      overrideJson: $checkedConvert(
        'override_json',
        (v) =>
            (v as Map<String, dynamic>).map((k, e) => MapEntry(k, e as Object)),
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
    'displayFont': 'display_font',
    'bodyFont': 'body_font',
    'monoFont': 'mono_font',
    'overrideJson': 'override_json',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$UserTypographyThemeOutToJson(
  UserTypographyThemeOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_user': instance.idUser,
  'name': instance.name,
  'display_font': instance.displayFont,
  'body_font': instance.bodyFont,
  'mono_font': instance.monoFont,
  'override_json': instance.overrideJson,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
