# openapi.api.AgentApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAgentApiV1AiAgentCreatePost**](AgentApi.md#createagentapiv1aiagentcreatepost) | **POST** /api/v1/ai/agent/create | Create Agent
[**deleteAgentApiV1AiAgentDeleteIdentificatorDelete**](AgentApi.md#deleteagentapiv1aiagentdeleteidentificatordelete) | **DELETE** /api/v1/ai/agent/delete/{identificator} | Delete Agent
[**getAgentApiV1AiAgentGetIdentificatorGet**](AgentApi.md#getagentapiv1aiagentgetidentificatorget) | **GET** /api/v1/ai/agent/get/{identificator} | Get Agent
[**listAgentApiV1AiAgentListGet**](AgentApi.md#listagentapiv1aiagentlistget) | **GET** /api/v1/ai/agent/list | List Agent
[**updateAgentApiV1AiAgentUpdateIdentificatorPut**](AgentApi.md#updateagentapiv1aiagentupdateidentificatorput) | **PUT** /api/v1/ai/agent/update/{identificator} | Update Agent


# **createAgentApiV1AiAgentCreatePost**
> AgentOut createAgentApiV1AiAgentCreatePost(agentCreate)

Create Agent

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentApi();
final AgentCreate agentCreate = ; // AgentCreate | 

try {
    final response = api.createAgentApiV1AiAgentCreatePost(agentCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentApi->createAgentApiV1AiAgentCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **agentCreate** | [**AgentCreate**](AgentCreate.md)|  | 

### Return type

[**AgentOut**](AgentOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAgentApiV1AiAgentDeleteIdentificatorDelete**
> JsonObject deleteAgentApiV1AiAgentDeleteIdentificatorDelete(identificator)

Delete Agent

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteAgentApiV1AiAgentDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentApi->deleteAgentApiV1AiAgentDeleteIdentificatorDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAgentApiV1AiAgentGetIdentificatorGet**
> AgentOut getAgentApiV1AiAgentGetIdentificatorGet(identificator)

Get Agent

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getAgentApiV1AiAgentGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentApi->getAgentApiV1AiAgentGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**AgentOut**](AgentOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAgentApiV1AiAgentListGet**
> BuiltList<AgentOut> listAgentApiV1AiAgentListGet(id, alias, task, baseSystemPrompt, temperature, createdAt, updatedAt)

List Agent

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String alias = alias_example; // String | 
final TaskType task = ; // TaskType | 
final String baseSystemPrompt = baseSystemPrompt_example; // String | 
final num temperature = 8.14; // num | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listAgentApiV1AiAgentListGet(id, alias, task, baseSystemPrompt, temperature, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentApi->listAgentApiV1AiAgentListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **alias** | **String**|  | [optional] 
 **task** | [**TaskType**](.md)|  | [optional] 
 **baseSystemPrompt** | **String**|  | [optional] 
 **temperature** | **num**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;AgentOut&gt;**](AgentOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAgentApiV1AiAgentUpdateIdentificatorPut**
> AgentOut updateAgentApiV1AiAgentUpdateIdentificatorPut(identificator, agentUpdate)

Update Agent

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentApi();
final String identificator = identificator_example; // String | 
final AgentUpdate agentUpdate = ; // AgentUpdate | 

try {
    final response = api.updateAgentApiV1AiAgentUpdateIdentificatorPut(identificator, agentUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentApi->updateAgentApiV1AiAgentUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **agentUpdate** | [**AgentUpdate**](AgentUpdate.md)|  | 

### Return type

[**AgentOut**](AgentOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

