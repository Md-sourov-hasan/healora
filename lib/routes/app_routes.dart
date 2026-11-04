import 'package:flutter/material.dart';
import 'package:healora/core/services/healora_state.dart';
import 'package:healora/features/audit/presentation/screens/audit_screen.dart';
import 'package:healora/features/checkin/presentation/screens/checkin_screen.dart';
import 'package:healora/features/clinical/presentation/screens/clinical_screen.dart';
import 'package:healora/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:healora/features/equipment/presentation/screens/equipment_screen.dart';
import 'package:healora/features/hubs/presentation/screens/hubs_screen.dart';
import 'package:healora/features/patient/presentation/screens/patient_preview_screen.dart';
import 'package:healora/features/queue/presentation/screens/queue_screen.dart';
import 'package:healora/features/reports/presentation/screens/reports_screen.dart';
import 'package:healora/features/sessions/presentation/screens/sessions_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static Widget pageForIndex(int index, HealoraState state) {
    switch (index) {
      case 1:
        return HubsScreen(state: state);
      case 2:
        return SessionsScreen(state: state);
      case 3:
        return QueueScreen(state: state);
      case 4:
        return CheckinScreen(state: state);
      case 5:
        return ClinicalScreen(state: state);
      case 6:
        return EquipmentScreen(state: state);
      case 7:
        return ReportsScreen(state: state);
      case 8:
        return AuditScreen(state: state);
      case 9:
        return PatientPreviewScreen(state: state);
      case 0:
      default:
        return DashboardScreen(state: state);
    }
  }
}
