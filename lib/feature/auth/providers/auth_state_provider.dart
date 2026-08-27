import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:openapi/openapi.dart';

final authStateProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(secureSorageProvider);
  final token = await storage.read(key: "access_token");
  final db = ref.read(appDatabaseProvider);

  if (token == null || token.isEmpty || token == "") {
    return false;
  }
  print(token);

  ref.read(apiClientProvider).setOAuthToken("OAuth2PasswordBearer", token);

  try {
  print("sem user");
    
    var response = await ref.read(userApiProvider).currentUserApiV1UserGetGet();

    UserOut? remoteUser = response.data;

    AppUserData? user = await AppUserDao(db).getUser(remoteId: remoteUser!.id);
    
    if (user == null) {
      AppUserDao(db).insertUser(
        remoteId: remoteUser.id,
        userName: remoteUser.userName,
        displayName: remoteUser.userDisplayName,
        primaryEmail: remoteUser.primaryEmail,
        isActive: remoteUser.isActive,
      );
    }
    return true;
  } catch (e) {
    print("erro");
    print(e.toString());
    await storage.delete(key: "access_token");
    return false;
  }
});
