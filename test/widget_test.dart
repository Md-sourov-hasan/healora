import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healora/main.dart';

void main() {
  testWidgets('Healora Hub Management app smoke test', (WidgetTester tester) async {
    // Set screen size to standard desktop (1280x800)
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const HealoraApp());
    await tester.pumpAndSettle();

    // Verify brand header and main navigation items exist
    expect(find.text('Healora'), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Live Queue'), findsOneWidget);
  });
}
