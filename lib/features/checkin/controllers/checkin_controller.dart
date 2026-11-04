import 'package:flutter/material.dart';
import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:healora/core/models/appointment_models.dart';

class CheckinController extends HealoraFeatureController {
  CheckinController(super.state);

  final TextEditingController searchController = TextEditingController();
  final TextEditingController walkInNameController = TextEditingController();
  final TextEditingController walkInPhoneController = TextEditingController();
  final TextEditingController walkInAgeController = TextEditingController();
  String searchFilter = '';
  String walkInGender = 'Female';
  bool walkInConsentChecked = true;

  List<Appointment> get filteredAppointments {
    final query = searchFilter.toLowerCase();
    return state.appointments.where((appointment) {
      return appointment.patientName.toLowerCase().contains(query) ||
          appointment.patientPhone.toLowerCase().contains(query) ||
          appointment.appointmentCode.toLowerCase().contains(query);
    }).toList();
  }

  void setSearchFilter(String value) {
    searchFilter = value;
    update();
  }

  void selectWalkInGender(String value) {
    walkInGender = value;
    update();
  }

  void setWalkInConsent(bool value) {
    walkInConsentChecked = value;
    update();
  }

  bool registerWalkIn() {
    final name = walkInNameController.text.trim();
    if (name.isEmpty) return false;

    state.registerWalkIn(
      fullName: name,
      phone: walkInPhoneController.text.trim().isEmpty
          ? '+880 1711 000000'
          : walkInPhoneController.text.trim(),
      age: int.tryParse(walkInAgeController.text) ?? 45,
      gender: walkInGender,
    );
    walkInNameController.clear();
    walkInPhoneController.clear();
    walkInAgeController.clear();
    return true;
  }

  void checkInAppointment(String appointmentId) {
    state.checkInAppointment(appointmentId);
  }

  @override
  void onClose() {
    searchController.dispose();
    walkInNameController.dispose();
    walkInPhoneController.dispose();
    walkInAgeController.dispose();
    super.onClose();
  }
}
