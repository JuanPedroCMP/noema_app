# openapi.api.GoogleOAuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**googleOauthCallbackApiV1AuthGoogleCallbackGet**](GoogleOAuthApi.md#googleoauthcallbackapiv1authgooglecallbackget) | **GET** /api/v1/auth/google/callback | Google Oauth Callback
[**linkGoogleAccountApiV1AuthGoogleLinkGet**](GoogleOAuthApi.md#linkgoogleaccountapiv1authgooglelinkget) | **GET** /api/v1/auth/google/link | Link Google Account


# **googleOauthCallbackApiV1AuthGoogleCallbackGet**
> JsonObject googleOauthCallbackApiV1AuthGoogleCallbackGet()

Google Oauth Callback

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getGoogleOAuthApi();

try {
    final response = api.googleOauthCallbackApiV1AuthGoogleCallbackGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleOAuthApi->googleOauthCallbackApiV1AuthGoogleCallbackGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **linkGoogleAccountApiV1AuthGoogleLinkGet**
> JsonObject linkGoogleAccountApiV1AuthGoogleLinkGet()

Link Google Account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleOAuthApi();

try {
    final response = api.linkGoogleAccountApiV1AuthGoogleLinkGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleOAuthApi->linkGoogleAccountApiV1AuthGoogleLinkGet: $e\n');
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

