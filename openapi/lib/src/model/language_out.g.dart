// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LanguageOutCWProxy {
  LanguageOut id(String id);

  LanguageOut name(String name);

  LanguageOut percentageTranslated(int percentageTranslated);

  LanguageOut verifiedTranslation(bool verifiedTranslation);

  LanguageOut automaticTranslation(bool automaticTranslation);

  LanguageOut createdAt(DateTime? createdAt);

  LanguageOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LanguageOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LanguageOut(...).copyWith(id: 12, name: "My name")
  /// ```
  LanguageOut call({
    String id,
    String name,
    int percentageTranslated,
    bool verifiedTranslation,
    bool automaticTranslation,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLanguageOut.copyWith(...)` or call `instanceOfLanguageOut.copyWith.fieldName(value)` for a single field.
class _$LanguageOutCWProxyImpl implements _$LanguageOutCWProxy {
  const _$LanguageOutCWProxyImpl(this._value);

  final LanguageOut _value;

  @override
  LanguageOut id(String id) => call(id: id);

  @override
  LanguageOut name(String name) => call(name: name);

  @override
  LanguageOut percentageTranslated(int percentageTranslated) =>
      call(percentageTranslated: percentageTranslated);

  @override
  LanguageOut verifiedTranslation(bool verifiedTranslation) =>
      call(verifiedTranslation: verifiedTranslation);

  @override
  LanguageOut automaticTranslation(bool automaticTranslation) =>
      call(automaticTranslation: automaticTranslation);

  @override
  LanguageOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  LanguageOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LanguageOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LanguageOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  LanguageOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? percentageTranslated = const $CopyWithPlaceholder(),
    Object? verifiedTranslation = const $CopyWithPlaceholder(),
    Object? automaticTranslation = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return LanguageOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      percentageTranslated:
          percentageTranslated == const $CopyWithPlaceholder() ||
              percentageTranslated == null
          ? _value.percentageTranslated
          // ignore: cast_nullable_to_non_nullable
          : percentageTranslated as int,
      verifiedTranslation:
          verifiedTranslation == const $CopyWithPlaceholder() ||
              verifiedTranslation == null
          ? _value.verifiedTranslation
          // ignore: cast_nullable_to_non_nullable
          : verifiedTranslation as bool,
      automaticTranslation:
          automaticTranslation == const $CopyWithPlaceholder() ||
              automaticTranslation == null
          ? _value.automaticTranslation
          // ignore: cast_nullable_to_non_nullable
          : automaticTranslation as bool,
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

extension $LanguageOutCopyWith on LanguageOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLanguageOut.copyWith(...)` or `instanceOfLanguageOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LanguageOutCWProxy get copyWith => _$LanguageOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageOut _$LanguageOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'LanguageOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'name',
        'percentage_translated',
        'verified_translation',
        'automatic_translation',
        'created_at',
        'updated_at',
      ],
    );
    final val = LanguageOut(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      percentageTranslated: $checkedConvert(
        'percentage_translated',
        (v) => (v as num).toInt(),
      ),
      verifiedTranslation: $checkedConvert(
        'verified_translation',
        (v) => v as bool,
      ),
      automaticTranslation: $checkedConvert(
        'automatic_translation',
        (v) => v as bool,
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
    'percentageTranslated': 'percentage_translated',
    'verifiedTranslation': 'verified_translation',
    'automaticTranslation': 'automatic_translation',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$LanguageOutToJson(LanguageOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'percentage_translated': instance.percentageTranslated,
      'verified_translation': instance.verifiedTranslation,
      'automatic_translation': instance.automaticTranslation,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
