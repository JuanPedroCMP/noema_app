// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_file_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackupFileCreateCWProxy {
  BackupFileCreate idGoogleAccount(String idGoogleAccount);

  BackupFileCreate driveFileId(String driveFileId);

  BackupFileCreate localRef(String localRef);

  BackupFileCreate driveVersion(String driveVersion);

  BackupFileCreate contentHash(String contentHash);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `BackupFileCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BackupFileCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  BackupFileCreate call({
    String idGoogleAccount,
    String driveFileId,
    String localRef,
    String driveVersion,
    String contentHash,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfBackupFileCreate.copyWith(...)` or call `instanceOfBackupFileCreate.copyWith.fieldName(value)` for a single field.
class _$BackupFileCreateCWProxyImpl implements _$BackupFileCreateCWProxy {
  const _$BackupFileCreateCWProxyImpl(this._value);

  final BackupFileCreate _value;

  @override
  BackupFileCreate idGoogleAccount(String idGoogleAccount) =>
      call(idGoogleAccount: idGoogleAccount);

  @override
  BackupFileCreate driveFileId(String driveFileId) =>
      call(driveFileId: driveFileId);

  @override
  BackupFileCreate localRef(String localRef) => call(localRef: localRef);

  @override
  BackupFileCreate driveVersion(String driveVersion) =>
      call(driveVersion: driveVersion);

  @override
  BackupFileCreate contentHash(String contentHash) =>
      call(contentHash: contentHash);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `BackupFileCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BackupFileCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  BackupFileCreate call({
    Object? idGoogleAccount = const $CopyWithPlaceholder(),
    Object? driveFileId = const $CopyWithPlaceholder(),
    Object? localRef = const $CopyWithPlaceholder(),
    Object? driveVersion = const $CopyWithPlaceholder(),
    Object? contentHash = const $CopyWithPlaceholder(),
  }) {
    return BackupFileCreate(
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
    );
  }
}

extension $BackupFileCreateCopyWith on BackupFileCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfBackupFileCreate.copyWith(...)` or `instanceOfBackupFileCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BackupFileCreateCWProxy get copyWith => _$BackupFileCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupFileCreate _$BackupFileCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BackupFileCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id_google_account',
            'drive_file_id',
            'local_ref',
            'drive_version',
            'content_hash',
          ],
        );
        final val = BackupFileCreate(
          idGoogleAccount: $checkedConvert(
            'id_google_account',
            (v) => v as String,
          ),
          driveFileId: $checkedConvert('drive_file_id', (v) => v as String),
          localRef: $checkedConvert('local_ref', (v) => v as String),
          driveVersion: $checkedConvert('drive_version', (v) => v as String),
          contentHash: $checkedConvert('content_hash', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'idGoogleAccount': 'id_google_account',
        'driveFileId': 'drive_file_id',
        'localRef': 'local_ref',
        'driveVersion': 'drive_version',
        'contentHash': 'content_hash',
      },
    );

Map<String, dynamic> _$BackupFileCreateToJson(BackupFileCreate instance) =>
    <String, dynamic>{
      'id_google_account': instance.idGoogleAccount,
      'drive_file_id': instance.driveFileId,
      'local_ref': instance.localRef,
      'drive_version': instance.driveVersion,
      'content_hash': instance.contentHash,
    };
