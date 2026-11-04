import 'package:get/get.dart';

class PatientPreviewController extends GetxController {
  int selectedSectionIndex = 0;

  void selectSection(int index) {
    selectedSectionIndex = index;
    update();
  }
}
