// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserApiKeyUpdateCWProxy {
  UserApiKeyUpdate idAiProvider(String? idAiProvider);

  UserApiKeyUpdate idUser(String? idUser);

  UserApiKeyUpdate name(String? name);

  UserApiKeyUpdate apiKey(String? apiKey);

  UserApiKeyUpdate isActive(bool? isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserApiKeyUpdate call({
    String? idAiProvider,
    String? idUser,
    String? name,
    String? apiKey,
    bool? isActive,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserApiKeyUpdate.copyWith(...)` or call `instanceOfUserApiKeyUpdate.copyWith.fieldName(value)` for a single field.
class _$UserApiKeyUpdateCWProxyImpl implements _$UserApiKeyUpdateCWProxy {
  const _$UserApiKeyUpdateCWProxyImpl(this._value);

  final UserApiKeyUpdate _value;

  @override
  UserApiKeyUpdate idAiProvider(String? idAiProvider) =>
      call(idAiProvider: idAiProvider);

  @override
  UserApiKeyUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  UserApiKeyUpdate name(String? name) => call(name: name);

  @override
  UserApiKeyUpdate apiKey(String? apiKey) => call(apiKey: apiKey);

  @override
  UserApiKeyUpdate isActive(bool? isActive) => call(isActive: isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserApiKeyUpdate call({
    Object? idAiProvider = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? apiKey = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return UserApiKeyUpdate(
      idAiProvider: idAiProvider == const $CopyWithPlaceholder()
          ? _value.idAiProvider
          // ignore: cast_nullable_to_non_nullable
          : idAiProvider as String?,
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      apiKey: apiKey == const $CopyWithPlaceholder()
          ? _value.apiKey
          // ignore: cast_nullable_to_non_nullable
          : apiKey as String?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $UserApiKeyUpdateCopyWith on UserApiKeyUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserApiKeyUpdate.copyWith(...)` or `instanceOfUserApiKeyUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserApiKeyUpdateCWProxy get copyWith => _$UserApiKeyUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiKeyUpdate _$UserApiKeyUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiKeyUpdate',
      json,
      ($checkedConvert) {
        final val = UserApiKeyUpdate(
          idAiProvider: $checkedConvert('id_ai_provider', (v) => v as String?),
          idUser: $checkedConvert('id_user', (v) => v as String?),
          name: $checkedConvert('name', (v) => v as String?),
          apiKey: $checkedConvert('api_key', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAiProvider': 'id_ai_provider',
        'idUser': 'id_user',
        'apiKey': 'api_key',
        'isActive': 'is_active',
      },
    );

Map<String, dynamic> _$UserApiKeyUpdateToJson(UserApiKeyUpdate instance) =>
    <String, dynamic>{
      'id_ai_provider': ?instance.idAiProvider,
      'id_user': ?instance.idUser,
      'name': ?instance.name,
      'api_key': ?instance.apiKey,
      'is_active': ?instance.isActive,
    };
