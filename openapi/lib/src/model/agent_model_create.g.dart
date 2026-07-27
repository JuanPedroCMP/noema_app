// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgentModelCreate extends AgentModelCreate {
  @override
  final String idAgent;
  @override
  final String idAiModel;
  @override
  final AgentModelQuality qualityExpected;
  @override
  final String customSystemPrompt;
  @override
  final num? temperature;

  factory _$AgentModelCreate(
          [void Function(AgentModelCreateBuilder)? updates]) =>
      (AgentModelCreateBuilder()..update(updates))._build();

  _$AgentModelCreate._(
      {required this.idAgent,
      required this.idAiModel,
      required this.qualityExpected,
      required this.customSystemPrompt,
      this.temperature})
      : super._();
  @override
  AgentModelCreate rebuild(void Function(AgentModelCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgentModelCreateBuilder toBuilder() =>
      AgentModelCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgentModelCreate &&
        idAgent == other.idAgent &&
        idAiModel == other.idAiModel &&
        qualityExpected == other.qualityExpected &&
        customSystemPrompt == other.customSystemPrompt &&
        temperature == other.temperature;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idAgent.hashCode);
    _$hash = $jc(_$hash, idAiModel.hashCode);
    _$hash = $jc(_$hash, qualityExpected.hashCode);
    _$hash = $jc(_$hash, customSystemPrompt.hashCode);
    _$hash = $jc(_$hash, temperature.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgentModelCreate')
          ..add('idAgent', idAgent)
          ..add('idAiModel', idAiModel)
          ..add('qualityExpected', qualityExpected)
          ..add('customSystemPrompt', customSystemPrompt)
          ..add('temperature', temperature))
        .toString();
  }
}

class AgentModelCreateBuilder
    implements Builder<AgentModelCreate, AgentModelCreateBuilder> {
  _$AgentModelCreate? _$v;

  String? _idAgent;
  String? get idAgent => _$this._idAgent;
  set idAgent(String? idAgent) => _$this._idAgent = idAgent;

  String? _idAiModel;
  String? get idAiModel => _$this._idAiModel;
  set idAiModel(String? idAiModel) => _$this._idAiModel = idAiModel;

  AgentModelQuality? _qualityExpected;
  AgentModelQuality? get qualityExpected => _$this._qualityExpected;
  set qualityExpected(AgentModelQuality? qualityExpected) =>
      _$this._qualityExpected = qualityExpected;

  String? _customSystemPrompt;
  String? get customSystemPrompt => _$this._customSystemPrompt;
  set customSystemPrompt(String? customSystemPrompt) =>
      _$this._customSystemPrompt = customSystemPrompt;

  num? _temperature;
  num? get temperature => _$this._temperature;
  set temperature(num? temperature) => _$this._temperature = temperature;

  AgentModelCreateBuilder() {
    AgentModelCreate._defaults(this);
  }

  AgentModelCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idAgent = $v.idAgent;
      _idAiModel = $v.idAiModel;
      _qualityExpected = $v.qualityExpected;
      _customSystemPrompt = $v.customSystemPrompt;
      _temperature = $v.temperature;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgentModelCreate other) {
    _$v = other as _$AgentModelCreate;
  }

  @override
  void update(void Function(AgentModelCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgentModelCreate build() => _build();

  _$AgentModelCreate _build() {
    final _$result = _$v ??
        _$AgentModelCreate._(
          idAgent: BuiltValueNullFieldError.checkNotNull(
              idAgent, r'AgentModelCreate', 'idAgent'),
          idAiModel: BuiltValueNullFieldError.checkNotNull(
              idAiModel, r'AgentModelCreate', 'idAiModel'),
          qualityExpected: BuiltValueNullFieldError.checkNotNull(
              qualityExpected, r'AgentModelCreate', 'qualityExpected'),
          customSystemPrompt: BuiltValueNullFieldError.checkNotNull(
              customSystemPrompt, r'AgentModelCreate', 'customSystemPrompt'),
          temperature: temperature,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
