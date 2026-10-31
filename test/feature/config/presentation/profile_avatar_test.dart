import 'package:dicebear_core/dicebear_core.dart';
import 'package:dicebear_styles/pixelbot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the DiceBear pixelbot fallback avatar', (tester) async {
    final style = Style.parse(pixelbot);
    final svg = Avatar(style, {
      'tags': ['animation'],
      'seed': 'stable-user-id',
    }).svg;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircleAvatar(child: ClipOval(child: SvgPicture.string(svg))),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
