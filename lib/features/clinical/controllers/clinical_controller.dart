import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:healora/core/controllers/healora_state.dart';

class ClinicalController extends HealoraFeatureController {
  ClinicalController(super.state);

  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController spo2Controller = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repeatReasonController = TextEditingController();
  final TextEditingController doctorAssessmentController =
      TextEditingController();
  final TextEditingController doctorPlanController = TextEditingController();

  String selectedDeviceId = 'Omron HEM-7120 #SN-OMR-98214';
  String glucoseContext = 'Fasting';
  bool isRepeatReading = false;
  EncounterDisposition selectedDisposition = EncounterDisposition.completed;

  Encounter? get activeEncounter {
    for (final encounter in state.encounters) {
      if (state.activeRole == HealoraRole.fieldHealthWorker &&
          encounter.status != EncounterStatus.completed &&
          encounter.status != EncounterStatus.submittedForReview &&
          encounter.status != EncounterStatus.awaitingSync) {
        return encounter;
      }
      if (state.activeRole == HealoraRole.specialTeamLead &&
          encounter.status != EncounterStatus.completed) {
        return encounter;
      }
      if ((state.activeRole == HealoraRole.localDoctor ||
              state.activeRole == HealoraRole.registeredMedicalDoctor) &&
          encounter.status == EncounterStatus.submittedForReview) {
        return encounter;
      }
    }
    return null;
  }

  String ticketLabel(String ticketId) => ticketId.replaceAll('tkt_', 'TOKEN #');

  double? get bmi {
    final heightCm = double.tryParse(heightController.text);
    final weightKg = double.tryParse(weightController.text);
    if (heightCm == null ||
        weightKg == null ||
        heightCm <= 50 ||
        weightKg <= 20) {
      return null;
    }
    final heightM = heightCm / 100;
    return double.parse((weightKg / (heightM * heightM)).toStringAsFixed(1));
  }

  void selectDevice(String value) {
    selectedDeviceId = value;
    update();
  }

  void selectGlucoseContext(String value) {
    glucoseContext = value;
    update();
  }

  void setRepeatReading(bool value) {
    isRepeatReading = value;
    update();
  }

  void refreshBmi() => update();

  void selectDisposition(EncounterDisposition value) {
    selectedDisposition = value;
    update();
  }

  void syncOutbox() => state.syncOutbox();

  bool saveObservations(String encounterId) {
    final values = <String, double?>{
      'Systolic blood pressure': double.tryParse(
        systolicController.text.trim(),
      ),
      'Diastolic blood pressure': double.tryParse(
        diastolicController.text.trim(),
      ),
      'Pulse rate': double.tryParse(pulseController.text.trim()),
      'Oxygen saturation': double.tryParse(spo2Controller.text.trim()),
      'Temperature': double.tryParse(temperatureController.text.trim()),
      'Blood glucose': double.tryParse(glucoseController.text.trim()),
      'Height': double.tryParse(heightController.text.trim()),
      'Weight': double.tryParse(weightController.text.trim()),
    };
    if (values.values.any(
          (value) => value == null || !value.isFinite || value <= 0,
        ) ||
        (isRepeatReading && repeatReasonController.text.trim().isEmpty)) {
      return false;
    }

    final reason = isRepeatReading ? repeatReasonController.text.trim() : null;
    void add(
      String code,
      String label,
      String value,
      String unit, {
      String? contextNote,
      String? device,
    }) {
      state.addObservation(
        encounterId: encounterId,
        code: code,
        label: label,
        value: value.trim(),
        unit: unit,
        contextNote: contextNote,
        deviceAttribution: device ?? selectedDeviceId,
        isRepeat: isRepeatReading,
        repeatReason: reason,
      );
    }

    add(
      'bp_sys',
      'Systolic Blood Pressure',
      systolicController.text,
      'mmHg',
      contextNote: 'Right arm, seated',
    );
    add(
      'bp_dia',
      'Diastolic Blood Pressure',
      diastolicController.text,
      'mmHg',
      contextNote: 'Right arm, seated',
    );
    add('pulse', 'Pulse Rate', pulseController.text, 'bpm');
    add('spo2', 'Oxygen Saturation', spo2Controller.text, '%');
    add('temperature', 'Temperature', temperatureController.text, '\u00B0C');
    add(
      'glucose',
      'Blood Glucose',
      glucoseController.text,
      'mmol/L',
      contextNote: glucoseContext,
      device: 'Accu-Chek Instant #SN-ROCHE-44102',
    );
    add('height', 'Height', heightController.text, 'cm');
    add('weight', 'Weight', weightController.text, 'kg');
    state.submitEncounterForReview(encounterId);
    return true;
  }

  bool submitReview(String encounterId) {
    if (doctorAssessmentController.text.trim().isEmpty ||
        doctorPlanController.text.trim().isEmpty ||
        (state.activeRole != HealoraRole.localDoctor &&
            state.activeRole != HealoraRole.registeredMedicalDoctor) ||
        !state.encounters.any(
          (encounter) =>
              encounter.id == encounterId &&
              encounter.status == EncounterStatus.submittedForReview,
        )) {
      return false;
    }
    state.submitDoctorReview(
      encounterId: encounterId,
      doctorName: 'Dr. Tariqul Islam',
      bmdcNumber: 'BMDC A-54910',
      assessment: doctorAssessmentController.text.trim(),
      plan: doctorPlanController.text.trim(),
      disposition: selectedDisposition,
    );
    return true;
  }

  @override
  void onClose() {
    systolicController.dispose();
    diastolicController.dispose();
    pulseController.dispose();
    spo2Controller.dispose();
    temperatureController.dispose();
    glucoseController.dispose();
    heightController.dispose();
    weightController.dispose();
    repeatReasonController.dispose();
    doctorAssessmentController.dispose();
    doctorPlanController.dispose();
    super.onClose();
  }
}
