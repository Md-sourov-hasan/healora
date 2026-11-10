import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/clinical_models.dart';

class FollowUpsController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  List<Encounter> get encountersWithNotes {
    return state.encounters
        .where((e) =>
            e.patientCode == patient.canonicalCode && e.doctorNote != null)
        .toList();
  }

  Encounter? get latestReviewedEncounter {
    return encountersWithNotes.isNotEmpty ? encountersWithNotes.first : null;
  }

  ClinicalReviewNote? get latestNote {
    return latestReviewedEncounter?.doctorNote;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('FollowUpsController initialized');
  }
}

