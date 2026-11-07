import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/manual_backup_archive.dart';

void main() {
  const accountId = 'noema-user-id-for-testing';
  final snapshot = Uint8List.fromList(utf8.encode('{"snapshot":"test-data"}'));

  test('round trips the compacted plaintext archive', () async {
    final archive = await ManualBackupArchive.encode(
      snapshotBytes: snapshot,
      accountId: accountId,
      encrypt: false,
    );

    expect(archive.take(2), [0x50, 0x4b]);
    expect(ManualBackupArchive.encryptionMode(archive), isNull);
    final decoded = await ManualBackupArchive.decode(
      bytes: archive,
      accountId: accountId,
    );

    expect(decoded.encrypted, isFalse);
    expect(decoded.snapshotBytes, snapshot);
  });

  test('round trips AES-GCM encryption derived from the account ID', () async {
    final archive = await ManualBackupArchive.encode(
      snapshotBytes: snapshot,
      accountId: accountId,
      encrypt: true,
    );

    expect(
      ManualBackupArchive.encryptionMode(archive),
      ManualBackupKeyMode.accountId,
    );
    final decoded = await ManualBackupArchive.decode(
      bytes: archive,
      accountId: accountId,
    );

    expect(decoded.encrypted, isTrue);
    expect(decoded.snapshotBytes, snapshot);
  });

  test('requires the correct custom key to decrypt a backup', () async {
    final archive = await ManualBackupArchive.encode(
      snapshotBytes: snapshot,
      accountId: accountId,
      encrypt: true,
      keyMode: ManualBackupKeyMode.custom,
      customKey: 'uma-chave-personalizada-segura',
    );

    expect(
      ManualBackupArchive.encryptionMode(archive),
      ManualBackupKeyMode.custom,
    );
    await expectLater(
      ManualBackupArchive.decode(
        bytes: archive,
        accountId: accountId,
        customKey: 'chave-incorreta',
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('chave está incorreta'),
        ),
      ),
    );
    final decoded = await ManualBackupArchive.decode(
      bytes: archive,
      accountId: accountId,
      customKey: 'uma-chave-personalizada-segura',
    );
    expect(decoded.snapshotBytes, snapshot);
  });
}
