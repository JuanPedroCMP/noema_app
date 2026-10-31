# openapi.api.GoogleOAuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet**](GoogleOAuthApi.md#retiredgoogleoauthcallbackapiv1authgooglecallbackget) | **GET** /api/v1/auth/google/callback | Retired Google Oauth Callback
[**retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet**](GoogleOAuthApi.md#retiredserversidegoogleoauthapiv1authgooglelinkget) | **GET** /api/v1/auth/google/link | Retired Server Side Google Oauth


# **retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet**
> JsonObject retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet()

Retired Google Oauth Callback

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getGoogleOAuthApi();

try {
    final response = api.retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleOAuthApi->retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet: $e\n');
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

# **retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet**
> JsonObject retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet()

Retired Server Side Google Oauth

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleOAuthApi();

try {
    final response = api.retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleOAuthApi->retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet: $e\n');
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

