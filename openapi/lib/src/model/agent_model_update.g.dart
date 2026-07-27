// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgentModelUpdate extends AgentModelUpdate {
  @override
  final String? idAgent;
  @override
  final String? idAiModel;
  @override
  final AgentModelQuality? qualityExpected;
  @override
  final String? customSystemPrompt;
  @override
  final num? customTemperature;

  factory _$AgentModelUpdate(
          [void Function(AgentModelUpdateBuilder)? updates]) =>
      (AgentModelUpdateBuilder()..update(updates))._build();

  _$AgentModelUpdate._(
      {this.idAgent,
      this.idAiModel,
      this.qualityExpected,
      this.customSystemPrompt,
      this.customTemperature})
      : super._();
  @override
  AgentModelUpdate rebuild(void Function(AgentModelUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgentModelUpdateBuilder toBuilder() =>
      AgentModelUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgentModelUpdate &&
        idAgent == other.idAgent &&
        idAiModel == other.idAiModel &&
        qualityExpected == other.qualityExpected &&
        customSystemPrompt == other.customSystemPrompt &&
        customTemperature == other.customTemperature;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idAgent.hashCode);
    _$hash = $jc(_$hash, idAiModel.hashCode);
    _$hash = $jc(_$hash, qualityExpected.hashCode);
    _$hash = $jc(_$hash, customSystemPrompt.hashCode);
    _$hash = $jc(_$hash, customTemperature.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgentModelUpdate')
          ..add('idAgent', idAgent)
          ..add('idAiModel', idAiModel)
          ..add('qualityExpected', qualityExpected)
          ..add('customSystemPrompt', customSystemPrompt)
          ..add('customTemperature', customTemperature))
        .toString();
  }
}

class AgentModelUpdateBuilder
    implements Builder<AgentModelUpdate, AgentModelUpdateBuilder> {
  _$AgentModelUpdate? _$v;

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

  num? _customTemperature;
  num? get customTemperature => _$this._customTemperature;
  set customTemperature(num? customTemperature) =>
      _$this._customTemperature = customTemperature;

  AgentModelUpdateBuilder() {
    AgentModelUpdate._defaults(this);
  }

  AgentModelUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idAgent = $v.idAgent;
      _idAiModel = $v.idAiModel;
      _qualityExpected = $v.qualityExpected;
      _customSystemPrompt = $v.customSystemPrompt;
      _customTemperature = $v.customTemperature;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgentModelUpdate other) {
    _$v = other as _$AgentModelUpdate;
  }

  @override
  void update(void Function(AgentModelUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgentModelUpdate build() => _build();

  _$AgentModelUpdate _build() {
    final _$result = _$v ??
        _$AgentModelUpdate._(
          idAgent: idAgent,
          idAiModel: idAiModel,
          qualityExpected: qualityExpected,
          customSystemPrompt: customSystemPrompt,
          customTemperature: customTemperature,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
