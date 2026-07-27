# openapi.api.AiModelApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAiModelApiV1AiAiModelCreatePost**](AiModelApi.md#createaimodelapiv1aiaimodelcreatepost) | **POST** /api/v1/ai/ai_model/create | Create Ai Model
[**deleteAiModelApiV1AiAiModelEleteIdentificatorDelete**](AiModelApi.md#deleteaimodelapiv1aiaimodeleleteidentificatordelete) | **DELETE** /api/v1/ai/ai_model/elete/{identificator} | Delete Ai Model
[**getAiModelApiV1AiAiModelGetIdentificatorGet**](AiModelApi.md#getaimodelapiv1aiaimodelgetidentificatorget) | **GET** /api/v1/ai/ai_model/get/{identificator} | Get Ai Model
[**listAiModelsApiV1AiAiModelListGet**](AiModelApi.md#listaimodelsapiv1aiaimodellistget) | **GET** /api/v1/ai/ai_model/list | List Ai Models
[**updateAiModelApiV1AiAiModelUpdateIdentificatorPut**](AiModelApi.md#updateaimodelapiv1aiaimodelupdateidentificatorput) | **PUT** /api/v1/ai/ai_model/update/{identificator} | Update Ai Model


# **createAiModelApiV1AiAiModelCreatePost**
> AiModelOut createAiModelApiV1AiAiModelCreatePost(aiModelCreate)

Create Ai Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAiModelApi();
final AiModelCreate aiModelCreate = ; // AiModelCreate | 

try {
    final response = api.createAiModelApiV1AiAiModelCreatePost(aiModelCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiModelApi->createAiModelApiV1AiAiModelCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aiModelCreate** | [**AiModelCreate**](AiModelCreate.md)|  | 

### Return type

[**AiModelOut**](AiModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAiModelApiV1AiAiModelEleteIdentificatorDelete**
> JsonObject deleteAiModelApiV1AiAiModelEleteIdentificatorDelete(identificator)

Delete Ai Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAiModelApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteAiModelApiV1AiAiModelEleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiModelApi->deleteAiModelApiV1AiAiModelEleteIdentificatorDelete: $e\n');
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

# **getAiModelApiV1AiAiModelGetIdentificatorGet**
> AiModelOut getAiModelApiV1AiAiModelGetIdentificatorGet(identificator)

Get Ai Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAiModelApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getAiModelApiV1AiAiModelGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiModelApi->getAiModelApiV1AiAiModelGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**AiModelOut**](AiModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAiModelsApiV1AiAiModelListGet**
> BuiltList<AiModelOut> listAiModelsApiV1AiAiModelListGet(id, slug, idAiProvider, displayName, contextWindow, inputTokenLimit, outputTokenLimit, supportsVision, isActive)

List Ai Models

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAiModelApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String slug = slug_example; // String | 
final String idAiProvider = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String displayName = displayName_example; // String | 
final int contextWindow = 56; // int | 
final int inputTokenLimit = 56; // int | 
final int outputTokenLimit = 56; // int | 
final bool supportsVision = true; // bool | 
final bool isActive = true; // bool | 

try {
    final response = api.listAiModelsApiV1AiAiModelListGet(id, slug, idAiProvider, displayName, contextWindow, inputTokenLimit, outputTokenLimit, supportsVision, isActive);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiModelApi->listAiModelsApiV1AiAiModelListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 
 **idAiProvider** | **String**|  | [optional] 
 **displayName** | **String**|  | [optional] 
 **contextWindow** | **int**|  | [optional] 
 **inputTokenLimit** | **int**|  | [optional] 
 **outputTokenLimit** | **int**|  | [optional] 
 **supportsVision** | **bool**|  | [optional] 
 **isActive** | **bool**|  | [optional] 

### Return type

[**BuiltList&lt;AiModelOut&gt;**](AiModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAiModelApiV1AiAiModelUpdateIdentificatorPut**
> AiModelOut updateAiModelApiV1AiAiModelUpdateIdentificatorPut(identificator, aiModelUpdate)

Update Ai Model

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAiModelApi();
final String identificator = identificator_example; // String | 
final AiModelUpdate aiModelUpdate = ; // AiModelUpdate | 

try {
    final response = api.updateAiModelApiV1AiAiModelUpdateIdentificatorPut(identificator, aiModelUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AiModelApi->updateAiModelApiV1AiAiModelUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **aiModelUpdate** | [**AiModelUpdate**](AiModelUpdate.md)|  | 

### Return type

[**AiModelOut**](AiModelOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

