# openapi.api.SyncLogApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSyncLogApiV1GoogleDriveSyncLogCreatePost**](SyncLogApi.md#createsynclogapiv1googledrivesynclogcreatepost) | **POST** /api/v1/google_drive/sync_log/create | Create Sync Log
[**getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet**](SyncLogApi.md#getsynclogapiv1googledrivesyncloggetidentificatorget) | **GET** /api/v1/google_drive/sync_log/get/{identificator} | Get Sync Log
[**listSyncLogApiV1GoogleDriveSyncLogListGet**](SyncLogApi.md#listsynclogapiv1googledrivesyncloglistget) | **GET** /api/v1/google_drive/sync_log/list | List Sync Log


# **createSyncLogApiV1GoogleDriveSyncLogCreatePost**
> SyncLogOut createSyncLogApiV1GoogleDriveSyncLogCreatePost(syncLogCreate)

Create Sync Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getSyncLogApi();
final SyncLogCreate syncLogCreate = ; // SyncLogCreate | 

try {
    final response = api.createSyncLogApiV1GoogleDriveSyncLogCreatePost(syncLogCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SyncLogApi->createSyncLogApiV1GoogleDriveSyncLogCreatePost: $e\n');
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
> BuiltList<SyncLogOut> listSyncLogApiV1GoogleDriveSyncLogListGet(id, idDevice, idBackupFile, event, derection, result, conflictStrategy, errorDetails, metadata, createdAt)

List Sync Log

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getSyncLogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idDevice = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idBackupFile = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String event = event_example; // String | 
final SyncDirection derection = ; // SyncDirection | 
final SyncResult result = ; // SyncResult | 
final ConflictStrategy conflictStrategy = ; // ConflictStrategy | 
final String errorDetails = errorDetails_example; // String | 
final String metadata = metadata_example; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listSyncLogApiV1GoogleDriveSyncLogListGet(id, idDevice, idBackupFile, event, derection, result, conflictStrategy, errorDetails, metadata, createdAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SyncLogApi->listSyncLogApiV1GoogleDriveSyncLogListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idDevice** | **String**|  | [optional] 
 **idBackupFile** | **String**|  | [optional] 
 **event** | **String**|  | [optional] 
 **derection** | [**SyncDirection**](.md)|  | [optional] 
 **result** | [**SyncResult**](.md)|  | [optional] 
 **conflictStrategy** | [**ConflictStrategy**](.md)|  | [optional] 
 **errorDetails** | **String**|  | [optional] 
 **metadata** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;SyncLogOut&gt;**](SyncLogOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

