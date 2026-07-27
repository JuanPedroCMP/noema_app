# openapi.api.LanguageApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createLanguageApiV1UserConfigLanguageCreatePost**](LanguageApi.md#createlanguageapiv1userconfiglanguagecreatepost) | **POST** /api/v1/user_config/language/create | Create Language
[**getLanguageApiV1UserConfigLanguageGetIdentificatorGet**](LanguageApi.md#getlanguageapiv1userconfiglanguagegetidentificatorget) | **GET** /api/v1/user_config/language/get/{identificator} | Get Language
[**listLanguagesApiV1UserConfigLanguageListGet**](LanguageApi.md#listlanguagesapiv1userconfiglanguagelistget) | **GET** /api/v1/user_config/language/list | List Languages
[**updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut**](LanguageApi.md#updatelanguageapiv1userconfiglanguageupdateidentificatorput) | **PUT** /api/v1/user_config/language/update/{identificator} | Update Language


# **createLanguageApiV1UserConfigLanguageCreatePost**
> LanguageOut createLanguageApiV1UserConfigLanguageCreatePost(languageCreate)

Create Language

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLanguageApi();
final LanguageCreate languageCreate = ; // LanguageCreate | 

try {
    final response = api.createLanguageApiV1UserConfigLanguageCreatePost(languageCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LanguageApi->createLanguageApiV1UserConfigLanguageCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **languageCreate** | [**LanguageCreate**](LanguageCreate.md)|  | 

### Return type

[**LanguageOut**](LanguageOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLanguageApiV1UserConfigLanguageGetIdentificatorGet**
> LanguageOut getLanguageApiV1UserConfigLanguageGetIdentificatorGet(identificator)

Get Language

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLanguageApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getLanguageApiV1UserConfigLanguageGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LanguageApi->getLanguageApiV1UserConfigLanguageGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**LanguageOut**](LanguageOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLanguagesApiV1UserConfigLanguageListGet**
> BuiltList<LanguageOut> listLanguagesApiV1UserConfigLanguageListGet(id, name, percentageTranslated, verifiedTranslation, automaticTranslation, createdAt, updatedAt)

List Languages

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLanguageApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String name = name_example; // String | 
final int percentageTranslated = 56; // int | 
final bool verifiedTranslation = true; // bool | 
final bool automaticTranslation = true; // bool | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime updatedAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listLanguagesApiV1UserConfigLanguageListGet(id, name, percentageTranslated, verifiedTranslation, automaticTranslation, createdAt, updatedAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LanguageApi->listLanguagesApiV1UserConfigLanguageListGet: $e\n');
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

[**BuiltList&lt;LanguageOut&gt;**](LanguageOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut**
> LanguageOut updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut(identificator, languageUpdate)

Update Language

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLanguageApi();
final String identificator = identificator_example; // String | 
final LanguageUpdate languageUpdate = ; // LanguageUpdate | 

try {
    final response = api.updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut(identificator, languageUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LanguageApi->updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 
 **languageUpdate** | [**LanguageUpdate**](LanguageUpdate.md)|  | 

### Return type

[**LanguageOut**](LanguageOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

