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
> BuiltMap<String, bool?> deleteBackupFileApiV1GoogleDriveBackupFileDeleteIdentificatorDelete(identificator)

Delete Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getBackupFileApi();
final String identificator = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

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

**BuiltMap&lt;String, bool?&gt;**

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
> BuiltList<BackupFileOut> listBackupFileApiV1GoogleDriveBackupFileListGet(filters, limit, offset)

List Backup File

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = Openapi().getBackupFileApi();
final BackupFileFilters filters = ; // BackupFileFilters | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listBackupFileApiV1GoogleDriveBackupFileListGet(filters, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BackupFileApi->listBackupFileApiV1GoogleDriveBackupFileListGet: $e\n');
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

