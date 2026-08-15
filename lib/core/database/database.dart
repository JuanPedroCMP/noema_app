import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'noema_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  Future<void> deleteDatabase() async { //TODO Apagar antes de lançar
    await close();

    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'noema_db.sqlite'));

    print('Banco: ${file.path}');

    if (await file.exists()) {
      await file.delete();
      print('Banco apagado com sucesso!');
    } else {
      print('Banco não encontrado!');
    }
  }
}
