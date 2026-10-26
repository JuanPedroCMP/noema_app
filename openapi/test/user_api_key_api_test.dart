import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserApiKeyApi
void main() {
  final instance = Openapi().getUserApiKeyApi();

  group(UserApiKeyApi, () {
    // Create User Api Key
    //
    //Future<UserApiKeyOut> createUserApiKeyApiV1AiUserApiKeyCreatePost(UserApiKeyCreate userApiKeyCreate) async
    test('test createUserApiKeyApiV1AiUserApiKeyCreatePost', () async {
      // TODO
    });

    // Delete User Api Key
    //
    //Future<JsonObject> deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete(String identificator) async
    test('test deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get User Api Key
    //
    //Future<UserApiKeyOut> getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet(String identificator) async
    test('test getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet', () async {
      // TODO
    });

    // List User Api Key
    //
    //Future<BuiltList<UserApiKeyOut>> listUserApiKeyApiV1AiUserApiKeyListGet({ String id, String idAiProvider, String idUser, String name, String encryptedKey, bool isActive, DateTime createdAt, DateTime updatedAt }) async
    test('test listUserApiKeyApiV1AiUserApiKeyListGet', () async {
      // TODO
    });

    // Update User Api Key
    //
    //Future<UserApiKeyOut> updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut(String identificator, UserApiKeyUpdate userApiKeyUpdate) async
    test('test updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}
