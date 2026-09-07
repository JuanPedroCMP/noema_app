import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';

final choicesProvider = StreamProvider.family<List<ChoiceData>, String>((
  ref,
  multipleChoiceId,
) {
  final db = ref.watch(appDatabaseProvider);

  return (db.select(db.choice)
        ..where((choice) => choice.multipleChoiceId.equals(multipleChoiceId)))
      .watch();
});
