import 'package:get/get.dart';

class QueueController extends GetxController {
  bool isPublicDisplayMode = false;
  String? selectedStationFilter;

  void togglePublicDisplayMode() {
    isPublicDisplayMode = !isPublicDisplayMode;
    update();
  }

  void toggleStationFilter(String stationId) {
    selectedStationFilter = selectedStationFilter == stationId
        ? null
        : stationId;
    update();
  }
}
