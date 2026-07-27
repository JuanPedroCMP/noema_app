# openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authenticateApiV1AuthLoginPost**](AuthenticationApi.md#authenticateapiv1authloginpost) | **POST** /api/v1/auth/login | Authenticate
[**createGoogleAccountApiV1AuthGoogleCreatePost**](AuthenticationApi.md#creategoogleaccountapiv1authgooglecreatepost) | **POST** /api/v1/auth/google/create | Create Google Account
[**deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete**](AuthenticationApi.md#deletegoogleaccountapiv1authgoogledeleteidentificatordelete) | **DELETE** /api/v1/auth/google/delete/{identificator} | Delete Google Account
[**getGoogleAccountApiV1AuthGoogleGetIdentificatorGet**](AuthenticationApi.md#getgoogleaccountapiv1authgooglegetidentificatorget) | **GET** /api/v1/auth/google/get/{identificator} | Get Google Account
[**updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut**](AuthenticationApi.md#updategoogleaccountapiv1authgoogleupdateidentificatorput) | **PUT** /api/v1/auth/google/update/{identificator} | Update Google Account


# **authenticateApiV1AuthLoginPost**
> JsonObject authenticateApiV1AuthLoginPost(username, password, grantType, scope, clientId, clientSecret)

Authenticate

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final String username = username_example; // String | 
final String password = password_example; // String | 
final String grantType = grantType_example; // String | 
final String scope = scope_example; // String | 
final String clientId = clientId_example; // String | 
final String clientSecret = clientSecret_example; // String | 

try {
    final response = api.authenticateApiV1AuthLoginPost(username, password, grantType, scope, clientId, clientSecret);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->authenticateApiV1AuthLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **String**|  | 
 **password** | **String**|  | 
 **grantType** | **String**|  | [optional] 
 **scope** | **String**|  | [optional] [default to '']
 **clientId** | **String**|  | [optional] 
 **clientSecret** | **String**|  | [optional] 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGoogleAccountApiV1AuthGoogleCreatePost**
> GoogleAccountOut createGoogleAccountApiV1AuthGoogleCreatePost(googleAccountCreate)

Create Google Account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAuthenticationApi();
final GoogleAccountCreate googleAccountCreate = ; // GoogleAccountCreate | 

try {
    final response = api.createGoogleAccountApiV1AuthGoogleCreatePost(googleAccountCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->createGoogleAccountApiV1AuthGoogleCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleAccountCreate** | [**GoogleAccountCreate**](GoogleAccountCreate.md)|  | 

### Return type

[**GoogleAccountOut**](GoogleAccountOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete**
> JsonObject deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete(identificator)

Delete Google Account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAuthenticationApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete: $e\n');
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

# **getGoogleAccountApiV1AuthGoogleGetIdentificatorGet**
> GoogleAccountOut getGoogleAccountApiV1AuthGoogleGetIdentificatorGet(identificator)

Get Google Account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAuthenticationApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getGoogleAccountApiV1AuthGoogleGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->getGoogleAccountApiV1AuthGoogleGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**GoogleAccountOut**](GoogleAccountOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut**
> GoogleAccountOut updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut(identificator, googleAccountUpdate)

Update Google Account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getAuthenticationApi();
final String identificator = identificator_example; // String | 
final GoogleAccountUpdate googleAccountUpdate = ; // GoogleAccountUpdate | 

try {
    final response = api.updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut(identificator, googleAccountUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **googleAccountUpdate** | [**GoogleAccountUpdate**](GoogleAccountUpdate.md)|  | 

### Return type

[**GoogleAccountOut**](GoogleAccountOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

