import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/providers/graph_prompt_preferences_provider.dart';

void main() {
  group('GraphPromptEnhancementMode', () {
    test(
      'supports automatic and manual enhancement without asking questions',
      () {
        expect(GraphPromptEnhancementMode.values, [
          GraphPromptEnhancementMode.automatic,
          GraphPromptEnhancementMode.direct,
        ]);
        expect(
          GraphPromptEnhancementMode.fromPreference('automatic'),
          GraphPromptEnhancementMode.automatic,
        );
        expect(
          GraphPromptEnhancementMode.fromPreference('direct'),
          GraphPromptEnhancementMode.direct,
        );
        expect(
          GraphPromptEnhancementMode.fromPreference('alwaysAsk'),
          GraphPromptEnhancementMode.direct,
        );
        expect(
          GraphPromptEnhancementMode.fromPreference('invalid'),
          GraphPromptEnhancementMode.direct,
        );
      },
    );
  });
}
