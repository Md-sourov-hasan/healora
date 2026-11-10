import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';

class ConsentController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxBool consentHubService = true.obs;
  final RxBool consentDataProcessing = true.obs;
  final RxBool consentTelehealth = true.obs;
  final RxBool consentCaregiver = true.obs;
  final RxBool consentOverseasSharing = false.obs;

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  @override
  void onInit() {
    super.onInit();
    final record = state.consentRecords
        .firstWhereOrNull((c) => c.patientId == patient.id);
    if (record != null) {
      consentHubService.value = record.consentHubService;
      consentDataProcessing.value = record.consentDataProcessing;
      consentTelehealth.value = record.consentTelehealthConsult;
    }
  }

  void toggleConsent(String type, bool value) {
    switch (type) {
      case 'hub':
        consentHubService.value = value;
        break;
      case 'data':
        consentDataProcessing.value = value;
        break;
      case 'telehealth':
        consentTelehealth.value = value;
        break;
      case 'caregiver':
        consentCaregiver.value = value;
        break;
      case 'overseas':
        consentOverseasSharing.value = value;
        break;
    }

    state.addNotification(
      category: 'Consent',
      title: 'Consent Preference Updated',
      body:
          'Your data authorisation preferences under Bangladesh PDPA 2026 were successfully updated.',
    );
    update();
  }
}

