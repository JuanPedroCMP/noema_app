import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AiUsageLogApi
void main() {
  final instance = Openapi().getAiUsageLogApi();

  group(AiUsageLogApi, () {
    // Create Agent Model
    //
    //Future<AiUsageLogOut> createAgentModelApiV1AiAiUsageLogCreatePost(AiUsageLogCreate aiUsageLogCreate) async
    test('test createAgentModelApiV1AiAiUsageLogCreatePost', () async {
      // TODO
    });

    // Get Agent Model
    //
    //Future<AiUsageLogOut> getAgentModelApiV1AiAiUsageLogGetIdentificatorGet(String identificator) async
    test('test getAgentModelApiV1AiAiUsageLogGetIdentificatorGet', () async {
      // TODO
    });

    // List Agent Model
    //
    //Future<BuiltList<AiUsageLogOut>> listAgentModelApiV1AiAiUsageLogListGet({ String id, String idUser, String idAgentModel, String usageDatails, DateTime createdAt }) async
    test('test listAgentModelApiV1AiAiUsageLogListGet', () async {
      // TODO
    });

  });
}
