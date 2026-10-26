// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_language_preference_order_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResponseLanguagePreferenceOrderCreate
    extends ResponseLanguagePreferenceOrderCreate {
  @override
  final int preferenceOrder;
  @override
  final String idUser;
  @override
  final String idLanguage;

  factory _$ResponseLanguagePreferenceOrderCreate(
          [void Function(ResponseLanguagePreferenceOrderCreateBuilder)?
              updates]) =>
      (ResponseLanguagePreferenceOrderCreateBuilder()..update(updates))
          ._build();

  _$ResponseLanguagePreferenceOrderCreate._(
      {required this.preferenceOrder,
      required this.idUser,
      required this.idLanguage})
      : super._();
  @override
  ResponseLanguagePreferenceOrderCreate rebuild(
          void Function(ResponseLanguagePreferenceOrderCreateBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponseLanguagePreferenceOrderCreateBuilder toBuilder() =>
      ResponseLanguagePreferenceOrderCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResponseLanguagePreferenceOrderCreate &&
        preferenceOrder == other.preferenceOrder &&
        idUser == other.idUser &&
        idLanguage == other.idLanguage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, preferenceOrder.hashCode);
    _$hash = $jc(_$hash, idUser.hashCode);
    _$hash = $jc(_$hash, idLanguage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ResponseLanguagePreferenceOrderCreate')
          ..add('preferenceOrder', preferenceOrder)
          ..add('idUser', idUser)
          ..add('idLanguage', idLanguage))
        .toString();
  }
}

class ResponseLanguagePreferenceOrderCreateBuilder
    implements
        Builder<ResponseLanguagePreferenceOrderCreate,
            ResponseLanguagePreferenceOrderCreateBuilder> {
  _$ResponseLanguagePreferenceOrderCreate? _$v;

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

  ResponseLanguagePreferenceOrderCreateBuilder() {
    ResponseLanguagePreferenceOrderCreate._defaults(this);
  }

  ResponseLanguagePreferenceOrderCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _preferenceOrder = $v.preferenceOrder;
      _idUser = $v.idUser;
      _idLanguage = $v.idLanguage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResponseLanguagePreferenceOrderCreate other) {
    _$v = other as _$ResponseLanguagePreferenceOrderCreate;
  }

  @override
  void update(
      void Function(ResponseLanguagePreferenceOrderCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResponseLanguagePreferenceOrderCreate build() => _build();

  _$ResponseLanguagePreferenceOrderCreate _build() {
    final _$result = _$v ??
        _$ResponseLanguagePreferenceOrderCreate._(
          preferenceOrder: BuiltValueNullFieldError.checkNotNull(
              preferenceOrder,
              r'ResponseLanguagePreferenceOrderCreate',
              'preferenceOrder'),
          idUser: BuiltValueNullFieldError.checkNotNull(
              idUser, r'ResponseLanguagePreferenceOrderCreate', 'idUser'),
          idLanguage: BuiltValueNullFieldError.checkNotNull(idLanguage,
              r'ResponseLanguagePreferenceOrderCreate', 'idLanguage'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
