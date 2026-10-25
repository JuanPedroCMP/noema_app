//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/task_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AgentOut {
  /// Returns a new [AgentOut] instance.
  AgentOut({

    required  this.id,

    required  this.alias,

    required  this.task,

    required  this.baseSystemPrompt,

    required  this.temperature,

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
    
    name: r'alias',
    required: true,
    includeIfNull: false,
  )


  final String alias;



  @JsonKey(
    
    name: r'task',
    required: true,
    includeIfNull: false,
  )


  final TaskType task;



  @JsonKey(
    
    name: r'base_system_prompt',
    required: true,
    includeIfNull: false,
  )


  final String baseSystemPrompt;



  @JsonKey(
    
    name: r'temperature',
    required: true,
    includeIfNull: true,
  )


  final num? temperature;



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
    bool operator ==(Object other) => identical(this, other) || other is AgentOut &&
      other.id == id &&
      other.alias == alias &&
      other.task == task &&
      other.baseSystemPrompt == baseSystemPrompt &&
      other.temperature == temperature &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        alias.hashCode +
        task.hashCode +
        baseSystemPrompt.hashCode +
        (temperature == null ? 0 : temperature.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory AgentOut.fromJson(Map<String, dynamic> json) => _$AgentOutFromJson(json);

  Map<String, dynamic> toJson() => _$AgentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

