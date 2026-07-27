import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ProviderApi
void main() {
  final instance = Openapi().getProviderApi();

  group(ProviderApi, () {
    // Create Provider
    //
    //Future<ProviderOut> createProviderApiV1AiProviderCreatePost(ProviderCreate providerCreate) async
    test('test createProviderApiV1AiProviderCreatePost', () async {
      // TODO
    });

    // Delete Provider
    //
    //Future<JsonObject> deleteProviderApiV1AiProviderDeleteIdentificatorDelete(String identificator) async
    test('test deleteProviderApiV1AiProviderDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Provider
    //
    //Future<ProviderOut> getProviderApiV1AiProviderGetIdentificatorGet(String identificator) async
    test('test getProviderApiV1AiProviderGetIdentificatorGet', () async {
      // TODO
    });

    // List Providers
    //
    //Future<BuiltList<ProviderOut>> listProvidersApiV1AiProviderListGet({ String id, String slug, String displayName, String baseUrl, bool isActive, DateTime createdAt, DateTime updatedAt }) async
    test('test listProvidersApiV1AiProviderListGet', () async {
      // TODO
    });

    // Update Provider
    //
    //Future<ProviderOut> updateProviderApiV1AiProviderUpdateIdentificatorPut(String identificator, ProviderUpdate providerUpdate) async
    test('test updateProviderApiV1AiProviderUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}
