import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/hub_models.dart';

class CheckInPatientController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxBool isCheckingIn = false.obs;

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  Appointment? get nextAppointment {
    final list = state.appointments
        .where((a) =>
            a.patientId == patient.id &&
            (a.status == AppointmentStatus.confirmed ||
                a.status == AppointmentStatus.checkedIn ||
                a.status == AppointmentStatus.inService ||
                a.status == AppointmentStatus.arrived))
        .toList();
    return list.isNotEmpty ? list.first : null;
  }

  QueueTicket? get activeTicket {
    final tickets = state.queue
        .where((t) =>
            t.patientCode == patient.canonicalCode &&
            t.status != QueueStatus.completed)
        .toList();
    return tickets.isNotEmpty ? tickets.first : null;
  }

  Hub? get currentHub {
    final appt = nextAppointment;
    if (appt == null) return null;
    return state.hubs.firstWhereOrNull((h) => h.id == appt.hubId);
  }

  Future<void> confirmSelfArrival() async {
    final appt = nextAppointment;
    if (appt == null) return;

    isCheckingIn.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    // Update appointment status to checkedIn
    final apptIndex = state.appointments.indexWhere((a) => a.id == appt.id);
    if (apptIndex != -1) {
      state.appointments[apptIndex] = appt.copyWith(
        status: AppointmentStatus.checkedIn,
      );
    }

    // Ensure queue ticket exists
    if (activeTicket == null) {
      final newTicket = QueueTicket(
        ticketId: 'tkt_${DateTime.now().millisecondsSinceEpoch}',
        tokenNumber: 'HUB-MKG-014',
        appointmentId: appt.id,
        patientId: patient.id,
        patientCode: patient.canonicalCode,
        patientName: patient.fullName,
        hubId: appt.hubId,
        sessionId: appt.sessionId,
        currentStationId: 'st_vitals_1',
        currentStationName: 'Station 1: Vitals & Measurements',
        status: QueueStatus.waiting,
        arrivalTime: '10:15 AM BST',
        waitDurationMinutes: 8,
        assignedWorker: 'Nasrin Sultana (Field Health Worker)',
      );
      state.queue.insert(0, newTicket);
    }

    state.addNotification(
      category: 'Queue',
      title: 'Arrival Confirmed at Hub',
      body:
          'Token HUB-MKG-014 issued. Please proceed to Station 1: Vitals & Measurements.',
      appointmentId: appt.id,
    );

    isCheckingIn.value = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('CheckInPatientController initialized');
  }
}

