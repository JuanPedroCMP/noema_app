// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SyncLogCreateCWProxy {
  SyncLogCreate idDevice(String idDevice);

  SyncLogCreate idBackupFile(String idBackupFile);

  SyncLogCreate event(String event);

  SyncLogCreate derection(SyncDirection derection);

  SyncLogCreate result(SyncResult result);

  SyncLogCreate conflictStrategy(ConflictStrategy conflictStrategy);

  SyncLogCreate errorDetails(String errorDetails);

  SyncLogCreate metadata(String metadata);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `SyncLogCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SyncLogCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  SyncLogCreate call({
    String idDevice,
    String idBackupFile,
    String event,
    SyncDirection derection,
    SyncResult result,
    ConflictStrategy conflictStrategy,
    String errorDetails,
    String metadata,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSyncLogCreate.copyWith(...)` or call `instanceOfSyncLogCreate.copyWith.fieldName(value)` for a single field.
class _$SyncLogCreateCWProxyImpl implements _$SyncLogCreateCWProxy {
  const _$SyncLogCreateCWProxyImpl(this._value);

  final SyncLogCreate _value;

  @override
  SyncLogCreate idDevice(String idDevice) => call(idDevice: idDevice);

  @override
  SyncLogCreate idBackupFile(String idBackupFile) =>
      call(idBackupFile: idBackupFile);

  @override
  SyncLogCreate event(String event) => call(event: event);

  @override
  SyncLogCreate derection(SyncDirection derection) =>
      call(derection: derection);

  @override
  SyncLogCreate result(SyncResult result) => call(result: result);

  @override
  SyncLogCreate conflictStrategy(ConflictStrategy conflictStrategy) =>
      call(conflictStrategy: conflictStrategy);

  @override
  SyncLogCreate errorDetails(String errorDetails) =>
      call(errorDetails: errorDetails);

  @override
  SyncLogCreate metadata(String metadata) => call(metadata: metadata);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `SyncLogCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SyncLogCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  SyncLogCreate call({
    Object? idDevice = const $CopyWithPlaceholder(),
    Object? idBackupFile = const $CopyWithPlaceholder(),
    Object? event = const $CopyWithPlaceholder(),
    Object? derection = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
    Object? conflictStrategy = const $CopyWithPlaceholder(),
    Object? errorDetails = const $CopyWithPlaceholder(),
    Object? metadata = const $CopyWithPlaceholder(),
  }) {
    return SyncLogCreate(
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
          : metadata as String,
    );
  }
}

extension $SyncLogCreateCopyWith on SyncLogCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSyncLogCreate.copyWith(...)` or `instanceOfSyncLogCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SyncLogCreateCWProxy get copyWith => _$SyncLogCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncLogCreate _$SyncLogCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SyncLogCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id_device',
            'id_backup_file',
            'event',
            'derection',
            'result',
            'conflict_strategy',
            'error_details',
            'metadata',
          ],
        );
        final val = SyncLogCreate(
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
          metadata: $checkedConvert('metadata', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'idDevice': 'id_device',
        'idBackupFile': 'id_backup_file',
        'conflictStrategy': 'conflict_strategy',
        'errorDetails': 'error_details',
      },
    );

Map<String, dynamic> _$SyncLogCreateToJson(
  SyncLogCreate instance,
) => <String, dynamic>{
  'id_device': instance.idDevice,
  'id_backup_file': instance.idBackupFile,
  'event': instance.event,
  'derection': _$SyncDirectionEnumMap[instance.derection]!,
  'result': _$SyncResultEnumMap[instance.result]!,
  'conflict_strategy': _$ConflictStrategyEnumMap[instance.conflictStrategy]!,
  'error_details': instance.errorDetails,
  'metadata': instance.metadata,
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
