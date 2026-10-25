// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_language_preference_order_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResponseLanguagePreferenceOrderCreateCWProxy {
  ResponseLanguagePreferenceOrderCreate preferenceOrder(int preferenceOrder);

  ResponseLanguagePreferenceOrderCreate idUser(String idUser);

  ResponseLanguagePreferenceOrderCreate idLanguage(String idLanguage);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ResponseLanguagePreferenceOrderCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ResponseLanguagePreferenceOrderCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  ResponseLanguagePreferenceOrderCreate call({
    int preferenceOrder,
    String idUser,
    String idLanguage,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfResponseLanguagePreferenceOrderCreate.copyWith(...)` or call `instanceOfResponseLanguagePreferenceOrderCreate.copyWith.fieldName(value)` for a single field.
class _$ResponseLanguagePreferenceOrderCreateCWProxyImpl
    implements _$ResponseLanguagePreferenceOrderCreateCWProxy {
  const _$ResponseLanguagePreferenceOrderCreateCWProxyImpl(this._value);

  final ResponseLanguagePreferenceOrderCreate _value;

  @override
  ResponseLanguagePreferenceOrderCreate preferenceOrder(int preferenceOrder) =>
      call(preferenceOrder: preferenceOrder);

  @override
  ResponseLanguagePreferenceOrderCreate idUser(String idUser) =>
      call(idUser: idUser);

  @override
  ResponseLanguagePreferenceOrderCreate idLanguage(String idLanguage) =>
      call(idLanguage: idLanguage);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ResponseLanguagePreferenceOrderCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ResponseLanguagePreferenceOrderCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ResponseLanguagePreferenceOrderCreate call({
    Object? preferenceOrder = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
  }) {
    return ResponseLanguagePreferenceOrderCreate(
      preferenceOrder:
          preferenceOrder == const $CopyWithPlaceholder() ||
              preferenceOrder == null
          ? _value.preferenceOrder
          // ignore: cast_nullable_to_non_nullable
          : preferenceOrder as int,
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      idLanguage:
          idLanguage == const $CopyWithPlaceholder() || idLanguage == null
          ? _value.idLanguage
          // ignore: cast_nullable_to_non_nullable
          : idLanguage as String,
    );
  }
}

extension $ResponseLanguagePreferenceOrderCreateCopyWith
    on ResponseLanguagePreferenceOrderCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfResponseLanguagePreferenceOrderCreate.copyWith(...)` or `instanceOfResponseLanguagePreferenceOrderCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResponseLanguagePreferenceOrderCreateCWProxy get copyWith =>
      _$ResponseLanguagePreferenceOrderCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLanguagePreferenceOrderCreate
_$ResponseLanguagePreferenceOrderCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ResponseLanguagePreferenceOrderCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['preference_order', 'id_user', 'id_language'],
        );
        final val = ResponseLanguagePreferenceOrderCreate(
          preferenceOrder: $checkedConvert(
            'preference_order',
            (v) => (v as num).toInt(),
          ),
          idUser: $checkedConvert('id_user', (v) => v as String),
          idLanguage: $checkedConvert('id_language', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'preferenceOrder': 'preference_order',
        'idUser': 'id_user',
        'idLanguage': 'id_language',
      },
    );

Map<String, dynamic> _$ResponseLanguagePreferenceOrderCreateToJson(
  ResponseLanguagePreferenceOrderCreate instance,
) => <String, dynamic>{
  'preference_order': instance.preferenceOrder,
  'id_user': instance.idUser,
  'id_language': instance.idLanguage,
};
