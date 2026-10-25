// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_file_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackupFileOutCWProxy {
  BackupFileOut id(String id);

  BackupFileOut idGoogleAccount(String idGoogleAccount);

  BackupFileOut driveFileId(String driveFileId);

  BackupFileOut localRef(String localRef);

  BackupFileOut driveVersion(String driveVersion);

  BackupFileOut contentHash(String contentHash);

  BackupFileOut createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `BackupFileOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BackupFileOut(...).copyWith(id: 12, name: "My name")
  /// ```
  BackupFileOut call({
    String id,
    String idGoogleAccount,
    String driveFileId,
    String localRef,
    String driveVersion,
    String contentHash,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfBackupFileOut.copyWith(...)` or call `instanceOfBackupFileOut.copyWith.fieldName(value)` for a single field.
class _$BackupFileOutCWProxyImpl implements _$BackupFileOutCWProxy {
  const _$BackupFileOutCWProxyImpl(this._value);

  final BackupFileOut _value;

  @override
  BackupFileOut id(String id) => call(id: id);

  @override
  BackupFileOut idGoogleAccount(String idGoogleAccount) =>
      call(idGoogleAccount: idGoogleAccount);

  @override
  BackupFileOut driveFileId(String driveFileId) =>
      call(driveFileId: driveFileId);

  @override
  BackupFileOut localRef(String localRef) => call(localRef: localRef);

  @override
  BackupFileOut driveVersion(String driveVersion) =>
      call(driveVersion: driveVersion);

  @override
  BackupFileOut contentHash(String contentHash) =>
      call(contentHash: contentHash);

  @override
  BackupFileOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `BackupFileOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BackupFileOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  BackupFileOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idGoogleAccount = const $CopyWithPlaceholder(),
    Object? driveFileId = const $CopyWithPlaceholder(),
    Object? localRef = const $CopyWithPlaceholder(),
    Object? driveVersion = const $CopyWithPlaceholder(),
    Object? contentHash = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return BackupFileOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      idGoogleAccount:
          idGoogleAccount == const $CopyWithPlaceholder() ||
              idGoogleAccount == null
          ? _value.idGoogleAccount
          // ignore: cast_nullable_to_non_nullable
          : idGoogleAccount as String,
      driveFileId:
          driveFileId == const $CopyWithPlaceholder() || driveFileId == null
          ? _value.driveFileId
          // ignore: cast_nullable_to_non_nullable
          : driveFileId as String,
      localRef: localRef == const $CopyWithPlaceholder() || localRef == null
          ? _value.localRef
          // ignore: cast_nullable_to_non_nullable
          : localRef as String,
      driveVersion:
          driveVersion == const $CopyWithPlaceholder() || driveVersion == null
          ? _value.driveVersion
          // ignore: cast_nullable_to_non_nullable
          : driveVersion as String,
      contentHash:
          contentHash == const $CopyWithPlaceholder() || contentHash == null
          ? _value.contentHash
          // ignore: cast_nullable_to_non_nullable
          : contentHash as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $BackupFileOutCopyWith on BackupFileOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfBackupFileOut.copyWith(...)` or `instanceOfBackupFileOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BackupFileOutCWProxy get copyWith => _$BackupFileOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupFileOut _$BackupFileOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BackupFileOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_google_account',
            'drive_file_id',
            'local_ref',
            'drive_version',
            'content_hash',
            'created_at',
          ],
        );
        final val = BackupFileOut(
          id: $checkedConvert('id', (v) => v as String),
          idGoogleAccount: $checkedConvert(
            'id_google_account',
            (v) => v as String,
          ),
          driveFileId: $checkedConvert('drive_file_id', (v) => v as String),
          localRef: $checkedConvert('local_ref', (v) => v as String),
          driveVersion: $checkedConvert('drive_version', (v) => v as String),
          contentHash: $checkedConvert('content_hash', (v) => v as String),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'idGoogleAccount': 'id_google_account',
        'driveFileId': 'drive_file_id',
        'localRef': 'local_ref',
        'driveVersion': 'drive_version',
        'contentHash': 'content_hash',
        'createdAt': 'created_at',
      },
    );

Map<String, dynamic> _$BackupFileOutToJson(BackupFileOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_google_account': instance.idGoogleAccount,
      'drive_file_id': instance.driveFileId,
      'local_ref': instance.localRef,
      'drive_version': instance.driveVersion,
      'content_hash': instance.contentHash,
      'created_at': instance.createdAt?.toIso8601String(),
    };
