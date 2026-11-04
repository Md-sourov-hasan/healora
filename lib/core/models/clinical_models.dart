enum EncounterStatus {
  created,
  assigned,
  inProgress,
  submittedForReview,
  reviewed,
  completed,
  syncFailed,
  awaitingSync,
}

enum EncounterDisposition {
  inProgress,
  completed,
  followUpRequired,
  referredToHospital,
  teleconsultScheduled,
  unableToComplete,
}

enum SyncState {
  capturedLocal,
  synced,
  syncFailed,
}

class Observation {
  final String id;
  final String encounterId;
  final String patientId;
  final String code; // e.g. 'bp_sys', 'bp_dia', 'pulse', 'spo2', 'temp', 'glucose', 'height', 'weight', 'bmi'
  final String label;
  final String value;
  final String unit;
  final String? contextNote; // e.g. Fasting, Left Arm Sitting
  final String deviceAttribution; // e.g. 'Omron HEM-7120 #SN-9821'
  final String performerName;
  final String measuredAt;
  final bool isRepeat;
  final String? repeatReason;
  final bool isFlaggedAbnormal;
  final SyncState syncState;
  final String idempotencyKey;

  const Observation({
    required this.id,
    required this.encounterId,
    required this.patientId,
    required this.code,
    required this.label,
    required this.value,
    required this.unit,
    this.contextNote,
    required this.deviceAttribution,
    required this.performerName,
    required this.measuredAt,
    this.isRepeat = false,
    this.repeatReason,
    this.isFlaggedAbnormal = false,
    required this.syncState,
    required this.idempotencyKey,
  });

  Observation copyWith({
    SyncState? syncState,
  }) {
    return Observation(
      id: id,
      encounterId: encounterId,
      patientId: patientId,
      code: code,
      label: label,
      value: value,
      unit: unit,
      contextNote: contextNote,
      deviceAttribution: deviceAttribution,
      performerName: performerName,
      measuredAt: measuredAt,
      isRepeat: isRepeat,
      repeatReason: repeatReason,
      isFlaggedAbnormal: isFlaggedAbnormal,
      syncState: syncState ?? this.syncState,
      idempotencyKey: idempotencyKey,
    );
  }
}

class ClinicalReviewNote {
  final String id;
  final String encounterId;
  final String doctorName;
  final String doctorBmdcNumber; // BMDC registration requirement
  final String clinicalAssessment;
  final String managementPlan;
  final String signedAt;

  const ClinicalReviewNote({
    required this.id,
    required this.encounterId,
    required this.doctorName,
    required this.doctorBmdcNumber,
    required this.clinicalAssessment,
    required this.managementPlan,
    required this.signedAt,
  });
}

class Encounter {
  final String id;
  final String appointmentId;
  final String ticketId;
  final String patientId;
  final String patientCode;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String hubId;
  final String hubName;
  final String sessionId;
  final String openedAt;
  final String? closedAt;
  final String assignedWorker;
  final String assignedDoctor;
  final EncounterStatus status;
  final EncounterDisposition disposition;
  final List<Observation> observations;
  final ClinicalReviewNote? doctorNote;
  final SyncState overallSyncState;

  const Encounter({
    required this.id,
    required this.appointmentId,
    required this.ticketId,
    required this.patientId,
    required this.patientCode,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.hubId,
    required this.hubName,
    required this.sessionId,
    required this.openedAt,
    this.closedAt,
    required this.assignedWorker,
    required this.assignedDoctor,
    required this.status,
    required this.disposition,
    required this.observations,
    this.doctorNote,
    required this.overallSyncState,
  });

  String get statusLabel {
    switch (status) {
      case EncounterStatus.created:
        return 'Created';
      case EncounterStatus.assigned:
        return 'Assigned';
      case EncounterStatus.inProgress:
        return 'In progress';
      case EncounterStatus.submittedForReview:
        return 'Under review';
      case EncounterStatus.reviewed:
        return 'Reviewed';
      case EncounterStatus.completed:
        return 'Completed';
      case EncounterStatus.syncFailed:
        return 'Sync failed';
      case EncounterStatus.awaitingSync:
        return 'Awaiting sync';
    }
  }

  Encounter copyWith({
    EncounterStatus? status,
    EncounterDisposition? disposition,
    List<Observation>? observations,
    ClinicalReviewNote? doctorNote,
    SyncState? overallSyncState,
    String? closedAt,
  }) {
    return Encounter(
      id: id,
      appointmentId: appointmentId,
      ticketId: ticketId,
      patientId: patientId,
      patientCode: patientCode,
      patientName: patientName,
      patientAge: patientAge,
      patientGender: patientGender,
      hubId: hubId,
      hubName: hubName,
      sessionId: sessionId,
      openedAt: openedAt,
      closedAt: closedAt ?? this.closedAt,
      assignedWorker: assignedWorker,
      assignedDoctor: assignedDoctor,
      status: status ?? this.status,
      disposition: disposition ?? this.disposition,
      observations: observations ?? this.observations,
      doctorNote: doctorNote ?? this.doctorNote,
      overallSyncState: overallSyncState ?? this.overallSyncState,
    );
  }
}

