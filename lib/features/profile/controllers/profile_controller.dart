import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/hub_models.dart';

class ProfileController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  PatientProfile get patient => state.currentPatient;
  bool get isBangla => state.isBangla;

  Hub? get preferredHub => state.hubs.firstWhereOrNull((h) => h.id == 'hub_mkg_01');

  void toggleLanguage() {
    state.toggleLanguage();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('ProfileController initialized');
  }
}

