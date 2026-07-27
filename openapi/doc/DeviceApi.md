# openapi.api.DeviceApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createDeviceApiV1DeviceCreatePost**](DeviceApi.md#createdeviceapiv1devicecreatepost) | **POST** /api/v1/device/create | Create Device
[**deleteDeviceApiV1DeviceDeleteIdentificatorDelete**](DeviceApi.md#deletedeviceapiv1devicedeleteidentificatordelete) | **DELETE** /api/v1/device/delete/{identificator} | Delete Device
[**getDeviceApiV1DeviceGetIdentificatorGet**](DeviceApi.md#getdeviceapiv1devicegetidentificatorget) | **GET** /api/v1/device/get/{identificator} | Get Device
[**listDeviceApiV1DeviceListGet**](DeviceApi.md#listdeviceapiv1devicelistget) | **GET** /api/v1/device/list | List Device
[**updateDeviceApiV1DeviceUpdateIdentificatorPut**](DeviceApi.md#updatedeviceapiv1deviceupdateidentificatorput) | **PUT** /api/v1/device/update/{identificator} | Update Device


# **createDeviceApiV1DeviceCreatePost**
> DeviceOut createDeviceApiV1DeviceCreatePost(deviceCreate)

Create Device

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDeviceApi();
final DeviceCreate deviceCreate = ; // DeviceCreate | 

try {
    final response = api.createDeviceApiV1DeviceCreatePost(deviceCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeviceApi->createDeviceApiV1DeviceCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceCreate** | [**DeviceCreate**](DeviceCreate.md)|  | 

### Return type

[**DeviceOut**](DeviceOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteDeviceApiV1DeviceDeleteIdentificatorDelete**
> JsonObject deleteDeviceApiV1DeviceDeleteIdentificatorDelete(identificator)

Delete Device

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDeviceApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteDeviceApiV1DeviceDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeviceApi->deleteDeviceApiV1DeviceDeleteIdentificatorDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDeviceApiV1DeviceGetIdentificatorGet**
> DeviceOut getDeviceApiV1DeviceGetIdentificatorGet(identificator)

Get Device

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDeviceApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getDeviceApiV1DeviceGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeviceApi->getDeviceApiV1DeviceGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**DeviceOut**](DeviceOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDeviceApiV1DeviceListGet**
> BuiltList<DeviceOut> listDeviceApiV1DeviceListGet(id, idUser, deviceName, deviceFingerprint, platform, lastSeenAt, createdAt, updatedAt)

List Device

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDeviceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String deviceName = deviceName_example; // String | 
final String deviceFingerprint = deviceFingerprint_example; // String | 
final String platform = platform_example; // String | 
final DateTime lastSeenAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listDeviceApiV1DeviceListGet(id, idUser, deviceName, deviceFingerprint, platform, lastSeenAt, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeviceApi->listDeviceApiV1DeviceListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **deviceName** | **String**|  | [optional] 
 **deviceFingerprint** | **String**|  | [optional] 
 **platform** | **String**|  | [optional] 
 **lastSeenAt** | **DateTime**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;DeviceOut&gt;**](DeviceOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateDeviceApiV1DeviceUpdateIdentificatorPut**
> DeviceOut updateDeviceApiV1DeviceUpdateIdentificatorPut(identificator, deviceUpdate)

Update Device

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getDeviceApi();
final String identificator = identificator_example; // String | 
final DeviceUpdate deviceUpdate = ; // DeviceUpdate | 

try {
    final response = api.updateDeviceApiV1DeviceUpdateIdentificatorPut(identificator, deviceUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeviceApi->updateDeviceApiV1DeviceUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **deviceUpdate** | [**DeviceUpdate**](DeviceUpdate.md)|  | 

### Return type

[**DeviceOut**](DeviceOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

