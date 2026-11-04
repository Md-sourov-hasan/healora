import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:healora/core/models/audit_models.dart';
import 'package:healora/core/models/hub_models.dart';

class DashboardController extends HealoraFeatureController {
  DashboardController(super.state);

  OperationalMetrics get metrics => state.metrics;
  Hub get currentHub => state.currentHub;

  void openSection(int index) {
    state.setNavIndex(index);
  }
}
