enum AppointmentStatus {
  pendingConfirmation,
  confirmed,
  arrived,
  checkedIn,
  inService,
  completed,
  cancelled,
  noShow,
}

enum QueueStatus {
  waiting,
  called,
  inService,
  awaitingReview,
  completed,
  paused,
  transferred,
}

class PatientProfile {
  final String id;
  final String canonicalCode; // e.g. PAT-BD-89211
  final String fullName;
  final String phone;
  final int age;
  final String gender;
  final String upazila;
  final String district;
  final String bloodGroup;
  final String emergencyContact;
  final bool hasActiveConsent;
  final String consentDate;

  const PatientProfile({
    required this.id,
    required this.canonicalCode,
    required this.fullName,
    required this.phone,
    required this.age,
    required this.gender,
    required this.upazila,
    required this.district,
    required this.bloodGroup,
    required this.emergencyContact,
    required this.hasActiveConsent,
    required this.consentDate,
  });
}

class Appointment {
  final String id;
  final String appointmentCode; // e.g. APT-2026-0812
  final String patientId;
  final String patientName;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String hubId;
  final String hubName;
  final String sessionId;
  final String sessionTitle;
  final String date;
  final String slotTime;
  final String bookingSource; // 'patient_app', 'walk_in', 'referral', 'campaign'
  final AppointmentStatus status;
  final String? cancellationReason;

  const Appointment({
    required this.id,
    required this.appointmentCode,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
    required this.hubId,
    required this.hubName,
    required this.sessionId,
    required this.sessionTitle,
    required this.date,
    required this.slotTime,
    required this.bookingSource,
    required this.status,
    this.cancellationReason,
  });

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.pendingConfirmation:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.arrived:
        return 'Arrived';
      case AppointmentStatus.checkedIn:
        return 'Checked in';
      case AppointmentStatus.inService:
        return 'In service';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No show';
    }
  }

  Appointment copyWith({
    AppointmentStatus? status,
    String? cancellationReason,
  }) {
    return Appointment(
      id: id,
      appointmentCode: appointmentCode,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      patientAge: patientAge,
      patientGender: patientGender,
      hubId: hubId,
      hubName: hubName,
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      date: date,
      slotTime: slotTime,
      bookingSource: bookingSource,
      status: status ?? this.status,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}

class QueueTicket {
  final String ticketId;
  final String tokenNumber; // e.g. HUB-MKG-014
  final String appointmentId;
  final String patientId;
  final String patientCode;
  final String patientName;
  final String hubId;
  final String sessionId;
  final String currentStationId;
  final String currentStationName;
  final QueueStatus status;
  final String arrivalTime;
  final int waitDurationMinutes;
  final String? delayReason;
  final String? assignedWorker;

  const QueueTicket({
    required this.ticketId,
    required this.tokenNumber,
    required this.appointmentId,
    required this.patientId,
    required this.patientCode,
    required this.patientName,
    required this.hubId,
    required this.sessionId,
    required this.currentStationId,
    required this.currentStationName,
    required this.status,
    required this.arrivalTime,
    required this.waitDurationMinutes,
    this.delayReason,
    this.assignedWorker,
  });

  String get statusLabel {
    switch (status) {
      case QueueStatus.waiting:
        return 'Waiting';
      case QueueStatus.called:
        return 'Called';
      case QueueStatus.inService:
        return 'In service';
      case QueueStatus.awaitingReview:
        return 'Awaiting review';
      case QueueStatus.completed:
        return 'Completed';
      case QueueStatus.paused:
        return 'Paused';
      case QueueStatus.transferred:
        return 'Transferred';
    }
  }

  QueueTicket copyWith({
    QueueStatus? status,
    String? currentStationId,
    String? currentStationName,
    String? delayReason,
    String? assignedWorker,
    int? waitDurationMinutes,
  }) {
    return QueueTicket(
      ticketId: ticketId,
      tokenNumber: tokenNumber,
      appointmentId: appointmentId,
      patientId: patientId,
      patientCode: patientCode,
      patientName: patientName,
      hubId: hubId,
      sessionId: sessionId,
      currentStationId: currentStationId ?? this.currentStationId,
      currentStationName: currentStationName ?? this.currentStationName,
      status: status ?? this.status,
      arrivalTime: arrivalTime,
      waitDurationMinutes: waitDurationMinutes ?? this.waitDurationMinutes,
      delayReason: delayReason ?? this.delayReason,
      assignedWorker: assignedWorker ?? this.assignedWorker,
    );
  }
}

class ConsentRecord {
  final String consentId;
  final String patientId;
  final String patientName;
  final bool consentHubService;
  final bool consentDataProcessing;
  final bool consentTelehealthConsult;
  final String capturedBy;
  final String capturedAt;
  final String legalBasis; // 'PDPA 2026 Section 14'

  const ConsentRecord({
    required this.consentId,
    required this.patientId,
    required this.patientName,
    required this.consentHubService,
    required this.consentDataProcessing,
    required this.consentTelehealthConsult,
    required this.capturedBy,
    required this.capturedAt,
    required this.legalBasis,
  });
}

