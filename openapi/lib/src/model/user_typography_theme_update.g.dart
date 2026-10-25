// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_typography_theme_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserTypographyThemeUpdateCWProxy {
  UserTypographyThemeUpdate idUser(String? idUser);

  UserTypographyThemeUpdate name(String? name);

  UserTypographyThemeUpdate displayFont(String? displayFont);

  UserTypographyThemeUpdate bodyFont(String? bodyFont);

  UserTypographyThemeUpdate monoFont(String? monoFont);

  UserTypographyThemeUpdate overrideJson(String? overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserTypographyThemeUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserTypographyThemeUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserTypographyThemeUpdate call({
    String? idUser,
    String? name,
    String? displayFont,
    String? bodyFont,
    String? monoFont,
    String? overrideJson,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserTypographyThemeUpdate.copyWith(...)` or call `instanceOfUserTypographyThemeUpdate.copyWith.fieldName(value)` for a single field.
class _$UserTypographyThemeUpdateCWProxyImpl
    implements _$UserTypographyThemeUpdateCWProxy {
  const _$UserTypographyThemeUpdateCWProxyImpl(this._value);

  final UserTypographyThemeUpdate _value;

  @override
  UserTypographyThemeUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  UserTypographyThemeUpdate name(String? name) => call(name: name);

  @override
  UserTypographyThemeUpdate displayFont(String? displayFont) =>
      call(displayFont: displayFont);

  @override
  UserTypographyThemeUpdate bodyFont(String? bodyFont) =>
      call(bodyFont: bodyFont);

  @override
  UserTypographyThemeUpdate monoFont(String? monoFont) =>
      call(monoFont: monoFont);

  @override
  UserTypographyThemeUpdate overrideJson(String? overrideJson) =>
      call(overrideJson: overrideJson);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserTypographyThemeUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserTypographyThemeUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserTypographyThemeUpdate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? displayFont = const $CopyWithPlaceholder(),
    Object? bodyFont = const $CopyWithPlaceholder(),
    Object? monoFont = const $CopyWithPlaceholder(),
    Object? overrideJson = const $CopyWithPlaceholder(),
  }) {
    return UserTypographyThemeUpdate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      displayFont: displayFont == const $CopyWithPlaceholder()
          ? _value.displayFont
          // ignore: cast_nullable_to_non_nullable
          : displayFont as String?,
      bodyFont: bodyFont == const $CopyWithPlaceholder()
          ? _value.bodyFont
          // ignore: cast_nullable_to_non_nullable
          : bodyFont as String?,
      monoFont: monoFont == const $CopyWithPlaceholder()
          ? _value.monoFont
          // ignore: cast_nullable_to_non_nullable
          : monoFont as String?,
      overrideJson: overrideJson == const $CopyWithPlaceholder()
          ? _value.overrideJson
          // ignore: cast_nullable_to_non_nullable
          : overrideJson as String?,
    );
  }
}

extension $UserTypographyThemeUpdateCopyWith on UserTypographyThemeUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserTypographyThemeUpdate.copyWith(...)` or `instanceOfUserTypographyThemeUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserTypographyThemeUpdateCWProxy get copyWith =>
      _$UserTypographyThemeUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTypographyThemeUpdate _$UserTypographyThemeUpdateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserTypographyThemeUpdate',
  json,
  ($checkedConvert) {
    final val = UserTypographyThemeUpdate(
      idUser: $checkedConvert('id_user', (v) => v as String?),
      name: $checkedConvert('name', (v) => v as String?),
      displayFont: $checkedConvert('display_font', (v) => v as String?),
      bodyFont: $checkedConvert('body_font', (v) => v as String?),
      monoFont: $checkedConvert('mono_font', (v) => v as String?),
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

Map<String, dynamic> _$UserTypographyThemeUpdateToJson(
  UserTypographyThemeUpdate instance,
) => <String, dynamic>{
  'id_user': ?instance.idUser,
  'name': ?instance.name,
  'display_font': ?instance.displayFont,
  'body_font': ?instance.bodyFont,
  'mono_font': ?instance.monoFont,
  'override_json': ?instance.overrideJson,
};
