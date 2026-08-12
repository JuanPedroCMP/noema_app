// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserOut extends UserOut {
  @override
  final String id;
  @override
  final String userName;
  @override
  final String primaryEmail;
  @override
  final String? userDisplayName;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final bool? isActive;
  @override
  final bool? isVerified;

  factory _$UserOut([void Function(UserOutBuilder)? updates]) =>
      (UserOutBuilder()..update(updates))._build();

  _$UserOut._(
      {required this.id,
      required this.userName,
      required this.primaryEmail,
      this.userDisplayName,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      this.isVerified})
      : super._();
  @override
  UserOut rebuild(void Function(UserOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserOutBuilder toBuilder() => UserOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserOut &&
        id == other.id &&
        userName == other.userName &&
        primaryEmail == other.primaryEmail &&
        userDisplayName == other.userDisplayName &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        isActive == other.isActive &&
        isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, primaryEmail.hashCode);
    _$hash = $jc(_$hash, userDisplayName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserOut')
          ..add('id', id)
          ..add('userName', userName)
          ..add('primaryEmail', primaryEmail)
          ..add('userDisplayName', userDisplayName)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('isActive', isActive)
          ..add('isVerified', isVerified))
        .toString();
  }
}

class UserOutBuilder implements Builder<UserOut, UserOutBuilder> {
  _$UserOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  UserOutBuilder() {
    UserOut._defaults(this);
  }

  UserOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userName = $v.userName;
      _primaryEmail = $v.primaryEmail;
      _userDisplayName = $v.userDisplayName;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _isActive = $v.isActive;
      _isVerified = $v.isVerified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserOut other) {
    _$v = other as _$UserOut;
  }

  @override
  void update(void Function(UserOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserOut build() => _build();

  _$UserOut _build() {
    final _$result = _$v ??
        _$UserOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserOut', 'id'),
          userName: BuiltValueNullFieldError.checkNotNull(
              userName, r'UserOut', 'userName'),
          primaryEmail: BuiltValueNullFieldError.checkNotNull(
              primaryEmail, r'UserOut', 'primaryEmail'),
          userDisplayName: userDisplayName,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isActive: isActive,
          isVerified: isVerified,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
