// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgentOut extends AgentOut {
  @override
  final String id;
  @override
  final String alias;
  @override
  final TaskType task;
  @override
  final String baseSystemPrompt;
  @override
  final num? temperature;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$AgentOut([void Function(AgentOutBuilder)? updates]) =>
      (AgentOutBuilder()..update(updates))._build();

  _$AgentOut._(
      {required this.id,
      required this.alias,
      required this.task,
      required this.baseSystemPrompt,
      this.temperature,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  AgentOut rebuild(void Function(AgentOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgentOutBuilder toBuilder() => AgentOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgentOut &&
        id == other.id &&
        alias == other.alias &&
        task == other.task &&
        baseSystemPrompt == other.baseSystemPrompt &&
        temperature == other.temperature &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, alias.hashCode);
    _$hash = $jc(_$hash, task.hashCode);
    _$hash = $jc(_$hash, baseSystemPrompt.hashCode);
    _$hash = $jc(_$hash, temperature.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgentOut')
          ..add('id', id)
          ..add('alias', alias)
          ..add('task', task)
          ..add('baseSystemPrompt', baseSystemPrompt)
          ..add('temperature', temperature)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AgentOutBuilder implements Builder<AgentOut, AgentOutBuilder> {
  _$AgentOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _alias;
  String? get alias => _$this._alias;
  set alias(String? alias) => _$this._alias = alias;

  TaskType? _task;
  TaskType? get task => _$this._task;
  set task(TaskType? task) => _$this._task = task;

  String? _baseSystemPrompt;
  String? get baseSystemPrompt => _$this._baseSystemPrompt;
  set baseSystemPrompt(String? baseSystemPrompt) =>
      _$this._baseSystemPrompt = baseSystemPrompt;

  num? _temperature;
  num? get temperature => _$this._temperature;
  set temperature(num? temperature) => _$this._temperature = temperature;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AgentOutBuilder() {
    AgentOut._defaults(this);
  }

  AgentOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _alias = $v.alias;
      _task = $v.task;
      _baseSystemPrompt = $v.baseSystemPrompt;
      _temperature = $v.temperature;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgentOut other) {
    _$v = other as _$AgentOut;
  }

  @override
  void update(void Function(AgentOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgentOut build() => _build();

  _$AgentOut _build() {
    final _$result = _$v ??
        _$AgentOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AgentOut', 'id'),
          alias: BuiltValueNullFieldError.checkNotNull(
              alias, r'AgentOut', 'alias'),
          task:
              BuiltValueNullFieldError.checkNotNull(task, r'AgentOut', 'task'),
          baseSystemPrompt: BuiltValueNullFieldError.checkNotNull(
              baseSystemPrompt, r'AgentOut', 'baseSystemPrompt'),
          temperature: temperature,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
