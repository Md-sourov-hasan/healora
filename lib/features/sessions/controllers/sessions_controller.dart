import 'package:healora/core/controllers/healora_feature_controller.dart';

class SessionsController extends HealoraFeatureController {
  SessionsController(super.state);

  void openQueue() {
    state.setNavIndex(3);
  }
}
