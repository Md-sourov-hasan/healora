import 'package:healora/core/controllers/healora_feature_controller.dart';

class AuditController extends HealoraFeatureController {
  AuditController(super.state);

  int get eventCount => state.auditLogs.length;
}
