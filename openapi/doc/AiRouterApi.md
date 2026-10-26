# openapi.api.AiRouterApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMaterialsApiV1AiRouterGetMaterialsPost**](AiRouterApi.md#getmaterialsapiv1airoutergetmaterialspost) | **POST** /api/v1/ai_router/get_materials | Get Materials
[**use1AiApiV1AiRouterGetPapersPost**](AiRouterApi.md#use1aiapiv1airoutergetpaperspost) | **POST** /api/v1/ai_router/get_papers | Use1 Ai
[**use2AiApiV1AiRouterGetYtPost**](AiRouterApi.md#use2aiapiv1airoutergetytpost) | **POST** /api/v1/ai_router/get_yt | Use2 Ai
[**use3AiApiV1AiRouterGetBooksPost**](AiRouterApi.md#use3aiapiv1airoutergetbookspost) | **POST** /api/v1/ai_router/get_books | Use3 Ai
[**use4AiApiV1AiRouterGetPesquisaPost**](AiRouterApi.md#use4aiapiv1airoutergetpesquisapost) | **POST** /api/v1/ai_router/get_pesquisa | Use4 Ai
[**useAiApiV1AiRouterUseAiPost**](AiRouterApi.md#useaiapiv1airouteruseaipost) | **POST** /api/v1/ai_router/use_ai | Use Ai


# **getMaterialsApiV1AiRouterGetMaterialsPost**
> JsonObject getMaterialsApiV1AiRouterGetMaterialsPost(userPrompt, agentId, getVideos, getBooks, getPapers, getWeb)

Get Materials

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiRouterApi();
final String userPrompt = userPrompt_example; // String | 
final String agentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool getVideos = true; // bool | 
final bool getBooks = true; // bool | 
final bool getPapers = true; // bool | 
final bool getWeb = true; // bool | 

try {
    final response = api.getMaterialsApiV1AiRouterGetMaterialsPost(userPrompt, agentId, getVideos, getBooks, getPapers, getWeb);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiRouterApi->getMaterialsApiV1AiRouterGetMaterialsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userPrompt** | **String**|  | 
 **agentId** | **String**|  | 
 **getVideos** | **bool**|  | [optional] [default to true]
 **getBooks** | **bool**|  | [optional] [default to true]
 **getPapers** | **bool**|  | [optional] [default to true]
 **getWeb** | **bool**|  | [optional] [default to true]

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **use1AiApiV1AiRouterGetPapersPost**
> JsonObject use1AiApiV1AiRouterGetPapersPost(query)

Use1 Ai

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiRouterApi();
final String query = query_example; // String | 

try {
    final response = api.use1AiApiV1AiRouterGetPapersPost(query);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiRouterApi->use1AiApiV1AiRouterGetPapersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **use2AiApiV1AiRouterGetYtPost**
> JsonObject use2AiApiV1AiRouterGetYtPost(query)

Use2 Ai

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiRouterApi();
final String query = query_example; // String | 

try {
    final response = api.use2AiApiV1AiRouterGetYtPost(query);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiRouterApi->use2AiApiV1AiRouterGetYtPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **use3AiApiV1AiRouterGetBooksPost**
> JsonObject use3AiApiV1AiRouterGetBooksPost(query)

Use3 Ai

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiRouterApi();
final String query = query_example; // String | 

try {
    final response = api.use3AiApiV1AiRouterGetBooksPost(query);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiRouterApi->use3AiApiV1AiRouterGetBooksPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **use4AiApiV1AiRouterGetPesquisaPost**
> JsonObject use4AiApiV1AiRouterGetPesquisaPost(query)

Use4 Ai

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiRouterApi();
final String query = query_example; // String | 

try {
    final response = api.use4AiApiV1AiRouterGetPesquisaPost(query);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiRouterApi->use4AiApiV1AiRouterGetPesquisaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **useAiApiV1AiRouterUseAiPost**
> JsonObject useAiApiV1AiRouterUseAiPost(userPrompt, agentId)

Use Ai

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAiRouterApi();
final String userPrompt = userPrompt_example; // String | 
final String agentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.useAiApiV1AiRouterUseAiPost(userPrompt, agentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiRouterApi->useAiApiV1AiRouterUseAiPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userPrompt** | **String**|  | 
 **agentId** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

