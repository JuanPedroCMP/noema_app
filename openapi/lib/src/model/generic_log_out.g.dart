// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_log_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GenericLogOut extends GenericLogOut {
  @override
  final String id;
  @override
  final String type;
  @override
  final String? idUser;
  @override
  final JsonObject? details;
  @override
  final DateTime? createdAt;

  factory _$GenericLogOut([void Function(GenericLogOutBuilder)? updates]) =>
      (GenericLogOutBuilder()..update(updates))._build();

  _$GenericLogOut._(
      {required this.id,
      required this.type,
      this.idUser,
      this.details,
      this.createdAt})
      : super._();
  @override
  GenericLogOut rebuild(void Function(GenericLogOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GenericLogOutBuilder toBuilder() => GenericLogOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GenericLogOut &&
        id == other.id &&
        type == other.type &&
        idUser == other.idUser &&
        details == other.details &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GenericLogOut')
          ..add('id', id)
          ..add('type', type)
          ..add('idUser', idUser)
          ..add('details', details)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class GenericLogOutBuilder
    implements Builder<GenericLogOut, GenericLogOutBuilder> {
  _$GenericLogOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  JsonObject? _details;
  JsonObject? get details => _$this._details;
  set details(JsonObject? details) => _$this._details = details;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  GenericLogOutBuilder() {
    GenericLogOut._defaults(this);
  }

  GenericLogOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _idUser = $v.idUser;
      _details = $v.details;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GenericLogOut other) {
    _$v = other as _$GenericLogOut;
  }

  @override
  void update(void Function(GenericLogOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GenericLogOut build() => _build();

  _$GenericLogOut _build() {
    final _$result = _$v ??
        _$GenericLogOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'GenericLogOut', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'GenericLogOut', 'type'),
          idUser: idUser,
          details: details,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
