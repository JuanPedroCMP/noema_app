# openapi.api.UserApiKeyApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUserApiKeyApiV1AiUserApiKeyCreatePost**](UserApiKeyApi.md#createuserapikeyapiv1aiuserapikeycreatepost) | **POST** /api/v1/ai/user_api_key/create | Create User Api Key
[**deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete**](UserApiKeyApi.md#deleteuserapikeyapiv1aiuserapikeydeleteidentificatordelete) | **DELETE** /api/v1/ai/user_api_key/delete/{identificator} | Delete User Api Key
[**getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet**](UserApiKeyApi.md#getuserapikeyapiv1aiuserapikeygetidentificatorget) | **GET** /api/v1/ai/user_api_key/get/{identificator} | Get User Api Key
[**listUserApiKeyApiV1AiUserApiKeyListGet**](UserApiKeyApi.md#listuserapikeyapiv1aiuserapikeylistget) | **GET** /api/v1/ai/user_api_key/list | List User Api Key
[**updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut**](UserApiKeyApi.md#updateuserapikeyapiv1aiuserapikeyupdateidentificatorput) | **PUT** /api/v1/ai/user_api_key/update/{identificator} | Update User Api Key


# **createUserApiKeyApiV1AiUserApiKeyCreatePost**
> UserApiKeyOut createUserApiKeyApiV1AiUserApiKeyCreatePost(userApiKeyCreate)

Create User Api Key

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyApi();
final UserApiKeyCreate userApiKeyCreate = ; // UserApiKeyCreate | 

try {
    final response = api.createUserApiKeyApiV1AiUserApiKeyCreatePost(userApiKeyCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyApi->createUserApiKeyApiV1AiUserApiKeyCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userApiKeyCreate** | [**UserApiKeyCreate**](UserApiKeyCreate.md)|  | 

### Return type

[**UserApiKeyOut**](UserApiKeyOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete**
> JsonObject deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete(identificator)

Delete User Api Key

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyApi->deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete: $e\n');
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

# **getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet**
> UserApiKeyOut getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet(identificator)

Get User Api Key

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyApi->getUserApiKeyApiV1AiUserApiKeyGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**UserApiKeyOut**](UserApiKeyOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listUserApiKeyApiV1AiUserApiKeyListGet**
> BuiltList<UserApiKeyOut> listUserApiKeyApiV1AiUserApiKeyListGet(id, idAiProvider, idUser, name, encryptedKey, isActive, createdAt, updatedAt)

List User Api Key

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idAiProvider = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String name = name_example; // String | 
final String encryptedKey = encryptedKey_example; // String | 
final bool isActive = true; // bool | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listUserApiKeyApiV1AiUserApiKeyListGet(id, idAiProvider, idUser, name, encryptedKey, isActive, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyApi->listUserApiKeyApiV1AiUserApiKeyListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idAiProvider** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **name** | **String**|  | [optional] 
 **encryptedKey** | **String**|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;UserApiKeyOut&gt;**](UserApiKeyOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut**
> UserApiKeyOut updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut(identificator, userApiKeyUpdate)

Update User Api Key

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyApi();
final String identificator = identificator_example; // String | 
final UserApiKeyUpdate userApiKeyUpdate = ; // UserApiKeyUpdate | 

try {
    final response = api.updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut(identificator, userApiKeyUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyApi->updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **userApiKeyUpdate** | [**UserApiKeyUpdate**](UserApiKeyUpdate.md)|  | 

### Return type

[**UserApiKeyOut**](UserApiKeyOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

