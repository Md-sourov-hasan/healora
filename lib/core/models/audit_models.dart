class AuditLogEntry {
  final String id;
  final String timestamp;
  final String actorName;
  final String actorRole;
  final String hubId;
  final String hubName;
  final String action;
  final String entityType;
  final String entityId;
  final String details;
  final String complianceStandard; // e.g., 'PDPA 2026 Sec 22', 'DGHS Telehealth Art 4'

  const AuditLogEntry({
    required this.id,
    required this.timestamp,
    required this.actorName,
    required this.actorRole,
    required this.hubId,
    required this.hubName,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.details,
    required this.complianceStandard,
  });
}

class OperationalMetrics {
  final int activeHubs;
  final int todaySessions;
  final int totalAppointments;
  final int arrivedCount;
  final int checkedInCount;
  final int inServiceCount;
  final int completedCount;
  final int syncPendingCount;
  final int syncFailedCount;
  final int equipmentIssuesCount;
  final int averageWaitMinutes;
  final int averageServiceMinutes;
  final double syncSuccessRate;
  final double requiredDataCompleteness;

  const OperationalMetrics({
    required this.activeHubs,
    required this.todaySessions,
    required this.totalAppointments,
    required this.arrivedCount,
    required this.checkedInCount,
    required this.inServiceCount,
    required this.completedCount,
    required this.syncPendingCount,
    required this.syncFailedCount,
    required this.equipmentIssuesCount,
    required this.averageWaitMinutes,
    required this.averageServiceMinutes,
    required this.syncSuccessRate,
    required this.requiredDataCompleteness,
  });
}

