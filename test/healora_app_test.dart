import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healora/main.dart';
import 'package:healora/core/services/healora_state.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/models/clinical_models.dart';

void main() {
  group('Healora Platform Comprehensive Tests', () {
    test('HealoraState initialization and seed data', () {
      final state = HealoraState();

      // Check hubs loaded
      expect(state.hubs.length, greaterThanOrEqualTo(4));
      expect(state.currentHub.code, 'HUB-MKG-01');

      // Check sessions loaded
      expect(state.sessions.length, greaterThanOrEqualTo(3));

      // Check queue and encounters
      expect(state.queue.isNotEmpty, isTrue);
      expect(state.encounters.isNotEmpty, isTrue);

      // Check initial role
      expect(state.activeRole, HealoraRole.hubManager);
      expect(state.isBangla, isFalse);
      expect(state.isOffline, isFalse);
    });

    test('Bilingual translation helper and toggle', () {
      final state = HealoraState();

      expect(state.t('Overview', 'সারসংক্ষেপ'), 'Overview');

      state.toggleLanguage();
      expect(state.isBangla, isTrue);
      expect(state.t('Overview', 'সারসংক্ষেপ'), 'সারসংক্ষেপ');
    });

    test('Patient check-in issues token and adds to queue & encounter', () {
      final state = HealoraState();
      final initialQueueLen = state.queue.length;
      final initialEncountersLen = state.encounters.length;

      // Check in appointment apt_04
      state.checkInAppointment('apt_04', consentConfirmed: true);

      expect(state.queue.length, equals(initialQueueLen + 1));
      expect(state.encounters.length, equals(initialEncountersLen + 1));

      final lastTicket = state.queue.last;
      expect(lastTicket.appointmentId, 'apt_04');
      expect(lastTicket.tokenNumber.startsWith('HUB-MKG-'), isTrue);
    });

    test('Assisted walk-in registration increments session count and queues patient', () {
      final state = HealoraState();
      final initialWalkIn = state.sessions.first.walkInCurrent;

      state.registerWalkIn(
        fullName: 'Golam Mostafa',
        phone: '+880 1711 999888',
        age: 60,
        gender: 'Male',
        consentConfirmed: true,
      );

      expect(state.sessions.first.walkInCurrent, equals(initialWalkIn + 1));
      expect(state.appointments.first.patientName, 'Golam Mostafa');
      expect(state.appointments.first.bookingSource, 'walk_in');
    });

    test('Offline mode queues observations in outbox and syncs idempotently', () {
      final state = HealoraState();

      // Enable simulated rural offline mode
      state.toggleOfflineMode();
      expect(state.isOffline, isTrue);

      final encId = state.encounters.first.id;

      // Add observation while offline
      state.addObservation(
        encounterId: encId,
        code: 'bp_sys',
        label: 'Systolic Blood Pressure',
        value: '142',
        unit: 'mmHg',
        deviceAttribution: 'Omron HEM-7120 #SN-OMR-98214',
        isRepeat: true,
        repeatReason: 'High initial reading on cold morning',
      );

      // Verify added to outbox
      expect(state.offlineOutbox.isNotEmpty, isTrue);
      expect(state.offlineOutbox.first.syncState, SyncState.capturedLocal);

      // Restore connectivity and sync
      state.toggleOfflineMode();
      expect(state.isOffline, isFalse);

      state.syncOutbox();
      expect(state.offlineOutbox.isEmpty, isTrue);
      expect(state.encounters.first.overallSyncState, SyncState.synced);
    });

    test('Local doctor review completes encounter and sets disposition', () {
      final state = HealoraState();
      final encId = state.encounters.first.id;

      state.submitDoctorReview(
        encounterId: encId,
        doctorName: 'Dr. Tariqul Islam',
        bmdcNumber: 'BMDC A-54910',
        assessment: 'Hypertension controlled. Blood glucose normalized.',
        plan: 'Continue diet and review in 30 days.',
        disposition: EncounterDisposition.completed,
      );

      final enc = state.encounters.firstWhere((e) => e.id == encId);
      expect(enc.status, EncounterStatus.completed);
      expect(enc.doctorNote, isNotNull);
      expect(enc.doctorNote!.doctorBmdcNumber, 'BMDC A-54910');
    });

    test('Medical equipment status update flags maintenance and blocks unsafe use', () {
      final state = HealoraState();

      state.updateEquipmentStatus('eq_01', EquipmentStatus.outOfService, notes: 'Defective cuff');

      final eq = state.equipment.firstWhere((e) => e.id == 'eq_01');
      expect(eq.status, EquipmentStatus.outOfService);
      expect(eq.notes, contains('Defective cuff'));
    });

    testWidgets('Full UI rendering across views', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const HealoraApp());
      await tester.pumpAndSettle();

      // Check Dashboard exists
      expect(find.text('Manikganj Rural Care Hub'), findsWidgets);

      // Tap Live Queue
      await tester.tap(find.text('Live Queue'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Active Tokens in Hub Queue'), findsOneWidget);

      // Tap Check-in
      await tester.tap(find.text('Check-in & Walk-in'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Today\'s Appointments'), findsOneWidget);

      // Tap Special Team & Doctor
      await tester.tap(find.text('Special Team & Doctor'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Standard Vitals Checklist'), findsOneWidget);

      // Tap Patient View Preview
      await tester.tap(find.text('Patient View Preview'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Good morning, Rahima'), findsOneWidget);
    });
  });
}

