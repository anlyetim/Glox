// Basic widget test for GLOX

import 'package:flutter_test/flutter_test.dart';
import 'package:glox/main.dart';

void main() {
  testWidgets('GLOX app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GloxApp());

    // Verify that level indicator is present
    expect(find.text('Level 1'), findsOneWidget);

    // Verify hint button is present
    expect(find.text('Hint'), findsOneWidget);
  });
}
