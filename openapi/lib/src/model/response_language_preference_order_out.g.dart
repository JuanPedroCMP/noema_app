// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_language_preference_order_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResponseLanguagePreferenceOrderOut
    extends ResponseLanguagePreferenceOrderOut {
  @override
  final String id;
  @override
  final int preferenceOrder;
  @override
  final String idUser;
  @override
  final String idLanguage;

  factory _$ResponseLanguagePreferenceOrderOut(
          [void Function(ResponseLanguagePreferenceOrderOutBuilder)?
              updates]) =>
      (ResponseLanguagePreferenceOrderOutBuilder()..update(updates))._build();

  _$ResponseLanguagePreferenceOrderOut._(
      {required this.id,
      required this.preferenceOrder,
      required this.idUser,
      required this.idLanguage})
      : super._();
  @override
  ResponseLanguagePreferenceOrderOut rebuild(
          void Function(ResponseLanguagePreferenceOrderOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponseLanguagePreferenceOrderOutBuilder toBuilder() =>
      ResponseLanguagePreferenceOrderOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResponseLanguagePreferenceOrderOut &&
        id == other.id &&
        preferenceOrder == other.preferenceOrder &&
        idUser == other.idUser &&
        idLanguage == other.idLanguage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, preferenceOrder.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idLanguage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResponseLanguagePreferenceOrderOut')
          ..add('id', id)
          ..add('preferenceOrder', preferenceOrder)
          ..add('idUser', idUser)
          ..add('idLanguage', idLanguage))
        .toString();
  }
}

class ResponseLanguagePreferenceOrderOutBuilder
    implements
        Builder<ResponseLanguagePreferenceOrderOut,
            ResponseLanguagePreferenceOrderOutBuilder> {
  _$ResponseLanguagePreferenceOrderOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _preferenceOrder;
  int? get preferenceOrder => _$this._preferenceOrder;
  set preferenceOrder(int? preferenceOrder) =>
      _$this._preferenceOrder = preferenceOrder;

  String? _idUser;
  String? get idUser => _$this._idUser;
  set idUser(String? idUser) => _$this._idUser = idUser;

  String? _idLanguage;
  String? get idLanguage => _$this._idLanguage;
  set idLanguage(String? idLanguage) => _$this._idLanguage = idLanguage;

  ResponseLanguagePreferenceOrderOutBuilder() {
    ResponseLanguagePreferenceOrderOut._defaults(this);
  }

  ResponseLanguagePreferenceOrderOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _preferenceOrder = $v.preferenceOrder;
      _idUser = $v.idUser;
      _idLanguage = $v.idLanguage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResponseLanguagePreferenceOrderOut other) {
    _$v = other as _$ResponseLanguagePreferenceOrderOut;
  }

  @override
  void update(
      void Function(ResponseLanguagePreferenceOrderOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResponseLanguagePreferenceOrderOut build() => _build();

  _$ResponseLanguagePreferenceOrderOut _build() {
    final _$result = _$v ??
        _$ResponseLanguagePreferenceOrderOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ResponseLanguagePreferenceOrderOut', 'id'),
          preferenceOrder: BuiltValueNullFieldError.checkNotNull(
              preferenceOrder,
              r'ResponseLanguagePreferenceOrderOut',
              'preferenceOrder'),
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'ResponseLanguagePreferenceOrderOut', 'idUser'),
          idLanguage: BuiltValueNullFieldError.checkNotNull(
              idLanguage, r'ResponseLanguagePreferenceOrderOut', 'idLanguage'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
