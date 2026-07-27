# openapi.api.TypographyThemeApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createTypographyThemeApiV1UserThemeTypographyThemeCreatePost**](TypographyThemeApi.md#createtypographythemeapiv1userthemetypographythemecreatepost) | **POST** /api/v1/user_theme/typography_theme/create | Create Typography Theme
[**deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete**](TypographyThemeApi.md#deletetypographythemeapiv1userthemetypographythemedeleteidentificatordelete) | **DELETE** /api/v1/user_theme/typography_theme/delete/{identificator} | Delete Typography Theme
[**getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet**](TypographyThemeApi.md#gettypographythemeapiv1userthemetypographythemegetidentificatorget) | **GET** /api/v1/user_theme/typography_theme/get/{identificator} | Get Typography Theme
[**listTypographyThemeApiV1UserThemeTypographyThemeListGet**](TypographyThemeApi.md#listtypographythemeapiv1userthemetypographythemelistget) | **GET** /api/v1/user_theme/typography_theme/list | List Typography Theme
[**updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut**](TypographyThemeApi.md#updatetypographythemeapiv1userthemetypographythemeupdateidentificatorput) | **PUT** /api/v1/user_theme/typography_theme/update/{identificator} | Update Typography Theme


# **createTypographyThemeApiV1UserThemeTypographyThemeCreatePost**
> UserTypographyThemeOut createTypographyThemeApiV1UserThemeTypographyThemeCreatePost(userTypographyThemeCreate)

Create Typography Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getTypographyThemeApi();
final UserTypographyThemeCreate userTypographyThemeCreate = ; // UserTypographyThemeCreate | 

try {
    final response = api.createTypographyThemeApiV1UserThemeTypographyThemeCreatePost(userTypographyThemeCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TypographyThemeApi->createTypographyThemeApiV1UserThemeTypographyThemeCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userTypographyThemeCreate** | [**UserTypographyThemeCreate**](UserTypographyThemeCreate.md)|  | 

### Return type

[**UserTypographyThemeOut**](UserTypographyThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete**
> JsonObject deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete(identificator)

Delete Typography Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getTypographyThemeApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TypographyThemeApi->deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete: $e\n');
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

# **getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet**
> UserTypographyThemeOut getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet(identificator)

Get Typography Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getTypographyThemeApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TypographyThemeApi->getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**UserTypographyThemeOut**](UserTypographyThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTypographyThemeApiV1UserThemeTypographyThemeListGet**
> BuiltList<UserTypographyThemeOut> listTypographyThemeApiV1UserThemeTypographyThemeListGet(id, idUser, name, displayFont, bodyFont, monoFont, overrideJson, createdAt, updatedAt)

List Typography Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getTypographyThemeApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idUser = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String name = name_example; // String | 
final String displayFont = displayFont_example; // String | 
final String bodyFont = bodyFont_example; // String | 
final String monoFont = monoFont_example; // String | 
final String overrideJson = overrideJson_example; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listTypographyThemeApiV1UserThemeTypographyThemeListGet(id, idUser, name, displayFont, bodyFont, monoFont, overrideJson, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TypographyThemeApi->listTypographyThemeApiV1UserThemeTypographyThemeListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idUser** | **String**|  | [optional] 
 **name** | **String**|  | [optional] 
 **displayFont** | **String**|  | [optional] 
 **bodyFont** | **String**|  | [optional] 
 **monoFont** | **String**|  | [optional] 
 **overrideJson** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;UserTypographyThemeOut&gt;**](UserTypographyThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut**
> UserTypographyThemeOut updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut(identificator, userTypographyThemeUpdate)

Update Typography Theme

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getTypographyThemeApi();
final String identificator = identificator_example; // String | 
final UserTypographyThemeUpdate userTypographyThemeUpdate = ; // UserTypographyThemeUpdate | 

try {
    final response = api.updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut(identificator, userTypographyThemeUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TypographyThemeApi->updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **userTypographyThemeUpdate** | [**UserTypographyThemeUpdate**](UserTypographyThemeUpdate.md)|  | 

### Return type

[**UserTypographyThemeOut**](UserTypographyThemeOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

