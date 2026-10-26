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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 3 && to >= 3) {
        await _migrateStudySessionsToVersion3();
      }
      if (from < 4 && to >= 4) {
        await customStatement(
          "ALTER TABLE multiple_choice_response_log ADD COLUMN "
          "question_snapshot TEXT NOT NULL DEFAULT '{}' "
          "CHECK (json_valid(question_snapshot))",
        );
        await customStatement('''
          UPDATE open_ended
          SET created_at = CASE WHEN created_at > 100000000000
                                THEN created_at / 1000 ELSE created_at END,
              updated_at = CASE WHEN updated_at > 100000000000
                                THEN updated_at / 1000 ELSE updated_at END,
              soft_deleted_at = CASE
                WHEN soft_deleted_at > 100000000000
                THEN soft_deleted_at / 1000 ELSE soft_deleted_at
              END
        ''');
        await customStatement('''
          UPDATE multiple_choice
          SET created_at = CASE WHEN created_at > 100000000000
                                THEN created_at / 1000 ELSE created_at END,
              updated_at = CASE WHEN updated_at > 100000000000
                                THEN updated_at / 1000 ELSE updated_at END,
              soft_deleted_at = CASE
                WHEN soft_deleted_at > 100000000000
                THEN soft_deleted_at / 1000 ELSE soft_deleted_at
              END
        ''');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _migrateStudySessionsToVersion3() async {
    await customStatement(
      "ALTER TABLE study_session ADD COLUMN title TEXT NOT NULL DEFAULT ''",
    );
    await customStatement(
      'ALTER TABLE study_session ADD COLUMN description TEXT',
    );
    await customStatement(
      'ALTER TABLE study_session ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
    );
    await customStatement(
      'UPDATE study_session SET title = \'Sessão de estudo\', '
      'updated_at = unixepoch()',
    );

    await customStatement(
      "ALTER TABLE study_session_log ADD COLUMN session_title_snapshot "
      "TEXT NOT NULL DEFAULT ''",
    );
    await customStatement(
      "ALTER TABLE study_session_log ADD COLUMN questions_snapshot "
      "TEXT NOT NULL DEFAULT '[]' CHECK (json_valid(questions_snapshot))",
    );
    await customStatement(
      "ALTER TABLE study_session_log ADD COLUMN status TEXT NOT NULL "
      "DEFAULT 'IN_PROGRESS' CHECK (status IN "
      "('IN_PROGRESS', 'COMPLETED', 'ABANDONED'))",
    );
    await customStatement(
      'ALTER TABLE study_session_log ADD COLUMN actual_duration_min INTEGER '
      'CHECK (actual_duration_min IS NULL OR actual_duration_min >= 0)',
    );
    await customStatement('''
      UPDATE study_session_log
      SET session_title_snapshot = COALESCE(
            (SELECT title FROM study_session
             WHERE study_session.id = study_session_log.study_session_id),
            'Sessão de estudo'
          ),
          status = CASE
            WHEN ended_at IS NOT NULL THEN 'COMPLETED'
            ELSE 'ABANDONED'
          END,
          actual_duration_min = CASE
            WHEN ended_at IS NOT NULL
              THEN MAX(0, CAST((ended_at - started_at) / 60 AS INTEGER))
            ELSE NULL
          END
    ''');

    await customStatement(
      'ALTER TABLE multiple_choice_response_log ADD COLUMN '
      'study_session_log_id TEXT REFERENCES study_session_log(id) '
      'ON DELETE SET NULL',
    );
    await customStatement(
      'ALTER TABLE open_ended_response_log ADD COLUMN '
      'study_session_log_id TEXT REFERENCES study_session_log(id) '
      'ON DELETE SET NULL',
    );

    await customStatement('''
      CREATE TABLE study_session_question (
        id TEXT NOT NULL PRIMARY KEY,
        study_session_id TEXT NOT NULL REFERENCES study_session(id) ON DELETE CASCADE,
        multiple_choice_id TEXT REFERENCES multiple_choice(id) ON DELETE CASCADE,
        open_ended_id TEXT REFERENCES open_ended(id) ON DELETE CASCADE,
        display_order INTEGER NOT NULL CHECK (display_order >= 0),
        created_at INTEGER NOT NULL DEFAULT (unixepoch()),
        CHECK (
          (multiple_choice_id IS NOT NULL AND open_ended_id IS NULL) OR
          (multiple_choice_id IS NULL AND open_ended_id IS NOT NULL)
        ),
        CONSTRAINT study_session_question_mc_uq
          UNIQUE (study_session_id, multiple_choice_id),
        CONSTRAINT study_session_question_oe_uq
          UNIQUE (study_session_id, open_ended_id),
        CONSTRAINT study_session_question_order_uq
          UNIQUE (study_session_id, display_order)
      )
    ''');
    await customStatement('''
      INSERT INTO study_session_question (
        id, study_session_id, multiple_choice_id, open_ended_id,
        display_order, created_at
      )
      SELECT id, study_session_id, multiple_choice_id, open_ended_id,
             ROW_NUMBER() OVER (
               PARTITION BY study_session_id ORDER BY created_at, id
             ) - 1,
             created_at
      FROM (
        SELECT id, study_session_id, multiple_choice_id,
               NULL AS open_ended_id, created_at
        FROM study_session_has_multiple_choice_question
        UNION ALL
        SELECT id, study_session_id, NULL AS multiple_choice_id,
               open_ended_id, created_at
        FROM study_session_has_open_ended_question
      )
    ''');
    await customStatement('DROP TABLE study_session_has_multiple_choice_question');
    await customStatement('DROP TABLE study_session_has_open_ended_question');
    await customStatement(
      'CREATE INDEX idx_study_session_log_started_at '
      'ON study_session_log(started_at)',
    );
    await customStatement(
      'CREATE INDEX idx_study_session_question_session_order '
      'ON study_session_question(study_session_id, display_order)',
    );
    await customStatement(
      'CREATE INDEX idx_study_session_question_mc_id '
      'ON study_session_question(multiple_choice_id)',
    );
    await customStatement(
      'CREATE INDEX idx_study_session_question_oe_id '
      'ON study_session_question(open_ended_id)',
    );
    await customStatement(
      'CREATE INDEX idx_oe_response_log_session_log_id '
      'ON open_ended_response_log(study_session_log_id)',
    );
    await customStatement(
      'CREATE INDEX idx_mc_response_log_session_log_id '
      'ON multiple_choice_response_log(study_session_log_id)',
    );
  }

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
