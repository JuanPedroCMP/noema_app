# openapi.api.UserApiKeyCanUseIaModelApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost**](UserApiKeyCanUseIaModelApi.md#createagentmodelapiv1aiuserapikeycanuseiamodelcreatepost) | **POST** /api/v1/ai/user_api_key_can_use_ia_model/create | Create Agent Model
[**deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete**](UserApiKeyCanUseIaModelApi.md#deleteagentmodelapiv1aiuserapikeycanuseiamodeldeleteidentificatordelete) | **DELETE** /api/v1/ai/user_api_key_can_use_ia_model/delete/{identificator} | Delete Agent Model
[**getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet**](UserApiKeyCanUseIaModelApi.md#getagentmodelapiv1aiuserapikeycanuseiamodelgetidentificatorget) | **GET** /api/v1/ai/user_api_key_can_use_ia_model/get/{identificator} | Get Agent Model
[**listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet**](UserApiKeyCanUseIaModelApi.md#listagentmodelapiv1aiuserapikeycanuseiamodellistget) | **GET** /api/v1/ai/user_api_key_can_use_ia_model/list | List Agent Model


# **createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost**
> UserApiKeyCanUseIaModelOut createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost(userApiKeyCanUseIaModelCreate)

Create Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyCanUseIaModelApi();
final UserApiKeyCanUseIaModelCreate userApiKeyCanUseIaModelCreate = ; // UserApiKeyCanUseIaModelCreate | 

try {
    final response = api.createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost(userApiKeyCanUseIaModelCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyCanUseIaModelApi->createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userApiKeyCanUseIaModelCreate** | [**UserApiKeyCanUseIaModelCreate**](UserApiKeyCanUseIaModelCreate.md)|  | 

### Return type

[**UserApiKeyCanUseIaModelOut**](UserApiKeyCanUseIaModelOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete**
> JsonObject deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete(identificator)

Delete Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyCanUseIaModelApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyCanUseIaModelApi->deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete: $e\n');
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

# **getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet**
> UserApiKeyCanUseIaModelOut getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet(identificator)

Get Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyCanUseIaModelApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyCanUseIaModelApi->getAgentModelApiV1AiUserApiKeyCanUseIaModelGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**UserApiKeyCanUseIaModelOut**](UserApiKeyCanUseIaModelOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet**
> BuiltList<UserApiKeyCanUseIaModelOut> listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet(id, idAiModel, idUserApiKey, createdAt)

List Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApiKeyCanUseIaModelApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idAiModel = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUserApiKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet(id, idAiModel, idUserApiKey, createdAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApiKeyCanUseIaModelApi->listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idAiModel** | **String**|  | [optional] 
 **idUserApiKey** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;UserApiKeyCanUseIaModelOut&gt;**](UserApiKeyCanUseIaModelOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

