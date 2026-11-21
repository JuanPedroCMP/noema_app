import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

class UserPreferencesApi {
  const UserPreferencesApi(this._client);

  static const _path = '/api/v1/user_config/preferences';

  final Openapi _client;

  Future<Map<String, dynamic>> getPreferences() async {
    final response = await _client.dio.get<Map<String, dynamic>>(_path);
    return _decodePreferences(response.data);
  }

  Future<Map<String, dynamic>> replacePreferences(
    Map<String, dynamic> preferences,
  ) async {
    final response = await _client.dio.put<Map<String, dynamic>>(
      _path,
      data: {'preferences': preferences},
    );
    return _decodePreferences(response.data);
  }

  Future<Map<String, dynamic>> patchPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await _client.dio.patch<Map<String, dynamic>>(
        _path,
        data: {'preferences': preferences},
      );
      return _decodePreferences(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode != 405) rethrow;
      final currentPreferences = await getPreferences();
      return replacePreferences({...currentPreferences, ...preferences});
    }
  }

  Map<String, dynamic> _decodePreferences(Map<String, dynamic>? response) {
    final preferences = response?['preferences'];
    if (preferences is! Map) {
      throw const FormatException(
        'A API retornou preferências de usuário inválidas.',
      );
    }
    return {
      for (final entry in preferences.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }
}
