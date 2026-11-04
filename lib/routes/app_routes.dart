import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/features/audit/controllers/audit_controller.dart';
import 'package:healora/features/audit/presentation/screens/audit_screen.dart';
import 'package:healora/features/checkin/controllers/checkin_controller.dart';
import 'package:healora/features/checkin/presentation/screens/checkin_screen.dart';
import 'package:healora/features/clinical/controllers/clinical_controller.dart';
import 'package:healora/features/clinical/presentation/screens/clinical_screen.dart';
import 'package:healora/features/dashboard/controllers/dashboard_controller.dart';
import 'package:healora/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:healora/features/equipment/controllers/equipment_controller.dart';
import 'package:healora/features/equipment/presentation/screens/equipment_screen.dart';
import 'package:healora/features/hubs/controllers/hubs_controller.dart';
import 'package:healora/features/hubs/presentation/screens/hubs_screen.dart';
import 'package:healora/features/patient/controllers/patient_preview_controller.dart';
import 'package:healora/features/patient/presentation/screens/patient_preview_screen.dart';
import 'package:healora/features/queue/controllers/queue_controller.dart';
import 'package:healora/features/queue/presentation/screens/queue_screen.dart';
import 'package:healora/features/reports/controllers/reports_controller.dart';
import 'package:healora/features/reports/presentation/screens/reports_screen.dart';
import 'package:healora/features/sessions/controllers/sessions_controller.dart';
import 'package:healora/features/sessions/presentation/screens/sessions_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static Widget pageForIndex(int index, HealoraState state) {
    switch (index) {
      case 1:
        return GetBuilder<HubsController>(
          init: HubsController(state),
          builder: (controller) => HubsScreen(controller: controller),
        );
      case 2:
        return GetBuilder<SessionsController>(
          init: SessionsController(state),
          builder: (controller) => SessionsScreen(controller: controller),
        );
      case 3:
        return GetBuilder<QueueController>(
          init: QueueController(state),
          builder: (controller) => QueueScreen(controller: controller),
        );
      case 4:
        return GetBuilder<CheckinController>(
          init: CheckinController(state),
          builder: (controller) => CheckinScreen(controller: controller),
        );
      case 5:
        return GetBuilder<ClinicalController>(
          init: ClinicalController(state),
          builder: (controller) => ClinicalScreen(controller: controller),
        );
      case 6:
        return GetBuilder<EquipmentController>(
          init: EquipmentController(state),
          builder: (controller) => EquipmentScreen(controller: controller),
        );
      case 7:
        return GetBuilder<ReportsController>(
          init: ReportsController(state),
          builder: (controller) => ReportsScreen(controller: controller),
        );
      case 8:
        return GetBuilder<AuditController>(
          init: AuditController(state),
          builder: (controller) => AuditScreen(controller: controller),
        );
      case 9:
        return GetBuilder<PatientPreviewController>(
          init: PatientPreviewController(state),
          builder: (controller) => PatientPreviewScreen(controller: controller),
        );
      case 0:
      default:
        return GetBuilder<DashboardController>(
          init: DashboardController(state),
          builder: (controller) => DashboardScreen(controller: controller),
        );
    }
  }
}
