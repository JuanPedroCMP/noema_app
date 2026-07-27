# openapi.api.GenericLogApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createGenericLogApiV1GenericLogCreatePost**](GenericLogApi.md#creategenericlogapiv1genericlogcreatepost) | **POST** /api/v1/generic_log/create | Create Generic Log
[**getGenericLogApiV1GenericLogGetIdentificatorGet**](GenericLogApi.md#getgenericlogapiv1genericloggetidentificatorget) | **GET** /api/v1/generic_log/get/{identificator} | Get Generic Log
[**listGenericLogApiV1GenericLogListGet**](GenericLogApi.md#listgenericlogapiv1genericloglistget) | **GET** /api/v1/generic_log/list | List Generic Log


# **createGenericLogApiV1GenericLogCreatePost**
> GenericLogOut createGenericLogApiV1GenericLogCreatePost(genericLogCreate)

Create Generic Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGenericLogApi();
final GenericLogCreate genericLogCreate = ; // GenericLogCreate | 

try {
    final response = api.createGenericLogApiV1GenericLogCreatePost(genericLogCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GenericLogApi->createGenericLogApiV1GenericLogCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **genericLogCreate** | [**GenericLogCreate**](GenericLogCreate.md)|  | 

### Return type

[**GenericLogOut**](GenericLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGenericLogApiV1GenericLogGetIdentificatorGet**
> GenericLogOut getGenericLogApiV1GenericLogGetIdentificatorGet(identificator)

Get Generic Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGenericLogApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getGenericLogApiV1GenericLogGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GenericLogApi->getGenericLogApiV1GenericLogGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**GenericLogOut**](GenericLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGenericLogApiV1GenericLogListGet**
> BuiltList<GenericLogOut> listGenericLogApiV1GenericLogListGet(id, type, idUser, details, createdAt)

List Generic Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGenericLogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String type = type_example; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String details = details_example; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listGenericLogApiV1GenericLogListGet(id, type, idUser, details, createdAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GenericLogApi->listGenericLogApiV1GenericLogListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **type** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **details** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;GenericLogOut&gt;**](GenericLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

