import 'package:healora/core/controllers/healora_feature_controller.dart';

class PatientPreviewController extends HealoraFeatureController {
  PatientPreviewController(super.state);
  int selectedSectionIndex = 0;

  void selectSection(int index) {
    selectedSectionIndex = index;
    update();
  }
}
