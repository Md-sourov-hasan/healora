import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/hub_models.dart';

class HubsFindController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxString searchQuery = ''.obs;
  final RxString selectedDivision = 'All'.obs;
  final Rx<Hub?> selectedHubForBooking = Rx<Hub?>(null);
  final RxString selectedSlotTime = '10:00 AM'.obs;
  final RxString selectedDate = '14 Nov 2026'.obs;
  final RxBool isBooking = false.obs;

  List<Hub> get allHubs => state.hubs;

  List<Hub> get filteredHubs {
    final query = searchQuery.value.trim().toLowerCase();
    return allHubs.where((hub) {
      final matchesQuery = query.isEmpty ||
          hub.name.toLowerCase().contains(query) ||
          hub.upazila.toLowerCase().contains(query) ||
          hub.district.toLowerCase().contains(query) ||
          hub.code.toLowerCase().contains(query);

      final matchesDivision = selectedDivision.value == 'All' ||
          hub.division == selectedDivision.value;

      return matchesQuery && matchesDivision;
    }).toList();
  }

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setDivision(String division) {
    selectedDivision.value = division;
  }

  void selectHubForBooking(Hub hub) {
    selectedHubForBooking.value = hub;
  }

  void setSlotTime(String slot) {
    selectedSlotTime.value = slot;
  }

  void setDate(String date) {
    selectedDate.value = date;
  }

  Future<bool> confirmBooking() async {
    final hub = selectedHubForBooking.value;
    if (hub == null) return false;

    isBooking.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    // Create booking in central platform state
    final String appointmentCode =
        'APT-2026-${(1000 + state.appointments.length + 1)}';
    final newAppointment = Appointment(
      id: 'apt_auto_${DateTime.now().millisecondsSinceEpoch}',
      appointmentCode: appointmentCode,
      patientId: patient.id,
      patientName: patient.fullName,
      patientPhone: patient.phone,
      patientAge: patient.age,
      patientGender: patient.gender,
      hubId: hub.id,
      hubName: hub.name,
      sessionId: 'ses_${hub.id}_std',
      sessionTitle: 'General Vitals & Routine Health Check',
      date: selectedDate.value,
      slotTime: selectedSlotTime.value,
      bookingSource: 'patient_app',
      status: AppointmentStatus.confirmed,
    );

    state.appointments.insert(0, newAppointment);
    state.addNotification(
      category: 'Appointment',
      title: 'Booking Confirmed: $appointmentCode',
      body:
          'Your visit at ${hub.name} has been confirmed for ${selectedDate.value} at ${selectedSlotTime.value}.',
      appointmentId: newAppointment.id,
    );

    isBooking.value = false;
    update();
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('HubsFindController initialized');
  }
}

