import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/models/appointment_models.dart';

class PatientNotificationsController extends GetxController {
  final HealoraState state = Get.find<HealoraState>();

  final RxString selectedCategory = 'All'.obs;

  bool get isBangla => state.isBangla;
  List<NotificationItem> get allNotifications => state.notifications;

  List<NotificationItem> get filteredNotifications {
    if (selectedCategory.value == 'All') return allNotifications;
    return allNotifications
        .where((n) => n.category == selectedCategory.value)
        .toList();
  }

  void setCategory(String cat) {
    selectedCategory.value = cat;
  }

  void markAllAsRead() {
    state.markAllNotificationsRead();
    update();
  }

  void markSingleAsRead(String id) {
    state.markNotificationRead(id);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('PatientNotificationsController initialized');
  }
}

