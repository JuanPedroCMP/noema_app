// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_log_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GenericLogOutCWProxy {
  GenericLogOut id(String id);

  GenericLogOut type(String type);

  GenericLogOut idUser(String? idUser);

  GenericLogOut details(Object? details);

  GenericLogOut createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GenericLogOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GenericLogOut(...).copyWith(id: 12, name: "My name")
  /// ```
  GenericLogOut call({
    String id,
    String type,
    String? idUser,
    Object? details,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGenericLogOut.copyWith(...)` or call `instanceOfGenericLogOut.copyWith.fieldName(value)` for a single field.
class _$GenericLogOutCWProxyImpl implements _$GenericLogOutCWProxy {
  const _$GenericLogOutCWProxyImpl(this._value);

  final GenericLogOut _value;

  @override
  GenericLogOut id(String id) => call(id: id);

  @override
  GenericLogOut type(String type) => call(type: type);

  @override
  GenericLogOut idUser(String? idUser) => call(idUser: idUser);

  @override
  GenericLogOut details(Object? details) => call(details: details);

  @override
  GenericLogOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GenericLogOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GenericLogOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  GenericLogOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? details = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return GenericLogOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      details: details == const $CopyWithPlaceholder()
          ? _value.details
          // ignore: cast_nullable_to_non_nullable
          : details as Object?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $GenericLogOutCopyWith on GenericLogOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGenericLogOut.copyWith(...)` or `instanceOfGenericLogOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GenericLogOutCWProxy get copyWith => _$GenericLogOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericLogOut _$GenericLogOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GenericLogOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'type', 'id_user', 'details', 'created_at'],
      );
      final val = GenericLogOut(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
        idUser: $checkedConvert('id_user', (v) => v as String?),
        details: $checkedConvert('details', (v) => v),
        createdAt: $checkedConvert(
          'created_at',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    }, fieldKeyMap: const {'idUser': 'id_user', 'createdAt': 'created_at'});

Map<String, dynamic> _$GenericLogOutToJson(GenericLogOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'id_user': instance.idUser,
      'details': instance.details,
      'created_at': instance.createdAt?.toIso8601String(),
    };
