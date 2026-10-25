// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AgentModelOutCWProxy {
  AgentModelOut id(String id);

  AgentModelOut idAgent(String idAgent);

  AgentModelOut idAiModel(String idAiModel);

  AgentModelOut qualityExpected(AgentModelQuality qualityExpected);

  AgentModelOut customSystemPrompt(String customSystemPrompt);

  AgentModelOut customTemperature(num? customTemperature);

  AgentModelOut createdAt(DateTime? createdAt);

  AgentModelOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentModelOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentModelOut(...).copyWith(id: 12, name: "My name")
  /// ```
  AgentModelOut call({
    String id,
    String idAgent,
    String idAiModel,
    AgentModelQuality qualityExpected,
    String customSystemPrompt,
    num? customTemperature,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAgentModelOut.copyWith(...)` or call `instanceOfAgentModelOut.copyWith.fieldName(value)` for a single field.
class _$AgentModelOutCWProxyImpl implements _$AgentModelOutCWProxy {
  const _$AgentModelOutCWProxyImpl(this._value);

  final AgentModelOut _value;

  @override
  AgentModelOut id(String id) => call(id: id);

  @override
  AgentModelOut idAgent(String idAgent) => call(idAgent: idAgent);

  @override
  AgentModelOut idAiModel(String idAiModel) => call(idAiModel: idAiModel);

  @override
  AgentModelOut qualityExpected(AgentModelQuality qualityExpected) =>
      call(qualityExpected: qualityExpected);

  @override
  AgentModelOut customSystemPrompt(String customSystemPrompt) =>
      call(customSystemPrompt: customSystemPrompt);

  @override
  AgentModelOut customTemperature(num? customTemperature) =>
      call(customTemperature: customTemperature);

  @override
  AgentModelOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  AgentModelOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentModelOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentModelOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AgentModelOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idAgent = const $CopyWithPlaceholder(),
    Object? idAiModel = const $CopyWithPlaceholder(),
    Object? qualityExpected = const $CopyWithPlaceholder(),
    Object? customSystemPrompt = const $CopyWithPlaceholder(),
    Object? customTemperature = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return AgentModelOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idAgent: idAgent == const $CopyWithPlaceholder() || idAgent == null
          ? _value.idAgent
          // ignore: cast_nullable_to_non_nullable
          : idAgent as String,
      idAiModel: idAiModel == const $CopyWithPlaceholder() || idAiModel == null
          ? _value.idAiModel
          // ignore: cast_nullable_to_non_nullable
          : idAiModel as String,
      qualityExpected:
          qualityExpected == const $CopyWithPlaceholder() ||
              qualityExpected == null
          ? _value.qualityExpected
          // ignore: cast_nullable_to_non_nullable
          : qualityExpected as AgentModelQuality,
      customSystemPrompt:
          customSystemPrompt == const $CopyWithPlaceholder() ||
              customSystemPrompt == null
          ? _value.customSystemPrompt
          // ignore: cast_nullable_to_non_nullable
          : customSystemPrompt as String,
      customTemperature: customTemperature == const $CopyWithPlaceholder()
          ? _value.customTemperature
          // ignore: cast_nullable_to_non_nullable
          : customTemperature as num?,
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

extension $AgentModelOutCopyWith on AgentModelOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAgentModelOut.copyWith(...)` or `instanceOfAgentModelOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AgentModelOutCWProxy get copyWith => _$AgentModelOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentModelOut _$AgentModelOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AgentModelOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_agent',
            'id_ai_model',
            'quality_expected',
            'custom_system_prompt',
            'custom_temperature',
            'created_at',
            'updated_at',
          ],
        );
        final val = AgentModelOut(
          id: $checkedConvert('id', (v) => v as String),
          idAgent: $checkedConvert('id_agent', (v) => v as String),
          idAiModel: $checkedConvert('id_ai_model', (v) => v as String),
          qualityExpected: $checkedConvert(
            'quality_expected',
            (v) => $enumDecode(_$AgentModelQualityEnumMap, v),
          ),
          customSystemPrompt: $checkedConvert(
            'custom_system_prompt',
            (v) => v as String,
          ),
          customTemperature: $checkedConvert(
            'custom_temperature',
            (v) => v as num?,
          ),
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
        'idAgent': 'id_agent',
        'idAiModel': 'id_ai_model',
        'qualityExpected': 'quality_expected',
        'customSystemPrompt': 'custom_system_prompt',
        'customTemperature': 'custom_temperature',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$AgentModelOutToJson(AgentModelOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_agent': instance.idAgent,
      'id_ai_model': instance.idAiModel,
      'quality_expected': _$AgentModelQualityEnumMap[instance.qualityExpected]!,
      'custom_system_prompt': instance.customSystemPrompt,
      'custom_temperature': instance.customTemperature,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$AgentModelQualityEnumMap = {
  AgentModelQuality.unusable: 'unusable',
  AgentModelQuality.poor: 'poor',
  AgentModelQuality.fair: 'fair',
  AgentModelQuality.good: 'good',
  AgentModelQuality.veryGood: 'very_good',
  AgentModelQuality.excellent: 'excellent',
};
