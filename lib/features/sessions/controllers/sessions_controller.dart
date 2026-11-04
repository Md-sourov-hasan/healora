import 'package:get/get.dart';
import 'package:healora/core/services/healora_state.dart';

class SessionsController extends GetxController {
  SessionsController(this.state);

  final HealoraState state;

  void openQueue() {
    state.setNavIndex(3);
  }
}
