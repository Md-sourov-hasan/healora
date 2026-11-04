import 'package:get/get.dart';

class ClinicalController extends GetxController {
  String selectedDeviceId = 'Omron HEM-7120 #SN-OMR-98214';
  String glucoseContext = 'Fasting';
  bool isRepeatReading = false;

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
}
