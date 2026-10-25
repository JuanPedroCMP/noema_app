// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_can_use_ia_model_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserApiKeyCanUseIaModelOutCWProxy {
  UserApiKeyCanUseIaModelOut id(String id);

  UserApiKeyCanUseIaModelOut idAiModel(String idAiModel);

  UserApiKeyCanUseIaModelOut idUserApiKey(String idUserApiKey);

  UserApiKeyCanUseIaModelOut createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyCanUseIaModelOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyCanUseIaModelOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserApiKeyCanUseIaModelOut call({
    String id,
    String idAiModel,
    String idUserApiKey,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserApiKeyCanUseIaModelOut.copyWith(...)` or call `instanceOfUserApiKeyCanUseIaModelOut.copyWith.fieldName(value)` for a single field.
class _$UserApiKeyCanUseIaModelOutCWProxyImpl
    implements _$UserApiKeyCanUseIaModelOutCWProxy {
  const _$UserApiKeyCanUseIaModelOutCWProxyImpl(this._value);

  final UserApiKeyCanUseIaModelOut _value;

  @override
  UserApiKeyCanUseIaModelOut id(String id) => call(id: id);

  @override
  UserApiKeyCanUseIaModelOut idAiModel(String idAiModel) =>
      call(idAiModel: idAiModel);

  @override
  UserApiKeyCanUseIaModelOut idUserApiKey(String idUserApiKey) =>
      call(idUserApiKey: idUserApiKey);

  @override
  UserApiKeyCanUseIaModelOut createdAt(DateTime? createdAt) =>
      call(createdAt: createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyCanUseIaModelOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyCanUseIaModelOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserApiKeyCanUseIaModelOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idAiModel = const $CopyWithPlaceholder(),
    Object? idUserApiKey = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return UserApiKeyCanUseIaModelOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idAiModel: idAiModel == const $CopyWithPlaceholder() || idAiModel == null
          ? _value.idAiModel
          // ignore: cast_nullable_to_non_nullable
          : idAiModel as String,
      idUserApiKey:
          idUserApiKey == const $CopyWithPlaceholder() || idUserApiKey == null
          ? _value.idUserApiKey
          // ignore: cast_nullable_to_non_nullable
          : idUserApiKey as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $UserApiKeyCanUseIaModelOutCopyWith on UserApiKeyCanUseIaModelOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserApiKeyCanUseIaModelOut.copyWith(...)` or `instanceOfUserApiKeyCanUseIaModelOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserApiKeyCanUseIaModelOutCWProxy get copyWith =>
      _$UserApiKeyCanUseIaModelOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiKeyCanUseIaModelOut _$UserApiKeyCanUseIaModelOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserApiKeyCanUseIaModelOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'id_ai_model',
        'id_user_api_key',
        'created_at',
      ],
    );
    final val = UserApiKeyCanUseIaModelOut(
      id: $checkedConvert('id', (v) => v as String),
      idAiModel: $checkedConvert('id_ai_model', (v) => v as String),
      idUserApiKey: $checkedConvert('id_user_api_key', (v) => v as String),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'idAiModel': 'id_ai_model',
    'idUserApiKey': 'id_user_api_key',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$UserApiKeyCanUseIaModelOutToJson(
  UserApiKeyCanUseIaModelOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_ai_model': instance.idAiModel,
  'id_user_api_key': instance.idUserApiKey,
  'created_at': instance.createdAt?.toIso8601String(),
};
