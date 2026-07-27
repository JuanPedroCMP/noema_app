// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_language_preference_order_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResponseLanguagePreferenceOrderUpdate
    extends ResponseLanguagePreferenceOrderUpdate {
  @override
  final String? id;
  @override
  final int? preferenceOrder;
  @override
  final String? idUser;
  @override
  final String? idLanguage;

  factory _$ResponseLanguagePreferenceOrderUpdate(
          [void Function(ResponseLanguagePreferenceOrderUpdateBuilder)?
              updates]) =>
      (ResponseLanguagePreferenceOrderUpdateBuilder()..update(updates))
          ._build();

  _$ResponseLanguagePreferenceOrderUpdate._(
      {this.id, this.preferenceOrder, this.idUser, this.idLanguage})
      : super._();
  @override
  ResponseLanguagePreferenceOrderUpdate rebuild(
          void Function(ResponseLanguagePreferenceOrderUpdateBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponseLanguagePreferenceOrderUpdateBuilder toBuilder() =>
      ResponseLanguagePreferenceOrderUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResponseLanguagePreferenceOrderUpdate &&
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
    return (newBuiltValueToStringHelper(
            r'ResponseLanguagePreferenceOrderUpdate')
          ..add('id', id)
          ..add('preferenceOrder', preferenceOrder)
          ..add('idUser', idUser)
          ..add('idLanguage', idLanguage))
        .toString();
  }
}

class ResponseLanguagePreferenceOrderUpdateBuilder
    implements
        Builder<ResponseLanguagePreferenceOrderUpdate,
            ResponseLanguagePreferenceOrderUpdateBuilder> {
  _$ResponseLanguagePreferenceOrderUpdate? _$v;

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

  ResponseLanguagePreferenceOrderUpdateBuilder() {
    ResponseLanguagePreferenceOrderUpdate._defaults(this);
  }

  ResponseLanguagePreferenceOrderUpdateBuilder get _$this {
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
  void replace(ResponseLanguagePreferenceOrderUpdate other) {
    _$v = other as _$ResponseLanguagePreferenceOrderUpdate;
  }

  @override
  void update(
      void Function(ResponseLanguagePreferenceOrderUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResponseLanguagePreferenceOrderUpdate build() => _build();

  _$ResponseLanguagePreferenceOrderUpdate _build() {
    final _$result = _$v ??
        _$ResponseLanguagePreferenceOrderUpdate._(
          id: id,
          preferenceOrder: preferenceOrder,
          idUser: idUser,
          idLanguage: idLanguage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
