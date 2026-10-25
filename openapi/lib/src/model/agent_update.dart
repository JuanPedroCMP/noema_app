//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/task_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AgentUpdate {
  /// Returns a new [AgentUpdate] instance.
  AgentUpdate({

     this.alias,

     this.task,

     this.baseSystemPrompt,

     this.temperature,
  });

  @JsonKey(
    
    name: r'alias',
    required: false,
    includeIfNull: false,
  )


  final String? alias;



  @JsonKey(
    
    name: r'task',
    required: false,
    includeIfNull: false,
  )


  final TaskType? task;



  @JsonKey(
    
    name: r'base_system_prompt',
    required: false,
    includeIfNull: false,
  )


  final String? baseSystemPrompt;



  @JsonKey(
    
    name: r'temperature',
    required: false,
    includeIfNull: false,
  )


  final num? temperature;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AgentUpdate &&
      other.alias == alias &&
      other.task == task &&
      other.baseSystemPrompt == baseSystemPrompt &&
      other.temperature == temperature;

    @override
    int get hashCode =>
        (alias == null ? 0 : alias.hashCode) +
        (task == null ? 0 : task.hashCode) +
        (baseSystemPrompt == null ? 0 : baseSystemPrompt.hashCode) +
        (temperature == null ? 0 : temperature.hashCode);

  factory AgentUpdate.fromJson(Map<String, dynamic> json) => _$AgentUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$AgentUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

