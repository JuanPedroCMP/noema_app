import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserApiKeyCanUseIaModelApi
void main() {
  final instance = Openapi().getUserApiKeyCanUseIaModelApi();

  group(UserApiKeyCanUseIaModelApi, () {
    // Create Agent Model
    //
    //Future<UserApiKeyCanUseIaModelOut> createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost(UserApiKeyCanUseIaModelCreate userApiKeyCanUseIaModelCreate) async
    test('test createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost', () async {
      // TODO
    });

    // Delete Agent Model
    //
    //Future<JsonObject> deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete(String identificator) async
    test('test deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Agent Model
    //
    //Future<UserApiKeyCanUseIaModelOut> getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet(String identificator) async
    test('test getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet', () async {
      // TODO
    });

    // List Agent Model
    //
    //Future<BuiltList<UserApiKeyCanUseIaModelOut>> listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet({ String id, String idAiModel, String idUserApiKey, DateTime createdAt }) async
    test('test listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet', () async {
      // TODO
    });

  });
}
