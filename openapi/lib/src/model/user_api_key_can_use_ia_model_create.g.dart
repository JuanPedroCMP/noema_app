// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_key_can_use_ia_model_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserApiKeyCanUseIaModelCreateCWProxy {
  UserApiKeyCanUseIaModelCreate idAiModel(String idAiModel);

  UserApiKeyCanUseIaModelCreate idUserApiKey(String idUserApiKey);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyCanUseIaModelCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyCanUseIaModelCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserApiKeyCanUseIaModelCreate call({String idAiModel, String idUserApiKey});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserApiKeyCanUseIaModelCreate.copyWith(...)` or call `instanceOfUserApiKeyCanUseIaModelCreate.copyWith.fieldName(value)` for a single field.
class _$UserApiKeyCanUseIaModelCreateCWProxyImpl
    implements _$UserApiKeyCanUseIaModelCreateCWProxy {
  const _$UserApiKeyCanUseIaModelCreateCWProxyImpl(this._value);

  final UserApiKeyCanUseIaModelCreate _value;

  @override
  UserApiKeyCanUseIaModelCreate idAiModel(String idAiModel) =>
      call(idAiModel: idAiModel);

  @override
  UserApiKeyCanUseIaModelCreate idUserApiKey(String idUserApiKey) =>
      call(idUserApiKey: idUserApiKey);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserApiKeyCanUseIaModelCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserApiKeyCanUseIaModelCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserApiKeyCanUseIaModelCreate call({
    Object? idAiModel = const $CopyWithPlaceholder(),
    Object? idUserApiKey = const $CopyWithPlaceholder(),
  }) {
    return UserApiKeyCanUseIaModelCreate(
      idAiModel: idAiModel == const $CopyWithPlaceholder() || idAiModel == null
          ? _value.idAiModel
          // ignore: cast_nullable_to_non_nullable
          : idAiModel as String,
      idUserApiKey:
          idUserApiKey == const $CopyWithPlaceholder() || idUserApiKey == null
          ? _value.idUserApiKey
          // ignore: cast_nullable_to_non_nullable
          : idUserApiKey as String,
    );
  }
}

extension $UserApiKeyCanUseIaModelCreateCopyWith
    on UserApiKeyCanUseIaModelCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserApiKeyCanUseIaModelCreate.copyWith(...)` or `instanceOfUserApiKeyCanUseIaModelCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserApiKeyCanUseIaModelCreateCWProxy get copyWith =>
      _$UserApiKeyCanUseIaModelCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiKeyCanUseIaModelCreate _$UserApiKeyCanUseIaModelCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UserApiKeyCanUseIaModelCreate',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['id_ai_model', 'id_user_api_key']);
    final val = UserApiKeyCanUseIaModelCreate(
      idAiModel: $checkedConvert('id_ai_model', (v) => v as String),
      idUserApiKey: $checkedConvert('id_user_api_key', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'idAiModel': 'id_ai_model',
    'idUserApiKey': 'id_user_api_key',
  },
);

Map<String, dynamic> _$UserApiKeyCanUseIaModelCreateToJson(
  UserApiKeyCanUseIaModelCreate instance,
) => <String, dynamic>{
  'id_ai_model': instance.idAiModel,
  'id_user_api_key': instance.idUserApiKey,
};
