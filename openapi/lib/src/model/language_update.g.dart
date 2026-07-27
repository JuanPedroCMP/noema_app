// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LanguageUpdate extends LanguageUpdate {
  @override
  final String? name;
  @override
  final int? percentageTranslated;
  @override
  final bool? verifiedTranslation;
  @override
  final bool? automaticTranslation;

  factory _$LanguageUpdate([void Function(LanguageUpdateBuilder)? updates]) =>
      (LanguageUpdateBuilder()..update(updates))._build();

  _$LanguageUpdate._(
      {this.name,
      this.percentageTranslated,
      this.verifiedTranslation,
      this.automaticTranslation})
      : super._();
  @override
  LanguageUpdate rebuild(void Function(LanguageUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LanguageUpdateBuilder toBuilder() => LanguageUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LanguageUpdate &&
        name == other.name &&
        percentageTranslated == other.percentageTranslated &&
        verifiedTranslation == other.verifiedTranslation &&
        automaticTranslation == other.automaticTranslation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, percentageTranslated.hashCode);
    _$hash = $jc(_$hash, verifiedTranslation.hashCode);
    _$hash = $jc(_$hash, automaticTranslation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LanguageUpdate')
          ..add('name', name)
          ..add('percentageTranslated', percentageTranslated)
          ..add('verifiedTranslation', verifiedTranslation)
          ..add('automaticTranslation', automaticTranslation))
        .toString();
  }
}

class LanguageUpdateBuilder
    implements Builder<LanguageUpdate, LanguageUpdateBuilder> {
  _$LanguageUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _percentageTranslated;
  int? get percentageTranslated => _$this._percentageTranslated;
  set percentageTranslated(int? percentageTranslated) =>
      _$this._percentageTranslated = percentageTranslated;

  bool? _verifiedTranslation;
  bool? get verifiedTranslation => _$this._verifiedTranslation;
  set verifiedTranslation(bool? verifiedTranslation) =>
      _$this._verifiedTranslation = verifiedTranslation;

  bool? _automaticTranslation;
  bool? get automaticTranslation => _$this._automaticTranslation;
  set automaticTranslation(bool? automaticTranslation) =>
      _$this._automaticTranslation = automaticTranslation;

  LanguageUpdateBuilder() {
    LanguageUpdate._defaults(this);
  }

  LanguageUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _percentageTranslated = $v.percentageTranslated;
      _verifiedTranslation = $v.verifiedTranslation;
      _automaticTranslation = $v.automaticTranslation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LanguageUpdate other) {
    _$v = other as _$LanguageUpdate;
  }

  @override
  void update(void Function(LanguageUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LanguageUpdate build() => _build();

  _$LanguageUpdate _build() {
    final _$result = _$v ??
        _$LanguageUpdate._(
          name: name,
          percentageTranslated: percentageTranslated,
          verifiedTranslation: verifiedTranslation,
          automaticTranslation: automaticTranslation,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
