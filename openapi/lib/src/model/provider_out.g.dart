// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProviderOutCWProxy {
  ProviderOut id(String id);

  ProviderOut slug(String slug);

  ProviderOut displayName(String displayName);

  ProviderOut baseUrl(String baseUrl);

  ProviderOut isActive(bool? isActive);

  ProviderOut createdAt(DateTime? createdAt);

  ProviderOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ProviderOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderOut(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderOut call({
    String id,
    String slug,
    String displayName,
    String baseUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProviderOut.copyWith(...)` or call `instanceOfProviderOut.copyWith.fieldName(value)` for a single field.
class _$ProviderOutCWProxyImpl implements _$ProviderOutCWProxy {
  const _$ProviderOutCWProxyImpl(this._value);

  final ProviderOut _value;

  @override
  ProviderOut id(String id) => call(id: id);

  @override
  ProviderOut slug(String slug) => call(slug: slug);

  @override
  ProviderOut displayName(String displayName) => call(displayName: displayName);

  @override
  ProviderOut baseUrl(String baseUrl) => call(baseUrl: baseUrl);

  @override
  ProviderOut isActive(bool? isActive) => call(isActive: isActive);

  @override
  ProviderOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  ProviderOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ProviderOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ProviderOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? baseUrl = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return ProviderOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
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

extension $ProviderOutCopyWith on ProviderOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProviderOut.copyWith(...)` or `instanceOfProviderOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProviderOutCWProxy get copyWith => _$ProviderOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderOut _$ProviderOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ProviderOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'slug',
        'display_name',
        'base_url',
        'is_active',
        'created_at',
        'updated_at',
      ],
    );
    final val = ProviderOut(
      id: $checkedConvert('id', (v) => v as String),
      slug: $checkedConvert('slug', (v) => v as String),
      displayName: $checkedConvert('display_name', (v) => v as String),
      baseUrl: $checkedConvert('base_url', (v) => v as String),
      isActive: $checkedConvert('is_active', (v) => v as bool?),
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
    'displayName': 'display_name',
    'baseUrl': 'base_url',
    'isActive': 'is_active',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ProviderOutToJson(ProviderOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'display_name': instance.displayName,
      'base_url': instance.baseUrl,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
