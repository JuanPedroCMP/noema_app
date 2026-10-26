// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgentCreate extends AgentCreate {
  @override
  final String alias;
  @override
  final TaskType task;
  @override
  final String baseSystemPrompt;
  @override
  final num? temperature;

  factory _$AgentCreate([void Function(AgentCreateBuilder)? updates]) =>
      (AgentCreateBuilder()..update(updates))._build();

  _$AgentCreate._(
      {required this.alias,
      required this.task,
      required this.baseSystemPrompt,
      this.temperature})
      : super._();
  @override
  AgentCreate rebuild(void Function(AgentCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgentCreateBuilder toBuilder() => AgentCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgentCreate &&
        alias == other.alias &&
        task == other.task &&
        baseSystemPrompt == other.baseSystemPrompt &&
        temperature == other.temperature;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, alias.hashCode);
    _$hash = $jc(_$hash, task.hashCode);
    _$hash = $jc(_$hash, baseSystemPrompt.hashCode);
    _$hash = $jc(_$hash, temperature.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgentCreate')
          ..add('alias', alias)
          ..add('task', task)
          ..add('baseSystemPrompt', baseSystemPrompt)
          ..add('temperature', temperature))
        .toString();
  }
}

class AgentCreateBuilder implements Builder<AgentCreate, AgentCreateBuilder> {
  _$AgentCreate? _$v;

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

  AgentCreateBuilder() {
    AgentCreate._defaults(this);
  }

  AgentCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _alias = $v.alias;
      _task = $v.task;
      _baseSystemPrompt = $v.baseSystemPrompt;
      _temperature = $v.temperature;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgentCreate other) {
    _$v = other as _$AgentCreate;
  }

  @override
  void update(void Function(AgentCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgentCreate build() => _build();

  _$AgentCreate _build() {
    final _$result = _$v ??
        _$AgentCreate._(
          alias: BuiltValueNullFieldError.checkNotNull(
              alias, r'AgentCreate', 'alias'),
          task: BuiltValueNullFieldError.checkNotNull(
              task, r'AgentCreate', 'task'),
          baseSystemPrompt: BuiltValueNullFieldError.checkNotNull(
              baseSystemPrompt, r'AgentCreate', 'baseSystemPrompt'),
          temperature: temperature,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
