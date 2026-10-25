// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AgentUpdateCWProxy {
  AgentUpdate alias(String? alias);

  AgentUpdate task(TaskType? task);

  AgentUpdate baseSystemPrompt(String? baseSystemPrompt);

  AgentUpdate temperature(num? temperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  AgentUpdate call({
    String? alias,
    TaskType? task,
    String? baseSystemPrompt,
    num? temperature,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAgentUpdate.copyWith(...)` or call `instanceOfAgentUpdate.copyWith.fieldName(value)` for a single field.
class _$AgentUpdateCWProxyImpl implements _$AgentUpdateCWProxy {
  const _$AgentUpdateCWProxyImpl(this._value);

  final AgentUpdate _value;

  @override
  AgentUpdate alias(String? alias) => call(alias: alias);

  @override
  AgentUpdate task(TaskType? task) => call(task: task);

  @override
  AgentUpdate baseSystemPrompt(String? baseSystemPrompt) =>
      call(baseSystemPrompt: baseSystemPrompt);

  @override
  AgentUpdate temperature(num? temperature) => call(temperature: temperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AgentUpdate call({
    Object? alias = const $CopyWithPlaceholder(),
    Object? task = const $CopyWithPlaceholder(),
    Object? baseSystemPrompt = const $CopyWithPlaceholder(),
    Object? temperature = const $CopyWithPlaceholder(),
  }) {
    return AgentUpdate(
      alias: alias == const $CopyWithPlaceholder()
          ? _value.alias
          // ignore: cast_nullable_to_non_nullable
          : alias as String?,
      task: task == const $CopyWithPlaceholder()
          ? _value.task
          // ignore: cast_nullable_to_non_nullable
          : task as TaskType?,
      baseSystemPrompt: baseSystemPrompt == const $CopyWithPlaceholder()
          ? _value.baseSystemPrompt
          // ignore: cast_nullable_to_non_nullable
          : baseSystemPrompt as String?,
      temperature: temperature == const $CopyWithPlaceholder()
          ? _value.temperature
          // ignore: cast_nullable_to_non_nullable
          : temperature as num?,
    );
  }
}

extension $AgentUpdateCopyWith on AgentUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAgentUpdate.copyWith(...)` or `instanceOfAgentUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AgentUpdateCWProxy get copyWith => _$AgentUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentUpdate _$AgentUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AgentUpdate', json, ($checkedConvert) {
      final val = AgentUpdate(
        alias: $checkedConvert('alias', (v) => v as String?),
        task: $checkedConvert(
          'task',
          (v) => $enumDecodeNullable(_$TaskTypeEnumMap, v),
        ),
        baseSystemPrompt: $checkedConvert(
          'base_system_prompt',
          (v) => v as String?,
        ),
        temperature: $checkedConvert('temperature', (v) => v as num?),
      );
      return val;
    }, fieldKeyMap: const {'baseSystemPrompt': 'base_system_prompt'});

Map<String, dynamic> _$AgentUpdateToJson(AgentUpdate instance) =>
    <String, dynamic>{
      'alias': ?instance.alias,
      'task': ?_$TaskTypeEnumMap[instance.task],
      'base_system_prompt': ?instance.baseSystemPrompt,
      'temperature': ?instance.temperature,
    };

const _$TaskTypeEnumMap = {
  TaskType.manipulateGraph: 'manipulate_graph',
  TaskType.manipulateNode: 'manipulate_node',
  TaskType.createStudySession: 'create_study_session',
  TaskType.evaluateEssayQuestion: 'evaluate_essay_question',
  TaskType.createEssayQuestion: 'create_essay_question',
  TaskType.createMultipleChoiceQuestion: 'create_multiple_choice_question',
  TaskType.evaluateMultipleChoiceQuestion: 'evaluate_multiple_choice_question',
  TaskType.createFeynman: 'create_feynman',
  TaskType.evaluateFeynman: 'evaluate_feynman ',
  TaskType.recommendStudyResource: 'recommend_study_resource',
  TaskType.studyManager: 'study_manager',
  TaskType.studyAssistent: 'study_assistent',
  TaskType.createFlashcardGroup: 'create_flashcard_group',
  TaskType.manipulateFlashcardGroup: 'manipulate_flashcard_group',
  TaskType.createFlashcard: 'create_flashcard',
  TaskType.createFlashcardS: 'create_flashcardS',
};
