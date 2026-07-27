// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_log_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GenericLogCreate extends GenericLogCreate {
  @override
  final String? idUser;
  @override
  final String type;
  @override
  final String details;

  factory _$GenericLogCreate(
          [void Function(GenericLogCreateBuilder)? updates]) =>
      (GenericLogCreateBuilder()..update(updates))._build();

  _$GenericLogCreate._({this.idUser, required this.type, required this.details})
      : super._();
  @override
  GenericLogCreate rebuild(void Function(GenericLogCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GenericLogCreateBuilder toBuilder() =>
      GenericLogCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GenericLogCreate &&
        idUser == other.idUser &&
        type == other.type &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GenericLogCreate')
          ..add('idUser', idUser)
          ..add('type', type)
          ..add('details', details))
        .toString();
  }
}

class GenericLogCreateBuilder
    implements Builder<GenericLogCreate, GenericLogCreateBuilder> {
  _$GenericLogCreate? _$v;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  GenericLogCreateBuilder() {
    GenericLogCreate._defaults(this);
  }

  GenericLogCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idUser = $v.idUser;
      _type = $v.type;
      _details = $v.details;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GenericLogCreate other) {
    _$v = other as _$GenericLogCreate;
  }

  @override
  void update(void Function(GenericLogCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GenericLogCreate build() => _build();

  _$GenericLogCreate _build() {
    final _$result = _$v ??
        _$GenericLogCreate._(
          idUser: idUser,
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'GenericLogCreate', 'type'),
          details: BuiltValueNullFieldError.checkNotNull(
              details, r'GenericLogCreate', 'details'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
