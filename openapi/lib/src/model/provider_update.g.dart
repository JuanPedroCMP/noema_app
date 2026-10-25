// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProviderUpdateCWProxy {
  ProviderUpdate slug(String? slug);

  ProviderUpdate displayName(String? displayName);

  ProviderUpdate baseUrl(String? baseUrl);

  ProviderUpdate isActive(bool? isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ProviderUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderUpdate call({
    String? slug,
    String? displayName,
    String? baseUrl,
    bool? isActive,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProviderUpdate.copyWith(...)` or call `instanceOfProviderUpdate.copyWith.fieldName(value)` for a single field.
class _$ProviderUpdateCWProxyImpl implements _$ProviderUpdateCWProxy {
  const _$ProviderUpdateCWProxyImpl(this._value);

  final ProviderUpdate _value;

  @override
  ProviderUpdate slug(String? slug) => call(slug: slug);

  @override
  ProviderUpdate displayName(String? displayName) =>
      call(displayName: displayName);

  @override
  ProviderUpdate baseUrl(String? baseUrl) => call(baseUrl: baseUrl);

  @override
  ProviderUpdate isActive(bool? isActive) => call(isActive: isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ProviderUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ProviderUpdate call({
    Object? slug = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? baseUrl = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return ProviderUpdate(
      slug: slug == const $CopyWithPlaceholder()
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String?,
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String?,
      baseUrl: baseUrl == const $CopyWithPlaceholder()
          ? _value.baseUrl
          // ignore: cast_nullable_to_non_nullable
          : baseUrl as String?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $ProviderUpdateCopyWith on ProviderUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProviderUpdate.copyWith(...)` or `instanceOfProviderUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProviderUpdateCWProxy get copyWith => _$ProviderUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderUpdate _$ProviderUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProviderUpdate',
      json,
      ($checkedConvert) {
        final val = ProviderUpdate(
          slug: $checkedConvert('slug', (v) => v as String?),
          displayName: $checkedConvert('display_name', (v) => v as String?),
          baseUrl: $checkedConvert('base_url', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'displayName': 'display_name',
        'baseUrl': 'base_url',
        'isActive': 'is_active',
      },
    );

Map<String, dynamic> _$ProviderUpdateToJson(ProviderUpdate instance) =>
    <String, dynamic>{
      'slug': ?instance.slug,
      'display_name': ?instance.displayName,
      'base_url': ?instance.baseUrl,
      'is_active': ?instance.isActive,
    };
