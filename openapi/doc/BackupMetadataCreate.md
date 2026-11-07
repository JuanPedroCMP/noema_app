# openapi.model.BackupMetadataCreate

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**idGoogleAccount** | **String** |  | 
**idDevice** | **String** |  | 
**driveFileId** | **String** |  | 
**localRef** | **String** |  | [optional] 
**driveVersion** | **String** | Drive API file version/revision; distinct from snapshot_version. | 
**snapshotVersion** | **String** | Logical snapshot version assigned by the Flutter app. | 
**contentHash** | **String** |  | 
**sizeBytes** | **int** |  | 
**operationState** | [**BackupOperationState**](BackupOperationState.md) |  | 
**manifest** | [**SnapshotManifest**](SnapshotManifest.md) |  | 
**idempotencyKey** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


