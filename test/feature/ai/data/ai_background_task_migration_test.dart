import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';

void main() {
  test(
    'migrates v9 queue rows and accepts persisted study-pack payloads',
    () async {
      final database = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (sqlite) {
            sqlite.execute('CREATE TABLE graph_node (id TEXT PRIMARY KEY)');
            sqlite.execute('''
            CREATE TABLE ai_background_task (
              id TEXT NOT NULL PRIMARY KEY,
              node_id TEXT NOT NULL REFERENCES graph_node(id) ON DELETE CASCADE,
              task_type TEXT NOT NULL CHECK (
                task_type IN (
                  'NODE_DESCRIPTION',
                  'OPEN_ENDED_CORRECTION',
                  'MULTIPLE_CHOICE_CORRECTION'
                )
              ),
              subject_id TEXT,
              status TEXT NOT NULL DEFAULT 'PENDING',
              attempt_count INTEGER NOT NULL DEFAULT 0,
              next_attempt_at INTEGER,
              last_error TEXT,
              created_at INTEGER NOT NULL DEFAULT (unixepoch()),
              updated_at INTEGER NOT NULL DEFAULT (unixepoch())
            )
          ''');
            sqlite.execute("INSERT INTO graph_node (id) VALUES ('node-1')");
            sqlite.execute('''
            INSERT INTO ai_background_task (
              id, node_id, task_type, status, attempt_count, last_error
            ) VALUES (
              'old-task', 'node-1', 'NODE_DESCRIPTION', 'RETRY_WAIT', 2, 'network'
            )
          ''');
            sqlite.execute('PRAGMA user_version = 9');
          },
        ),
      );
      addTearDown(database.close);

      final oldTask = await (database.select(
        database.aiBackgroundTask,
      )..where((task) => task.id.equals('old-task'))).getSingle();
      expect(oldTask.status, aiTaskRetryWait);
      expect(oldTask.attemptCount, 2);
      expect(oldTask.lastError, 'network');
      expect(oldTask.payloadJson, '{}');

      final packId = await AiBackgroundTaskDao(database).enqueueStudyPack(
        nodeId: 'node-1',
        payload: const {'multiple_choice': 1, 'flashcards': 2},
      );
      final pack = await (database.select(
        database.aiBackgroundTask,
      )..where((task) => task.id.equals(packId))).getSingle();
      expect(pack.taskType, aiStudyPackTaskType);
      expect(jsonDecode(pack.payloadJson), {
        'multiple_choice': 1,
        'flashcards': 2,
      });
    },
  );
}
