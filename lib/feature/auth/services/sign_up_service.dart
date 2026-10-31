import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:openapi/openapi.dart';

class SignUpService {
  const SignUpService(this.userApi);

  final UserApi userApi;

  Future<void> createUser({
    required String userName,
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await userApi.newUserApiV1UserCreatePost(
      userCreate: UserCreate(
        (builder) => builder
          ..password = password
          ..primaryEmail = email
          ..userDisplayName = displayName
          ..userName = userName,
      ),
    );
    if (response.data == null) {
      throw StateError('O servidor não confirmou a criação da conta.');
    }
  }
}

final signUpServiceProvider = Provider<SignUpService>(
  (ref) => SignUpService(ref.watch(userApiProvider)),
);
