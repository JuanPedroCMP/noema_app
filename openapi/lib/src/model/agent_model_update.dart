//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/agent_model_quality.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_model_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AgentModelUpdate {
  /// Returns a new [AgentModelUpdate] instance.
  AgentModelUpdate({

     this.idAgent,

     this.idAiModel,

     this.qualityExpected,

     this.customSystemPrompt,

     this.customTemperature,
  });

  @JsonKey(
    
    name: r'id_agent',
    required: false,
    includeIfNull: false,
  )


  final String? idAgent;



  @JsonKey(
    
    name: r'id_ai_model',
    required: false,
    includeIfNull: false,
  )


  final String? idAiModel;



  @JsonKey(
    
    name: r'quality_expected',
    required: false,
    includeIfNull: false,
  )


  final AgentModelQuality? qualityExpected;



  @JsonKey(
    
    name: r'custom_system_prompt',
    required: false,
    includeIfNull: false,
  )


  final String? customSystemPrompt;



  @JsonKey(
    
    name: r'custom_temperature',
    required: false,
    includeIfNull: false,
  )


  final num? customTemperature;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AgentModelUpdate &&
      other.idAgent == idAgent &&
      other.idAiModel == idAiModel &&
      other.qualityExpected == qualityExpected &&
      other.customSystemPrompt == customSystemPrompt &&
      other.customTemperature == customTemperature;

    @override
    int get hashCode =>
        (idAgent == null ? 0 : idAgent.hashCode) +
        (idAiModel == null ? 0 : idAiModel.hashCode) +
        (qualityExpected == null ? 0 : qualityExpected.hashCode) +
        (customSystemPrompt == null ? 0 : customSystemPrompt.hashCode) +
        (customTemperature == null ? 0 : customTemperature.hashCode);

  factory AgentModelUpdate.fromJson(Map<String, dynamic> json) => _$AgentModelUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$AgentModelUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

