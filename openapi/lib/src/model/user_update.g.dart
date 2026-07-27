// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserUpdate extends UserUpdate {
  @override
  final String? userName;
  @override
  final String? primaryEmail;
  @override
  final String? userDisplayName;
  @override
  final String? password;

  factory _$UserUpdate([void Function(UserUpdateBuilder)? updates]) =>
      (UserUpdateBuilder()..update(updates))._build();

  _$UserUpdate._(
      {this.userName, this.primaryEmail, this.userDisplayName, this.password})
      : super._();
  @override
  UserUpdate rebuild(void Function(UserUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserUpdateBuilder toBuilder() => UserUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserUpdate &&
        userName == other.userName &&
        primaryEmail == other.primaryEmail &&
        userDisplayName == other.userDisplayName &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, primaryEmail.hashCode);
    _$hash = $jc(_$hash, userDisplayName.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserUpdate')
          ..add('userName', userName)
          ..add('primaryEmail', primaryEmail)
          ..add('userDisplayName', userDisplayName)
          ..add('password', password))
        .toString();
  }
}

class UserUpdateBuilder implements Builder<UserUpdate, UserUpdateBuilder> {
  _$UserUpdate? _$v;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  String? _primaryEmail;
  String? get primaryEmail => _$this._primaryEmail;
  set primaryEmail(String? primaryEmail) => _$this._primaryEmail = primaryEmail;

  String? _userDisplayName;
  String? get userDisplayName => _$this._userDisplayName;
  set userDisplayName(String? userDisplayName) =>
      _$this._userDisplayName = userDisplayName;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  UserUpdateBuilder() {
    UserUpdate._defaults(this);
  }

  UserUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userName = $v.userName;
      _primaryEmail = $v.primaryEmail;
      _userDisplayName = $v.userDisplayName;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserUpdate other) {
    _$v = other as _$UserUpdate;
  }

  @override
  void update(void Function(UserUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserUpdate build() => _build();

  _$UserUpdate _build() {
    final _$result = _$v ??
        _$UserUpdate._(
          userName: userName,
          primaryEmail: primaryEmail,
          userDisplayName: userDisplayName,
          password: password,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
