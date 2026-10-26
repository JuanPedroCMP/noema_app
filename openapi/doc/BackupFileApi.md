# openapi.api.BackupFileApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createBackupFileApiV1GoogleDriveBackupFileCreatePost**](BackupFileApi.md#createbackupfileapiv1googledrivebackupfilecreatepost) | **POST** /api/v1/google_drive/backup_file/create | Create Backup File
[**deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete**](BackupFileApi.md#deletebackupfileapiv1googledrivebackupfiledeleteidentificatordelete) | **DELETE** /api/v1/google_drive/backup_file/delete/{identificator} | Delete Backup File
[**getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet**](BackupFileApi.md#getbackupfileapiv1googledrivebackupfilegetidentificatorget) | **GET** /api/v1/google_drive/backup_file/get/{identificator} | Get Backup File
[**listBackupFileApiV1GoogleDriveBackupFileListGet**](BackupFileApi.md#listbackupfileapiv1googledrivebackupfilelistget) | **GET** /api/v1/google_drive/backup_file/list | List Backup File


# **createBackupFileApiV1GoogleDriveBackupFileCreatePost**
> BackupFileOut createBackupFileApiV1GoogleDriveBackupFileCreatePost(backupFileCreate)

Create Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getBackupFileApi();
final BackupFileCreate backupFileCreate = ; // BackupFileCreate | 

try {
    final response = api.createBackupFileApiV1GoogleDriveBackupFileCreatePost(backupFileCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BackupFileApi->createBackupFileApiV1GoogleDriveBackupFileCreatePost: $e\n');
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

# **deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete**
> JsonObject deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(identificator)

Delete Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getBackupFileApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BackupFileApi->deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete: $e\n');
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

# **getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet**
> BackupFileOut getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet(identificator)

Get Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getBackupFileApi();
final String identificator = identificator_example; // String | 

try {
    final response = api.getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet(identificator);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BackupFileApi->getBackupFileApiV1GoogleDriveBackupFileGetIdentificatorGet: $e\n');
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

# **listBackupFileApiV1GoogleDriveBackupFileListGet**
> BuiltList<BackupFileOut> listBackupFileApiV1GoogleDriveBackupFileListGet(id, idGoogleAccount, driveFileId, localRef, driveVersion, contentHash, createdAt)

List Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getBackupFileApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idGoogleAccount = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String driveFileId = driveFileId_example; // String | 
final String localRef = localRef_example; // String | 
final String driveVersion = driveVersion_example; // String | 
final String contentHash = contentHash_example; // String | 
final DateTime createdAt = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listBackupFileApiV1GoogleDriveBackupFileListGet(id, idGoogleAccount, driveFileId, localRef, driveVersion, contentHash, createdAt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BackupFileApi->listBackupFileApiV1GoogleDriveBackupFileListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **idGoogleAccount** | **String**|  | [optional] 
 **driveFileId** | **String**|  | [optional] 
 **localRef** | **String**|  | [optional] 
 **driveVersion** | **String**|  | [optional] 
 **contentHash** | **String**|  | [optional] 
 **createdAt** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;BackupFileOut&gt;**](BackupFileOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

