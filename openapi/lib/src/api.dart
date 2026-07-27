//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/serializers.dart';
import 'package:openapi/src/auth/api_key_auth.dart';
import 'package:openapi/src/auth/basic_auth.dart';
import 'package:openapi/src/auth/bearer_auth.dart';
import 'package:openapi/src/auth/oauth.dart';
import 'package:openapi/src/api/agent_api.dart';
import 'package:openapi/src/api/agent_model_api.dart';
import 'package:openapi/src/api/ai_model_api.dart';
import 'package:openapi/src/api/ai_usage_log_api.dart';
import 'package:openapi/src/api/authentication_api.dart';
import 'package:openapi/src/api/backup_file_api.dart';
import 'package:openapi/src/api/color_theme_api.dart';
import 'package:openapi/src/api/default_api.dart';
import 'package:openapi/src/api/device_api.dart';
import 'package:openapi/src/api/generic_log_api.dart';
import 'package:openapi/src/api/language_api.dart';
import 'package:openapi/src/api/provider_api.dart';
import 'package:openapi/src/api/response_response_language_preference_order_api.dart';
import 'package:openapi/src/api/sync_log_api.dart';
import 'package:openapi/src/api/typography_theme_api.dart';
import 'package:openapi/src/api/user_api.dart';
import 'package:openapi/src/api/user_api_key_api.dart';
import 'package:openapi/src/api/user_api_key_can_use_ia_model_api.dart';
import 'package:openapi/src/api/user_global_config_api.dart';
import 'package:openapi/src/api/user_local_config_api.dart';

class Openapi {
  static const String basePath = r'http://localhost';

  final Dio dio;
  final Serializers serializers;

  Openapi({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the OAuth token associated with the given [name].
  ///
  /// If no [OAuthInterceptor] is registered or no token exists for the given
  /// [name], this method has no effect.
  void removeOAuthToken(String name) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens.remove(name);
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the bearer authentication token associated with the given [name].
  ///
  /// If no [BearerAuthInterceptor] is registered or no token exists for the
  /// given [name], this method has no effect.
  void removeBearerAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens.remove(name);
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  /// Removes the basic authentication credentials associated with the given [name].
  ///
  /// If no [BasicAuthInterceptor] is registered or no credentials exist for the
  /// given [name], this method has no effect.
  void removeBasicAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo.remove(name);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Removes the API key associated with the given [name].
  ///
  /// If no [ApiKeyAuthInterceptor] is registered or no API key exists for the
  /// given [name], this method has no effect.
  void removeApiKey(String name) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys.remove(name);
    }
  }

  /// Get AgentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AgentApi getAgentApi() {
    return AgentApi(dio, serializers);
  }

  /// Get AgentModelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AgentModelApi getAgentModelApi() {
    return AgentModelApi(dio, serializers);
  }

  /// Get AiModelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AiModelApi getAiModelApi() {
    return AiModelApi(dio, serializers);
  }

  /// Get AiUsageLogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AiUsageLogApi getAiUsageLogApi() {
    return AiUsageLogApi(dio, serializers);
  }

  /// Get AuthenticationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthenticationApi getAuthenticationApi() {
    return AuthenticationApi(dio, serializers);
  }

  /// Get BackupFileApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BackupFileApi getBackupFileApi() {
    return BackupFileApi(dio, serializers);
  }

  /// Get ColorThemeApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ColorThemeApi getColorThemeApi() {
    return ColorThemeApi(dio, serializers);
  }

  /// Get DefaultApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DefaultApi getDefaultApi() {
    return DefaultApi(dio, serializers);
  }

  /// Get DeviceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceApi getDeviceApi() {
    return DeviceApi(dio, serializers);
  }

  /// Get GenericLogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  GenericLogApi getGenericLogApi() {
    return GenericLogApi(dio, serializers);
  }

  /// Get LanguageApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LanguageApi getLanguageApi() {
    return LanguageApi(dio, serializers);
  }

  /// Get ProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ProviderApi getProviderApi() {
    return ProviderApi(dio, serializers);
  }

  /// Get ResponseResponseLanguagePreferenceOrderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ResponseResponseLanguagePreferenceOrderApi getResponseResponseLanguagePreferenceOrderApi() {
    return ResponseResponseLanguagePreferenceOrderApi(dio, serializers);
  }

  /// Get SyncLogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SyncLogApi getSyncLogApi() {
    return SyncLogApi(dio, serializers);
  }

  /// Get TypographyThemeApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TypographyThemeApi getTypographyThemeApi() {
    return TypographyThemeApi(dio, serializers);
  }

  /// Get UserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UserApi getUserApi() {
    return UserApi(dio, serializers);
  }

  /// Get UserApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UserApiKeyApi getUserApiKeyApi() {
    return UserApiKeyApi(dio, serializers);
  }

  /// Get UserApiKeyCanUseIaModelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UserApiKeyCanUseIaModelApi getUserApiKeyCanUseIaModelApi() {
    return UserApiKeyCanUseIaModelApi(dio, serializers);
  }

  /// Get UserGlobalConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UserGlobalConfigApi getUserGlobalConfigApi() {
    return UserGlobalConfigApi(dio, serializers);
  }

  /// Get UserLocalConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UserLocalConfigApi getUserLocalConfigApi() {
    return UserLocalConfigApi(dio, serializers);
  }
}
