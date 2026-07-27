# openapi.api.ColorThemeApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createColorThemeApiV1UserThemeColorThemeCreatePost**](ColorThemeApi.md#createcolorthemeapiv1userthemecolorthemecreatepost) | **POST** /api/v1/user_theme/color_theme/create | Create Color Theme
[**deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete**](ColorThemeApi.md#deletecolorthemeapiv1userthemecolorthemedeleteidentificatordelete) | **DELETE** /api/v1/user_theme/color_theme/delete/{identificator} | Delete Color Theme
[**getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet**](ColorThemeApi.md#getcolorthemeapiv1userthemecolorthemegetidentificatorget) | **GET** /api/v1/user_theme/color_theme/get/{identificator} | Get Color Theme
[**listColorThemeApiV1UserThemeColorThemeListGet**](ColorThemeApi.md#listcolorthemeapiv1userthemecolorthemelistget) | **GET** /api/v1/user_theme/color_theme/list | List Color Theme
[**updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut**](ColorThemeApi.md#updatecolorthemeapiv1userthemecolorthemeupdateidentificatorput) | **PUT** /api/v1/user_theme/color_theme/update/{identificator} | Update Color Theme


# **createColorThemeApiV1UserThemeColorThemeCreatePost**
> UserColorThemeOut createColorThemeApiV1UserThemeColorThemeCreatePost(userColorThemeCreate)

Create Color Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getColorThemeApi();
final UserColorThemeCreate userColorThemeCreate = ; // UserColorThemeCreate | 

try {
    final response = api.createColorThemeApiV1UserThemeColorThemeCreatePost(userColorThemeCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ColorThemeApi->createColorThemeApiV1UserThemeColorThemeCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userColorThemeCreate** | [**UserColorThemeCreate**](UserColorThemeCreate.md)|  | 

### Return type

[**UserColorThemeOut**](UserColorThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete**
> JsonObject deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete(identificator)

Delete Color Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getColorThemeApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ColorThemeApi->deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete: $e\n');
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

# **getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet**
> UserColorThemeOut getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet(identificator)

Get Color Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getColorThemeApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ColorThemeApi->getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**UserColorThemeOut**](UserColorThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listColorThemeApiV1UserThemeColorThemeListGet**
> BuiltList<UserColorThemeOut> listColorThemeApiV1UserThemeColorThemeListGet(id, idUser, name, seedColor, overrideJson, createdAt, updatedAt)

List Color Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getColorThemeApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String name = name_example; // String | 
final int seedColor = 56; // int | 
final String overrideJson = overrideJson_example; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listColorThemeApiV1UserThemeColorThemeListGet(id, idUser, name, seedColor, overrideJson, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ColorThemeApi->listColorThemeApiV1UserThemeColorThemeListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **name** | **String**|  | [optional] 
 **seedColor** | **int**|  | [optional] 
 **overrideJson** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;UserColorThemeOut&gt;**](UserColorThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut**
> UserColorThemeOut updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut(identificator, userColorThemeUpdate)

Update Color Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getColorThemeApi();
final String identificator = identificator_example; // String | 
final UserColorThemeUpdate userColorThemeUpdate = ; // UserColorThemeUpdate | 

try {
    final response = api.updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut(identificator, userColorThemeUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ColorThemeApi->updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **userColorThemeUpdate** | [**UserColorThemeUpdate**](UserColorThemeUpdate.md)|  | 

### Return type

[**UserColorThemeOut**](UserColorThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

