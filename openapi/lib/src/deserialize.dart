import 'package:openapi/src/model/agent_create.dart';
import 'package:openapi/src/model/agent_model_create.dart';
import 'package:openapi/src/model/agent_model_out.dart';
import 'package:openapi/src/model/agent_model_update.dart';
import 'package:openapi/src/model/agent_out.dart';
import 'package:openapi/src/model/agent_update.dart';
import 'package:openapi/src/model/ai_model_create.dart';
import 'package:openapi/src/model/ai_model_out.dart';
import 'package:openapi/src/model/ai_model_update.dart';
import 'package:openapi/src/model/ai_usage_log_create.dart';
import 'package:openapi/src/model/ai_usage_log_out.dart';
import 'package:openapi/src/model/backup_file_create.dart';
import 'package:openapi/src/model/backup_file_out.dart';
import 'package:openapi/src/model/device_create.dart';
import 'package:openapi/src/model/device_out.dart';
import 'package:openapi/src/model/device_update.dart';
import 'package:openapi/src/model/generic_log_create.dart';
import 'package:openapi/src/model/generic_log_out.dart';
import 'package:openapi/src/model/google_account_create.dart';
import 'package:openapi/src/model/google_account_out.dart';
import 'package:openapi/src/model/google_account_update.dart';
import 'package:openapi/src/model/http_validation_error.dart';
import 'package:openapi/src/model/language_create.dart';
import 'package:openapi/src/model/language_out.dart';
import 'package:openapi/src/model/language_update.dart';
import 'package:openapi/src/model/location_inner.dart';
import 'package:openapi/src/model/provider_create.dart';
import 'package:openapi/src/model/provider_out.dart';
import 'package:openapi/src/model/provider_update.dart';
import 'package:openapi/src/model/response_language_preference_order_create.dart';
import 'package:openapi/src/model/response_language_preference_order_out.dart';
import 'package:openapi/src/model/response_language_preference_order_update.dart';
import 'package:openapi/src/model/sync_log_create.dart';
import 'package:openapi/src/model/sync_log_out.dart';
import 'package:openapi/src/model/user_api_key_can_use_ia_model_create.dart';
import 'package:openapi/src/model/user_api_key_can_use_ia_model_out.dart';
import 'package:openapi/src/model/user_api_key_create.dart';
import 'package:openapi/src/model/user_api_key_out.dart';
import 'package:openapi/src/model/user_api_key_update.dart';
import 'package:openapi/src/model/user_color_theme_create.dart';
import 'package:openapi/src/model/user_color_theme_out.dart';
import 'package:openapi/src/model/user_color_theme_update.dart';
import 'package:openapi/src/model/user_create.dart';
import 'package:openapi/src/model/user_global_config_create.dart';
import 'package:openapi/src/model/user_global_config_out.dart';
import 'package:openapi/src/model/user_global_config_update.dart';
import 'package:openapi/src/model/user_local_config_create.dart';
import 'package:openapi/src/model/user_local_config_out.dart';
import 'package:openapi/src/model/user_local_config_update.dart';
import 'package:openapi/src/model/user_out.dart';
import 'package:openapi/src/model/user_typography_theme_create.dart';
import 'package:openapi/src/model/user_typography_theme_out.dart';
import 'package:openapi/src/model/user_typography_theme_update.dart';
import 'package:openapi/src/model/user_update.dart';
import 'package:openapi/src/model/validation_error.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AgentCreate':
          return AgentCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AgentModelCreate':
          return AgentModelCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AgentModelOut':
          return AgentModelOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AgentModelQuality':
          
          
        case 'AgentModelUpdate':
          return AgentModelUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AgentOut':
          return AgentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AgentUpdate':
          return AgentUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AiModelCreate':
          return AiModelCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AiModelOut':
          return AiModelOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AiModelUpdate':
          return AiModelUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AiUsageLogCreate':
          return AiUsageLogCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AiUsageLogOut':
          return AiUsageLogOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BackupFileCreate':
          return BackupFileCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BackupFileOut':
          return BackupFileOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConflictStrategy':
          
          
        case 'DeviceCreate':
          return DeviceCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceOut':
          return DeviceOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceUpdate':
          return DeviceUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GenericLogCreate':
          return GenericLogCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GenericLogOut':
          return GenericLogOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleAccountCreate':
          return GoogleAccountCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleAccountOut':
          return GoogleAccountOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleAccountUpdate':
          return GoogleAccountUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HTTPValidationError':
          return HTTPValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LanguageCreate':
          return LanguageCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LanguageOut':
          return LanguageOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LanguageUpdate':
          return LanguageUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LocationInner':
          return LocationInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProviderCreate':
          return ProviderCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProviderOut':
          return ProviderOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProviderUpdate':
          return ProviderUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResponseLanguagePreferenceOrderCreate':
          return ResponseLanguagePreferenceOrderCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResponseLanguagePreferenceOrderOut':
          return ResponseLanguagePreferenceOrderOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResponseLanguagePreferenceOrderUpdate':
          return ResponseLanguagePreferenceOrderUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SyncDirection':
          
          
        case 'SyncLogCreate':
          return SyncLogCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SyncLogOut':
          return SyncLogOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SyncResult':
          
          
        case 'TaskType':
          
          
        case 'UserApiKeyCanUseIaModelCreate':
          return UserApiKeyCanUseIaModelCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserApiKeyCanUseIaModelOut':
          return UserApiKeyCanUseIaModelOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserApiKeyCreate':
          return UserApiKeyCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserApiKeyOut':
          return UserApiKeyOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserApiKeyUpdate':
          return UserApiKeyUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserColorThemeCreate':
          return UserColorThemeCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserColorThemeOut':
          return UserColorThemeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserColorThemeUpdate':
          return UserColorThemeUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserCreate':
          return UserCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserGlobalConfigCreate':
          return UserGlobalConfigCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserGlobalConfigOut':
          return UserGlobalConfigOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserGlobalConfigUpdate':
          return UserGlobalConfigUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserLocalConfigCreate':
          return UserLocalConfigCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserLocalConfigOut':
          return UserLocalConfigOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserLocalConfigUpdate':
          return UserLocalConfigUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserOut':
          return UserOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserTypographyThemeCreate':
          return UserTypographyThemeCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserTypographyThemeOut':
          return UserTypographyThemeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserTypographyThemeUpdate':
          return UserTypographyThemeUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserUpdate':
          return UserUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationError':
          return ValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }