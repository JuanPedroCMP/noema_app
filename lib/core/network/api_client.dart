import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final apiClientProvider = Provider<Openapi>((ref) {
  return Openapi(basePathOverride: "http://api.tccnoema.me");
});

final userApiProvider = Provider((ref){
  return ref.watch(apiClientProvider).getUserApi();
});