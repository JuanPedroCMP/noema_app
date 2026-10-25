// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LanguageCreateCWProxy {
  LanguageCreate name(String name);

  LanguageCreate percentageTranslated(int percentageTranslated);

  LanguageCreate verifiedTranslation(bool verifiedTranslation);

  LanguageCreate automaticTranslation(bool automaticTranslation);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LanguageCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LanguageCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  LanguageCreate call({
    String name,
    int percentageTranslated,
    bool verifiedTranslation,
    bool automaticTranslation,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLanguageCreate.copyWith(...)` or call `instanceOfLanguageCreate.copyWith.fieldName(value)` for a single field.
class _$LanguageCreateCWProxyImpl implements _$LanguageCreateCWProxy {
  const _$LanguageCreateCWProxyImpl(this._value);

  final LanguageCreate _value;

  @override
  LanguageCreate name(String name) => call(name: name);

  @override
  LanguageCreate percentageTranslated(int percentageTranslated) =>
      call(percentageTranslated: percentageTranslated);

  @override
  LanguageCreate verifiedTranslation(bool verifiedTranslation) =>
      call(verifiedTranslation: verifiedTranslation);

  @override
  LanguageCreate automaticTranslation(bool automaticTranslation) =>
      call(automaticTranslation: automaticTranslation);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LanguageCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LanguageCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  LanguageCreate call({
    Object? name = const $CopyWithPlaceholder(),
    Object? percentageTranslated = const $CopyWithPlaceholder(),
    Object? verifiedTranslation = const $CopyWithPlaceholder(),
    Object? automaticTranslation = const $CopyWithPlaceholder(),
  }) {
    return LanguageCreate(
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
    );
  }
}

extension $LanguageCreateCopyWith on LanguageCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLanguageCreate.copyWith(...)` or `instanceOfLanguageCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LanguageCreateCWProxy get copyWith => _$LanguageCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageCreate _$LanguageCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LanguageCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'name',
            'percentage_translated',
            'verified_translation',
            'automatic_translation',
          ],
        );
        final val = LanguageCreate(
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
        );
        return val;
      },
      fieldKeyMap: const {
        'percentageTranslated': 'percentage_translated',
        'verifiedTranslation': 'verified_translation',
        'automaticTranslation': 'automatic_translation',
      },
    );

Map<String, dynamic> _$LanguageCreateToJson(LanguageCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'percentage_translated': instance.percentageTranslated,
      'verified_translation': instance.verifiedTranslation,
      'automatic_translation': instance.automaticTranslation,
    };
