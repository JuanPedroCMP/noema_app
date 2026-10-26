# openapi.api.UserLocalConfigApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost**](UserLocalConfigApi.md#createuserlocalconfigapiv1userconfiguserlocalconfigcreatepost) | **POST** /api/v1/user_config/user_local_config/create | Create User Local Config
[**getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet**](UserLocalConfigApi.md#getuserlocalconfigapiv1userconfiguserlocalconfiggetidentificatorget) | **GET** /api/v1/user_config/user_local_config/get/{identificator} | Get User Local Config
[**listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet**](UserLocalConfigApi.md#listuserlocalconfigsapiv1userconfiguserlocalconfiglistget) | **GET** /api/v1/user_config/user_local_config/list | List User Local Configs
[**updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut**](UserLocalConfigApi.md#updateuserlocalconfigapiv1userconfiguserlocalconfigupdateidentificatorput) | **PUT** /api/v1/user_config/user_local_config/update/{identificator} | Update User Local Config


# **createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost**
> UserLocalConfigOut createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost(userLocalConfigCreate)

Create User Local Config

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserLocalConfigApi();
final UserLocalConfigCreate userLocalConfigCreate = ; // UserLocalConfigCreate | 

try {
    final response = api.createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost(userLocalConfigCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserLocalConfigApi->createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userLocalConfigCreate** | [**UserLocalConfigCreate**](UserLocalConfigCreate.md)|  | 

### Return type

[**UserLocalConfigOut**](UserLocalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet**
> UserLocalConfigOut getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet(identificator)

Get User Local Config

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserLocalConfigApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserLocalConfigApi->getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**UserLocalConfigOut**](UserLocalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet**
> BuiltList<UserLocalConfigOut> listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet(preferences, id, idUser, idDevice, idLanguage, idUserColorTheme, idUserTypographyTheme, createdAt, updatedAt)

List User Local Configs

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserLocalConfigApi();
final String preferences = preferences_example; // String | 
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idDevice = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idLanguage = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUserColorTheme = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUserTypographyTheme = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet(preferences, id, idUser, idDevice, idLanguage, idUserColorTheme, idUserTypographyTheme, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserLocalConfigApi->listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **preferences** | **String**|  | 
 **id** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **idDevice** | **String**|  | [optional] 
 **idLanguage** | **String**|  | [optional] 
 **idUserColorTheme** | **String**|  | [optional] 
 **idUserTypographyTheme** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;UserLocalConfigOut&gt;**](UserLocalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut**
> UserLocalConfigOut updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut(identificator, userLocalConfigUpdate)

Update User Local Config

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserLocalConfigApi();
final String identificator = identificator_example; // String | 
final UserLocalConfigUpdate userLocalConfigUpdate = ; // UserLocalConfigUpdate | 

try {
    final response = api.updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut(identificator, userLocalConfigUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserLocalConfigApi->updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **userLocalConfigUpdate** | [**UserLocalConfigUpdate**](UserLocalConfigUpdate.md)|  | 

### Return type

[**UserLocalConfigOut**](UserLocalConfigOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

