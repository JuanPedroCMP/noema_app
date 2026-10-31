# openapi.model.SyncLogCreate

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**idDevice** | **String** |  | 
**idBackupFile** | **String** |  | [optional] 
**idGoogleAccount** | **String** |  | [optional] 
**idempotencyKey** | **String** |  | [optional] 
**event** | **String** |  | 
**derection** | [**SyncDirection**](SyncDirection.md) |  | 
**result** | [**SyncResult**](SyncResult.md) |  | 
**conflictStrategy** | [**ConflictStrategy**](ConflictStrategy.md) |  | [optional] 
**errorDetails** | **String** |  | [optional] 
**metadata** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


