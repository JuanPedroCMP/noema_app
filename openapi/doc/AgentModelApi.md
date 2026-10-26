# openapi.api.AgentModelApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAgentModelApiV1AiAgentModelCreatePost**](AgentModelApi.md#createagentmodelapiv1aiagentmodelcreatepost) | **POST** /api/v1/ai/agent_model/create | Create Agent Model
[**deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete**](AgentModelApi.md#deleteagentmodelapiv1aiagentmodeldeleteidentificatordelete) | **DELETE** /api/v1/ai/agent_model/delete/{identificator} | Delete Agent Model
[**getAgentModelApiV1AiAgentModelGetIdentificatorGet**](AgentModelApi.md#getagentmodelapiv1aiagentmodelgetidentificatorget) | **GET** /api/v1/ai/agent_model/get/{identificator} | Get Agent Model
[**listAgentModelApiV1AiAgentModelListGet**](AgentModelApi.md#listagentmodelapiv1aiagentmodellistget) | **GET** /api/v1/ai/agent_model/list | List Agent Model
[**updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut**](AgentModelApi.md#updateagentmodelapiv1aiagentmodelupdateidentificatorput) | **PUT** /api/v1/ai/agent_model/update/{identificator} | Update Agent Model


# **createAgentModelApiV1AiAgentModelCreatePost**
> AgentModelOut createAgentModelApiV1AiAgentModelCreatePost(agentModelCreate)

Create Agent Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentModelApi();
final AgentModelCreate agentModelCreate = ; // AgentModelCreate | 

try {
    final response = api.createAgentModelApiV1AiAgentModelCreatePost(agentModelCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentModelApi->createAgentModelApiV1AiAgentModelCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **agentModelCreate** | [**AgentModelCreate**](AgentModelCreate.md)|  | 

### Return type

[**AgentModelOut**](AgentModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete**
> JsonObject deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete(identificator)

Delete Agent Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentModelApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentModelApi->deleteAgentModelApiV1AiAgentModelDeleteIdentificatorDelete: $e\n');
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

# **getAgentModelApiV1AiAgentModelGetIdentificatorGet**
> AgentModelOut getAgentModelApiV1AiAgentModelGetIdentificatorGet(identificator)

Get Agent Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentModelApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getAgentModelApiV1AiAgentModelGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentModelApi->getAgentModelApiV1AiAgentModelGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**AgentModelOut**](AgentModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAgentModelApiV1AiAgentModelListGet**
> BuiltList<AgentModelOut> listAgentModelApiV1AiAgentModelListGet(id, idAgent, idAiModel, qualityExpected, customSystemPrompt, customTemperature, createdAt, updatedAt)

List Agent Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentModelApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idAgent = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idAiModel = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AgentModelQuality qualityExpected = ; // AgentModelQuality | 
final String customSystemPrompt = customSystemPrompt_example; // String | 
final num customTemperature = 8.14; // num | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listAgentModelApiV1AiAgentModelListGet(id, idAgent, idAiModel, qualityExpected, customSystemPrompt, customTemperature, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentModelApi->listAgentModelApiV1AiAgentModelListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idAgent** | **String**|  | [optional] 
 **idAiModel** | **String**|  | [optional] 
 **qualityExpected** | [**AgentModelQuality**](.md)|  | [optional] 
 **customSystemPrompt** | **String**|  | [optional] 
 **customTemperature** | **num**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;AgentModelOut&gt;**](AgentModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut**
> AgentModelOut updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut(identificator, agentModelUpdate)

Update Agent Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAgentModelApi();
final String identificator = identificator_example; // String | 
final AgentModelUpdate agentModelUpdate = ; // AgentModelUpdate | 

try {
    final response = api.updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut(identificator, agentModelUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgentModelApi->updateAgentModelApiV1AiAgentModelUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **agentModelUpdate** | [**AgentModelUpdate**](AgentModelUpdate.md)|  | 

### Return type

[**AgentModelOut**](AgentModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

