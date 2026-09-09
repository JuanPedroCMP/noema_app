import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceFingerprint {
  static const _storage = FlutterSecureStorage();
  static const _key = 'device_fingerprint';

  static Future<String> get() async {
    final existing = await _storage.read(key: _key);

    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final fingerprint = const Uuid().v4();

    await _storage.write(
      key: _key,
      value: fingerprint,
    );

    return fingerprint;
  }
}