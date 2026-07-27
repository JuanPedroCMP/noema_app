import 'package:built_value/json_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:openapi/openapi.dart';

class SignUpService {
  final UserApi userApi;

  SignUpService(this.userApi);

  Future<JsonObject> createUser({
    required String userName,
    required String email,
    required String password,
    required String displayName,
  }) 
 
  async {

    final userCreate = UserCreate((b) => b
      ..password = password
      ..primaryEmail = email
      ..userDisplayName = displayName
      ..userName = userName
    );

    final response = await userApi.newUserApiV1UserCreatePost(userCreate: userCreate);
  
    return response.data!;
  }
}

final signUpServiceProvider = Provider((ref) {
  return SignUpService(ref.watch(userApiProvider));
});