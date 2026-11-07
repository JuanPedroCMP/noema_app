// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_status_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoogleAccountStatusOutStateEnum
    _$googleAccountStatusOutStateEnum_notLinked =
    const GoogleAccountStatusOutStateEnum._('notLinked');
const GoogleAccountStatusOutStateEnum
    _$googleAccountStatusOutStateEnum_granted =
    const GoogleAccountStatusOutStateEnum._('granted');
const GoogleAccountStatusOutStateEnum
    _$googleAccountStatusOutStateEnum_missing =
    const GoogleAccountStatusOutStateEnum._('missing');
const GoogleAccountStatusOutStateEnum
    _$googleAccountStatusOutStateEnum_revoked =
    const GoogleAccountStatusOutStateEnum._('revoked');
const GoogleAccountStatusOutStateEnum
    _$googleAccountStatusOutStateEnum_unknown =
    const GoogleAccountStatusOutStateEnum._('unknown');

GoogleAccountStatusOutStateEnum _$googleAccountStatusOutStateEnumValueOf(
    String name) {
  switch (name) {
    case 'notLinked':
      return _$googleAccountStatusOutStateEnum_notLinked;
    case 'granted':
      return _$googleAccountStatusOutStateEnum_granted;
    case 'missing':
      return _$googleAccountStatusOutStateEnum_missing;
    case 'revoked':
      return _$googleAccountStatusOutStateEnum_revoked;
    case 'unknown':
      return _$googleAccountStatusOutStateEnum_unknown;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoogleAccountStatusOutStateEnum>
    _$googleAccountStatusOutStateEnumValues = BuiltSet<
        GoogleAccountStatusOutStateEnum>(const <GoogleAccountStatusOutStateEnum>[
  _$googleAccountStatusOutStateEnum_notLinked,
  _$googleAccountStatusOutStateEnum_granted,
  _$googleAccountStatusOutStateEnum_missing,
  _$googleAccountStatusOutStateEnum_revoked,
  _$googleAccountStatusOutStateEnum_unknown,
]);

const GoogleAccountStatusOutErrorEnum
    _$googleAccountStatusOutErrorEnum_googleAccountNotLinked =
    const GoogleAccountStatusOutErrorEnum._('googleAccountNotLinked');
const GoogleAccountStatusOutErrorEnum
    _$googleAccountStatusOutErrorEnum_driveAppdataScopeMissing =
    const GoogleAccountStatusOutErrorEnum._('driveAppdataScopeMissing');
const GoogleAccountStatusOutErrorEnum
    _$googleAccountStatusOutErrorEnum_googleAuthorizationRevoked =
    const GoogleAccountStatusOutErrorEnum._('googleAuthorizationRevoked');
const GoogleAccountStatusOutErrorEnum
    _$googleAccountStatusOutErrorEnum_googleAuthorizationUnverified =
    const GoogleAccountStatusOutErrorEnum._('googleAuthorizationUnverified');

GoogleAccountStatusOutErrorEnum _$googleAccountStatusOutErrorEnumValueOf(
    String name) {
  switch (name) {
    case 'googleAccountNotLinked':
      return _$googleAccountStatusOutErrorEnum_googleAccountNotLinked;
    case 'driveAppdataScopeMissing':
      return _$googleAccountStatusOutErrorEnum_driveAppdataScopeMissing;
    case 'googleAuthorizationRevoked':
      return _$googleAccountStatusOutErrorEnum_googleAuthorizationRevoked;
    case 'googleAuthorizationUnverified':
      return _$googleAccountStatusOutErrorEnum_googleAuthorizationUnverified;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoogleAccountStatusOutErrorEnum>
    _$googleAccountStatusOutErrorEnumValues = BuiltSet<
        GoogleAccountStatusOutErrorEnum>(const <GoogleAccountStatusOutErrorEnum>[
  _$googleAccountStatusOutErrorEnum_googleAccountNotLinked,
  _$googleAccountStatusOutErrorEnum_driveAppdataScopeMissing,
  _$googleAccountStatusOutErrorEnum_googleAuthorizationRevoked,
  _$googleAccountStatusOutErrorEnum_googleAuthorizationUnverified,
]);

Serializer<GoogleAccountStatusOutStateEnum>
    _$googleAccountStatusOutStateEnumSerializer =
    _$GoogleAccountStatusOutStateEnumSerializer();
Serializer<GoogleAccountStatusOutErrorEnum>
    _$googleAccountStatusOutErrorEnumSerializer =
    _$GoogleAccountStatusOutErrorEnumSerializer();

class _$GoogleAccountStatusOutStateEnumSerializer
    implements PrimitiveSerializer<GoogleAccountStatusOutStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'notLinked': 'not_linked',
    'granted': 'granted',
    'missing': 'missing',
    'revoked': 'revoked',
    'unknown': 'unknown',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'not_linked': 'notLinked',
    'granted': 'granted',
    'missing': 'missing',
    'revoked': 'revoked',
    'unknown': 'unknown',
  };

  @override
  final Iterable<Type> types = const <Type>[GoogleAccountStatusOutStateEnum];
  @override
  final String wireName = 'GoogleAccountStatusOutStateEnum';

  @override
  Object serialize(
          Serializers serializers, GoogleAccountStatusOutStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoogleAccountStatusOutStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoogleAccountStatusOutStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoogleAccountStatusOutErrorEnumSerializer
    implements PrimitiveSerializer<GoogleAccountStatusOutErrorEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'googleAccountNotLinked': 'google_account_not_linked',
    'driveAppdataScopeMissing': 'drive_appdata_scope_missing',
    'googleAuthorizationRevoked': 'google_authorization_revoked',
    'googleAuthorizationUnverified': 'google_authorization_unverified',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'google_account_not_linked': 'googleAccountNotLinked',
    'drive_appdata_scope_missing': 'driveAppdataScopeMissing',
    'google_authorization_revoked': 'googleAuthorizationRevoked',
    'google_authorization_unverified': 'googleAuthorizationUnverified',
  };

  @override
  final Iterable<Type> types = const <Type>[GoogleAccountStatusOutErrorEnum];
  @override
  final String wireName = 'GoogleAccountStatusOutErrorEnum';

  @override
  Object serialize(
          Serializers serializers, GoogleAccountStatusOutErrorEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoogleAccountStatusOutErrorEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoogleAccountStatusOutErrorEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoogleAccountStatusOut extends GoogleAccountStatusOut {
  @override
  final String? accountId;
  @override
  final String? googleEmail;
  @override
  final GoogleAccountStatusOutStateEnum state;
  @override
  final bool driveAppdataGranted;
  @override
  final bool syncAvailable;
  @override
  final BuiltList<String> grantedScopes;
  @override
  final DateTime? checkedAt;
  @override
  final GoogleAccountStatusOutErrorEnum? error;

  factory _$GoogleAccountStatusOut(
          [void Function(GoogleAccountStatusOutBuilder)? updates]) =>
      (GoogleAccountStatusOutBuilder()..update(updates))._build();

  _$GoogleAccountStatusOut._(
      {this.accountId,
      this.googleEmail,
      required this.state,
      required this.driveAppdataGranted,
      required this.syncAvailable,
      required this.grantedScopes,
      this.checkedAt,
      this.error})
      : super._();
  @override
  GoogleAccountStatusOut rebuild(
          void Function(GoogleAccountStatusOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAccountStatusOutBuilder toBuilder() =>
      GoogleAccountStatusOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAccountStatusOut &&
        accountId == other.accountId &&
        googleEmail == other.googleEmail &&
        state == other.state &&
        driveAppdataGranted == other.driveAppdataGranted &&
        syncAvailable == other.syncAvailable &&
        grantedScopes == other.grantedScopes &&
        checkedAt == other.checkedAt &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, googleEmail.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, driveAppdataGranted.hashCode);
    _$hash = $jc(_$hash, syncAvailable.hashCode);
    _$hash = $jc(_$hash, grantedScopes.hashCode);
    _$hash = $jc(_$hash, checkedAt.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAccountStatusOut')
          ..add('accountId', accountId)
          ..add('googleEmail', googleEmail)
          ..add('state', state)
          ..add('driveAppdataGranted', driveAppdataGranted)
          ..add('syncAvailable', syncAvailable)
          ..add('grantedScopes', grantedScopes)
          ..add('checkedAt', checkedAt)
          ..add('error', error))
        .toString();
  }
}

class GoogleAccountStatusOutBuilder
    implements Builder<GoogleAccountStatusOut, GoogleAccountStatusOutBuilder> {
  _$GoogleAccountStatusOut? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _googleEmail;
  String? get googleEmail => _$this._googleEmail;
  set googleEmail(String? googleEmail) => _$this._googleEmail = googleEmail;

  GoogleAccountStatusOutStateEnum? _state;
  GoogleAccountStatusOutStateEnum? get state => _$this._state;
  set state(GoogleAccountStatusOutStateEnum? state) => _$this._state = state;

  bool? _driveAppdataGranted;
  bool? get driveAppdataGranted => _$this._driveAppdataGranted;
  set driveAppdataGranted(bool? driveAppdataGranted) =>
      _$this._driveAppdataGranted = driveAppdataGranted;

  bool? _syncAvailable;
  bool? get syncAvailable => _$this._syncAvailable;
  set syncAvailable(bool? syncAvailable) =>
      _$this._syncAvailable = syncAvailable;

  ListBuilder<String>? _grantedScopes;
  ListBuilder<String> get grantedScopes =>
      _$this._grantedScopes ??= ListBuilder<String>();
  set grantedScopes(ListBuilder<String>? grantedScopes) =>
      _$this._grantedScopes = grantedScopes;

  DateTime? _checkedAt;
  DateTime? get checkedAt => _$this._checkedAt;
  set checkedAt(DateTime? checkedAt) => _$this._checkedAt = checkedAt;

  GoogleAccountStatusOutErrorEnum? _error;
  GoogleAccountStatusOutErrorEnum? get error => _$this._error;
  set error(GoogleAccountStatusOutErrorEnum? error) => _$this._error = error;

  GoogleAccountStatusOutBuilder() {
    GoogleAccountStatusOut._defaults(this);
  }

  GoogleAccountStatusOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _googleEmail = $v.googleEmail;
      _state = $v.state;
      _driveAppdataGranted = $v.driveAppdataGranted;
      _syncAvailable = $v.syncAvailable;
      _grantedScopes = $v.grantedScopes.toBuilder();
      _checkedAt = $v.checkedAt;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAccountStatusOut other) {
    _$v = other as _$GoogleAccountStatusOut;
  }

  @override
  void update(void Function(GoogleAccountStatusOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAccountStatusOut build() => _build();

  _$GoogleAccountStatusOut _build() {
    _$GoogleAccountStatusOut _$result;
    try {
      _$result = _$v ??
          _$GoogleAccountStatusOut._(
            accountId: accountId,
            googleEmail: googleEmail,
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'GoogleAccountStatusOut', 'state'),
            driveAppdataGranted: BuiltValueNullFieldError.checkNotNull(
                driveAppdataGranted,
                r'GoogleAccountStatusOut',
                'driveAppdataGranted'),
            syncAvailable: BuiltValueNullFieldError.checkNotNull(
                syncAvailable, r'GoogleAccountStatusOut', 'syncAvailable'),
            grantedScopes: grantedScopes.build(),
            checkedAt: checkedAt,
            error: error,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'grantedScopes';
        grantedScopes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GoogleAccountStatusOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
