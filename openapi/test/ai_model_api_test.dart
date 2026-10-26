import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AiModelApi
void main() {
  final instance = Openapi().getAiModelApi();

  group(AiModelApi, () {
    // Create Ai Model
    //
    //Future<AiModelOut> createAiModelApiV1AiAiModelCreatePost(AiModelCreate aiModelCreate) async
    test('test createAiModelApiV1AiAiModelCreatePost', () async {
      // TODO
    });

    // Delete Ai Model
    //
    //Future<JsonObject> deleteAiModelApiV1AiAiModelEleteIdentificatorDelete(String identificator) async
    test('test deleteAiModelApiV1AiAiModelEleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Ai Model
    //
    //Future<AiModelOut> getAiModelApiV1AiAiModelGetIdentificatorGet(String identificator) async
    test('test getAiModelApiV1AiAiModelGetIdentificatorGet', () async {
      // TODO
    });

    // List Ai Models
    //
    //Future<BuiltList<AiModelOut>> listAiModelsApiV1AiAiModelListGet({ String id, String slug, String idAiProvider, String displayName, int contextWindow, int inputTokenLimit, int outputTokenLimit, bool supportsVision, bool isActive }) async
    test('test listAiModelsApiV1AiAiModelListGet', () async {
      // TODO
    });

    // Update Ai Model
    //
    //Future<AiModelOut> updateAiModelApiV1AiAiModelUpdateIdentificatorPut(String identificator, AiModelUpdate aiModelUpdate) async
    test('test updateAiModelApiV1AiAiModelUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}
