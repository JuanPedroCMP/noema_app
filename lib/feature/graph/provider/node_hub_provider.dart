import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/flashcards/data/flashcard_dao.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';
import 'package:noema/feature/graph/data/node_skill_dao.dart';

class NodePracticeCounts {
  const NodePracticeCounts({
    required this.multipleChoice,
    required this.openEnded,
    required this.flashcards,
  });

  final int multipleChoice;
  final int openEnded;
  final int flashcards;

  int get exercises => multipleChoice + openEnded;
}

final nodeSkillsProvider = StreamProvider.autoDispose
    .family<List<NodeSkillData>, String>((ref, nodeId) {
      return NodeSkillDao(ref.watch(appDatabaseProvider)).watchByNode(nodeId);
    });

final nodeResourcesProvider = StreamProvider.autoDispose
    .family<List<LearningResourceData>, String>((ref, nodeId) {
      return LearningResourceDao(
        ref.watch(appDatabaseProvider),
      ).watchByNode(nodeId: nodeId);
    });

final nodeFlashcardsProvider = StreamProvider.autoDispose
    .family<List<FlashcardData>, String>((ref, nodeId) {
      return FlashcardDao(ref.watch(appDatabaseProvider)).watchByNode(nodeId);
    });

final nodePracticeCountsProvider = StreamProvider.autoDispose
    .family<NodePracticeCounts, String>((ref, nodeId) {
      final db = ref.watch(appDatabaseProvider);

      final multipleChoice = (db.select(db.multipleChoice)
            ..where((tbl) => tbl.nodeId.equals(nodeId))
            ..where((tbl) => tbl.softDeleted.equals(false)))
          .watch();
      final openEnded = (db.select(db.openEnded)
            ..where((tbl) => tbl.nodeId.equals(nodeId))
            ..where((tbl) => tbl.softDeleted.equals(false)))
          .watch();
      final flashcards = FlashcardDao(db).watchByNode(nodeId);

      var mcCount = 0;
      var oeCount = 0;
      var fcCount = 0;
      var mcReady = false;
      var oeReady = false;
      var fcReady = false;

      late final Stream<NodePracticeCounts> combined;
      combined = Stream.multi((listener) {
        void emitIfReady() {
          if (mcReady && oeReady && fcReady) {
            listener.add(
              NodePracticeCounts(
                multipleChoice: mcCount,
                openEnded: oeCount,
                flashcards: fcCount,
              ),
            );
          }
        }

        final subs = [
          multipleChoice.listen((rows) {
            mcCount = rows.length;
            mcReady = true;
            emitIfReady();
          }, onError: listener.addError),
          openEnded.listen((rows) {
            oeCount = rows.length;
            oeReady = true;
            emitIfReady();
          }, onError: listener.addError),
          flashcards.listen((rows) {
            fcCount = rows.length;
            fcReady = true;
            emitIfReady();
          }, onError: listener.addError),
        ];

        listener
          ..onPause = () {
            for (final sub in subs) {
              sub.pause();
            }
          }
          ..onResume = () {
            for (final sub in subs) {
              sub.resume();
            }
          }
          ..onCancel = () async {
            for (final sub in subs) {
              await sub.cancel();
            }
          };
      });

      return combined;
    });
