// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage_log_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AiUsageLogOutCWProxy {
  AiUsageLogOut id(String id);

  AiUsageLogOut idUser(String idUser);

  AiUsageLogOut idAgentModel(String idAgentModel);

  AiUsageLogOut usageDetails(Map<String, Object> usageDetails);

  AiUsageLogOut createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiUsageLogOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiUsageLogOut(...).copyWith(id: 12, name: "My name")
  /// ```
  AiUsageLogOut call({
    String id,
    String idUser,
    String idAgentModel,
    Map<String, Object> usageDetails,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAiUsageLogOut.copyWith(...)` or call `instanceOfAiUsageLogOut.copyWith.fieldName(value)` for a single field.
class _$AiUsageLogOutCWProxyImpl implements _$AiUsageLogOutCWProxy {
  const _$AiUsageLogOutCWProxyImpl(this._value);

  final AiUsageLogOut _value;

  @override
  AiUsageLogOut id(String id) => call(id: id);

  @override
  AiUsageLogOut idUser(String idUser) => call(idUser: idUser);

  @override
  AiUsageLogOut idAgentModel(String idAgentModel) =>
      call(idAgentModel: idAgentModel);

  @override
  AiUsageLogOut usageDetails(Map<String, Object> usageDetails) =>
      call(usageDetails: usageDetails);

  @override
  AiUsageLogOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AiUsageLogOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AiUsageLogOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AiUsageLogOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? idAgentModel = const $CopyWithPlaceholder(),
    Object? usageDetails = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AiUsageLogOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $AiUsageLogOutCopyWith on AiUsageLogOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAiUsageLogOut.copyWith(...)` or `instanceOfAiUsageLogOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AiUsageLogOutCWProxy get copyWith => _$AiUsageLogOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiUsageLogOut _$AiUsageLogOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AiUsageLogOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_user',
            'id_agent_model',
            'usage_details',
            'created_at',
          ],
        );
        final val = AiUsageLogOut(
          id: $checkedConvert('id', (v) => v as String),
          idUser: $checkedConvert('id_user', (v) => v as String),
          idAgentModel: $checkedConvert('id_agent_model', (v) => v as String),
          usageDetails: $checkedConvert(
            'usage_details',
            (v) => (v as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, e as Object),
            ),
          ),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'idUser': 'id_user',
        'idAgentModel': 'id_agent_model',
        'usageDetails': 'usage_details',
        'createdAt': 'created_at',
      },
    );

Map<String, dynamic> _$AiUsageLogOutToJson(AiUsageLogOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'id_agent_model': instance.idAgentModel,
      'usage_details': instance.usageDetails,
      'created_at': instance.createdAt?.toIso8601String(),
    };
