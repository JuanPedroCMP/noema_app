import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';

const maxManualBackupBytes = 400 * 1024 * 1024;
const _encryptedPrefix = 'NOEMA-ENCRYPTED-BACKUP-1\n';
const _archiveFormat = 'noema-manual-backup';
const _archiveVersion = 1;
const _pbkdf2Iterations = 310000;
const _associatedData = 'noema-manual-backup:v1';

enum ManualBackupKeyMode { accountId, custom }

class DecodedManualBackup {
  const DecodedManualBackup({
    required this.snapshotBytes,
    required this.encrypted,
  });

  final Uint8List snapshotBytes;
  final bool encrypted;
}

class ManualBackupArchive {
  static ManualBackupKeyMode? encryptionMode(List<int> bytes) {
    if (!_hasEncryptedPrefix(bytes)) return null;
    final envelope = _decodeEnvelope(bytes);
    return switch (envelope['key_mode']) {
      'account_id' => ManualBackupKeyMode.accountId,
      'custom' => ManualBackupKeyMode.custom,
      _ => throw const FormatException(
        'O arquivo criptografado usa um modo de chave desconhecido.',
      ),
    };
  }

  static Future<Uint8List> encode({
    required Uint8List snapshotBytes,
    required String accountId,
    required bool encrypt,
    ManualBackupKeyMode keyMode = ManualBackupKeyMode.accountId,
    String? customKey,
  }) async {
    if (snapshotBytes.isEmpty || snapshotBytes.length > maxLocalSnapshotBytes) {
      throw const FormatException(
        'O snapshot está vazio ou excede o limite suportado pelo app.',
      );
    }

    final digest = sha256.convert(snapshotBytes).toString();
    final manifestBytes = utf8.encode(
      jsonEncode({
        'format': _archiveFormat,
        'version': _archiveVersion,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'snapshot_size_bytes': snapshotBytes.length,
        'snapshot_sha256': digest,
      }),
    );
    final zipped = await compute(_encodeZip, <String, Uint8List>{
      'manifest': Uint8List.fromList(manifestBytes),
      'snapshot': snapshotBytes,
    });
    if (zipped.length > maxManualBackupBytes) {
      throw const FormatException(
        'O arquivo compactado excede o limite seguro de 400 MiB.',
      );
    }
    if (!encrypt) return zipped;

    final password = keyMode == ManualBackupKeyMode.accountId
        ? accountId
        : customKey;
    if (password == null || password.isEmpty) {
      throw const FormatException(
        'Informe uma chave para criptografar o backup.',
      );
    }
    if (keyMode == ManualBackupKeyMode.custom && password.trim().length < 12) {
      throw const FormatException(
        'A chave personalizada deve ter pelo menos 12 caracteres.',
      );
    }

    final salt = _secureRandomBytes(16);
    final cipher = AesGcm.with256bits();
    final nonce = cipher.newNonce();
    final key = await _deriveKey(password, salt);
    final box = await cipher.encrypt(
      zipped,
      secretKey: key,
      nonce: nonce,
      aad: utf8.encode(_associatedData),
    );
    final envelope = utf8.encode(
      jsonEncode({
        'format': _archiveFormat,
        'version': _archiveVersion,
        'key_mode': keyMode == ManualBackupKeyMode.accountId
            ? 'account_id'
            : 'custom',
        'kdf': 'pbkdf2-hmac-sha256',
        'iterations': _pbkdf2Iterations,
        'salt': base64Encode(salt),
        'nonce': base64Encode(box.nonce),
        'ciphertext': base64Encode(box.cipherText),
        'mac': base64Encode(box.mac.bytes),
      }),
    );
    final result = Uint8List.fromList([
      ...utf8.encode(_encryptedPrefix),
      ...envelope,
    ]);
    if (result.length > maxManualBackupBytes) {
      throw const FormatException(
        'O arquivo criptografado excede o limite seguro de 400 MiB.',
      );
    }
    return result;
  }

  static Future<DecodedManualBackup> decode({
    required Uint8List bytes,
    required String accountId,
    String? customKey,
  }) async {
    if (bytes.isEmpty || bytes.length > maxManualBackupBytes) {
      throw const FormatException(
        'O arquivo está vazio ou excede o limite seguro de 400 MiB.',
      );
    }
    Uint8List archiveBytes;
    final encrypted = _hasEncryptedPrefix(bytes);
    if (encrypted) {
      final envelope = _decodeEnvelope(bytes);
      final mode = switch (envelope['key_mode']) {
        'account_id' => ManualBackupKeyMode.accountId,
        'custom' => ManualBackupKeyMode.custom,
        _ => throw const FormatException(
          'O arquivo criptografado usa um modo de chave desconhecido.',
        ),
      };
      final password = mode == ManualBackupKeyMode.accountId
          ? accountId
          : customKey;
      if (password == null || password.isEmpty) {
        throw const FormatException(
          'Este backup exige a chave personalizada usada na exportação.',
        );
      }

      final salt = _decodeBase64Field(envelope, 'salt', expectedLength: 16);
      final nonce = _decodeBase64Field(envelope, 'nonce', expectedLength: 12);
      final ciphertext = _decodeBase64Field(
        envelope,
        'ciphertext',
        minLength: 1,
      );
      final mac = _decodeBase64Field(envelope, 'mac', expectedLength: 16);
      final iterations = envelope['iterations'];
      if (iterations is! int || iterations < 100000 || iterations > 1000000) {
        throw const FormatException(
          'A configuração de criptografia deste arquivo não é suportada.',
        );
      }
      final key = await _deriveKey(password, salt, iterations: iterations);
      try {
        archiveBytes = Uint8List.fromList(
          await AesGcm.with256bits().decrypt(
            SecretBox(ciphertext, nonce: nonce, mac: Mac(mac)),
            secretKey: key,
            aad: utf8.encode(_associatedData),
          ),
        );
      } on SecretBoxAuthenticationError {
        throw const FormatException(
          'A chave está incorreta ou o arquivo criptografado foi danificado.',
        );
      }
    } else {
      archiveBytes = bytes;
    }

    final decoded = await compute(_decodeZip, archiveBytes);
    return DecodedManualBackup(snapshotBytes: decoded, encrypted: encrypted);
  }

  static Map<String, dynamic> _decodeEnvelope(List<int> bytes) {
    if (bytes.length <= _encryptedPrefix.length) {
      throw const FormatException('O arquivo criptografado está incompleto.');
    }
    try {
      final raw = jsonDecode(
        utf8.decode(bytes.sublist(_encryptedPrefix.length)),
      );
      if (raw is! Map<String, dynamic> ||
          raw['format'] != _archiveFormat ||
          raw['version'] != _archiveVersion ||
          raw['kdf'] != 'pbkdf2-hmac-sha256') {
        throw const FormatException(
          'O cabeçalho do backup criptografado é inválido.',
        );
      }
      return raw;
    } on FormatException {
      rethrow;
    }
  }

  static Uint8List _decodeZip(List<int> bytes) {
    if (bytes.length < 4 ||
        bytes[0] != 0x50 ||
        bytes[1] != 0x4b ||
        bytes.length > maxManualBackupBytes) {
      throw const FormatException(
        'O arquivo não é um backup compactado Noema reconhecido.',
      );
    }

    late final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes, verify: true);
    } on ArchiveException {
      throw const FormatException(
        'O arquivo compactado está inválido ou corrompido.',
      );
    } on RangeError {
      throw const FormatException(
        'O arquivo compactado está truncado ou corrompido.',
      );
    }
    if (archive.length != 2) {
      throw const FormatException(
        'O backup deve conter somente o manifesto e o snapshot Noema.',
      );
    }
    final files = <String, ArchiveFile>{};
    for (final entry in archive) {
      if (!entry.isFile ||
          (entry.name != 'manifest.json' && entry.name != 'snapshot.json') ||
          files.containsKey(entry.name)) {
        throw const FormatException(
          'O arquivo compactado contém entradas inesperadas.',
        );
      }
      files[entry.name] = entry;
    }
    final manifestFile = files['manifest.json'];
    final snapshotFile = files['snapshot.json'];
    if (manifestFile == null ||
        snapshotFile == null ||
        manifestFile.size > 64 * 1024 ||
        snapshotFile.size <= 0 ||
        snapshotFile.size > maxLocalSnapshotBytes) {
      throw const FormatException(
        'O manifesto ou snapshot do backup está ausente ou excede o limite.',
      );
    }

    final Uint8List snapshotBytes;
    final Map<String, dynamic> manifest;
    try {
      final decodedManifest = jsonDecode(utf8.decode(manifestFile.content));
      if (decodedManifest is! Map<String, dynamic>) {
        throw const FormatException('Manifesto inválido.');
      }
      manifest = decodedManifest;
      snapshotBytes = snapshotFile.content;
    } on FormatException {
      throw const FormatException('O manifesto do backup está inválido.');
    }
    if (manifest['format'] != _archiveFormat ||
        manifest['version'] != _archiveVersion ||
        manifest['snapshot_size_bytes'] != snapshotBytes.length ||
        manifest['snapshot_sha256'] !=
            sha256.convert(snapshotBytes).toString()) {
      throw const FormatException(
        'A integridade do snapshot não corresponde ao manifesto.',
      );
    }
    return snapshotBytes;
  }

  static Uint8List _encodeZip(Map<String, Uint8List> contents) {
    final manifest = contents['manifest']!;
    final snapshot = contents['snapshot']!;
    final archive = Archive()
      ..addFile(ArchiveFile('manifest.json', manifest.length, manifest))
      ..addFile(ArchiveFile('snapshot.json', snapshot.length, snapshot));
    return ZipEncoder().encodeBytes(
      archive,
      level: DeflateLevel.bestCompression,
    );
  }

  static Uint8List _decodeBase64Field(
    Map<String, dynamic> envelope,
    String name, {
    int? expectedLength,
    int? minLength,
  }) {
    final value = envelope[name];
    if (value is! String) {
      throw const FormatException('O cabeçalho de criptografia está inválido.');
    }
    late final Uint8List bytes;
    try {
      bytes = Uint8List.fromList(base64Decode(value));
    } on FormatException {
      throw const FormatException('O cabeçalho de criptografia está inválido.');
    }
    if ((expectedLength != null && bytes.length != expectedLength) ||
        (minLength != null && bytes.length < minLength)) {
      throw const FormatException('O cabeçalho de criptografia está inválido.');
    }
    return bytes;
  }

  static Future<SecretKey> _deriveKey(
    String password,
    List<int> salt, {
    int iterations = _pbkdf2Iterations,
  }) {
    return Pbkdf2.hmacSha256(
      iterations: iterations,
      bits: 256,
    ).deriveKeyFromPassword(password: password, nonce: salt);
  }

  static List<int> _secureRandomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  static bool _hasEncryptedPrefix(List<int> bytes) {
    final prefix = utf8.encode(_encryptedPrefix);
    if (bytes.length < prefix.length) return false;
    for (var index = 0; index < prefix.length; index++) {
      if (bytes[index] != prefix[index]) return false;
    }
    return true;
  }
}
