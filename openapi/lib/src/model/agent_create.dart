//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/task_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AgentCreate {
  /// Returns a new [AgentCreate] instance.
  AgentCreate({

    required  this.alias,

    required  this.task,

    required  this.baseSystemPrompt,

    required  this.temperature,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is AgentCreate &&
      other.alias == alias &&
      other.task == task &&
      other.baseSystemPrompt == baseSystemPrompt &&
      other.temperature == temperature;

    @override
    int get hashCode =>
        alias.hashCode +
        task.hashCode +
        baseSystemPrompt.hashCode +
        (temperature == null ? 0 : temperature.hashCode);

  factory AgentCreate.fromJson(Map<String, dynamic> json) => _$AgentCreateFromJson(json);

  Map<String, dynamic> toJson() => _$AgentCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

