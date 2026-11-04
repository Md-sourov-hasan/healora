import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/models/clinical_models.dart';

class ClinicalController extends HealoraFeatureController {
  ClinicalController(super.state);

  final TextEditingController systolicController = TextEditingController(
    text: '136',
  );
  final TextEditingController diastolicController = TextEditingController(
    text: '86',
  );
  final TextEditingController pulseController = TextEditingController(
    text: '78',
  );
  final TextEditingController spo2Controller = TextEditingController(
    text: '98',
  );
  final TextEditingController temperatureController = TextEditingController(
    text: '36.8',
  );
  final TextEditingController glucoseController = TextEditingController(
    text: '7.2',
  );
  final TextEditingController heightController = TextEditingController(
    text: '162',
  );
  final TextEditingController weightController = TextEditingController(
    text: '65.0',
  );
  final TextEditingController repeatReasonController = TextEditingController();
  final TextEditingController doctorAssessmentController =
      TextEditingController(
        text: 'Stage 1 Hypertension noted with mildly elevated fasting glucose (7.4 mmol/L). Cardiac auscultation normal S1 S2, no pedal edema.',
      );
  final TextEditingController doctorPlanController = TextEditingController(
    text: 'Prescribed lifestyle modification and dietary salt reduction. Scheduled follow-up vitals check at hub in 14 days. Teleconsultation package with Chennai cardiologist recommended.',
  );

  String selectedDeviceId = 'Omron HEM-7120 #SN-OMR-98214';
  String glucoseContext = 'Fasting';
  bool isRepeatReading = false;
  EncounterDisposition selectedDisposition = EncounterDisposition.completed;

  Encounter? get activeEncounter =>
      state.encounters.isEmpty ? null : state.encounters.first;

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

  void saveObservations(String encounterId) {
    final reason = isRepeatReading ? repeatReasonController.text : null;
    state.addObservation(
      encounterId: encounterId,
      code: 'bp_sys',
      label: 'Systolic Blood Pressure',
      value: systolicController.text.trim(),
      unit: 'mmHg',
      contextNote: 'Right arm seated',
      deviceAttribution: selectedDeviceId,
      isRepeat: isRepeatReading,
      repeatReason: reason,
    );
    state.addObservation(
      encounterId: encounterId,
      code: 'bp_dia',
      label: 'Diastolic Blood Pressure',
      value: diastolicController.text.trim(),
      unit: 'mmHg',
      contextNote: 'Right arm seated',
      deviceAttribution: selectedDeviceId,
      isRepeat: isRepeatReading,
      repeatReason: reason,
    );
    state.addObservation(
      encounterId: encounterId,
      code: 'pulse',
      label: 'Pulse Rate',
      value: pulseController.text.trim(),
      unit: 'bpm',
      deviceAttribution: selectedDeviceId,
      isRepeat: isRepeatReading,
    );
    final glucose = double.tryParse(glucoseController.text);
    state.addObservation(
      encounterId: encounterId,
      code: 'glucose',
      label: 'Blood Glucose',
      value: glucoseController.text.trim(),
      unit: 'mmol/L',
      contextNote: glucoseContext,
      deviceAttribution: 'Accu-Chek Instant #SN-ROCHE-44102',
      isRepeat: isRepeatReading,
      isAbnormal: glucose != null && glucose > 7.0,
      repeatReason: reason,
    );
  }

  void submitReview(String encounterId) {
    state.submitDoctorReview(
      encounterId: encounterId,
      doctorName: 'Dr. Tariqul Islam',
      bmdcNumber: 'BMDC A-54910',
      assessment: doctorAssessmentController.text.trim(),
      plan: doctorPlanController.text.trim(),
      disposition: selectedDisposition,
    );
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
