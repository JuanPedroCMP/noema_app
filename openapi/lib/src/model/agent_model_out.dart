//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/agent_model_quality.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_model_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AgentModelOut {
  /// Returns a new [AgentModelOut] instance.
  AgentModelOut({

    required  this.id,

    required  this.idAgent,

    required  this.idAiModel,

    required  this.qualityExpected,

    required  this.customSystemPrompt,

    required  this.customTemperature,

    required  this.createdAt,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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
    
    name: r'custom_temperature',
    required: true,
    includeIfNull: true,
  )


  final num? customTemperature;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;



  @JsonKey(
    
    name: r'updated_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AgentModelOut &&
      other.id == id &&
      other.idAgent == idAgent &&
      other.idAiModel == idAiModel &&
      other.qualityExpected == qualityExpected &&
      other.customSystemPrompt == customSystemPrompt &&
      other.customTemperature == customTemperature &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idAgent.hashCode +
        idAiModel.hashCode +
        qualityExpected.hashCode +
        customSystemPrompt.hashCode +
        (customTemperature == null ? 0 : customTemperature.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory AgentModelOut.fromJson(Map<String, dynamic> json) => _$AgentModelOutFromJson(json);

  Map<String, dynamic> toJson() => _$AgentModelOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

