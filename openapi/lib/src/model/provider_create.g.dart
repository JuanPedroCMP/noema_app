// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProviderCreateCWProxy {
  ProviderCreate slug(String slug);

  ProviderCreate displayName(String displayName);

  ProviderCreate baseUrl(String baseUrl);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ProviderCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderCreate call({String slug, String displayName, String baseUrl});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProviderCreate.copyWith(...)` or call `instanceOfProviderCreate.copyWith.fieldName(value)` for a single field.
class _$ProviderCreateCWProxyImpl implements _$ProviderCreateCWProxy {
  const _$ProviderCreateCWProxyImpl(this._value);

  final ProviderCreate _value;

  @override
  ProviderCreate slug(String slug) => call(slug: slug);

  @override
  ProviderCreate displayName(String displayName) =>
      call(displayName: displayName);

  @override
  ProviderCreate baseUrl(String baseUrl) => call(baseUrl: baseUrl);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ProviderCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ProviderCreate call({
    Object? slug = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? baseUrl = const $CopyWithPlaceholder(),
  }) {
    return ProviderCreate(
      slug: slug == const $CopyWithPlaceholder() || slug == null
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String,
      displayName:
          displayName == const $CopyWithPlaceholder() || displayName == null
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String,
      baseUrl: baseUrl == const $CopyWithPlaceholder() || baseUrl == null
          ? _value.baseUrl
          // ignore: cast_nullable_to_non_nullable
          : baseUrl as String,
    );
  }
}

extension $ProviderCreateCopyWith on ProviderCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProviderCreate.copyWith(...)` or `instanceOfProviderCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProviderCreateCWProxy get copyWith => _$ProviderCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderCreate _$ProviderCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ProviderCreate', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['slug', 'display_name', 'base_url']);
  final val = ProviderCreate(
    slug: $checkedConvert('slug', (v) => v as String),
    displayName: $checkedConvert('display_name', (v) => v as String),
    baseUrl: $checkedConvert('base_url', (v) => v as String),
  );
  return val;
}, fieldKeyMap: const {'displayName': 'display_name', 'baseUrl': 'base_url'});

Map<String, dynamic> _$ProviderCreateToJson(ProviderCreate instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'display_name': instance.displayName,
      'base_url': instance.baseUrl,
    };
