// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LanguageUpdateCWProxy {
  LanguageUpdate name(String? name);

  LanguageUpdate percentageTranslated(int? percentageTranslated);

  LanguageUpdate verifiedTranslation(bool? verifiedTranslation);

  LanguageUpdate automaticTranslation(bool? automaticTranslation);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LanguageUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LanguageUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  LanguageUpdate call({
    String? name,
    int? percentageTranslated,
    bool? verifiedTranslation,
    bool? automaticTranslation,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLanguageUpdate.copyWith(...)` or call `instanceOfLanguageUpdate.copyWith.fieldName(value)` for a single field.
class _$LanguageUpdateCWProxyImpl implements _$LanguageUpdateCWProxy {
  const _$LanguageUpdateCWProxyImpl(this._value);

  final LanguageUpdate _value;

  @override
  LanguageUpdate name(String? name) => call(name: name);

  @override
  LanguageUpdate percentageTranslated(int? percentageTranslated) =>
      call(percentageTranslated: percentageTranslated);

  @override
  LanguageUpdate verifiedTranslation(bool? verifiedTranslation) =>
      call(verifiedTranslation: verifiedTranslation);

  @override
  LanguageUpdate automaticTranslation(bool? automaticTranslation) =>
      call(automaticTranslation: automaticTranslation);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LanguageUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LanguageUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  LanguageUpdate call({
    Object? name = const $CopyWithPlaceholder(),
    Object? percentageTranslated = const $CopyWithPlaceholder(),
    Object? verifiedTranslation = const $CopyWithPlaceholder(),
    Object? automaticTranslation = const $CopyWithPlaceholder(),
  }) {
    return LanguageUpdate(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      percentageTranslated: percentageTranslated == const $CopyWithPlaceholder()
          ? _value.percentageTranslated
          // ignore: cast_nullable_to_non_nullable
          : percentageTranslated as int?,
      verifiedTranslation: verifiedTranslation == const $CopyWithPlaceholder()
          ? _value.verifiedTranslation
          // ignore: cast_nullable_to_non_nullable
          : verifiedTranslation as bool?,
      automaticTranslation: automaticTranslation == const $CopyWithPlaceholder()
          ? _value.automaticTranslation
          // ignore: cast_nullable_to_non_nullable
          : automaticTranslation as bool?,
    );
  }
}

extension $LanguageUpdateCopyWith on LanguageUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLanguageUpdate.copyWith(...)` or `instanceOfLanguageUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LanguageUpdateCWProxy get copyWith => _$LanguageUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageUpdate _$LanguageUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LanguageUpdate',
      json,
      ($checkedConvert) {
        final val = LanguageUpdate(
          name: $checkedConvert('name', (v) => v as String?),
          percentageTranslated: $checkedConvert(
            'percentage_translated',
            (v) => (v as num?)?.toInt(),
          ),
          verifiedTranslation: $checkedConvert(
            'verified_translation',
            (v) => v as bool?,
          ),
          automaticTranslation: $checkedConvert(
            'automatic_translation',
            (v) => v as bool?,
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

Map<String, dynamic> _$LanguageUpdateToJson(LanguageUpdate instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'percentage_translated': ?instance.percentageTranslated,
      'verified_translation': ?instance.verifiedTranslation,
      'automatic_translation': ?instance.automaticTranslation,
    };
