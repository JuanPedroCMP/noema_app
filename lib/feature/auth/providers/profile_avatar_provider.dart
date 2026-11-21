import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

final profileAvatarUrlProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  final user = await ref.watch(userProvider.future);
  try {
    final response = await ref
        .read(apiClientProvider)
        .getAuthenticationApi()
        .getGoogleAccountApiV1AuthGoogleGetIdentificatorGet(
          identificator: user.remoteId,
        );
    final account = response.data;
    if (account == null) return null;
    if (account.idUser != user.remoteId) {
      throw StateError('A conta Google retornada não pertence ao usuário.');
    }
    if (!account.isActive) return null;

    final googleIdentity = (account.googleUserId ?? '').trim();
    final fallbackIdentity = (account.emailGoogle ?? '').trim();
    final resolvedIdentity = googleIdentity.isNotEmpty
        ? googleIdentity
        : fallbackIdentity;
    if (resolvedIdentity.isEmpty) return null;

    return Uri.https('www.google.com', '/s2/photos/profile/$resolvedIdentity', {
      'sz': '160',
    }).toString();
  } on DioException catch (error) {
    if (error.response?.statusCode != 404 &&
        error.response?.statusCode != 503) {
      debugPrint('Não foi possível carregar o avatar Google: $error');
    }
    return null;
  } catch (error, stackTrace) {
    debugPrint('Não foi possível carregar o avatar Google: $error');
    debugPrintStack(stackTrace: stackTrace);
    return null;
  }
});
