// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SyncLogCreateEventEnum _$syncLogCreateEventEnum_syncStarted =
    const SyncLogCreateEventEnum._('syncStarted');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_syncCompleted =
    const SyncLogCreateEventEnum._('syncCompleted');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_syncFailed =
    const SyncLogCreateEventEnum._('syncFailed');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_conflictDetected =
    const SyncLogCreateEventEnum._('conflictDetected');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_authorizationRefreshed =
    const SyncLogCreateEventEnum._('authorizationRefreshed');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_backupCreated =
    const SyncLogCreateEventEnum._('backupCreated');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_backupUpdated =
    const SyncLogCreateEventEnum._('backupUpdated');
const SyncLogCreateEventEnum _$syncLogCreateEventEnum_backupDeleted =
    const SyncLogCreateEventEnum._('backupDeleted');

SyncLogCreateEventEnum _$syncLogCreateEventEnumValueOf(String name) {
  switch (name) {
    case 'syncStarted':
      return _$syncLogCreateEventEnum_syncStarted;
    case 'syncCompleted':
      return _$syncLogCreateEventEnum_syncCompleted;
    case 'syncFailed':
      return _$syncLogCreateEventEnum_syncFailed;
    case 'conflictDetected':
      return _$syncLogCreateEventEnum_conflictDetected;
    case 'authorizationRefreshed':
      return _$syncLogCreateEventEnum_authorizationRefreshed;
    case 'backupCreated':
      return _$syncLogCreateEventEnum_backupCreated;
    case 'backupUpdated':
      return _$syncLogCreateEventEnum_backupUpdated;
    case 'backupDeleted':
      return _$syncLogCreateEventEnum_backupDeleted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SyncLogCreateEventEnum> _$syncLogCreateEventEnumValues =
    BuiltSet<SyncLogCreateEventEnum>(const <SyncLogCreateEventEnum>[
  _$syncLogCreateEventEnum_syncStarted,
  _$syncLogCreateEventEnum_syncCompleted,
  _$syncLogCreateEventEnum_syncFailed,
  _$syncLogCreateEventEnum_conflictDetected,
  _$syncLogCreateEventEnum_authorizationRefreshed,
  _$syncLogCreateEventEnum_backupCreated,
  _$syncLogCreateEventEnum_backupUpdated,
  _$syncLogCreateEventEnum_backupDeleted,
]);

const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_googleAuthorizationRevoked =
    const SyncLogCreateErrorDetailsEnum._('googleAuthorizationRevoked');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_driveAppdataScopeMissing =
    const SyncLogCreateErrorDetailsEnum._('driveAppdataScopeMissing');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_driveRevisionConflict =
    const SyncLogCreateErrorDetailsEnum._('driveRevisionConflict');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_driveFileMissing =
    const SyncLogCreateErrorDetailsEnum._('driveFileMissing');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_driveQuotaExceeded =
    const SyncLogCreateErrorDetailsEnum._('driveQuotaExceeded');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_networkUnavailable =
    const SyncLogCreateErrorDetailsEnum._('networkUnavailable');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_snapshotValidationFailed =
    const SyncLogCreateErrorDetailsEnum._('snapshotValidationFailed');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_restoreFailed =
    const SyncLogCreateErrorDetailsEnum._('restoreFailed');
const SyncLogCreateErrorDetailsEnum
    _$syncLogCreateErrorDetailsEnum_unknownError =
    const SyncLogCreateErrorDetailsEnum._('unknownError');

SyncLogCreateErrorDetailsEnum _$syncLogCreateErrorDetailsEnumValueOf(
    String name) {
  switch (name) {
    case 'googleAuthorizationRevoked':
      return _$syncLogCreateErrorDetailsEnum_googleAuthorizationRevoked;
    case 'driveAppdataScopeMissing':
      return _$syncLogCreateErrorDetailsEnum_driveAppdataScopeMissing;
    case 'driveRevisionConflict':
      return _$syncLogCreateErrorDetailsEnum_driveRevisionConflict;
    case 'driveFileMissing':
      return _$syncLogCreateErrorDetailsEnum_driveFileMissing;
    case 'driveQuotaExceeded':
      return _$syncLogCreateErrorDetailsEnum_driveQuotaExceeded;
    case 'networkUnavailable':
      return _$syncLogCreateErrorDetailsEnum_networkUnavailable;
    case 'snapshotValidationFailed':
      return _$syncLogCreateErrorDetailsEnum_snapshotValidationFailed;
    case 'restoreFailed':
      return _$syncLogCreateErrorDetailsEnum_restoreFailed;
    case 'unknownError':
      return _$syncLogCreateErrorDetailsEnum_unknownError;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SyncLogCreateErrorDetailsEnum>
    _$syncLogCreateErrorDetailsEnumValues = BuiltSet<
        SyncLogCreateErrorDetailsEnum>(const <SyncLogCreateErrorDetailsEnum>[
  _$syncLogCreateErrorDetailsEnum_googleAuthorizationRevoked,
  _$syncLogCreateErrorDetailsEnum_driveAppdataScopeMissing,
  _$syncLogCreateErrorDetailsEnum_driveRevisionConflict,
  _$syncLogCreateErrorDetailsEnum_driveFileMissing,
  _$syncLogCreateErrorDetailsEnum_driveQuotaExceeded,
  _$syncLogCreateErrorDetailsEnum_networkUnavailable,
  _$syncLogCreateErrorDetailsEnum_snapshotValidationFailed,
  _$syncLogCreateErrorDetailsEnum_restoreFailed,
  _$syncLogCreateErrorDetailsEnum_unknownError,
]);

Serializer<SyncLogCreateEventEnum> _$syncLogCreateEventEnumSerializer =
    _$SyncLogCreateEventEnumSerializer();
Serializer<SyncLogCreateErrorDetailsEnum>
    _$syncLogCreateErrorDetailsEnumSerializer =
    _$SyncLogCreateErrorDetailsEnumSerializer();

class _$SyncLogCreateEventEnumSerializer
    implements PrimitiveSerializer<SyncLogCreateEventEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'syncStarted': 'sync_started',
    'syncCompleted': 'sync_completed',
    'syncFailed': 'sync_failed',
    'conflictDetected': 'conflict_detected',
    'authorizationRefreshed': 'authorization_refreshed',
    'backupCreated': 'backup_created',
    'backupUpdated': 'backup_updated',
    'backupDeleted': 'backup_deleted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'sync_started': 'syncStarted',
    'sync_completed': 'syncCompleted',
    'sync_failed': 'syncFailed',
    'conflict_detected': 'conflictDetected',
    'authorization_refreshed': 'authorizationRefreshed',
    'backup_created': 'backupCreated',
    'backup_updated': 'backupUpdated',
    'backup_deleted': 'backupDeleted',
  };

  @override
  final Iterable<Type> types = const <Type>[SyncLogCreateEventEnum];
  @override
  final String wireName = 'SyncLogCreateEventEnum';

  @override
  Object serialize(Serializers serializers, SyncLogCreateEventEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncLogCreateEventEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncLogCreateEventEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SyncLogCreateErrorDetailsEnumSerializer
    implements PrimitiveSerializer<SyncLogCreateErrorDetailsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'googleAuthorizationRevoked': 'google_authorization_revoked',
    'driveAppdataScopeMissing': 'drive_appdata_scope_missing',
    'driveRevisionConflict': 'drive_revision_conflict',
    'driveFileMissing': 'drive_file_missing',
    'driveQuotaExceeded': 'drive_quota_exceeded',
    'networkUnavailable': 'network_unavailable',
    'snapshotValidationFailed': 'snapshot_validation_failed',
    'restoreFailed': 'restore_failed',
    'unknownError': 'unknown_error',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'google_authorization_revoked': 'googleAuthorizationRevoked',
    'drive_appdata_scope_missing': 'driveAppdataScopeMissing',
    'drive_revision_conflict': 'driveRevisionConflict',
    'drive_file_missing': 'driveFileMissing',
    'drive_quota_exceeded': 'driveQuotaExceeded',
    'network_unavailable': 'networkUnavailable',
    'snapshot_validation_failed': 'snapshotValidationFailed',
    'restore_failed': 'restoreFailed',
    'unknown_error': 'unknownError',
  };

  @override
  final Iterable<Type> types = const <Type>[SyncLogCreateErrorDetailsEnum];
  @override
  final String wireName = 'SyncLogCreateErrorDetailsEnum';

  @override
  Object serialize(
          Serializers serializers, SyncLogCreateErrorDetailsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncLogCreateErrorDetailsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncLogCreateErrorDetailsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SyncLogCreate extends SyncLogCreate {
  @override
  final String idDevice;
  @override
  final String? idBackupFile;
  @override
  final String? idGoogleAccount;
  @override
  final String? idempotencyKey;
  @override
  final SyncLogCreateEventEnum event;
  @override
  final SyncDirection derection;
  @override
  final SyncResult result;
  @override
  final ConflictStrategy? conflictStrategy;
  @override
  final SyncLogCreateErrorDetailsEnum? errorDetails;
  @override
  final BuiltMap<String, JsonObject?>? metadata;

  factory _$SyncLogCreate([void Function(SyncLogCreateBuilder)? updates]) =>
      (SyncLogCreateBuilder()..update(updates))._build();

  _$SyncLogCreate._(
      {required this.idDevice,
      this.idBackupFile,
      this.idGoogleAccount,
      this.idempotencyKey,
      required this.event,
      required this.derection,
      required this.result,
      this.conflictStrategy,
      this.errorDetails,
      this.metadata})
      : super._();
  @override
  SyncLogCreate rebuild(void Function(SyncLogCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncLogCreateBuilder toBuilder() => SyncLogCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncLogCreate &&
        idDevice == other.idDevice &&
        idBackupFile == other.idBackupFile &&
        idGoogleAccount == other.idGoogleAccount &&
        idempotencyKey == other.idempotencyKey &&
        event == other.event &&
        derection == other.derection &&
        result == other.result &&
        conflictStrategy == other.conflictStrategy &&
        errorDetails == other.errorDetails &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idDevice.hashCode);
    _$hash = $jc(_$hash, idBackupFile.hashCode);
    _$hash = $jc(_$hash, idGoogleAccount.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, derection.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, conflictStrategy.hashCode);
    _$hash = $jc(_$hash, errorDetails.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncLogCreate')
          ..add('idDevice', idDevice)
          ..add('idBackupFile', idBackupFile)
          ..add('idGoogleAccount', idGoogleAccount)
          ..add('idempotencyKey', idempotencyKey)
          ..add('event', event)
          ..add('derection', derection)
          ..add('result', result)
          ..add('conflictStrategy', conflictStrategy)
          ..add('errorDetails', errorDetails)
          ..add('metadata', metadata))
        .toString();
  }
}

class SyncLogCreateBuilder
    implements Builder<SyncLogCreate, SyncLogCreateBuilder> {
  _$SyncLogCreate? _$v;

  String? _idDevice;
  String? get idDevice => _$this._idDevice;
  set idDevice(String? idDevice) => _$this._idDevice = idDevice;

  String? _idBackupFile;
  String? get idBackupFile => _$this._idBackupFile;
  set idBackupFile(String? idBackupFile) => _$this._idBackupFile = idBackupFile;

  String? _idGoogleAccount;
  String? get idGoogleAccount => _$this._idGoogleAccount;
  set idGoogleAccount(String? idGoogleAccount) =>
      _$this._idGoogleAccount = idGoogleAccount;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

  SyncLogCreateEventEnum? _event;
  SyncLogCreateEventEnum? get event => _$this._event;
  set event(SyncLogCreateEventEnum? event) => _$this._event = event;

  SyncDirection? _derection;
  SyncDirection? get derection => _$this._derection;
  set derection(SyncDirection? derection) => _$this._derection = derection;

  SyncResult? _result;
  SyncResult? get result => _$this._result;
  set result(SyncResult? result) => _$this._result = result;

  ConflictStrategy? _conflictStrategy;
  ConflictStrategy? get conflictStrategy => _$this._conflictStrategy;
  set conflictStrategy(ConflictStrategy? conflictStrategy) =>
      _$this._conflictStrategy = conflictStrategy;

  SyncLogCreateErrorDetailsEnum? _errorDetails;
  SyncLogCreateErrorDetailsEnum? get errorDetails => _$this._errorDetails;
  set errorDetails(SyncLogCreateErrorDetailsEnum? errorDetails) =>
      _$this._errorDetails = errorDetails;

  MapBuilder<String, JsonObject?>? _metadata;
  MapBuilder<String, JsonObject?> get metadata =>
      _$this._metadata ??= MapBuilder<String, JsonObject?>();
  set metadata(MapBuilder<String, JsonObject?>? metadata) =>
      _$this._metadata = metadata;

  SyncLogCreateBuilder() {
    SyncLogCreate._defaults(this);
  }

  SyncLogCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idDevice = $v.idDevice;
      _idBackupFile = $v.idBackupFile;
      _idGoogleAccount = $v.idGoogleAccount;
      _idempotencyKey = $v.idempotencyKey;
      _event = $v.event;
      _derection = $v.derection;
      _result = $v.result;
      _conflictStrategy = $v.conflictStrategy;
      _errorDetails = $v.errorDetails;
      _metadata = $v.metadata?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncLogCreate other) {
    _$v = other as _$SyncLogCreate;
  }

  @override
  void update(void Function(SyncLogCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncLogCreate build() => _build();

  _$SyncLogCreate _build() {
    _$SyncLogCreate _$result;
    try {
      _$result = _$v ??
          _$SyncLogCreate._(
            idDevice: BuiltValueNullFieldError.checkNotNull(
                idDevice, r'SyncLogCreate', 'idDevice'),
            idBackupFile: idBackupFile,
            idGoogleAccount: idGoogleAccount,
            idempotencyKey: idempotencyKey,
            event: BuiltValueNullFieldError.checkNotNull(
                event, r'SyncLogCreate', 'event'),
            derection: BuiltValueNullFieldError.checkNotNull(
                derection, r'SyncLogCreate', 'derection'),
            result: BuiltValueNullFieldError.checkNotNull(
                result, r'SyncLogCreate', 'result'),
            conflictStrategy: conflictStrategy,
            errorDetails: errorDetails,
            metadata: _metadata?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metadata';
        _metadata?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SyncLogCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
