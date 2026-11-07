# openapi.api.GoogleDriveOAuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**googleAccountLinkApiV1GoogleDriveAccountLinkPost**](GoogleDriveOAuthApi.md#googleaccountlinkapiv1googledriveaccountlinkpost) | **POST** /api/v1/google_drive/account/link | Link a native Google authorization without storing its tokens
[**googleAccountStatusApiV1GoogleDriveAccountStatusGet**](GoogleDriveOAuthApi.md#googleaccountstatusapiv1googledriveaccountstatusget) | **GET** /api/v1/google_drive/account/status | Get Google account and Drive app-data authorization state
[**refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost**](GoogleDriveOAuthApi.md#refreshgooglestatusapiv1googledriveaccountstatusrefreshpost) | **POST** /api/v1/google_drive/account/status/refresh | Re-check the currently linked Google authorization


# **googleAccountLinkApiV1GoogleDriveAccountLinkPost**
> GoogleAccountStatusOut googleAccountLinkApiV1GoogleDriveAccountLinkPost(googleAccountLinkRequest)

Link a native Google authorization without storing its tokens

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveOAuthApi();
final GoogleAccountLinkRequest googleAccountLinkRequest = ; // GoogleAccountLinkRequest | 

try {
    final response = api.googleAccountLinkApiV1GoogleDriveAccountLinkPost(googleAccountLinkRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveOAuthApi->googleAccountLinkApiV1GoogleDriveAccountLinkPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleAccountLinkRequest** | [**GoogleAccountLinkRequest**](GoogleAccountLinkRequest.md)|  | 

### Return type

[**GoogleAccountStatusOut**](GoogleAccountStatusOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **googleAccountStatusApiV1GoogleDriveAccountStatusGet**
> GoogleAccountStatusOut googleAccountStatusApiV1GoogleDriveAccountStatusGet()

Get Google account and Drive app-data authorization state

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveOAuthApi();

try {
    final response = api.googleAccountStatusApiV1GoogleDriveAccountStatusGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveOAuthApi->googleAccountStatusApiV1GoogleDriveAccountStatusGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GoogleAccountStatusOut**](GoogleAccountStatusOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost**
> GoogleAccountStatusOut refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost(googleAccountLinkRequest)

Re-check the currently linked Google authorization

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveOAuthApi();
final GoogleAccountLinkRequest googleAccountLinkRequest = ; // GoogleAccountLinkRequest | 

try {
    final response = api.refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost(googleAccountLinkRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveOAuthApi->refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleAccountLinkRequest** | [**GoogleAccountLinkRequest**](GoogleAccountLinkRequest.md)|  | 

### Return type

[**GoogleAccountStatusOut**](GoogleAccountStatusOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

