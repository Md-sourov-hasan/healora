import 'package:get/get.dart';

class CheckinController extends GetxController {
  String searchFilter = '';

  void setSearchFilter(String value) {
    searchFilter = value;
    update();
  }
}
