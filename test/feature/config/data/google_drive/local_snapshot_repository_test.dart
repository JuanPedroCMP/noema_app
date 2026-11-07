import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('imports theme rows from a snapshot with an older column set', () async {
    await database
        .into(database.appUser)
        .insert(
          AppUserCompanion.insert(
            id: 'user-id',
            remoteId: 'remote-user-id',
            userName: 'student',
            displayName: 'Student',
            primaryEmail: 'student@example.com',
            lastSeenAt: 0,
          ),
        );

    final snapshot = LocalSnapshot(
      document: {
        'data': {
          for (final category in snapshotCategories)
            category: _emptyCategory(category),
        },
      },
      file: File('unused'),
      contentHash: 'unused',
      sizeBytes: 0,
      snapshotVersion: 'legacy',
      manifest: const {},
    );
    ((snapshot.document['data'] as Map<String, dynamic>)['custom_themes']
        as Map<String, dynamic>)['color_theme'] = [
      {
        'id': 'legacy-theme',
        'user_id': 'user-id',
        'name': 'Legacy theme',
        'seed_color': 123,
      },
    ];

    await LocalSnapshotRepository(
      database,
    ).restoreRemote(snapshot: snapshot, localUserId: 'user-id');

    final restored = await (database.select(
      database.colorTheme,
    )..where((theme) => theme.id.equals('legacy-theme'))).getSingle();
    expect(restored.name, 'Legacy theme');
    expect(restored.seedColor, 123);
  });
}

Map<String, dynamic> _emptyCategory(String category) => {
  for (final table in _tablesByCategory[category]!) table: <dynamic>[],
};

const _tablesByCategory = <String, List<String>>{
  'custom_themes': ['color_theme', 'typography_theme'],
  'graphs_and_notes': [
    'knowledge_graph',
    'graph_version',
    'graph_node',
    'graph_edge',
    'node_skill',
    'learning_resource',
    'note',
    'note_version',
    'note_node',
  ],
  'learning_content': [
    'flashcard',
    'flashcard_group',
    'flashcard_belongs_group',
    'multiple_choice',
    'choice',
    'open_ended',
  ],
  'study_history': [
    'study_session',
    'study_session_log',
    'study_session_use_knowledge_graph',
    'session_node',
    'flashcard_response_log',
    'multiple_choice_response_log',
    'study_session_question',
    'open_ended_response_log',
    'review_item_state',
    'review_item_log',
    'fsrs_state',
    'fsrs_review_log',
    'domain_log',
  ],
  'activity_history': ['generic_log'],
};
