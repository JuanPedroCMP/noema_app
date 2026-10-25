// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_language_preference_order_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResponseLanguagePreferenceOrderOutCWProxy {
  ResponseLanguagePreferenceOrderOut id(String id);

  ResponseLanguagePreferenceOrderOut preferenceOrder(int preferenceOrder);

  ResponseLanguagePreferenceOrderOut idUser(String idUser);

  ResponseLanguagePreferenceOrderOut idLanguage(String idLanguage);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ResponseLanguagePreferenceOrderOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ResponseLanguagePreferenceOrderOut(...).copyWith(id: 12, name: "My name")
  /// ```
  ResponseLanguagePreferenceOrderOut call({
    String id,
    int preferenceOrder,
    String idUser,
    String idLanguage,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfResponseLanguagePreferenceOrderOut.copyWith(...)` or call `instanceOfResponseLanguagePreferenceOrderOut.copyWith.fieldName(value)` for a single field.
class _$ResponseLanguagePreferenceOrderOutCWProxyImpl
    implements _$ResponseLanguagePreferenceOrderOutCWProxy {
  const _$ResponseLanguagePreferenceOrderOutCWProxyImpl(this._value);

  final ResponseLanguagePreferenceOrderOut _value;

  @override
  ResponseLanguagePreferenceOrderOut id(String id) => call(id: id);

  @override
  ResponseLanguagePreferenceOrderOut preferenceOrder(int preferenceOrder) =>
      call(preferenceOrder: preferenceOrder);

  @override
  ResponseLanguagePreferenceOrderOut idUser(String idUser) =>
      call(idUser: idUser);

  @override
  ResponseLanguagePreferenceOrderOut idLanguage(String idLanguage) =>
      call(idLanguage: idLanguage);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ResponseLanguagePreferenceOrderOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ResponseLanguagePreferenceOrderOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ResponseLanguagePreferenceOrderOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? preferenceOrder = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
  }) {
    return ResponseLanguagePreferenceOrderOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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

extension $ResponseLanguagePreferenceOrderOutCopyWith
    on ResponseLanguagePreferenceOrderOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfResponseLanguagePreferenceOrderOut.copyWith(...)` or `instanceOfResponseLanguagePreferenceOrderOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResponseLanguagePreferenceOrderOutCWProxy get copyWith =>
      _$ResponseLanguagePreferenceOrderOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLanguagePreferenceOrderOut _$ResponseLanguagePreferenceOrderOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ResponseLanguagePreferenceOrderOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['id', 'preference_order', 'id_user', 'id_language'],
    );
    final val = ResponseLanguagePreferenceOrderOut(
      id: $checkedConvert('id', (v) => v as String),
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

Map<String, dynamic> _$ResponseLanguagePreferenceOrderOutToJson(
  ResponseLanguagePreferenceOrderOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'preference_order': instance.preferenceOrder,
  'id_user': instance.idUser,
  'id_language': instance.idLanguage,
};
