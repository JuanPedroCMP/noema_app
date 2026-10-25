// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AgentModelCreateCWProxy {
  AgentModelCreate idAgent(String idAgent);

  AgentModelCreate idAiModel(String idAiModel);

  AgentModelCreate qualityExpected(AgentModelQuality qualityExpected);

  AgentModelCreate customSystemPrompt(String customSystemPrompt);

  AgentModelCreate temperature(num? temperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentModelCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentModelCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  AgentModelCreate call({
    String idAgent,
    String idAiModel,
    AgentModelQuality qualityExpected,
    String customSystemPrompt,
    num? temperature,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAgentModelCreate.copyWith(...)` or call `instanceOfAgentModelCreate.copyWith.fieldName(value)` for a single field.
class _$AgentModelCreateCWProxyImpl implements _$AgentModelCreateCWProxy {
  const _$AgentModelCreateCWProxyImpl(this._value);

  final AgentModelCreate _value;

  @override
  AgentModelCreate idAgent(String idAgent) => call(idAgent: idAgent);

  @override
  AgentModelCreate idAiModel(String idAiModel) => call(idAiModel: idAiModel);

  @override
  AgentModelCreate qualityExpected(AgentModelQuality qualityExpected) =>
      call(qualityExpected: qualityExpected);

  @override
  AgentModelCreate customSystemPrompt(String customSystemPrompt) =>
      call(customSystemPrompt: customSystemPrompt);

  @override
  AgentModelCreate temperature(num? temperature) =>
      call(temperature: temperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentModelCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentModelCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AgentModelCreate call({
    Object? idAgent = const $CopyWithPlaceholder(),
    Object? idAiModel = const $CopyWithPlaceholder(),
    Object? qualityExpected = const $CopyWithPlaceholder(),
    Object? customSystemPrompt = const $CopyWithPlaceholder(),
    Object? temperature = const $CopyWithPlaceholder(),
  }) {
    return AgentModelCreate(
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
      temperature: temperature == const $CopyWithPlaceholder()
          ? _value.temperature
          // ignore: cast_nullable_to_non_nullable
          : temperature as num?,
    );
  }
}

extension $AgentModelCreateCopyWith on AgentModelCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAgentModelCreate.copyWith(...)` or `instanceOfAgentModelCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AgentModelCreateCWProxy get copyWith => _$AgentModelCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentModelCreate _$AgentModelCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AgentModelCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id_agent',
            'id_ai_model',
            'quality_expected',
            'custom_system_prompt',
            'temperature',
          ],
        );
        final val = AgentModelCreate(
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
          temperature: $checkedConvert('temperature', (v) => v as num?),
        );
        return val;
      },
      fieldKeyMap: const {
        'idAgent': 'id_agent',
        'idAiModel': 'id_ai_model',
        'qualityExpected': 'quality_expected',
        'customSystemPrompt': 'custom_system_prompt',
      },
    );

Map<String, dynamic> _$AgentModelCreateToJson(AgentModelCreate instance) =>
    <String, dynamic>{
      'id_agent': instance.idAgent,
      'id_ai_model': instance.idAiModel,
      'quality_expected': _$AgentModelQualityEnumMap[instance.qualityExpected]!,
      'custom_system_prompt': instance.customSystemPrompt,
      'temperature': instance.temperature,
    };

const _$AgentModelQualityEnumMap = {
  AgentModelQuality.unusable: 'unusable',
  AgentModelQuality.poor: 'poor',
  AgentModelQuality.fair: 'fair',
  AgentModelQuality.good: 'good',
  AgentModelQuality.veryGood: 'very_good',
  AgentModelQuality.excellent: 'excellent',
};
