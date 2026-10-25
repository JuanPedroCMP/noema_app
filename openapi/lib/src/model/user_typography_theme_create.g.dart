// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_typography_theme_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserTypographyThemeCreateCWProxy {
  UserTypographyThemeCreate idUser(String idUser);

  UserTypographyThemeCreate name(String name);

  UserTypographyThemeCreate displayFont(String displayFont);

  UserTypographyThemeCreate bodyFont(String bodyFont);

  UserTypographyThemeCreate monoFont(String monoFont);

  UserTypographyThemeCreate overrideJson(String? overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserTypographyThemeCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserTypographyThemeCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserTypographyThemeCreate call({
    String idUser,
    String name,
    String displayFont,
    String bodyFont,
    String monoFont,
    String? overrideJson,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserTypographyThemeCreate.copyWith(...)` or call `instanceOfUserTypographyThemeCreate.copyWith.fieldName(value)` for a single field.
class _$UserTypographyThemeCreateCWProxyImpl
    implements _$UserTypographyThemeCreateCWProxy {
  const _$UserTypographyThemeCreateCWProxyImpl(this._value);

  final UserTypographyThemeCreate _value;

  @override
  UserTypographyThemeCreate idUser(String idUser) => call(idUser: idUser);

  @override
  UserTypographyThemeCreate name(String name) => call(name: name);

  @override
  UserTypographyThemeCreate displayFont(String displayFont) =>
      call(displayFont: displayFont);

  @override
  UserTypographyThemeCreate bodyFont(String bodyFont) =>
      call(bodyFont: bodyFont);

  @override
  UserTypographyThemeCreate monoFont(String monoFont) =>
      call(monoFont: monoFont);

  @override
  UserTypographyThemeCreate overrideJson(String? overrideJson) =>
      call(overrideJson: overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserTypographyThemeCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserTypographyThemeCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserTypographyThemeCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? displayFont = const $CopyWithPlaceholder(),
    Object? bodyFont = const $CopyWithPlaceholder(),
    Object? monoFont = const $CopyWithPlaceholder(),
    Object? overrideJson = const $CopyWithPlaceholder(),
  }) {
    return UserTypographyThemeCreate(
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
      overrideJson: overrideJson == const $CopyWithPlaceholder()
          ? _value.overrideJson
          // ignore: cast_nullable_to_non_nullable
          : overrideJson as String?,
    );
  }
}

extension $UserTypographyThemeCreateCopyWith on UserTypographyThemeCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserTypographyThemeCreate.copyWith(...)` or `instanceOfUserTypographyThemeCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserTypographyThemeCreateCWProxy get copyWith =>
      _$UserTypographyThemeCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTypographyThemeCreate _$UserTypographyThemeCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserTypographyThemeCreate',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id_user',
        'name',
        'display_font',
        'body_font',
        'mono_font',
        'override_json',
      ],
    );
    final val = UserTypographyThemeCreate(
      idUser: $checkedConvert('id_user', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      displayFont: $checkedConvert('display_font', (v) => v as String),
      bodyFont: $checkedConvert('body_font', (v) => v as String),
      monoFont: $checkedConvert('mono_font', (v) => v as String),
      overrideJson: $checkedConvert('override_json', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'idUser': 'id_user',
    'displayFont': 'display_font',
    'bodyFont': 'body_font',
    'monoFont': 'mono_font',
    'overrideJson': 'override_json',
  },
);

Map<String, dynamic> _$UserTypographyThemeCreateToJson(
  UserTypographyThemeCreate instance,
) => <String, dynamic>{
  'id_user': instance.idUser,
  'name': instance.name,
  'display_font': instance.displayFont,
  'body_font': instance.bodyFont,
  'mono_font': instance.monoFont,
  'override_json': instance.overrideJson,
};
