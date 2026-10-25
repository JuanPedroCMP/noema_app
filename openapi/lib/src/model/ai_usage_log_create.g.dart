// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage_log_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AiUsageLogCreateCWProxy {
  AiUsageLogCreate idUser(String idUser);

  AiUsageLogCreate idAgentModel(String idAgentModel);

  AiUsageLogCreate usageDetails(Map<String, Object> usageDetails);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiUsageLogCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiUsageLogCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  AiUsageLogCreate call({
    String idUser,
    String idAgentModel,
    Map<String, Object> usageDetails,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAiUsageLogCreate.copyWith(...)` or call `instanceOfAiUsageLogCreate.copyWith.fieldName(value)` for a single field.
class _$AiUsageLogCreateCWProxyImpl implements _$AiUsageLogCreateCWProxy {
  const _$AiUsageLogCreateCWProxyImpl(this._value);

  final AiUsageLogCreate _value;

  @override
  AiUsageLogCreate idUser(String idUser) => call(idUser: idUser);

  @override
  AiUsageLogCreate idAgentModel(String idAgentModel) =>
      call(idAgentModel: idAgentModel);

  @override
  AiUsageLogCreate usageDetails(Map<String, Object> usageDetails) =>
      call(usageDetails: usageDetails);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiUsageLogCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiUsageLogCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AiUsageLogCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idAgentModel = const $CopyWithPlaceholder(),
    Object? usageDetails = const $CopyWithPlaceholder(),
  }) {
    return AiUsageLogCreate(
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      idAgentModel:
          idAgentModel == const $CopyWithPlaceholder() || idAgentModel == null
          ? _value.idAgentModel
          // ignore: cast_nullable_to_non_nullable
          : idAgentModel as String,
      usageDetails:
          usageDetails == const $CopyWithPlaceholder() || usageDetails == null
          ? _value.usageDetails
          // ignore: cast_nullable_to_non_nullable
          : usageDetails as Map<String, Object>,
    );
  }
}

extension $AiUsageLogCreateCopyWith on AiUsageLogCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAiUsageLogCreate.copyWith(...)` or `instanceOfAiUsageLogCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AiUsageLogCreateCWProxy get copyWith => _$AiUsageLogCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiUsageLogCreate _$AiUsageLogCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AiUsageLogCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id_user', 'id_agent_model', 'usage_details'],
        );
        final val = AiUsageLogCreate(
          idUser: $checkedConvert('id_user', (v) => v as String),
          idAgentModel: $checkedConvert('id_agent_model', (v) => v as String),
          usageDetails: $checkedConvert(
            'usage_details',
            (v) => (v as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, e as Object),
            ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'idUser': 'id_user',
        'idAgentModel': 'id_agent_model',
        'usageDetails': 'usage_details',
      },
    );

Map<String, dynamic> _$AiUsageLogCreateToJson(AiUsageLogCreate instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'id_agent_model': instance.idAgentModel,
      'usage_details': instance.usageDetails,
    };
