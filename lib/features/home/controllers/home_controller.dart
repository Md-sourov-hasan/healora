import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:healora/core/models/hub_models.dart';

class HomeController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxString searchQuery = ''.obs;

  PatientProfile get patient => state.currentPatient;
  List<Appointment> get appointments => state.appointments
      .where((a) => a.patientId == patient.id)
      .toList();

  Appointment? get nextAppointment {
    final list = appointments
        .where((a) =>
            a.status == AppointmentStatus.confirmed ||
            a.status == AppointmentStatus.pendingConfirmation ||
            a.status == AppointmentStatus.checkedIn ||
            a.status == AppointmentStatus.inService)
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

  Encounter? get latestEncounter {
    final encounters = state.encounters
        .where((e) => e.patientCode == patient.canonicalCode)
        .toList();
    return encounters.isNotEmpty ? encounters.first : null;
  }

  Hub? get preferredHub {
    final hubs = state.hubs.where((h) => h.id == state.selectedHubId).toList();
    return hubs.isNotEmpty ? hubs.first : state.hubs.first;
  }

  bool get isBangla => state.isBangla;

  void toggleLanguage() {
    state.toggleLanguage();
    update();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('HomeController initialized');
  }
}

