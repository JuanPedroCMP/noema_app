import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for GenericLogApi
void main() {
  final instance = Openapi().getGenericLogApi();

  group(GenericLogApi, () {
    // Create Generic Log
    //
    //Future<GenericLogOut> createGenericLogApiV1GenericLogCreatePost(GenericLogCreate genericLogCreate) async
    test('test createGenericLogApiV1GenericLogCreatePost', () async {
      // TODO
    });

    // Get Generic Log
    //
    //Future<GenericLogOut> getGenericLogApiV1GenericLogGetIdentificatorGet(String identificator) async
    test('test getGenericLogApiV1GenericLogGetIdentificatorGet', () async {
      // TODO
    });

    // List Generic Log
    //
    //Future<BuiltList<GenericLogOut>> listGenericLogApiV1GenericLogListGet({ String id, String type, String idUser, String details, DateTime createdAt }) async
    test('test listGenericLogApiV1GenericLogListGet', () async {
      // TODO
    });

  });
}
