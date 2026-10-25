// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SyncLogOutCWProxy {
  SyncLogOut id(String id);

  SyncLogOut idDevice(String idDevice);

  SyncLogOut idBackupFile(String idBackupFile);

  SyncLogOut event(String event);

  SyncLogOut derection(SyncDirection derection);

  SyncLogOut result(SyncResult result);

  SyncLogOut conflictStrategy(ConflictStrategy conflictStrategy);

  SyncLogOut errorDetails(String errorDetails);

  SyncLogOut metadata(Map<String, Object> metadata);

  SyncLogOut createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `SyncLogOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SyncLogOut(...).copyWith(id: 12, name: "My name")
  /// ```
  SyncLogOut call({
    String id,
    String idDevice,
    String idBackupFile,
    String event,
    SyncDirection derection,
    SyncResult result,
    ConflictStrategy conflictStrategy,
    String errorDetails,
    Map<String, Object> metadata,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSyncLogOut.copyWith(...)` or call `instanceOfSyncLogOut.copyWith.fieldName(value)` for a single field.
class _$SyncLogOutCWProxyImpl implements _$SyncLogOutCWProxy {
  const _$SyncLogOutCWProxyImpl(this._value);

  final SyncLogOut _value;

  @override
  SyncLogOut id(String id) => call(id: id);

  @override
  SyncLogOut idDevice(String idDevice) => call(idDevice: idDevice);

  @override
  SyncLogOut idBackupFile(String idBackupFile) =>
      call(idBackupFile: idBackupFile);

  @override
  SyncLogOut event(String event) => call(event: event);

  @override
  SyncLogOut derection(SyncDirection derection) => call(derection: derection);

  @override
  SyncLogOut result(SyncResult result) => call(result: result);

  @override
  SyncLogOut conflictStrategy(ConflictStrategy conflictStrategy) =>
      call(conflictStrategy: conflictStrategy);

  @override
  SyncLogOut errorDetails(String errorDetails) =>
      call(errorDetails: errorDetails);

  @override
  SyncLogOut metadata(Map<String, Object> metadata) => call(metadata: metadata);

  @override
  SyncLogOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `SyncLogOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SyncLogOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  SyncLogOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idDevice = const $CopyWithPlaceholder(),
    Object? idBackupFile = const $CopyWithPlaceholder(),
    Object? event = const $CopyWithPlaceholder(),
    Object? derection = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
    Object? conflictStrategy = const $CopyWithPlaceholder(),
    Object? errorDetails = const $CopyWithPlaceholder(),
    Object? metadata = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return SyncLogOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idDevice: idDevice == const $CopyWithPlaceholder() || idDevice == null
          ? _value.idDevice
          // ignore: cast_nullable_to_non_nullable
          : idDevice as String,
      idBackupFile:
          idBackupFile == const $CopyWithPlaceholder() || idBackupFile == null
          ? _value.idBackupFile
          // ignore: cast_nullable_to_non_nullable
          : idBackupFile as String,
      event: event == const $CopyWithPlaceholder() || event == null
          ? _value.event
          // ignore: cast_nullable_to_non_nullable
          : event as String,
      derection: derection == const $CopyWithPlaceholder() || derection == null
          ? _value.derection
          // ignore: cast_nullable_to_non_nullable
          : derection as SyncDirection,
      result: result == const $CopyWithPlaceholder() || result == null
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as SyncResult,
      conflictStrategy:
          conflictStrategy == const $CopyWithPlaceholder() ||
              conflictStrategy == null
          ? _value.conflictStrategy
          // ignore: cast_nullable_to_non_nullable
          : conflictStrategy as ConflictStrategy,
      errorDetails:
          errorDetails == const $CopyWithPlaceholder() || errorDetails == null
          ? _value.errorDetails
          // ignore: cast_nullable_to_non_nullable
          : errorDetails as String,
      metadata: metadata == const $CopyWithPlaceholder() || metadata == null
          ? _value.metadata
          // ignore: cast_nullable_to_non_nullable
          : metadata as Map<String, Object>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $SyncLogOutCopyWith on SyncLogOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSyncLogOut.copyWith(...)` or `instanceOfSyncLogOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SyncLogOutCWProxy get copyWith => _$SyncLogOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncLogOut _$SyncLogOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'SyncLogOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'id_device',
        'id_backup_file',
        'event',
        'derection',
        'result',
        'conflict_strategy',
        'error_details',
        'metadata',
        'created_at',
      ],
    );
    final val = SyncLogOut(
      id: $checkedConvert('id', (v) => v as String),
      idDevice: $checkedConvert('id_device', (v) => v as String),
      idBackupFile: $checkedConvert('id_backup_file', (v) => v as String),
      event: $checkedConvert('event', (v) => v as String),
      derection: $checkedConvert(
        'derection',
        (v) => $enumDecode(_$SyncDirectionEnumMap, v),
      ),
      result: $checkedConvert(
        'result',
        (v) => $enumDecode(_$SyncResultEnumMap, v),
      ),
      conflictStrategy: $checkedConvert(
        'conflict_strategy',
        (v) => $enumDecode(_$ConflictStrategyEnumMap, v),
      ),
      errorDetails: $checkedConvert('error_details', (v) => v as String),
      metadata: $checkedConvert(
        'metadata',
        (v) =>
            (v as Map<String, dynamic>).map((k, e) => MapEntry(k, e as Object)),
      ),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'idDevice': 'id_device',
    'idBackupFile': 'id_backup_file',
    'conflictStrategy': 'conflict_strategy',
    'errorDetails': 'error_details',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$SyncLogOutToJson(
  SyncLogOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_device': instance.idDevice,
  'id_backup_file': instance.idBackupFile,
  'event': instance.event,
  'derection': _$SyncDirectionEnumMap[instance.derection]!,
  'result': _$SyncResultEnumMap[instance.result]!,
  'conflict_strategy': _$ConflictStrategyEnumMap[instance.conflictStrategy]!,
  'error_details': instance.errorDetails,
  'metadata': instance.metadata,
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$SyncDirectionEnumMap = {
  SyncDirection.upload: 'upload',
  SyncDirection.download: 'download',
};

const _$SyncResultEnumMap = {
  SyncResult.success: 'success',
  SyncResult.failure: 'failure',
  SyncResult.inConflict: 'in_conflict',
};

const _$ConflictStrategyEnumMap = {
  ConflictStrategy.keepLocal: 'keep_local',
  ConflictStrategy.keepRemote: 'keep_remote',
  ConflictStrategy.merge: 'merge',
  ConflictStrategy.duplicate: 'duplicate',
};
