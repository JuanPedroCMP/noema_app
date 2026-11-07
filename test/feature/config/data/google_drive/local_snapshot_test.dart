import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';

void main() {
  group('LocalSnapshot.dataHash', () {
    test(
      'ignores per-snapshot metadata when the data hashes are unchanged',
      () {
        final first = _snapshot(
          manifest: {
            'created_at': '2025-01-01T00:00:00Z',
            'snapshot_version': 'one',
            'hashes': {'graphs_and_notes': 'sha256:stable'},
          },
        );
        final second = _snapshot(
          manifest: {
            'created_at': '2025-01-02T00:00:00Z',
            'snapshot_version': 'two',
            'hashes': {'graphs_and_notes': 'sha256:stable'},
          },
        );

        expect(first.dataHash, second.dataHash);
      },
    );
  });

  group('compareSnapshots', () {
    test('returns an empty diff for identical records', () {
      final data = _emptyData();
      (data['graphs_and_notes'] as Map<String, dynamic>)['knowledge_graph'] = [
        {'id': 'graph-1', 'title': 'Biologia'},
      ];

      expect(compareSnapshots(data, data).isEmpty, isTrue);
    });

    test('reports remote-only and conflicting records with field values', () {
      final local = _emptyData();
      final remote = _emptyData();
      (local['graphs_and_notes'] as Map<String, dynamic>)['knowledge_graph'] = [
        {'id': 'graph-1', 'title': 'Biologia'},
      ];
      (remote['graphs_and_notes']
          as Map<String, dynamic>)['knowledge_graph'] = [
        {'id': 'graph-1', 'title': 'Biologia celular'},
        {'id': 'graph-2', 'title': 'Química'},
      ];

      final diff = compareSnapshots(local, remote);
      final graphSummary = diff.categories.single;
      final changed = diff.changes.singleWhere(
        (change) => change.rowId == 'graph-1',
      );
      final remoteOnly = diff.changes.singleWhere(
        (change) => change.rowId == 'graph-2',
      );

      expect(diff.isEmpty, isFalse);
      expect(graphSummary.localOnly, 0);
      expect(graphSummary.remoteOnly, 1);
      expect(graphSummary.changed, 1);
      expect(changed.fields, ['title']);
      expect(changed.localValues['title'], 'Biologia');
      expect(changed.remoteValues['title'], 'Biologia celular');
      expect(remoteOnly.side, SnapshotSide.remote);
      expect(remoteOnly.remoteValues['title'], 'Química');
    });
  });

  group('mergeSnapshotData', () {
    test('omits children of remote rows rejected by logical identity', () {
      final local = _emptyData();
      final remote = _emptyData();
      (local['graphs_and_notes'] as Map<String, dynamic>)['note'] = [
        {'id': 'local-note', 'title': 'Same title', 'soft_deleted': 0},
      ];
      (remote['graphs_and_notes'] as Map<String, dynamic>)['note'] = [
        {'id': 'remote-note', 'title': 'Same title', 'soft_deleted': 0},
      ];
      (remote['graphs_and_notes'] as Map<String, dynamic>)['note_version'] = [
        {'id': 'remote-note-version', 'note_id': 'remote-note'},
      ];
      (remote['graphs_and_notes'] as Map<String, dynamic>)['note_node'] = [
        {'id': 'remote-note-node', 'note_id': 'remote-note'},
      ];
      (local['study_history'] as Map<String, dynamic>)['review_item_state'] = [
        {
          'id': 'local-review-state',
          'item_type': 'FLASHCARD',
          'item_id': 'card',
        },
      ];
      (remote['study_history'] as Map<String, dynamic>)['review_item_state'] = [
        {
          'id': 'remote-review-state',
          'item_type': 'FLASHCARD',
          'item_id': 'card',
        },
      ];
      (remote['study_history'] as Map<String, dynamic>)['review_item_log'] = [
        {
          'id': 'remote-review-log',
          'review_item_state_id': 'remote-review-state',
        },
      ];
      (local['study_history'] as Map<String, dynamic>)['fsrs_state'] = [
        {'id': 'local-fsrs-state', 'node_id': 'node'},
      ];
      (remote['study_history'] as Map<String, dynamic>)['fsrs_state'] = [
        {'id': 'remote-fsrs-state', 'node_id': 'node'},
      ];
      (remote['study_history'] as Map<String, dynamic>)['fsrs_review_log'] = [
        {'id': 'remote-fsrs-log', 'fsrs_state_id': 'remote-fsrs-state'},
      ];

      final merged = mergeSnapshotData(local, remote);
      final graphData = merged['graphs_and_notes'] as Map<String, dynamic>;
      final studyData = merged['study_history'] as Map<String, dynamic>;

      expect((graphData['note'] as List).map((row) => row['id']), [
        'local-note',
      ]);
      expect(graphData['note_version'], isEmpty);
      expect(graphData['note_node'], isEmpty);
      expect(studyData['review_item_state'], hasLength(1));
      expect(studyData['review_item_log'], isEmpty);
      expect(studyData['fsrs_state'], hasLength(1));
      expect(studyData['fsrs_review_log'], isEmpty);
    });
  });
}

Map<String, dynamic> _emptyData() => {
  for (final category in snapshotCategories) category: <String, dynamic>{},
};

LocalSnapshot _snapshot({required Map<String, dynamic> manifest}) =>
    LocalSnapshot(
      document: const {},
      file: File('unused'),
      contentHash: 'sha256:unused',
      sizeBytes: 0,
      snapshotVersion: 'unused',
      manifest: manifest,
    );
