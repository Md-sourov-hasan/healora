import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';

class BookingsController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxInt selectedTab = 0.obs; // 0: Upcoming, 1: Past

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  List<Appointment> get allAppointments => state.appointments
      .where((a) => a.patientId == patient.id)
      .toList();

  List<Appointment> get upcomingAppointments => allAppointments
      .where((a) =>
          a.status == AppointmentStatus.confirmed ||
          a.status == AppointmentStatus.pendingConfirmation ||
          a.status == AppointmentStatus.arrived ||
          a.status == AppointmentStatus.checkedIn ||
          a.status == AppointmentStatus.inService)
      .toList();

  List<Appointment> get pastAppointments => allAppointments
      .where((a) =>
          a.status == AppointmentStatus.completed ||
          a.status == AppointmentStatus.cancelled ||
          a.status == AppointmentStatus.noShow)
      .toList();

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void cancelAppointment(Appointment appointment, String reason) {
    final index = state.appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      state.appointments[index] = appointment.copyWith(
        status: AppointmentStatus.cancelled,
        cancellationReason: reason,
      );
      state.addNotification(
        category: 'Appointment',
        title: 'Appointment Cancelled: ${appointment.appointmentCode}',
        body: 'Your visit at ${appointment.hubName} has been cancelled.',
        appointmentId: appointment.id,
      );
      update();
    }
  }

  void rescheduleAppointment(
    Appointment appointment,
    String newDate,
    String newSlot,
  ) {
    final index = state.appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      state.appointments[index] = Appointment(
        id: appointment.id,
        appointmentCode: appointment.appointmentCode,
        patientId: appointment.patientId,
        patientName: appointment.patientName,
        patientPhone: appointment.patientPhone,
        patientAge: appointment.patientAge,
        patientGender: appointment.patientGender,
        hubId: appointment.hubId,
        hubName: appointment.hubName,
        sessionId: appointment.sessionId,
        sessionTitle: appointment.sessionTitle,
        date: newDate,
        slotTime: newSlot,
        bookingSource: appointment.bookingSource,
        status: AppointmentStatus.confirmed,
      );
      state.addNotification(
        category: 'Appointment',
        title: 'Appointment Rescheduled: ${appointment.appointmentCode}',
        body:
            'Your visit at ${appointment.hubName} was rescheduled to $newDate at $newSlot.',
        appointmentId: appointment.id,
      );
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('BookingsController initialized');
  }
}

