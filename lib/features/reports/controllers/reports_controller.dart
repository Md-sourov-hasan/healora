import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:healora/core/models/audit_models.dart';

class ReportsController extends HealoraFeatureController {
  ReportsController(super.state);

  OperationalMetrics get metrics => state.metrics;
}
