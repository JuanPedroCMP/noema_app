import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final apiClientProvider = Provider<Openapi>((ref) {
  final client = Openapi(basePathOverride: "https://api.tccnoema.me");
  client.dio.options.receiveTimeout = const Duration(minutes: 2);
  client.dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final security = options.extra['secure'];
        final requiresOAuth =
            security is List &&
            security.any(
              (entry) =>
                  entry is Map &&
                  (entry['type'] == 'oauth' || entry['type'] == 'oauth2') &&
                  entry['name'] == 'OAuth2PasswordBearer',
            );
        final authorization = client.dio.options.headers['Authorization'];
        if (requiresOAuth && authorization is String) {
          options.headers['Authorization'] = authorization;
        }
        handler.next(options);
      },
    ),
  );
  ref.onDispose(() => client.dio.close(force: true));
  return client;
  // return Openapi(basePathOverride: "https://apiv2.tccnoema.me/");
  // return Openapi(basePathOverride: "http://127.0.0.1:8000");
});

void setApiAccessToken(Openapi client, String token) {
  client.setOAuthToken('OAuth2PasswordBearer', token);
  client.dio.options.headers['Authorization'] = ['Bearer', token].join(' ');
}

void clearApiAccessToken(Openapi client) {
  client.removeOAuthToken('OAuth2PasswordBearer');
  client.dio.options.headers.remove('Authorization');
}

final userApiProvider = Provider((ref) {
  return ref.watch(apiClientProvider).getUserApi();
});

final authApiProvider = Provider((ref) {
  return ref.watch(apiClientProvider).getAuthenticationApi();
});
