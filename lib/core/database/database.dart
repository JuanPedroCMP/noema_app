import 'dart:io';
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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

  Future<void> deleteDatabase() async {
    //TODO Apagar antes de lançar
    await close();

    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'noema_db.sqlite'));

    developer.log('Banco: ${file.path}', name: 'AppDatabase');

    if (await file.exists()) {
      await file.delete();
      developer.log('Banco apagado com sucesso!', name: 'AppDatabase');
    } else {
      developer.log('Banco não encontrado!', name: 'AppDatabase');
    }
  }
}
