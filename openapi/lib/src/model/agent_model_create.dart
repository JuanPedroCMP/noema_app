//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/agent_model_quality.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_model_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AgentModelCreate {
  /// Returns a new [AgentModelCreate] instance.
  AgentModelCreate({

    required  this.idAgent,

    required  this.idAiModel,

    required  this.qualityExpected,

    required  this.customSystemPrompt,

    required  this.temperature,
  });

  @JsonKey(
    
    name: r'id_agent',
    required: true,
    includeIfNull: false,
  )


  final String idAgent;



  @JsonKey(
    
    name: r'id_ai_model',
    required: true,
    includeIfNull: false,
  )


  final String idAiModel;



  @JsonKey(
    
    name: r'quality_expected',
    required: true,
    includeIfNull: false,
  )


  final AgentModelQuality qualityExpected;



  @JsonKey(
    
    name: r'custom_system_prompt',
    required: true,
    includeIfNull: false,
  )


  final String customSystemPrompt;



  @JsonKey(
    
    name: r'temperature',
    required: true,
    includeIfNull: true,
  )


  final num? temperature;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AgentModelCreate &&
      other.idAgent == idAgent &&
      other.idAiModel == idAiModel &&
      other.qualityExpected == qualityExpected &&
      other.customSystemPrompt == customSystemPrompt &&
      other.temperature == temperature;

    @override
    int get hashCode =>
        idAgent.hashCode +
        idAiModel.hashCode +
        qualityExpected.hashCode +
        customSystemPrompt.hashCode +
        (temperature == null ? 0 : temperature.hashCode);

  factory AgentModelCreate.fromJson(Map<String, dynamic> json) => _$AgentModelCreateFromJson(json);

  Map<String, dynamic> toJson() => _$AgentModelCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

