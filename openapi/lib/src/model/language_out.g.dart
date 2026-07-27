// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LanguageOut extends LanguageOut {
  @override
  final String id;
  @override
  final String name;
  @override
  final int percentageTranslated;
  @override
  final bool verifiedTranslation;
  @override
  final bool automaticTranslation;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$LanguageOut([void Function(LanguageOutBuilder)? updates]) =>
      (LanguageOutBuilder()..update(updates))._build();

  _$LanguageOut._(
      {required this.id,
      required this.name,
      required this.percentageTranslated,
      required this.verifiedTranslation,
      required this.automaticTranslation,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  LanguageOut rebuild(void Function(LanguageOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LanguageOutBuilder toBuilder() => LanguageOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LanguageOut &&
        id == other.id &&
        name == other.name &&
        percentageTranslated == other.percentageTranslated &&
        verifiedTranslation == other.verifiedTranslation &&
        automaticTranslation == other.automaticTranslation &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, percentageTranslated.hashCode);
    _$hash = $jc(_$hash, verifiedTranslation.hashCode);
    _$hash = $jc(_$hash, automaticTranslation.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LanguageOut')
          ..add('id', id)
          ..add('name', name)
          ..add('percentageTranslated', percentageTranslated)
          ..add('verifiedTranslation', verifiedTranslation)
          ..add('automaticTranslation', automaticTranslation)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class LanguageOutBuilder implements Builder<LanguageOut, LanguageOutBuilder> {
  _$LanguageOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  LanguageOutBuilder() {
    LanguageOut._defaults(this);
  }

  LanguageOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _percentageTranslated = $v.percentageTranslated;
      _verifiedTranslation = $v.verifiedTranslation;
      _automaticTranslation = $v.automaticTranslation;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LanguageOut other) {
    _$v = other as _$LanguageOut;
  }

  @override
  void update(void Function(LanguageOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LanguageOut build() => _build();

  _$LanguageOut _build() {
    final _$result = _$v ??
        _$LanguageOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'LanguageOut', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'LanguageOut', 'name'),
          percentageTranslated: BuiltValueNullFieldError.checkNotNull(
              percentageTranslated, r'LanguageOut', 'percentageTranslated'),
          verifiedTranslation: BuiltValueNullFieldError.checkNotNull(
              verifiedTranslation, r'LanguageOut', 'verifiedTranslation'),
          automaticTranslation: BuiltValueNullFieldError.checkNotNull(
              automaticTranslation, r'LanguageOut', 'automaticTranslation'),
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
