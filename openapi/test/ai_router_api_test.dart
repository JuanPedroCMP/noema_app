import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AiRouterApi
void main() {
  final instance = Openapi().getAiRouterApi();

  group(AiRouterApi, () {
    // Get Materials
    //
    //Future<JsonObject> getMaterialsApiV1AiRouterGetMaterialsPost(String userPrompt, String agentId, { bool getVideos, bool getBooks, bool getPapers, bool getWeb }) async
    test('test getMaterialsApiV1AiRouterGetMaterialsPost', () async {
      // TODO
    });

    // Use1 Ai
    //
    //Future<JsonObject> use1AiApiV1AiRouterGetPapersPost(String query) async
    test('test use1AiApiV1AiRouterGetPapersPost', () async {
      // TODO
    });

    // Use2 Ai
    //
    //Future<JsonObject> use2AiApiV1AiRouterGetYtPost(String query) async
    test('test use2AiApiV1AiRouterGetYtPost', () async {
      // TODO
    });

    // Use3 Ai
    //
    //Future<JsonObject> use3AiApiV1AiRouterGetBooksPost(String query) async
    test('test use3AiApiV1AiRouterGetBooksPost', () async {
      // TODO
    });

    // Use4 Ai
    //
    //Future<JsonObject> use4AiApiV1AiRouterGetPesquisaPost(String query) async
    test('test use4AiApiV1AiRouterGetPesquisaPost', () async {
      // TODO
    });

    // Use Ai
    //
    //Future<JsonObject> useAiApiV1AiRouterUseAiPost(String userPrompt, String agentId) async
    test('test useAiApiV1AiRouterUseAiPost', () async {
      // TODO
    });

  });
}
