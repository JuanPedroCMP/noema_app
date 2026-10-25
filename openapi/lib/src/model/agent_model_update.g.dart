// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AgentModelUpdateCWProxy {
  AgentModelUpdate idAgent(String? idAgent);

  AgentModelUpdate idAiModel(String? idAiModel);

  AgentModelUpdate qualityExpected(AgentModelQuality? qualityExpected);

  AgentModelUpdate customSystemPrompt(String? customSystemPrompt);

  AgentModelUpdate customTemperature(num? customTemperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentModelUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentModelUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  AgentModelUpdate call({
    String? idAgent,
    String? idAiModel,
    AgentModelQuality? qualityExpected,
    String? customSystemPrompt,
    num? customTemperature,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAgentModelUpdate.copyWith(...)` or call `instanceOfAgentModelUpdate.copyWith.fieldName(value)` for a single field.
class _$AgentModelUpdateCWProxyImpl implements _$AgentModelUpdateCWProxy {
  const _$AgentModelUpdateCWProxyImpl(this._value);

  final AgentModelUpdate _value;

  @override
  AgentModelUpdate idAgent(String? idAgent) => call(idAgent: idAgent);

  @override
  AgentModelUpdate idAiModel(String? idAiModel) => call(idAiModel: idAiModel);

  @override
  AgentModelUpdate qualityExpected(AgentModelQuality? qualityExpected) =>
      call(qualityExpected: qualityExpected);

  @override
  AgentModelUpdate customSystemPrompt(String? customSystemPrompt) =>
      call(customSystemPrompt: customSystemPrompt);

  @override
  AgentModelUpdate customTemperature(num? customTemperature) =>
      call(customTemperature: customTemperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentModelUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentModelUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AgentModelUpdate call({
    Object? idAgent = const $CopyWithPlaceholder(),
    Object? idAiModel = const $CopyWithPlaceholder(),
    Object? qualityExpected = const $CopyWithPlaceholder(),
    Object? customSystemPrompt = const $CopyWithPlaceholder(),
    Object? customTemperature = const $CopyWithPlaceholder(),
  }) {
    return AgentModelUpdate(
      idAgent: idAgent == const $CopyWithPlaceholder()
          ? _value.idAgent
          // ignore: cast_nullable_to_non_nullable
          : idAgent as String?,
      idAiModel: idAiModel == const $CopyWithPlaceholder()
          ? _value.idAiModel
          // ignore: cast_nullable_to_non_nullable
          : idAiModel as String?,
      qualityExpected: qualityExpected == const $CopyWithPlaceholder()
          ? _value.qualityExpected
          // ignore: cast_nullable_to_non_nullable
          : qualityExpected as AgentModelQuality?,
      customSystemPrompt: customSystemPrompt == const $CopyWithPlaceholder()
          ? _value.customSystemPrompt
          // ignore: cast_nullable_to_non_nullable
          : customSystemPrompt as String?,
      customTemperature: customTemperature == const $CopyWithPlaceholder()
          ? _value.customTemperature
          // ignore: cast_nullable_to_non_nullable
          : customTemperature as num?,
    );
  }
}

extension $AgentModelUpdateCopyWith on AgentModelUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAgentModelUpdate.copyWith(...)` or `instanceOfAgentModelUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AgentModelUpdateCWProxy get copyWith => _$AgentModelUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentModelUpdate _$AgentModelUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AgentModelUpdate',
      json,
      ($checkedConvert) {
        final val = AgentModelUpdate(
          idAgent: $checkedConvert('id_agent', (v) => v as String?),
          idAiModel: $checkedConvert('id_ai_model', (v) => v as String?),
          qualityExpected: $checkedConvert(
            'quality_expected',
            (v) => $enumDecodeNullable(_$AgentModelQualityEnumMap, v),
          ),
          customSystemPrompt: $checkedConvert(
            'custom_system_prompt',
            (v) => v as String?,
          ),
          customTemperature: $checkedConvert(
            'custom_temperature',
            (v) => v as num?,
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
      },
    );

Map<String, dynamic> _$AgentModelUpdateToJson(AgentModelUpdate instance) =>
    <String, dynamic>{
      'id_agent': ?instance.idAgent,
      'id_ai_model': ?instance.idAiModel,
      'quality_expected': ?_$AgentModelQualityEnumMap[instance.qualityExpected],
      'custom_system_prompt': ?instance.customSystemPrompt,
      'custom_temperature': ?instance.customTemperature,
    };

const _$AgentModelQualityEnumMap = {
  AgentModelQuality.unusable: 'unusable',
  AgentModelQuality.poor: 'poor',
  AgentModelQuality.fair: 'fair',
  AgentModelQuality.good: 'good',
  AgentModelQuality.veryGood: 'very_good',
  AgentModelQuality.excellent: 'excellent',
};
