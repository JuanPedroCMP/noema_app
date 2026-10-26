// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LanguageCreate extends LanguageCreate {
  @override
  final String name;
  @override
  final int percentageTranslated;
  @override
  final bool verifiedTranslation;
  @override
  final bool automaticTranslation;

  factory _$LanguageCreate([void Function(LanguageCreateBuilder)? updates]) =>
      (LanguageCreateBuilder()..update(updates))._build();

  _$LanguageCreate._(
      {required this.name,
      required this.percentageTranslated,
      required this.verifiedTranslation,
      required this.automaticTranslation})
      : super._();
  @override
  LanguageCreate rebuild(void Function(LanguageCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LanguageCreateBuilder toBuilder() => LanguageCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LanguageCreate &&
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
    return (newBuiltValueToStringHelper(r'LanguageCreate')
          ..add('name', name)
          ..add('percentageTranslated', percentageTranslated)
          ..add('verifiedTranslation', verifiedTranslation)
          ..add('automaticTranslation', automaticTranslation))
        .toString();
  }
}

class LanguageCreateBuilder
    implements Builder<LanguageCreate, LanguageCreateBuilder> {
  _$LanguageCreate? _$v;

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

  LanguageCreateBuilder() {
    LanguageCreate._defaults(this);
  }

  LanguageCreateBuilder get _$this {
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
  void replace(LanguageCreate other) {
    _$v = other as _$LanguageCreate;
  }

  @override
  void update(void Function(LanguageCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LanguageCreate build() => _build();

  _$LanguageCreate _build() {
    final _$result = _$v ??
        _$LanguageCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'LanguageCreate', 'name'),
          percentageTranslated: BuiltValueNullFieldError.checkNotNull(
              percentageTranslated, r'LanguageCreate', 'percentageTranslated'),
          verifiedTranslation: BuiltValueNullFieldError.checkNotNull(
              verifiedTranslation, r'LanguageCreate', 'verifiedTranslation'),
          automaticTranslation: BuiltValueNullFieldError.checkNotNull(
              automaticTranslation, r'LanguageCreate', 'automaticTranslation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
