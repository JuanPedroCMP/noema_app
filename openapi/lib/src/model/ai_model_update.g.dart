// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AiModelUpdate extends AiModelUpdate {
  @override
  final String? slug;
  @override
  final String? idAiProvider;
  @override
  final String? displayName;
  @override
  final int? contextWindow;
  @override
  final int? inputTokenLimit;
  @override
  final int? outputTokenLimit;
  @override
  final bool? supportsVision;
  @override
  final bool? isActive;

  factory _$AiModelUpdate([void Function(AiModelUpdateBuilder)? updates]) =>
      (AiModelUpdateBuilder()..update(updates))._build();

  _$AiModelUpdate._(
      {this.slug,
      this.idAiProvider,
      this.displayName,
      this.contextWindow,
      this.inputTokenLimit,
      this.outputTokenLimit,
      this.supportsVision,
      this.isActive})
      : super._();
  @override
  AiModelUpdate rebuild(void Function(AiModelUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiModelUpdateBuilder toBuilder() => AiModelUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiModelUpdate &&
        slug == other.slug &&
        idAiProvider == other.idAiProvider &&
        displayName == other.displayName &&
        contextWindow == other.contextWindow &&
        inputTokenLimit == other.inputTokenLimit &&
        outputTokenLimit == other.outputTokenLimit &&
        supportsVision == other.supportsVision &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, idAiProvider.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, contextWindow.hashCode);
    _$hash = $jc(_$hash, inputTokenLimit.hashCode);
    _$hash = $jc(_$hash, outputTokenLimit.hashCode);
    _$hash = $jc(_$hash, supportsVision.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiModelUpdate')
          ..add('slug', slug)
          ..add('idAiProvider', idAiProvider)
          ..add('displayName', displayName)
          ..add('contextWindow', contextWindow)
          ..add('inputTokenLimit', inputTokenLimit)
          ..add('outputTokenLimit', outputTokenLimit)
          ..add('supportsVision', supportsVision)
          ..add('isActive', isActive))
        .toString();
  }
}

class AiModelUpdateBuilder
    implements Builder<AiModelUpdate, AiModelUpdateBuilder> {
  _$AiModelUpdate? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _idAiProvider;
  String? get idAiProvider => _$this._idAiProvider;
  set idAiProvider(String? idAiProvider) => _$this._idAiProvider = idAiProvider;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  int? _contextWindow;
  int? get contextWindow => _$this._contextWindow;
  set contextWindow(int? contextWindow) =>
      _$this._contextWindow = contextWindow;

  int? _inputTokenLimit;
  int? get inputTokenLimit => _$this._inputTokenLimit;
  set inputTokenLimit(int? inputTokenLimit) =>
      _$this._inputTokenLimit = inputTokenLimit;

  int? _outputTokenLimit;
  int? get outputTokenLimit => _$this._outputTokenLimit;
  set outputTokenLimit(int? outputTokenLimit) =>
      _$this._outputTokenLimit = outputTokenLimit;

  bool? _supportsVision;
  bool? get supportsVision => _$this._supportsVision;
  set supportsVision(bool? supportsVision) =>
      _$this._supportsVision = supportsVision;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  AiModelUpdateBuilder() {
    AiModelUpdate._defaults(this);
  }

  AiModelUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _idAiProvider = $v.idAiProvider;
      _displayName = $v.displayName;
      _contextWindow = $v.contextWindow;
      _inputTokenLimit = $v.inputTokenLimit;
      _outputTokenLimit = $v.outputTokenLimit;
      _supportsVision = $v.supportsVision;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiModelUpdate other) {
    _$v = other as _$AiModelUpdate;
  }

  @override
  void update(void Function(AiModelUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiModelUpdate build() => _build();

  _$AiModelUpdate _build() {
    final _$result = _$v ??
        _$AiModelUpdate._(
          slug: slug,
          idAiProvider: idAiProvider,
          displayName: displayName,
          contextWindow: contextWindow,
          inputTokenLimit: inputTokenLimit,
          outputTokenLimit: outputTokenLimit,
          supportsVision: supportsVision,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
