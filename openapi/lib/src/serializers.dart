//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/agent_create.dart';
import 'package:openapi/src/model/agent_model_create.dart';
import 'package:openapi/src/model/agent_model_out.dart';
import 'package:openapi/src/model/agent_model_quality.dart';
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
import 'package:openapi/src/model/conflict_strategy.dart';
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
import 'package:openapi/src/model/sync_direction.dart';
import 'package:openapi/src/model/sync_log_create.dart';
import 'package:openapi/src/model/sync_log_out.dart';
import 'package:openapi/src/model/sync_result.dart';
import 'package:openapi/src/model/task_type.dart';
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
import 'package:openapi/src/model/user_typography_theme_create.dart';
import 'package:openapi/src/model/user_typography_theme_out.dart';
import 'package:openapi/src/model/user_typography_theme_update.dart';
import 'package:openapi/src/model/user_update.dart';
import 'package:openapi/src/model/validation_error.dart';

part 'serializers.g.dart';

@SerializersFor([
  AgentCreate,
  AgentModelCreate,
  AgentModelOut,
  AgentModelQuality,
  AgentModelUpdate,
  AgentOut,
  AgentUpdate,
  AiModelCreate,
  AiModelOut,
  AiModelUpdate,
  AiUsageLogCreate,
  AiUsageLogOut,
  BackupFileCreate,
  BackupFileOut,
  ConflictStrategy,
  DeviceCreate,
  DeviceOut,
  DeviceUpdate,
  GenericLogCreate,
  GenericLogOut,
  GoogleAccountCreate,
  GoogleAccountOut,
  GoogleAccountUpdate,
  HTTPValidationError,
  LanguageCreate,
  LanguageOut,
  LanguageUpdate,
  LocationInner,
  ProviderCreate,
  ProviderOut,
  ProviderUpdate,
  ResponseLanguagePreferenceOrderCreate,
  ResponseLanguagePreferenceOrderOut,
  ResponseLanguagePreferenceOrderUpdate,
  SyncDirection,
  SyncLogCreate,
  SyncLogOut,
  SyncResult,
  TaskType,
  UserApiKeyCanUseIaModelCreate,
  UserApiKeyCanUseIaModelOut,
  UserApiKeyCreate,
  UserApiKeyOut,
  UserApiKeyUpdate,
  UserColorThemeCreate,
  UserColorThemeOut,
  UserColorThemeUpdate,
  UserCreate,
  UserGlobalConfigCreate,
  UserGlobalConfigOut,
  UserGlobalConfigUpdate,
  UserLocalConfigCreate,
  UserLocalConfigOut,
  UserLocalConfigUpdate,
  UserTypographyThemeCreate,
  UserTypographyThemeOut,
  UserTypographyThemeUpdate,
  UserUpdate,
  ValidationError,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ProviderOut)]),
        () => ListBuilder<ProviderOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserColorThemeOut)]),
        () => ListBuilder<UserColorThemeOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AgentOut)]),
        () => ListBuilder<AgentOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(BackupFileOut)]),
        () => ListBuilder<BackupFileOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AiModelOut)]),
        () => ListBuilder<AiModelOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SyncLogOut)]),
        () => ListBuilder<SyncLogOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserApiKeyCanUseIaModelOut)]),
        () => ListBuilder<UserApiKeyCanUseIaModelOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AiUsageLogOut)]),
        () => ListBuilder<AiUsageLogOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(GenericLogOut)]),
        () => ListBuilder<GenericLogOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserApiKeyOut)]),
        () => ListBuilder<UserApiKeyOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AgentModelOut)]),
        () => ListBuilder<AgentModelOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ResponseLanguagePreferenceOrderOut)]),
        () => ListBuilder<ResponseLanguagePreferenceOrderOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserTypographyThemeOut)]),
        () => ListBuilder<UserTypographyThemeOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DeviceOut)]),
        () => ListBuilder<DeviceOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(LanguageOut)]),
        () => ListBuilder<LanguageOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserLocalConfigOut)]),
        () => ListBuilder<UserLocalConfigOut>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
