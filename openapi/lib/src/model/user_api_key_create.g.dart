// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserApiKeyCreateCWProxy {
  UserApiKeyCreate idAiProvider(String idAiProvider);

  UserApiKeyCreate name(String name);

  UserApiKeyCreate apiKey(String apiKey);

  UserApiKeyCreate isActive(bool? isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserApiKeyCreate call({
    String idAiProvider,
    String name,
    String apiKey,
    bool? isActive,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserApiKeyCreate.copyWith(...)` or call `instanceOfUserApiKeyCreate.copyWith.fieldName(value)` for a single field.
class _$UserApiKeyCreateCWProxyImpl implements _$UserApiKeyCreateCWProxy {
  const _$UserApiKeyCreateCWProxyImpl(this._value);

  final UserApiKeyCreate _value;

  @override
  UserApiKeyCreate idAiProvider(String idAiProvider) =>
      call(idAiProvider: idAiProvider);

  @override
  UserApiKeyCreate name(String name) => call(name: name);

  @override
  UserApiKeyCreate apiKey(String apiKey) => call(apiKey: apiKey);

  @override
  UserApiKeyCreate isActive(bool? isActive) => call(isActive: isActive);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserApiKeyCreate call({
    Object? idAiProvider = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? apiKey = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return UserApiKeyCreate(
      idAiProvider:
          idAiProvider == const $CopyWithPlaceholder() || idAiProvider == null
          ? _value.idAiProvider
          // ignore: cast_nullable_to_non_nullable
          : idAiProvider as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      apiKey: apiKey == const $CopyWithPlaceholder() || apiKey == null
          ? _value.apiKey
          // ignore: cast_nullable_to_non_nullable
          : apiKey as String,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $UserApiKeyCreateCopyWith on UserApiKeyCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserApiKeyCreate.copyWith(...)` or `instanceOfUserApiKeyCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserApiKeyCreateCWProxy get copyWith => _$UserApiKeyCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiKeyCreate _$UserApiKeyCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiKeyCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id_ai_provider', 'name', 'api_key'],
        );
        final val = UserApiKeyCreate(
          idAiProvider: $checkedConvert('id_ai_provider', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          apiKey: $checkedConvert('api_key', (v) => v as String),
          isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAiProvider': 'id_ai_provider',
        'apiKey': 'api_key',
        'isActive': 'is_active',
      },
    );

Map<String, dynamic> _$UserApiKeyCreateToJson(UserApiKeyCreate instance) =>
    <String, dynamic>{
      'id_ai_provider': instance.idAiProvider,
      'name': instance.name,
      'api_key': instance.apiKey,
      'is_active': ?instance.isActive,
    };
