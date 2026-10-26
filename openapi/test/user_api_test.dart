import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserApi
void main() {
  final instance = Openapi().getUserApi();

  group(UserApi, () {
    // Current User
    //
    //Future<UserOut> currentUserApiV1UserGetGet() async
    test('test currentUserApiV1UserGetGet', () async {
      // TODO
    });

    // Delete User
    //
    //Future<JsonObject> deleteUserApiV1UserDeleteDelete() async
    test('test deleteUserApiV1UserDeleteDelete', () async {
      // TODO
    });

    // New User
    //
    //Future<UserOut> newUserApiV1UserCreatePost(UserCreate userCreate) async
    test('test newUserApiV1UserCreatePost', () async {
      // TODO
    });

    // Update User
    //
    //Future<UserOut> updateUserApiV1UserUpdatePut(UserUpdate userUpdate) async
    test('test updateUserApiV1UserUpdatePut', () async {
      // TODO
    });

  });
}
