import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

String decodeJwt(String token) {
  final claims = JwtDecoder.decode(token);

  final remoteOwnerId = claims['sub']?.toString();

  if (remoteOwnerId == null || remoteOwnerId.isEmpty) {
    throw StateError('ID do usuário não encontrado no token');
  }

  debugPrint(remoteOwnerId);

  return remoteOwnerId;
}
