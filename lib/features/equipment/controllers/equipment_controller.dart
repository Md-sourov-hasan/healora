import 'package:get/get.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/services/healora_state.dart';

class EquipmentController extends GetxController {
  EquipmentController(this.state);

  final HealoraState state;

  void updateStatus(
    String equipmentId,
    EquipmentStatus status, {
    String? notes,
  }) {
    state.updateEquipmentStatus(equipmentId, status, notes: notes);
  }
}
