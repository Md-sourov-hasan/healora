import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:healora/core/models/appointment_models.dart';

class QueueController extends HealoraFeatureController {
  QueueController(super.state);

  bool isPublicDisplayMode = false;
  String? selectedStationFilter;

  void togglePublicDisplayMode() {
    isPublicDisplayMode = !isPublicDisplayMode;
    update();
  }

  void toggleStationFilter(String stationId) {
    selectedStationFilter = selectedStationFilter == stationId
        ? null
        : stationId;
    update();
  }

  List<QueueTicket> get filteredQueue => state.queue.where((ticket) {
    if (selectedStationFilter == null) return true;
    return ticket.currentStationId == selectedStationFilter;
  }).toList();

  void callPatient(QueueTicket ticket) {
    state.updateQueueStatus(ticket.ticketId, QueueStatus.inService);
  }

  void openVitals() {
    state.setNavIndex(5);
  }

  String patientLabel(QueueTicket ticket) {
    if (!isPublicDisplayMode) return ticket.patientName;
    final tokenSuffix = ticket.tokenNumber.split('-').last;
    return translate('Patient #$tokenSuffix', 'রোগী #$tokenSuffix');
  }

  String stationLead(String assignedStaff) =>
      assignedStaff.split('(').first.trim();
}
