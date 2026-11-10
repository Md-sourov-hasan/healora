import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/utils/connectivity_service.dart';
import 'package:healora/main.dart';

void main() {
  testWidgets('Healora Patient App smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    Get.put(ConnectivityService(), permanent: true);
    Get.put(HealoraState(), permanent: true);

    await tester.pumpWidget(const HealoraApp());
    await tester.pumpAndSettle();

    // Verify patient home elements exist
    expect(find.text('PAT-BD-89211'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Hubs'), findsWidgets);
    expect(find.text('Bookings'), findsWidgets);
    expect(find.text('Results'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
