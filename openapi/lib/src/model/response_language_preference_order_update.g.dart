// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_language_preference_order_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResponseLanguagePreferenceOrderUpdateCWProxy {
  ResponseLanguagePreferenceOrderUpdate id(String? id);

  ResponseLanguagePreferenceOrderUpdate preferenceOrder(int? preferenceOrder);

  ResponseLanguagePreferenceOrderUpdate idUser(String? idUser);

  ResponseLanguagePreferenceOrderUpdate idLanguage(String? idLanguage);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ResponseLanguagePreferenceOrderUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ResponseLanguagePreferenceOrderUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  ResponseLanguagePreferenceOrderUpdate call({
    String? id,
    int? preferenceOrder,
    String? idUser,
    String? idLanguage,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfResponseLanguagePreferenceOrderUpdate.copyWith(...)` or call `instanceOfResponseLanguagePreferenceOrderUpdate.copyWith.fieldName(value)` for a single field.
class _$ResponseLanguagePreferenceOrderUpdateCWProxyImpl
    implements _$ResponseLanguagePreferenceOrderUpdateCWProxy {
  const _$ResponseLanguagePreferenceOrderUpdateCWProxyImpl(this._value);

  final ResponseLanguagePreferenceOrderUpdate _value;

  @override
  ResponseLanguagePreferenceOrderUpdate id(String? id) => call(id: id);

  @override
  ResponseLanguagePreferenceOrderUpdate preferenceOrder(int? preferenceOrder) =>
      call(preferenceOrder: preferenceOrder);

  @override
  ResponseLanguagePreferenceOrderUpdate idUser(String? idUser) =>
      call(idUser: idUser);

  @override
  ResponseLanguagePreferenceOrderUpdate idLanguage(String? idLanguage) =>
      call(idLanguage: idLanguage);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `ResponseLanguagePreferenceOrderUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ResponseLanguagePreferenceOrderUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ResponseLanguagePreferenceOrderUpdate call({
    Object? id = const $CopyWithPlaceholder(),
    Object? preferenceOrder = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idLanguage = const $CopyWithPlaceholder(),
  }) {
    return ResponseLanguagePreferenceOrderUpdate(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      preferenceOrder: preferenceOrder == const $CopyWithPlaceholder()
          ? _value.preferenceOrder
          // ignore: cast_nullable_to_non_nullable
          : preferenceOrder as int?,
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      idLanguage: idLanguage == const $CopyWithPlaceholder()
          ? _value.idLanguage
          // ignore: cast_nullable_to_non_nullable
          : idLanguage as String?,
    );
  }
}

extension $ResponseLanguagePreferenceOrderUpdateCopyWith
    on ResponseLanguagePreferenceOrderUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfResponseLanguagePreferenceOrderUpdate.copyWith(...)` or `instanceOfResponseLanguagePreferenceOrderUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResponseLanguagePreferenceOrderUpdateCWProxy get copyWith =>
      _$ResponseLanguagePreferenceOrderUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLanguagePreferenceOrderUpdate
_$ResponseLanguagePreferenceOrderUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ResponseLanguagePreferenceOrderUpdate',
      json,
      ($checkedConvert) {
        final val = ResponseLanguagePreferenceOrderUpdate(
          id: $checkedConvert('id', (v) => v as String?),
          preferenceOrder: $checkedConvert(
            'preference_order',
            (v) => (v as num?)?.toInt(),
          ),
          idUser: $checkedConvert('id_user', (v) => v as String?),
          idLanguage: $checkedConvert('id_language', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'preferenceOrder': 'preference_order',
        'idUser': 'id_user',
        'idLanguage': 'id_language',
      },
    );

Map<String, dynamic> _$ResponseLanguagePreferenceOrderUpdateToJson(
  ResponseLanguagePreferenceOrderUpdate instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'preference_order': ?instance.preferenceOrder,
  'id_user': ?instance.idUser,
  'id_language': ?instance.idLanguage,
};
