import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [AppUser])
class AppUserDao extends DatabaseAccessor<AppDatabase> with _$AppUserDaoMixin {
  AppUserDao(super.db);

  Future<int> insertUser({
    required String remoteId,
    required String userName,
    String? displayName,
    required String primaryEmail,
    bool? isActive,
  }) {
    return into(attachedDatabase.appUser).insert(
      AppUserCompanion.insert(
        id: Uuid().v4(),
        remoteId: remoteId,
        userName: userName,
        displayName: displayName!,
        primaryEmail: primaryEmail,
        lastSeenAt: DateTime.now().millisecondsSinceEpoch,
        isActive: Value(isActive!),
      ),
    );
  }

  Future<int> updateUser({
    required String id,
    String? remoteId,
    String? userName,
    String? displayName,
    String? primaryEmail,
    bool? isActive,
  }) {
    return (update(
      attachedDatabase.appUser,
    )..where((user) => user.id.equals(id))).write(
      AppUserCompanion(
        remoteId: remoteId == null ? const Value.absent() : Value(remoteId),
        userName: userName == null ? const Value.absent() : Value(userName),
        displayName: displayName == null
            ? const Value.absent()
            : Value(displayName),
        primaryEmail: primaryEmail == null
            ? const Value.absent()
            : Value(primaryEmail),
        isActive: isActive == null ? const Value.absent() : Value(isActive),
      ),
    );
  }

  Future<AppUserData?> getUser({
  required String remoteId
  }) {
    return (select(attachedDatabase.appUser)..where((user) => user.remoteId.equals(remoteId))).getSingleOrNull();
  }
}
