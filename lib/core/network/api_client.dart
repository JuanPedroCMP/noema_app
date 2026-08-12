import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final apiClientProvider = Provider<Openapi>((ref) {
  return Openapi(basePathOverride: "https://api.tccnoema.me");
  // return Openapi(basePathOverride: "https://apiv2.tccnoema.me/");
  // return Openapi(basePathOverride: "http://127.0.0.1:8000");
});

final userApiProvider = Provider((ref){
  return ref.watch(apiClientProvider).getUserApi();
});

final authApiProvider = Provider((ref) {
  return ref.watch(apiClientProvider).getAuthenticationApi();
});