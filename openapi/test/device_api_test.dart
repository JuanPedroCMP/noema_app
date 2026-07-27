import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DeviceApi
void main() {
  final instance = Openapi().getDeviceApi();

  group(DeviceApi, () {
    // Create Device
    //
    //Future<DeviceOut> createDeviceApiV1DeviceCreatePost(DeviceCreate deviceCreate) async
    test('test createDeviceApiV1DeviceCreatePost', () async {
      // TODO
    });

    // Delete Device
    //
    //Future<JsonObject> deleteDeviceApiV1DeviceDeleteIdentificatorDelete(String identificator) async
    test('test deleteDeviceApiV1DeviceDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Device
    //
    //Future<DeviceOut> getDeviceApiV1DeviceGetIdentificatorGet(String identificator) async
    test('test getDeviceApiV1DeviceGetIdentificatorGet', () async {
      // TODO
    });

    // List Device
    //
    //Future<BuiltList<DeviceOut>> listDeviceApiV1DeviceListGet({ String id, String idUser, String deviceName, String deviceFingerprint, String platform, DateTime lastSeenAt, DateTime createdAt, DateTime updatedAt }) async
    test('test listDeviceApiV1DeviceListGet', () async {
      // TODO
    });

    // Update Device
    //
    //Future<DeviceOut> updateDeviceApiV1DeviceUpdateIdentificatorPut(String identificator, DeviceUpdate deviceUpdate) async
    test('test updateDeviceApiV1DeviceUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}
