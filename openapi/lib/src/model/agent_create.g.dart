// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AgentCreateCWProxy {
  AgentCreate alias(String alias);

  AgentCreate task(TaskType task);

  AgentCreate baseSystemPrompt(String baseSystemPrompt);

  AgentCreate temperature(num? temperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  AgentCreate call({
    String alias,
    TaskType task,
    String baseSystemPrompt,
    num? temperature,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAgentCreate.copyWith(...)` or call `instanceOfAgentCreate.copyWith.fieldName(value)` for a single field.
class _$AgentCreateCWProxyImpl implements _$AgentCreateCWProxy {
  const _$AgentCreateCWProxyImpl(this._value);

  final AgentCreate _value;

  @override
  AgentCreate alias(String alias) => call(alias: alias);

  @override
  AgentCreate task(TaskType task) => call(task: task);

  @override
  AgentCreate baseSystemPrompt(String baseSystemPrompt) =>
      call(baseSystemPrompt: baseSystemPrompt);

  @override
  AgentCreate temperature(num? temperature) => call(temperature: temperature);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AgentCreate call({
    Object? alias = const $CopyWithPlaceholder(),
    Object? task = const $CopyWithPlaceholder(),
    Object? baseSystemPrompt = const $CopyWithPlaceholder(),
    Object? temperature = const $CopyWithPlaceholder(),
  }) {
    return AgentCreate(
      alias: alias == const $CopyWithPlaceholder() || alias == null
          ? _value.alias
          // ignore: cast_nullable_to_non_nullable
          : alias as String,
      task: task == const $CopyWithPlaceholder() || task == null
          ? _value.task
          // ignore: cast_nullable_to_non_nullable
          : task as TaskType,
      baseSystemPrompt:
          baseSystemPrompt == const $CopyWithPlaceholder() ||
              baseSystemPrompt == null
          ? _value.baseSystemPrompt
          // ignore: cast_nullable_to_non_nullable
          : baseSystemPrompt as String,
      temperature: temperature == const $CopyWithPlaceholder()
          ? _value.temperature
          // ignore: cast_nullable_to_non_nullable
          : temperature as num?,
    );
  }
}

extension $AgentCreateCopyWith on AgentCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAgentCreate.copyWith(...)` or `instanceOfAgentCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AgentCreateCWProxy get copyWith => _$AgentCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentCreate _$AgentCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AgentCreate', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['alias', 'task', 'base_system_prompt', 'temperature'],
  );
  final val = AgentCreate(
    alias: $checkedConvert('alias', (v) => v as String),
    task: $checkedConvert('task', (v) => $enumDecode(_$TaskTypeEnumMap, v)),
    baseSystemPrompt: $checkedConvert('base_system_prompt', (v) => v as String),
    temperature: $checkedConvert('temperature', (v) => v as num?),
  );
  return val;
}, fieldKeyMap: const {'baseSystemPrompt': 'base_system_prompt'});

Map<String, dynamic> _$AgentCreateToJson(AgentCreate instance) =>
    <String, dynamic>{
      'alias': instance.alias,
      'task': _$TaskTypeEnumMap[instance.task]!,
      'base_system_prompt': instance.baseSystemPrompt,
      'temperature': instance.temperature,
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
