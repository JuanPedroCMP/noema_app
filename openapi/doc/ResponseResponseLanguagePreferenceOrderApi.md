# openapi.api.ResponseResponseLanguagePreferenceOrderApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost**](ResponseResponseLanguagePreferenceOrderApi.md#createresponselanguagepreferenceorderapiv1userconfigresponseresponselanguagepreferenceordercreatepost) | **POST** /api/v1/user_config/response_response_language_preference_order/create | Create Response Language Preference Order
[**getResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderGetIdentificatorGet**](ResponseResponseLanguagePreferenceOrderApi.md#getresponselanguagepreferenceorderapiv1userconfigresponseresponselanguagepreferenceordergetidentificatorget) | **GET** /api/v1/user_config/response_response_language_preference_order/get/{identificator} | Get Response Language Preference Order
[**listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet**](ResponseResponseLanguagePreferenceOrderApi.md#listresponselanguagepreferenceordersapiv1userconfigresponseresponselanguagepreferenceorderlistget) | **GET** /api/v1/user_config/response_response_language_preference_order/list | List Response Language Preference Orders
[**updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete**](ResponseResponseLanguagePreferenceOrderApi.md#updateresponselanguagepreferenceorderapiv1userconfigresponseresponselanguagepreferenceorderdeleteidentificatordelete) | **DELETE** /api/v1/user_config/response_response_language_preference_order/delete/{identificator} | Update Response Language Preference Order
[**updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut**](ResponseResponseLanguagePreferenceOrderApi.md#updateresponselanguagepreferenceorderapiv1userconfigresponseresponselanguagepreferenceorderupdateidentificatorput) | **PUT** /api/v1/user_config/response_response_language_preference_order/update/{identificator} | Update Response Language Preference Order


# **createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost**
> ResponseLanguagePreferenceOrderOut createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost(responseLanguagePreferenceOrderCreate)

Create Response Language Preference Order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getResponseResponseLanguagePreferenceOrderApi();
final ResponseLanguagePreferenceOrderCreate responseLanguagePreferenceOrderCreate = ; // ResponseLanguagePreferenceOrderCreate | 

try {
    final response = api.createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost(responseLanguagePreferenceOrderCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ResponseResponseLanguagePreferenceOrderApi->createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **responseLanguagePreferenceOrderCreate** | [**ResponseLanguagePreferenceOrderCreate**](ResponseLanguagePreferenceOrderCreate.md)|  | 

### Return type

[**ResponseLanguagePreferenceOrderOut**](ResponseLanguagePreferenceOrderOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderGetIdentificatorGet**
> ResponseLanguagePreferenceOrderOut getResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderGetIdentificatorGet(identificator)

Get Response Language Preference Order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getResponseResponseLanguagePreferenceOrderApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ResponseResponseLanguagePreferenceOrderApi->getResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**ResponseLanguagePreferenceOrderOut**](ResponseLanguagePreferenceOrderOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet**
> BuiltList<ResponseLanguagePreferenceOrderOut> listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet(id, name, percentageTranslated, verifiedTranslation, automaticTranslation, createdAt, updatedAt)

List Response Language Preference Orders

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getResponseResponseLanguagePreferenceOrderApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String name = name_example; // String | 
final int percentageTranslated = 56; // int | 
final bool verifiedTranslation = true; // bool | 
final bool automaticTranslation = true; // bool | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet(id, name, percentageTranslated, verifiedTranslation, automaticTranslation, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ResponseResponseLanguagePreferenceOrderApi->listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **name** | **String**|  | [optional] 
 **percentageTranslated** | **int**|  | [optional] 
 **verifiedTranslation** | **bool**|  | [optional] 
 **automaticTranslation** | **bool**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 
 **updatedAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;ResponseLanguagePreferenceOrderOut&gt;**](ResponseLanguagePreferenceOrderOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete**
> bool updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete(identificator)

Update Response Language Preference Order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getResponseResponseLanguagePreferenceOrderApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ResponseResponseLanguagePreferenceOrderApi->updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

**bool**

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut**
> ResponseLanguagePreferenceOrderOut updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut(identificator, responseLanguagePreferenceOrderUpdate)

Update Response Language Preference Order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getResponseResponseLanguagePreferenceOrderApi();
final String identificator = identificator_example; // String | 
final ResponseLanguagePreferenceOrderUpdate responseLanguagePreferenceOrderUpdate = ; // ResponseLanguagePreferenceOrderUpdate | 

try {
    final response = api.updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut(identificator, responseLanguagePreferenceOrderUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ResponseResponseLanguagePreferenceOrderApi->updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **responseLanguagePreferenceOrderUpdate** | [**ResponseLanguagePreferenceOrderUpdate**](ResponseLanguagePreferenceOrderUpdate.md)|  | 

### Return type

[**ResponseLanguagePreferenceOrderOut**](ResponseLanguagePreferenceOrderOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

