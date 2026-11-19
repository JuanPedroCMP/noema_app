import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/theme_defaults.dart';

void main() {
  group('AppThemeDefaults.isUntouchedLegacyDefault', () {
    test(
      'updates an untouched default theme and keeps brightness preference',
      () {
        expect(
          AppThemeDefaults.isUntouchedLegacyDefault(
            name: 'Default',
            seedColor: 0xFF3F51B5,
            overridesJson: '{"__brightness":"dark"}',
          ),
          isTrue,
        );
      },
    );

    test('does not replace renamed or customized themes', () {
      expect(
        AppThemeDefaults.isUntouchedLegacyDefault(
          name: 'My theme',
          seedColor: 0xFF3F51B5,
        ),
        isFalse,
      );
      expect(
        AppThemeDefaults.isUntouchedLegacyDefault(
          name: 'Default',
          seedColor: 0xFF3F51B5,
          overridesJson: '{"primary":4281545523}',
        ),
        isFalse,
      );
      expect(
        AppThemeDefaults.isUntouchedLegacyDefault(
          name: 'Default',
          seedColor: AppThemeDefaults.seedColor,
        ),
        isFalse,
      );
    });
  });
}
