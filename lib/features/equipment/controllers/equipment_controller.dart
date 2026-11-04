import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:healora/core/models/hub_models.dart';

class EquipmentController extends HealoraFeatureController {
  EquipmentController(super.state);

  void updateStatus(
    String equipmentId,
    EquipmentStatus status, {
    String? notes,
  }) {
    state.updateEquipmentStatus(equipmentId, status, notes: notes);
  }
}
