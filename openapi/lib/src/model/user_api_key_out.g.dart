// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserApiKeyOutCWProxy {
  UserApiKeyOut id(String id);

  UserApiKeyOut idAiProvider(String idAiProvider);

  UserApiKeyOut idUser(String idUser);

  UserApiKeyOut name(String name);

  UserApiKeyOut isActive(bool isActive);

  UserApiKeyOut createdAt(DateTime? createdAt);

  UserApiKeyOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserApiKeyOut call({
    String id,
    String idAiProvider,
    String idUser,
    String name,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserApiKeyOut.copyWith(...)` or call `instanceOfUserApiKeyOut.copyWith.fieldName(value)` for a single field.
class _$UserApiKeyOutCWProxyImpl implements _$UserApiKeyOutCWProxy {
  const _$UserApiKeyOutCWProxyImpl(this._value);

  final UserApiKeyOut _value;

  @override
  UserApiKeyOut id(String id) => call(id: id);

  @override
  UserApiKeyOut idAiProvider(String idAiProvider) =>
      call(idAiProvider: idAiProvider);

  @override
  UserApiKeyOut idUser(String idUser) => call(idUser: idUser);

  @override
  UserApiKeyOut name(String name) => call(name: name);

  @override
  UserApiKeyOut isActive(bool isActive) => call(isActive: isActive);

  @override
  UserApiKeyOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  UserApiKeyOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserApiKeyOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idAiProvider = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return UserApiKeyOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idAiProvider:
          idAiProvider == const $CopyWithPlaceholder() || idAiProvider == null
          ? _value.idAiProvider
          // ignore: cast_nullable_to_non_nullable
          : idAiProvider as String,
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      isActive: isActive == const $CopyWithPlaceholder() || isActive == null
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
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

extension $UserApiKeyOutCopyWith on UserApiKeyOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserApiKeyOut.copyWith(...)` or `instanceOfUserApiKeyOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserApiKeyOutCWProxy get copyWith => _$UserApiKeyOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiKeyOut _$UserApiKeyOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiKeyOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_ai_provider',
            'id_user',
            'name',
            'is_active',
            'created_at',
            'updated_at',
          ],
        );
        final val = UserApiKeyOut(
          id: $checkedConvert('id', (v) => v as String),
          idAiProvider: $checkedConvert('id_ai_provider', (v) => v as String),
          idUser: $checkedConvert('id_user', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          isActive: $checkedConvert('is_active', (v) => v as bool),
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
        'idAiProvider': 'id_ai_provider',
        'idUser': 'id_user',
        'isActive': 'is_active',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$UserApiKeyOutToJson(UserApiKeyOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_ai_provider': instance.idAiProvider,
      'id_user': instance.idUser,
      'name': instance.name,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
