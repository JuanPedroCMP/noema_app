# openapi.api.UserGlobalConfigApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost**](UserGlobalConfigApi.md#createuserglobalconfigapiv1userconfiguserglobalconfigcreatepost) | **POST** /api/v1/user_config/user_global_config/create | Create User Global Config
[**getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet**](UserGlobalConfigApi.md#getuserglobalconfigapiv1userconfiguserglobalconfiggetidentificatorget) | **GET** /api/v1/user_config/user_global_config/get/{identificator} | Get User Global Config
[**updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut**](UserGlobalConfigApi.md#updateuserglobalconfigapiv1userconfiguserglobalconfigupdateidentificatorput) | **PUT** /api/v1/user_config/user_global_config/update/{identificator} | Update User Global Config


# **createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost**
> UserGlobalConfigOut createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost(userGlobalConfigCreate)

Create User Global Config

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserGlobalConfigApi();
final UserGlobalConfigCreate userGlobalConfigCreate = ; // UserGlobalConfigCreate | 

try {
    final response = api.createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost(userGlobalConfigCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserGlobalConfigApi->createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userGlobalConfigCreate** | [**UserGlobalConfigCreate**](UserGlobalConfigCreate.md)|  | 

### Return type

[**UserGlobalConfigOut**](UserGlobalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet**
> UserGlobalConfigOut getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(identificator)

Get User Global Config

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserGlobalConfigApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserGlobalConfigApi->getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**UserGlobalConfigOut**](UserGlobalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut**
> UserGlobalConfigOut updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut(identificator, userGlobalConfigUpdate)

Update User Global Config

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserGlobalConfigApi();
final String identificator = identificator_example; // String | 
final UserGlobalConfigUpdate userGlobalConfigUpdate = ; // UserGlobalConfigUpdate | 

try {
    final response = api.updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut(identificator, userGlobalConfigUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserGlobalConfigApi->updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **userGlobalConfigUpdate** | [**UserGlobalConfigUpdate**](UserGlobalConfigUpdate.md)|  | 

### Return type

[**UserGlobalConfigOut**](UserGlobalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

