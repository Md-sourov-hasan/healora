enum HubStatus {
  draft,
  active,
  paused,
  temporarilyClosed,
  permanentlyClosed,
}

enum SessionStatus {
  draft,
  published,
  openForBooking,
  inProgress,
  completed,
  cancelled,
}

enum StationStatus {
  available,
  busy,
  paused,
  outOfService,
}

enum EquipmentStatus {
  available,
  assigned,
  maintenance,
  calibrationDue,
  outOfService,
  retired,
}

class Hub {
  final String id;
  final String code;
  final String name;
  final HubStatus status;
  final String division;
  final String district;
  final String upazila;
  final String catchmentArea;
  final String address;
  final String contactNumber;
  final String operatingHours;
  final List<String> supportedServices;
  final List<String> languages;
  final String managerName;
  final String nearestReferralFacility;
  final String emergencyHotline;
  final int activeStationsCount;
  final int totalEquipmentCount;

  const Hub({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.division,
    required this.district,
    required this.upazila,
    required this.catchmentArea,
    required this.address,
    required this.contactNumber,
    required this.operatingHours,
    required this.supportedServices,
    required this.languages,
    required this.managerName,
    required this.nearestReferralFacility,
    required this.emergencyHotline,
    required this.activeStationsCount,
    required this.totalEquipmentCount,
  });

  String get statusLabel {
    switch (status) {
      case HubStatus.draft:
        return 'Draft';
      case HubStatus.active:
        return 'Active';
      case HubStatus.paused:
        return 'Paused';
      case HubStatus.temporarilyClosed:
        return 'Temp Closed';
      case HubStatus.permanentlyClosed:
        return 'Closed';
    }
  }

  Hub copyWith({
    HubStatus? status,
    String? operatingHours,
    String? managerName,
  }) {
    return Hub(
      id: id,
      code: code,
      name: name,
      status: status ?? this.status,
      division: division,
      district: district,
      upazila: upazila,
      catchmentArea: catchmentArea,
      address: address,
      contactNumber: contactNumber,
      operatingHours: operatingHours ?? this.operatingHours,
      supportedServices: supportedServices,
      languages: languages,
      managerName: managerName ?? this.managerName,
      nearestReferralFacility: nearestReferralFacility,
      emergencyHotline: emergencyHotline,
      activeStationsCount: activeStationsCount,
      totalEquipmentCount: totalEquipmentCount,
    );
  }
}

class HubSession {
  final String id;
  final String hubId;
  final String hubName;
  final String title;
  final String serviceType;
  final String date;
  final String startTime;
  final String endTime;
  final String sessionType; // 'Standard Clinic', 'Special Camp', 'Outreach'
  final SessionStatus status;
  final int slotCapacity;
  final int bookedCount;
  final int walkInCapacity;
  final int walkInCurrent;
  final List<String> requiredRoles;
  final List<String> requiredEquipment;
  final String assignedLead;
  final String? overrideReason;
  final String notes;

  const HubSession({
    required this.id,
    required this.hubId,
    required this.hubName,
    required this.title,
    required this.serviceType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.sessionType,
    required this.status,
    required this.slotCapacity,
    required this.bookedCount,
    required this.walkInCapacity,
    required this.walkInCurrent,
    required this.requiredRoles,
    required this.requiredEquipment,
    required this.assignedLead,
    this.overrideReason,
    required this.notes,
  });

  int get totalCapacity => slotCapacity + walkInCapacity;
  int get totalAttending => bookedCount + walkInCurrent;
  bool get isFull => totalAttending >= totalCapacity;

  String get statusLabel {
    switch (status) {
      case SessionStatus.draft:
        return 'Draft';
      case SessionStatus.published:
        return 'Published';
      case SessionStatus.openForBooking:
        return 'Open for booking';
      case SessionStatus.inProgress:
        return 'In progress';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  HubSession copyWith({
    SessionStatus? status,
    int? bookedCount,
    int? walkInCurrent,
    String? overrideReason,
  }) {
    return HubSession(
      id: id,
      hubId: hubId,
      hubName: hubName,
      title: title,
      serviceType: serviceType,
      date: date,
      startTime: startTime,
      endTime: endTime,
      sessionType: sessionType,
      status: status ?? this.status,
      slotCapacity: slotCapacity,
      bookedCount: bookedCount ?? this.bookedCount,
      walkInCapacity: walkInCapacity,
      walkInCurrent: walkInCurrent ?? this.walkInCurrent,
      requiredRoles: requiredRoles,
      requiredEquipment: requiredEquipment,
      assignedLead: assignedLead,
      overrideReason: overrideReason ?? this.overrideReason,
      notes: notes,
    );
  }
}

class HubStation {
  final String id;
  final String hubId;
  final String name;
  final String stationType;
  final StationStatus status;
  final String assignedStaff;
  final int activeQueueLength;

  const HubStation({
    required this.id,
    required this.hubId,
    required this.name,
    required this.stationType,
    required this.status,
    required this.assignedStaff,
    required this.activeQueueLength,
  });

  HubStation copyWith({
    StationStatus? status,
    String? assignedStaff,
    int? activeQueueLength,
  }) {
    return HubStation(
      id: id,
      hubId: hubId,
      name: name,
      stationType: stationType,
      status: status ?? this.status,
      assignedStaff: assignedStaff ?? this.assignedStaff,
      activeQueueLength: activeQueueLength ?? this.activeQueueLength,
    );
  }
}

class HubEquipment {
  final String id;
  final String hubId;
  final String stationId;
  final String category;
  final String name;
  final String model;
  final String serialNumber;
  final EquipmentStatus status;
  final String lastCalibration;
  final String nextCalibrationDue;
  final List<String> supportedMeasurements;
  final String notes;

  const HubEquipment({
    required this.id,
    required this.hubId,
    required this.stationId,
    required this.category,
    required this.name,
    required this.model,
    required this.serialNumber,
    required this.status,
    required this.lastCalibration,
    required this.nextCalibrationDue,
    required this.supportedMeasurements,
    required this.notes,
  });

  String get statusLabel {
    switch (status) {
      case EquipmentStatus.available:
        return 'Available';
      case EquipmentStatus.assigned:
        return 'Assigned';
      case EquipmentStatus.maintenance:
        return 'Maintenance';
      case EquipmentStatus.calibrationDue:
        return 'Calibration due';
      case EquipmentStatus.outOfService:
        return 'Out of service';
      case EquipmentStatus.retired:
        return 'Retired';
    }
  }

  HubEquipment copyWith({
    EquipmentStatus? status,
    String? notes,
  }) {
    return HubEquipment(
      id: id,
      hubId: hubId,
      stationId: stationId,
      category: category,
      name: name,
      model: model,
      serialNumber: serialNumber,
      status: status ?? this.status,
      lastCalibration: lastCalibration,
      nextCalibrationDue: nextCalibrationDue,
      supportedMeasurements: supportedMeasurements,
      notes: notes ?? this.notes,
    );
  }
}

