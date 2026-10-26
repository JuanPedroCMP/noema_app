import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AgentApi
void main() {
  final instance = Openapi().getAgentApi();

  group(AgentApi, () {
    // Create Agent
    //
    //Future<AgentOut> createAgentApiV1AiAgentCreatePost(AgentCreate agentCreate) async
    test('test createAgentApiV1AiAgentCreatePost', () async {
      // TODO
    });

    // Delete Agent
    //
    //Future<JsonObject> deleteAgentApiV1AiAgentDeleteIdentificatorDelete(String identificator) async
    test('test deleteAgentApiV1AiAgentDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Agent
    //
    //Future<AgentOut> getAgentApiV1AiAgentGetIdentificatorGet(String identificator) async
    test('test getAgentApiV1AiAgentGetIdentificatorGet', () async {
      // TODO
    });

    // List Agent
    //
    //Future<BuiltList<AgentOut>> listAgentApiV1AiAgentListGet({ String id, String alias, TaskType task, String baseSystemPrompt, num temperature, DateTime createdAt, DateTime updatedAt }) async
    test('test listAgentApiV1AiAgentListGet', () async {
      // TODO
    });

    // Update Agent
    //
    //Future<AgentOut> updateAgentApiV1AiAgentUpdateIdentificatorPut(String identificator, AgentUpdate agentUpdate) async
    test('test updateAgentApiV1AiAgentUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}
