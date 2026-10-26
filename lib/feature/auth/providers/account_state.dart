import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/color_theme_provider.dart';
import 'package:noema/core/design/theme/typography_theme_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/flashcards/presentation/flashcard.dart';
import 'package:noema/feature/graph/provider/edge_form_provider.dart';
import 'package:noema/feature/graph/provider/edge_type_provider.dart';
import 'package:noema/feature/graph/provider/graph_form_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/provider/node_form_provider.dart';
import 'package:noema/feature/graph/provider/path_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/provider/temp_json_graph_provider.dart';
import 'package:noema/feature/graph/provider/transformation_controller_provider.dart';

void resetAccountScopedState(WidgetRef ref) {
  ref.invalidate(userProvider);
  ref.invalidate(flashcardsProvider);
  ref.invalidate(knowledgeGraphsProvider);
  ref.invalidate(nodesProvider);
  ref.invalidate(edgesProvider);
  ref.invalidate(colorProvider);
  ref.invalidate(activeColorThemeProvider);
  ref.invalidate(activeTypographyThemeProvider);
  ref.invalidate(graphFormProvider);
  ref.invalidate(nodeFormProvider);
  ref.invalidate(edgeFormProvider);
  ref.invalidate(edgeTypeProvider);
  ref.invalidate(graphStatesProvider);
  ref.invalidate(pathProvider);
  ref.invalidate(tempJsonGraphProvider);
  ref.invalidate(transformationControllerProvider);
  ref.read(selectedProvider.notifier).clear();
}
