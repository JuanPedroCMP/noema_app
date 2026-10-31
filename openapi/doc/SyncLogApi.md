# openapi.api.SyncLogApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost**](SyncLogApi.md#createsynclogendpointapiv1googledrivesynclogcreatepost) | **POST** /api/v1/google_drive/sync_log/create | Create Sync Log Endpoint
[**getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet**](SyncLogApi.md#getsynclogapiv1googledrivesyncloggetidentificatorget) | **GET** /api/v1/google_drive/sync_log/get/{identificator} | Get Sync Log
[**listSyncLogApiV1GoogleDriveSyncLogListGet**](SyncLogApi.md#listsynclogapiv1googledrivesyncloglistget) | **GET** /api/v1/google_drive/sync_log/list | List Sync Log


# **createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost**
> SyncLogOut createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(syncLogCreate)

Create Sync Log Endpoint

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getSyncLogApi();
final SyncLogCreate syncLogCreate = ; // SyncLogCreate | 

try {
    final response = api.createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(syncLogCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SyncLogApi->createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **syncLogCreate** | [**SyncLogCreate**](SyncLogCreate.md)|  | 

### Return type

[**SyncLogOut**](SyncLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet**
> SyncLogOut getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet(identificator)

Get Sync Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getSyncLogApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SyncLogApi->getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**SyncLogOut**](SyncLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSyncLogApiV1GoogleDriveSyncLogListGet**
> BuiltList<SyncLogOut> listSyncLogApiV1GoogleDriveSyncLogListGet(filters, limit, offset)

List Sync Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getSyncLogApi();
final SyncLogFilters filters = ; // SyncLogFilters | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listSyncLogApiV1GoogleDriveSyncLogListGet(filters, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SyncLogApi->listSyncLogApiV1GoogleDriveSyncLogListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filters** | [**SyncLogFilters**](.md)|  | 
 **limit** | **int**|  | [optional] [default to 100]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**BuiltList&lt;SyncLogOut&gt;**](SyncLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

