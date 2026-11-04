import 'package:get/get.dart';
import 'package:healora/core/services/healora_state.dart';

class DashboardController extends GetxController {
  DashboardController(this.state);

  final HealoraState state;

  void openSection(int index) {
    state.setNavIndex(index);
  }
}
