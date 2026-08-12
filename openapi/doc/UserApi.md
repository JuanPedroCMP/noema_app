# openapi.api.UserApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**currentUserApiV1UserGetGet**](UserApi.md#currentuserapiv1usergetget) | **GET** /api/v1/user/get | Current User
[**deleteUserApiV1UserDeleteDelete**](UserApi.md#deleteuserapiv1userdeletedelete) | **DELETE** /api/v1/user/delete | Delete User
[**newUserApiV1UserCreatePost**](UserApi.md#newuserapiv1usercreatepost) | **POST** /api/v1/user/create | New User
[**updateUserApiV1UserUpdatePut**](UserApi.md#updateuserapiv1userupdateput) | **PUT** /api/v1/user/update | Update User


# **currentUserApiV1UserGetGet**
> UserOut currentUserApiV1UserGetGet()

Current User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApi();

try {
    final response = api.currentUserApiV1UserGetGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->currentUserApiV1UserGetGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserApiV1UserDeleteDelete**
> JsonObject deleteUserApiV1UserDeleteDelete()

Delete User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApi();

try {
    final response = api.deleteUserApiV1UserDeleteDelete();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->deleteUserApiV1UserDeleteDelete: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **newUserApiV1UserCreatePost**
> UserOut newUserApiV1UserCreatePost(userCreate)

New User

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUserApi();
final UserCreate userCreate = ; // UserCreate | 

try {
    final response = api.newUserApiV1UserCreatePost(userCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->newUserApiV1UserCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userCreate** | [**UserCreate**](UserCreate.md)|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserApiV1UserUpdatePut**
> UserOut updateUserApiV1UserUpdatePut(userUpdate)

Update User

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getUserApi();
final UserUpdate userUpdate = ; // UserUpdate | 

try {
    final response = api.updateUserApiV1UserUpdatePut(userUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->updateUserApiV1UserUpdatePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userUpdate** | [**UserUpdate**](UserUpdate.md)|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

