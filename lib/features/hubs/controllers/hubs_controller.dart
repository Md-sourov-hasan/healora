import 'package:get/get.dart';

class HubsController extends GetxController {
  String searchQuery = '';
  String? selectedDivisionFilter;

  void setSearchQuery(String value) {
    searchQuery = value;
    update();
  }

  void setDivisionFilter(String? value) {
    selectedDivisionFilter = value;
    update();
  }
}
