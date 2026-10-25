// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_log_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GenericLogCreateCWProxy {
  GenericLogCreate idUser(String? idUser);

  GenericLogCreate type(String type);

  GenericLogCreate details(String details);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GenericLogCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GenericLogCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  GenericLogCreate call({String? idUser, String type, String details});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGenericLogCreate.copyWith(...)` or call `instanceOfGenericLogCreate.copyWith.fieldName(value)` for a single field.
class _$GenericLogCreateCWProxyImpl implements _$GenericLogCreateCWProxy {
  const _$GenericLogCreateCWProxyImpl(this._value);

  final GenericLogCreate _value;

  @override
  GenericLogCreate idUser(String? idUser) => call(idUser: idUser);

  @override
  GenericLogCreate type(String type) => call(type: type);

  @override
  GenericLogCreate details(String details) => call(details: details);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GenericLogCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GenericLogCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  GenericLogCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? details = const $CopyWithPlaceholder(),
  }) {
    return GenericLogCreate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      details: details == const $CopyWithPlaceholder() || details == null
          ? _value.details
          // ignore: cast_nullable_to_non_nullable
          : details as String,
    );
  }
}

extension $GenericLogCreateCopyWith on GenericLogCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGenericLogCreate.copyWith(...)` or `instanceOfGenericLogCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GenericLogCreateCWProxy get copyWith => _$GenericLogCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericLogCreate _$GenericLogCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GenericLogCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id_user', 'type', 'details']);
      final val = GenericLogCreate(
        idUser: $checkedConvert('id_user', (v) => v as String?),
        type: $checkedConvert('type', (v) => v as String),
        details: $checkedConvert('details', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'idUser': 'id_user'});

Map<String, dynamic> _$GenericLogCreateToJson(GenericLogCreate instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'type': instance.type,
      'details': instance.details,
    };
