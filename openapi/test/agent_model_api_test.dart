import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AgentModelApi
void main() {
  final instance = Openapi().getAgentModelApi();

  group(AgentModelApi, () {
    // Create Agent Model
    //
    //Future<AgentModelOut> createAgentModelApiV1AiAgentModelCreatePost(AgentModelCreate agentModelCreate) async
    test('test createAgentModelApiV1AiAgentModelCreatePost', () async {
      // TODO
    });

    // Delete Agent Model
    //
    //Future<JsonObject> deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete(String identificator) async
    test('test deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Agent Model
    //
    //Future<AgentModelOut> getAgentModelApiV1AiAgentModelGetIdentificatorGet(String identificator) async
    test('test getAgentModelApiV1AiAgentModelGetIdentificatorGet', () async {
      // TODO
    });

    // List Agent Model
    //
    //Future<BuiltList<AgentModelOut>> listAgentModelApiV1AiAgentModelListGet({ String id, String idAgent, String idAiModel, AgentModelQuality qualityExpected, String customSystemPrompt, num customTemperature, DateTime createdAt, DateTime updatedAt }) async
    test('test listAgentModelApiV1AiAgentModelListGet', () async {
      // TODO
    });

    // Update Agent Model
    //
    //Future<AgentModelOut> updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut(String identificator, AgentModelUpdate agentModelUpdate) async
    test('test updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}
