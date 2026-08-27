import 'package:built_value/json_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:openapi/openapi.dart';

final secureSorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class LoginService {
  final AuthenticationApi authApi;
  final FlutterSecureStorage storage;
  final Ref ref;

  LoginService(this.authApi, this.storage, this.ref);

  Future<String> login({required String user, required String password}) async {
    final response = await authApi.authenticateApiV1AuthLoginPost(
      username: user,
      password: password,
    );

    final data = response.data?.asMap;
    final token = data?["access_token"] as String;

    if (token.isEmpty) {
      throw StateError("Token não veio");
    }

    await storage.write(key: "access_token", value: token);

    ref.read(apiClientProvider).setOAuthToken("OAuth2PasswordBearer", token);

    return token;
  }
}

final loginServiceProvider = Provider((ref) {
  return LoginService(
    ref.read(authApiProvider),
    ref.read(secureSorageProvider),
    ref,
  );
});
