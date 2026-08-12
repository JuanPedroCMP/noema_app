import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:openapi/openapi.dart';

class UserNotifier extends AsyncNotifier<AppUserData> {
  late final db = ref.read(appDatabaseProvider);

  @override
  Future<AppUserData> build() async {
    final response = await ref
        .read(userApiProvider)
        .currentUserApiV1UserGetGet();

    UserOut? remoteUser = response.data;

    AppUserData? user = await AppUserDao(db).getUser(remoteId: remoteUser!.id);

    return user!;
  }

  Future<int> updateUser({
    String? userName,
    String? displayName,
    String? primaryEmail,
    String? password,
  }) async {
    final response = await ref
        .read(userApiProvider)
        .currentUserApiV1UserGetGet();
    UserOut? remoteUser = response.data;

    final updateUser = UserUpdate((b) {
      b.password = clean(password);
      b.primaryEmail = clean(primaryEmail);
      b.userDisplayName = clean(displayName);
      b.userName = clean(userName);
    });

    final upd = await ref
        .read(userApiProvider)
        .updateUserApiV1UserUpdatePut(userUpdate: updateUser);

    final bdUser = state.requireValue;

    int user = await AppUserDao(db).updateUser(
      id: bdUser.id,
      remoteId: remoteUser!.id,
      userName: upd.data?.userName,
      displayName: upd.data?.userDisplayName,
      primaryEmail: upd.data?.primaryEmail,
    );

    ref.invalidateSelf();

    return user;
  }
Future<AppUserData> getUser() async{
   final response = await ref
        .read(userApiProvider)
        .currentUserApiV1UserGetGet();
    UserOut? remoteUser = response.data;

    final user =  await AppUserDao(db).getUser(remoteId: remoteUser!.id);

    return user!;
}
}


String? clean(String? value) {
  final trimmed = value?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

final userProvider = AsyncNotifierProvider<UserNotifier, AppUserData>(
  UserNotifier.new,
);
