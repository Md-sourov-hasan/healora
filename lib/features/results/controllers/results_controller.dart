import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/clinical_models.dart';

class ResultsController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxString selectedFilter = 'All'.obs;

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  List<Encounter> get patientEncounters => state.encounters
      .where((e) => e.patientCode == patient.canonicalCode)
      .toList();

  Encounter? get latestEncounter =>
      patientEncounters.isNotEmpty ? patientEncounters.first : null;

  List<Observation> get allObservations {
    final List<Observation> obs = [];
    for (final enc in patientEncounters) {
      obs.addAll(enc.observations);
    }
    return obs;
  }

  List<Observation> get filteredObservations {
    if (selectedFilter.value == 'All') return allObservations;
    if (selectedFilter.value == 'BP') {
      return allObservations
          .where((o) => o.code == 'bp_sys' || o.code == 'bp_dia')
          .toList();
    }
    if (selectedFilter.value == 'Glucose') {
      return allObservations.where((o) => o.code == 'glucose').toList();
    }
    if (selectedFilter.value == 'Vitals') {
      return allObservations
          .where((o) =>
              o.code == 'pulse' || o.code == 'spo2' || o.code == 'temp')
          .toList();
    }
    if (selectedFilter.value == 'Body') {
      return allObservations
          .where((o) =>
              o.code == 'weight' || o.code == 'height' || o.code == 'bmi')
          .toList();
    }
    return allObservations;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('ResultsController initialized');
  }
}

