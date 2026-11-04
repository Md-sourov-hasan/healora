import 'package:healora/core/controllers/healora_feature_controller.dart';
import 'package:healora/core/models/hub_models.dart';

class HubsController extends HealoraFeatureController {
  HubsController(super.state);

  String searchQuery = '';
  String? selectedDivisionFilter;

  void setSearchQuery(String value) {
    searchQuery = value;
    update();
  }

  void setDivisionFilter(String? value) {
    selectedDivisionFilter = value;
    update();
  }

  List<Hub> get filteredHubs {
    return state.hubs.where((hub) {
      final query = searchQuery.toLowerCase();
      final matchesSearch =
          hub.name.toLowerCase().contains(query) ||
          hub.district.toLowerCase().contains(query) ||
          hub.code.toLowerCase().contains(query);
      final matchesDivision =
          selectedDivisionFilter == null ||
          hub.division.toLowerCase() == selectedDivisionFilter!.toLowerCase();
      return matchesSearch && matchesDivision;
    }).toList();
  }

  void selectHub(String hubId) {
    state.setSelectedHub(hubId);
  }
}
