# openapi.api.GoogleDriveSyncApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createBackupApiV1GoogleDriveBackupsPost**](GoogleDriveSyncApi.md#createbackupapiv1googledrivebackupspost) | **POST** /api/v1/google_drive/backups | Record metadata after the app completes a direct Drive upload
[**createBackupFileApiV1GoogleDriveBackupFileCreatePost**](GoogleDriveSyncApi.md#createbackupfileapiv1googledrivebackupfilecreatepost) | **POST** /api/v1/google_drive/backup_file/create | Create Backup File
[**createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost**](GoogleDriveSyncApi.md#createsynclogendpointapiv1googledrivesynclogcreatepost) | **POST** /api/v1/google_drive/sync_log/create | Create Sync Log Endpoint
[**deleteBackupApiV1GoogleDriveBackupsBackupIdDelete**](GoogleDriveSyncApi.md#deletebackupapiv1googledrivebackupsbackupiddelete) | **DELETE** /api/v1/google_drive/backups/{backup_id} | Delete metadata only; the app must delete the Drive file separately
[**deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete**](GoogleDriveSyncApi.md#deletebackupfileapiv1googledrivebackupfiledeleteidentificatordelete) | **DELETE** /api/v1/google_drive/backup_file/delete/{identificator} | Delete Backup File
[**getBackupApiV1GoogleDriveBackupsBackupIdGet**](GoogleDriveSyncApi.md#getbackupapiv1googledrivebackupsbackupidget) | **GET** /api/v1/google_drive/backups/{backup_id} | Get one owned backup metadata record
[**getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet**](GoogleDriveSyncApi.md#getbackupfileapiv1googledrivebackupfilegetidentificatorget) | **GET** /api/v1/google_drive/backup_file/get/{identificator} | Get Backup File
[**getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet**](GoogleDriveSyncApi.md#getsynclogapiv1googledrivesyncloggetidentificatorget) | **GET** /api/v1/google_drive/sync_log/get/{identificator} | Get Sync Log
[**googleAccountLinkApiV1GoogleDriveAccountLinkPost**](GoogleDriveSyncApi.md#googleaccountlinkapiv1googledriveaccountlinkpost) | **POST** /api/v1/google_drive/account/link | Link a native Google authorization without storing its tokens
[**googleAccountStatusApiV1GoogleDriveAccountStatusGet**](GoogleDriveSyncApi.md#googleaccountstatusapiv1googledriveaccountstatusget) | **GET** /api/v1/google_drive/account/status | Get Google account and Drive app-data authorization state
[**listBackupFileApiV1GoogleDriveBackupFileListGet**](GoogleDriveSyncApi.md#listbackupfileapiv1googledrivebackupfilelistget) | **GET** /api/v1/google_drive/backup_file/list | List Backup File
[**listBackupsApiV1GoogleDriveBackupsGet**](GoogleDriveSyncApi.md#listbackupsapiv1googledrivebackupsget) | **GET** /api/v1/google_drive/backups | List backup metadata owned by the authenticated user
[**listSyncLogApiV1GoogleDriveSyncLogListGet**](GoogleDriveSyncApi.md#listsynclogapiv1googledrivesyncloglistget) | **GET** /api/v1/google_drive/sync_log/list | List Sync Log
[**refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost**](GoogleDriveSyncApi.md#refreshgooglestatusapiv1googledriveaccountstatusrefreshpost) | **POST** /api/v1/google_drive/account/status/refresh | Re-check the currently linked Google authorization
[**updateBackupApiV1GoogleDriveBackupsBackupIdPut**](GoogleDriveSyncApi.md#updatebackupapiv1googledrivebackupsbackupidput) | **PUT** /api/v1/google_drive/backups/{backup_id} | Update metadata with optimistic Drive-version and hash preconditions


# **createBackupApiV1GoogleDriveBackupsPost**
> BackupFileOut createBackupApiV1GoogleDriveBackupsPost(backupMetadataCreate)

Record metadata after the app completes a direct Drive upload

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final BackupMetadataCreate backupMetadataCreate = ; // BackupMetadataCreate | 

try {
    final response = api.createBackupApiV1GoogleDriveBackupsPost(backupMetadataCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->createBackupApiV1GoogleDriveBackupsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backupMetadataCreate** | [**BackupMetadataCreate**](BackupMetadataCreate.md)|  | 

### Return type

[**BackupFileOut**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBackupFileApiV1GoogleDriveBackupFileCreatePost**
> BackupFileOut createBackupFileApiV1GoogleDriveBackupFileCreatePost(backupFileCreate)

Create Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final BackupFileCreate backupFileCreate = ; // BackupFileCreate | 

try {
    final response = api.createBackupFileApiV1GoogleDriveBackupFileCreatePost(backupFileCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->createBackupFileApiV1GoogleDriveBackupFileCreatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backupFileCreate** | [**BackupFileCreate**](BackupFileCreate.md)|  | 

### Return type

[**BackupFileOut**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost**
> SyncLogOut createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(syncLogCreate)

Create Sync Log Endpoint

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final SyncLogCreate syncLogCreate = ; // SyncLogCreate | 

try {
    final response = api.createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost(syncLogCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->createSyncLogEndpointApiV1GoogleDriveSyncLogCreatePost: $e\n');
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

# **deleteBackupApiV1GoogleDriveBackupsBackupIdDelete**
> BuiltMap<String, bool?> deleteBackupApiV1GoogleDriveBackupsBackupIdDelete(backupId)

Delete metadata only; the app must delete the Drive file separately

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final String backupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.deleteBackupApiV1GoogleDriveBackupsBackupIdDelete(backupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->deleteBackupApiV1GoogleDriveBackupsBackupIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backupId** | **String**|  | 

### Return type

**BuiltMap&lt;String, bool?&gt;**

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete**
> BuiltMap<String, bool?> deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(identificator)

Delete Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final String identificator = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

**BuiltMap&lt;String, bool?&gt;**

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBackupApiV1GoogleDriveBackupsBackupIdGet**
> BackupFileOut getBackupApiV1GoogleDriveBackupsBackupIdGet(backupId)

Get one owned backup metadata record

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final String backupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getBackupApiV1GoogleDriveBackupsBackupIdGet(backupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->getBackupApiV1GoogleDriveBackupsBackupIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backupId** | **String**|  | 

### Return type

[**BackupFileOut**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet**
> BackupFileOut getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet(identificator)

Get Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **identificator** | **String**|  | 

### Return type

[**BackupFileOut**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
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

final api = Openapi().getGoogleDriveSyncApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->getSyncLogApiV1GoogleDriveSyncLogGetIdentificatorGet: $e\n');
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

# **googleAccountLinkApiV1GoogleDriveAccountLinkPost**
> GoogleAccountStatusOut googleAccountLinkApiV1GoogleDriveAccountLinkPost(googleAccountLinkRequest)

Link a native Google authorization without storing its tokens

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final GoogleAccountLinkRequest googleAccountLinkRequest = ; // GoogleAccountLinkRequest | 

try {
    final response = api.googleAccountLinkApiV1GoogleDriveAccountLinkPost(googleAccountLinkRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->googleAccountLinkApiV1GoogleDriveAccountLinkPost: $e\n');
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

final api = Openapi().getGoogleDriveSyncApi();

try {
    final response = api.googleAccountStatusApiV1GoogleDriveAccountStatusGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->googleAccountStatusApiV1GoogleDriveAccountStatusGet: $e\n');
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

# **listBackupFileApiV1GoogleDriveBackupFileListGet**
> BuiltList<BackupFileOut> listBackupFileApiV1GoogleDriveBackupFileListGet(filters, limit, offset)

List Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final BackupFileFilters filters = ; // BackupFileFilters | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listBackupFileApiV1GoogleDriveBackupFileListGet(filters, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->listBackupFileApiV1GoogleDriveBackupFileListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filters** | [**BackupFileFilters**](.md)|  | 
 **limit** | **int**|  | [optional] [default to 100]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**BuiltList&lt;BackupFileOut&gt;**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBackupsApiV1GoogleDriveBackupsGet**
> BuiltList<BackupFileOut> listBackupsApiV1GoogleDriveBackupsGet(filters, limit, offset)

List backup metadata owned by the authenticated user

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final BackupFileFilters filters = ; // BackupFileFilters | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listBackupsApiV1GoogleDriveBackupsGet(filters, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->listBackupsApiV1GoogleDriveBackupsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filters** | [**BackupFileFilters**](.md)|  | 
 **limit** | **int**|  | [optional] [default to 100]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**BuiltList&lt;BackupFileOut&gt;**](BackupFileOut.md)

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

final api = Openapi().getGoogleDriveSyncApi();
final SyncLogFilters filters = ; // SyncLogFilters | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listSyncLogApiV1GoogleDriveSyncLogListGet(filters, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->listSyncLogApiV1GoogleDriveSyncLogListGet: $e\n');
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

# **refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost**
> GoogleAccountStatusOut refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost(googleAccountLinkRequest)

Re-check the currently linked Google authorization

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final GoogleAccountLinkRequest googleAccountLinkRequest = ; // GoogleAccountLinkRequest | 

try {
    final response = api.refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost(googleAccountLinkRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost: $e\n');
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

# **updateBackupApiV1GoogleDriveBackupsBackupIdPut**
> BackupFileOut updateBackupApiV1GoogleDriveBackupsBackupIdPut(backupId, backupMetadataUpdate)

Update metadata with optimistic Drive-version and hash preconditions

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getGoogleDriveSyncApi();
final String backupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final BackupMetadataUpdate backupMetadataUpdate = ; // BackupMetadataUpdate | 

try {
    final response = api.updateBackupApiV1GoogleDriveBackupsBackupIdPut(backupId, backupMetadataUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GoogleDriveSyncApi->updateBackupApiV1GoogleDriveBackupsBackupIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backupId** | **String**|  | 
 **backupMetadataUpdate** | [**BackupMetadataUpdate**](BackupMetadataUpdate.md)|  | 

### Return type

[**BackupFileOut**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

