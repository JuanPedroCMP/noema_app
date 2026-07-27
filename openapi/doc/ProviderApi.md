# openapi.api.ProviderApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createProviderApiV1AiProviderCreatePost**](ProviderApi.md#createproviderapiv1aiprovidercreatepost) | **POST** /api/v1/ai/provider/create | Create Provider
[**deleteProviderApiV1AiProviderDeleteIdentificatorDelete**](ProviderApi.md#deleteproviderapiv1aiproviderdeleteidentificatordelete) | **DELETE** /api/v1/ai/provider/delete/{identificator} | Delete Provider
[**getProviderApiV1AiProviderGetIdentificatorGet**](ProviderApi.md#getproviderapiv1aiprovidergetidentificatorget) | **GET** /api/v1/ai/provider/get/{identificator} | Get Provider
[**listProvidersApiV1AiProviderListGet**](ProviderApi.md#listprovidersapiv1aiproviderlistget) | **GET** /api/v1/ai/provider/list | List Providers
[**updateProviderApiV1AiProviderUpdateIdentificatorPut**](ProviderApi.md#updateproviderapiv1aiproviderupdateidentificatorput) | **PUT** /api/v1/ai/provider/update/{identificator} | Update Provider


# **createProviderApiV1AiProviderCreatePost**
> ProviderOut createProviderApiV1AiProviderCreatePost(providerCreate)

Create Provider

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProviderApi();
final ProviderCreate providerCreate = ; // ProviderCreate | 

try {
    final response = api.createProviderApiV1AiProviderCreatePost(providerCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProviderApi->createProviderApiV1AiProviderCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **providerCreate** | [**ProviderCreate**](ProviderCreate.md)|  | 

### Return type

[**ProviderOut**](ProviderOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProviderApiV1AiProviderDeleteIdentificatorDelete**
> JsonObject deleteProviderApiV1AiProviderDeleteIdentificatorDelete(identificator)

Delete Provider

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProviderApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteProviderApiV1AiProviderDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProviderApi->deleteProviderApiV1AiProviderDeleteIdentificatorDelete: $e\n');
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

# **getProviderApiV1AiProviderGetIdentificatorGet**
> ProviderOut getProviderApiV1AiProviderGetIdentificatorGet(identificator)

Get Provider

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProviderApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getProviderApiV1AiProviderGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProviderApi->getProviderApiV1AiProviderGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**ProviderOut**](ProviderOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProvidersApiV1AiProviderListGet**
> BuiltList<ProviderOut> listProvidersApiV1AiProviderListGet(id, slug, displayName, baseUrl, isActive, createdAt, updatedAt)

List Providers

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProviderApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String slug = slug_example; // String | 
final String displayName = displayName_example; // String | 
final String baseUrl = baseUrl_example; // String | 
final bool isActive = true; // bool | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listProvidersApiV1AiProviderListGet(id, slug, displayName, baseUrl, isActive, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProviderApi->listProvidersApiV1AiProviderListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 
 **displayName** | **String**|  | [optional] 
 **baseUrl** | **String**|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;ProviderOut&gt;**](ProviderOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProviderApiV1AiProviderUpdateIdentificatorPut**
> ProviderOut updateProviderApiV1AiProviderUpdateIdentificatorPut(identificator, providerUpdate)

Update Provider

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProviderApi();
final String identificator = identificator_example; // String | 
final ProviderUpdate providerUpdate = ; // ProviderUpdate | 

try {
    final response = api.updateProviderApiV1AiProviderUpdateIdentificatorPut(identificator, providerUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProviderApi->updateProviderApiV1AiProviderUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **providerUpdate** | [**ProviderUpdate**](ProviderUpdate.md)|  | 

### Return type

[**ProviderOut**](ProviderOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

