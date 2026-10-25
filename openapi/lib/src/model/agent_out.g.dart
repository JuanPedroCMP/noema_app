// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AgentOutCWProxy {
  AgentOut id(String id);

  AgentOut alias(String alias);

  AgentOut task(TaskType task);

  AgentOut baseSystemPrompt(String baseSystemPrompt);

  AgentOut temperature(num? temperature);

  AgentOut createdAt(DateTime? createdAt);

  AgentOut updatedAt(DateTime? updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentOut(...).copyWith(id: 12, name: "My name")
  /// ```
  AgentOut call({
    String id,
    String alias,
    TaskType task,
    String baseSystemPrompt,
    num? temperature,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAgentOut.copyWith(...)` or call `instanceOfAgentOut.copyWith.fieldName(value)` for a single field.
class _$AgentOutCWProxyImpl implements _$AgentOutCWProxy {
  const _$AgentOutCWProxyImpl(this._value);

  final AgentOut _value;

  @override
  AgentOut id(String id) => call(id: id);

  @override
  AgentOut alias(String alias) => call(alias: alias);

  @override
  AgentOut task(TaskType task) => call(task: task);

  @override
  AgentOut baseSystemPrompt(String baseSystemPrompt) =>
      call(baseSystemPrompt: baseSystemPrompt);

  @override
  AgentOut temperature(num? temperature) => call(temperature: temperature);

  @override
  AgentOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  AgentOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AgentOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AgentOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AgentOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? alias = const $CopyWithPlaceholder(),
    Object? task = const $CopyWithPlaceholder(),
    Object? baseSystemPrompt = const $CopyWithPlaceholder(),
    Object? temperature = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return AgentOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $AgentOutCopyWith on AgentOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAgentOut.copyWith(...)` or `instanceOfAgentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AgentOutCWProxy get copyWith => _$AgentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentOut _$AgentOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AgentOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'alias',
        'task',
        'base_system_prompt',
        'temperature',
        'created_at',
        'updated_at',
      ],
    );
    final val = AgentOut(
      id: $checkedConvert('id', (v) => v as String),
      alias: $checkedConvert('alias', (v) => v as String),
      task: $checkedConvert('task', (v) => $enumDecode(_$TaskTypeEnumMap, v)),
      baseSystemPrompt: $checkedConvert(
        'base_system_prompt',
        (v) => v as String,
      ),
      temperature: $checkedConvert('temperature', (v) => v as num?),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'baseSystemPrompt': 'base_system_prompt',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$AgentOutToJson(AgentOut instance) => <String, dynamic>{
  'id': instance.id,
  'alias': instance.alias,
  'task': _$TaskTypeEnumMap[instance.task]!,
  'base_system_prompt': instance.baseSystemPrompt,
  'temperature': instance.temperature,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
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
