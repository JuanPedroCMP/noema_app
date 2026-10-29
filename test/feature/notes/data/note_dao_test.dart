import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/notes/data/note_dao.dart';

void main() {
  late AppDatabase database;
  late NoteDao dao;

  const firstContent = '[{"insert":"Primeira versão\\n"}]';
  const secondContent = '[{"insert":"Conteúdo atualizado\\n"}]';

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dao = NoteDao(database);
    for (final user in [('user-1', 'student1'), ('user-2', 'student2')]) {
      await database
          .into(database.appUser)
          .insert(
            AppUserCompanion.insert(
              id: user.$1,
              remoteId: 'remote-${user.$1}',
              userName: user.$2,
              displayName: user.$2,
              primaryEmail: '${user.$2}@example.com',
              lastSeenAt: 0,
            ),
          );
      await database
          .into(database.knowledgeGraph)
          .insert(
            KnowledgeGraphCompanion.insert(
              id: 'graph-${user.$1}',
              userId: user.$1,
              title: 'Graph ${user.$1}',
            ),
          );
      await database
          .into(database.graphNode)
          .insert(
            GraphNodeCompanion.insert(
              id: 'node-${user.$1}',
              graphId: 'graph-${user.$1}',
              type: 'CONCEPT',
              title: 'Concept ${user.$1}',
              positionX: 0,
              positionY: 0,
            ),
          );
    }
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'creates an owned note and concept links without versioning it',
    () async {
      final note = await dao.create(
        userId: 'user-1',
        title: 'Biologia',
        contentQuillJson: firstContent,
        nodeIds: ['node-user-1'],
      );

      final result = await dao.getNote(noteId: note.id, userId: 'user-1');
      expect(result?.note.title, 'Biologia');
      expect(result?.nodes.single.id, 'node-user-1');
      expect(result?.note.currentVersion, 0);
      expect(await dao.getVersions(noteId: note.id, userId: 'user-1'), isEmpty);
    },
  );

  test('saves changes without creating an unsolicited version', () async {
    final note = await dao.create(
      userId: 'user-1',
      title: 'Biologia',
      contentQuillJson: firstContent,
    );

    final saved = await dao.save(
      noteId: note.id,
      userId: 'user-1',
      title: 'Biologia celular',
      contentQuillJson: secondContent,
      nodeIds: ['node-user-1'],
      author: 'AI',
      changeDescription: 'Resumo organizado com IA',
    );

    final versions = await dao.getVersions(noteId: note.id, userId: 'user-1');
    expect(saved.title, 'Biologia celular');
    expect(saved.currentVersion, 0);
    expect(versions, isEmpty);
  });

  test('creates a version only when explicitly requested', () async {
    final note = await dao.create(
      userId: 'user-1',
      title: 'Biologia',
      contentQuillJson: firstContent,
    );

    final saved = await dao.save(
      noteId: note.id,
      userId: 'user-1',
      title: 'Biologia celular',
      contentQuillJson: secondContent,
      nodeIds: const [],
      changeDescription: 'Resumo validado',
      createVersion: true,
    );
    final versions = await dao.getVersions(noteId: note.id, userId: 'user-1');

    expect(saved.currentVersion, 1);
    expect(versions.first.author, 'USER');
    expect(versions.first.changeDescription, 'Resumo validado');
    expect(versions.first.contentQuillJson, secondContent);
    expect(versions, hasLength(1));
  });

  test('rejects links to another user and preserves prior note data', () async {
    final note = await dao.create(
      userId: 'user-1',
      title: 'Privada',
      contentQuillJson: firstContent,
    );

    await expectLater(
      dao.save(
        noteId: note.id,
        userId: 'user-1',
        title: 'Alteração inválida',
        contentQuillJson: secondContent,
        nodeIds: ['node-user-2'],
      ),
      throwsStateError,
    );

    final unchanged = await dao.getNote(noteId: note.id, userId: 'user-1');
    expect(unchanged?.note.title, 'Privada');
    expect(unchanged?.note.contentQuillJson, firstContent);
    expect(unchanged?.nodes, isEmpty);
    expect(await dao.getNote(noteId: note.id, userId: 'user-2'), isNull);
  });

  test('restores a previous content version as a new version', () async {
    final note = await dao.create(
      userId: 'user-1',
      title: 'Revisão',
      contentQuillJson: firstContent,
    );
    await dao.save(
      noteId: note.id,
      userId: 'user-1',
      title: 'Revisão',
      contentQuillJson: firstContent,
      nodeIds: const [],
      changeDescription: 'Base antes da revisão',
      createVersion: true,
    );
    await dao.save(
      noteId: note.id,
      userId: 'user-1',
      title: 'Revisão',
      contentQuillJson: secondContent,
      nodeIds: const [],
    );

    final restored = await dao.restoreVersion(
      noteId: note.id,
      userId: 'user-1',
      versionNumber: 1,
    );
    final versions = await dao.getVersions(noteId: note.id, userId: 'user-1');
    expect(restored.contentQuillJson, firstContent);
    expect(restored.currentVersion, 2);
    expect(versions.first.versionNumber, 2);
    expect(versions.first.changeDescription, 'Restaurada versão 1');
    expect(versions.first.author, 'USER');
    expect(versions, hasLength(2));
  });

  test('soft-deletes a note while retaining it for the trash view', () async {
    final note = await dao.create(
      userId: 'user-1',
      title: 'Lixeira',
      contentQuillJson: jsonEncode([
        {'insert': 'Conteúdo\n'},
      ]),
    );

    expect(await dao.delete(noteId: note.id, userId: 'user-1'), isTrue);
    final trashed = await dao.watchNotes(userId: 'user-1').first;
    expect(trashed.single.id, note.id);
    expect(trashed.single.softDeleted, isTrue);
    expect(await dao.getNote(noteId: note.id, userId: 'user-1'), isNull);
  });

  test('restores a trashed note and keeps its history', () async {
    final note = await dao.create(
      userId: 'user-1',
      title: 'Restaurável',
      contentQuillJson: firstContent,
    );
    await dao.save(
      noteId: note.id,
      userId: 'user-1',
      title: 'Restaurável',
      contentQuillJson: firstContent,
      nodeIds: const [],
      createVersion: true,
    );
    await dao.delete(noteId: note.id, userId: 'user-1');

    expect(await dao.restore(noteId: note.id, userId: 'user-1'), isTrue);
    final restored = await dao.getNote(noteId: note.id, userId: 'user-1');
    expect(restored?.note.softDeleted, isFalse);
    expect(
      await dao.getVersions(noteId: note.id, userId: 'user-1'),
      hasLength(1),
    );
  });

  test(
    'permanently deletes only a trashed owned note and its versions',
    () async {
      final note = await dao.create(
        userId: 'user-1',
        title: 'Remoção definitiva',
        contentQuillJson: firstContent,
      );
      expect(
        await dao.deletePermanently(noteId: note.id, userId: 'user-1'),
        isFalse,
      );
      await dao.delete(noteId: note.id, userId: 'user-1');

      expect(
        await dao.deletePermanently(noteId: note.id, userId: 'user-2'),
        isFalse,
      );
      expect(
        await dao.deletePermanently(noteId: note.id, userId: 'user-1'),
        isTrue,
      );
      expect(
        await (database.select(
          database.noteVersion,
        )..where((version) => version.noteId.equals(note.id))).get(),
        isEmpty,
      );
    },
  );
}
