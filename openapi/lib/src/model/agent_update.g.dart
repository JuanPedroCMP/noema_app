// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgentUpdate extends AgentUpdate {
  @override
  final String? alias;
  @override
  final TaskType? task;
  @override
  final String? baseSystemPrompt;
  @override
  final num? temperature;

  factory _$AgentUpdate([void Function(AgentUpdateBuilder)? updates]) =>
      (AgentUpdateBuilder()..update(updates))._build();

  _$AgentUpdate._(
      {this.alias, this.task, this.baseSystemPrompt, this.temperature})
      : super._();
  @override
  AgentUpdate rebuild(void Function(AgentUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgentUpdateBuilder toBuilder() => AgentUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgentUpdate &&
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
    return (newBuiltValueToStringHelper(r'AgentUpdate')
          ..add('alias', alias)
          ..add('task', task)
          ..add('baseSystemPrompt', baseSystemPrompt)
          ..add('temperature', temperature))
        .toString();
  }
}

class AgentUpdateBuilder implements Builder<AgentUpdate, AgentUpdateBuilder> {
  _$AgentUpdate? _$v;

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

  AgentUpdateBuilder() {
    AgentUpdate._defaults(this);
  }

  AgentUpdateBuilder get _$this {
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
  void replace(AgentUpdate other) {
    _$v = other as _$AgentUpdate;
  }

  @override
  void update(void Function(AgentUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgentUpdate build() => _build();

  _$AgentUpdate _build() {
    final _$result = _$v ??
        _$AgentUpdate._(
          alias: alias,
          task: task,
          baseSystemPrompt: baseSystemPrompt,
          temperature: temperature,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
