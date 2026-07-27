# openapi.api.AiUsageLogApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAgentModelApiV1AiAiUsageLogCreatePost**](AiUsageLogApi.md#createagentmodelapiv1aiaiusagelogcreatepost) | **POST** /api/v1/ai/ai_usage_log/create | Create Agent Model
[**getAgentModelApiV1AiAiUsageLogGetIdentificatorGet**](AiUsageLogApi.md#getagentmodelapiv1aiaiusageloggetidentificatorget) | **GET** /api/v1/ai/ai_usage_log/get/{identificator} | Get Agent Model
[**listAgentModelApiV1AiAiUsageLogListGet**](AiUsageLogApi.md#listagentmodelapiv1aiaiusageloglistget) | **GET** /api/v1/ai/ai_usage_log/list | List Agent Model


# **createAgentModelApiV1AiAiUsageLogCreatePost**
> AiUsageLogOut createAgentModelApiV1AiAiUsageLogCreatePost(aiUsageLogCreate)

Create Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiUsageLogApi();
final AiUsageLogCreate aiUsageLogCreate = ; // AiUsageLogCreate | 

try {
    final response = api.createAgentModelApiV1AiAiUsageLogCreatePost(aiUsageLogCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiUsageLogApi->createAgentModelApiV1AiAiUsageLogCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aiUsageLogCreate** | [**AiUsageLogCreate**](AiUsageLogCreate.md)|  | 

### Return type

[**AiUsageLogOut**](AiUsageLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAgentModelApiV1AiAiUsageLogGetIdentificatorGet**
> AiUsageLogOut getAgentModelApiV1AiAiUsageLogGetIdentificatorGet(identificator)

Get Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiUsageLogApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getAgentModelApiV1AiAiUsageLogGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiUsageLogApi->getAgentModelApiV1AiAiUsageLogGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**AiUsageLogOut**](AiUsageLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAgentModelApiV1AiAiUsageLogListGet**
> BuiltList<AiUsageLogOut> listAgentModelApiV1AiAiUsageLogListGet(id, idUser, idAgentModel, usageDatails, createdAt)

List Agent Model

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiUsageLogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idAgentModel = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String usageDatails = usageDatails_example; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listAgentModelApiV1AiAiUsageLogListGet(id, idUser, idAgentModel, usageDatails, createdAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiUsageLogApi->listAgentModelApiV1AiAiUsageLogListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **idAgentModel** | **String**|  | [optional] 
 **usageDatails** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;AiUsageLogOut&gt;**](AiUsageLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

