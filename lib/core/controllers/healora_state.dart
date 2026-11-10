import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:healora/core/models/audit_models.dart';

enum HealoraRole {
  platformAdmin,
  regionalManager,
  hubManager,
  receptionist,
  queueCoordinator,
  equipmentOfficer,
  readOnlyAuditor,
  specialTeamLead,
  fieldHealthWorker,
  localDoctor,
  registeredMedicalDoctor,
  patient,
  caregiver,
}

extension HealoraRoleScope on HealoraRole {
  bool get isTeamClinicalRole => const {
    HealoraRole.specialTeamLead,
    HealoraRole.fieldHealthWorker,
    HealoraRole.localDoctor,
    HealoraRole.registeredMedicalDoctor,
  }.contains(this);
}

extension HealoraRoleExtension on HealoraRole {
  String get displayName {
    switch (this) {
      case HealoraRole.platformAdmin:
        return 'Platform Super Admin';
      case HealoraRole.regionalManager:
        return 'Regional Operations Manager';
      case HealoraRole.hubManager:
        return 'Hub Manager';
      case HealoraRole.receptionist:
        return 'Reception / Registration Officer';
      case HealoraRole.queueCoordinator:
        return 'Queue Coordinator';
      case HealoraRole.equipmentOfficer:
        return 'Equipment / Facilities Officer';
      case HealoraRole.readOnlyAuditor:
        return 'Read-only Operations Auditor';
      case HealoraRole.specialTeamLead:
        return 'Special Team Lead';
      case HealoraRole.fieldHealthWorker:
        return 'Field Health Worker';
      case HealoraRole.localDoctor:
        return 'Local / Assistant Doctor';
      case HealoraRole.registeredMedicalDoctor:
        return 'Registered Medical Doctor';
      case HealoraRole.patient:
        return 'Patient';
      case HealoraRole.caregiver:
        return 'Authorised Caregiver';
    }
  }

  String get bnDisplayName {
    switch (this) {
      case HealoraRole.platformAdmin:
        return 'প্ল্যাটফর্ম সুপার অ্যাডমিন';
      case HealoraRole.regionalManager:
        return 'আঞ্চলিক অপারেশন ম্যানেজার';
      case HealoraRole.hubManager:
        return 'হাব ম্যানেজার';
      case HealoraRole.receptionist:
        return 'রিসেপশন / নিবন্ধন কর্মকর্তা';
      case HealoraRole.queueCoordinator:
        return 'কিউ সমন্বয়কারী';
      case HealoraRole.equipmentOfficer:
        return 'সরঞ্জাম / সুবিধা কর্মকর্তা';
      case HealoraRole.readOnlyAuditor:
        return 'শুধু পাঠযোগ্য অপারেশন অডিটর';
      case HealoraRole.specialTeamLead:
        return 'বিশেষ দলের প্রধান';
      case HealoraRole.fieldHealthWorker:
        return 'মাঠ স্বাস্থ্যকর্মী';
      case HealoraRole.localDoctor:
        return 'স্থানীয় / সহকারী ডাক্তার';
      case HealoraRole.registeredMedicalDoctor:
        return 'নিবন্ধিত চিকিৎসক';
      case HealoraRole.patient:
        return 'রোগী';
      case HealoraRole.caregiver:
        return 'অনুমোদিত পরিচর্যাকারী';
    }
  }

  List<int> get allowedNavIndexes {
    switch (this) {
      case HealoraRole.platformAdmin:
        return [0, 1, 2, 3, 4, 6, 7, 8, 9];
      case HealoraRole.regionalManager:
        return [0, 1, 2, 3, 6, 7, 8, 9];
      case HealoraRole.hubManager:
        return [0, 1, 2, 3, 4, 6, 7, 9];
      case HealoraRole.receptionist:
        return [0, 3, 4, 9];
      case HealoraRole.queueCoordinator:
        return [0, 3, 9];
      case HealoraRole.equipmentOfficer:
        return [0, 6, 9];
      case HealoraRole.readOnlyAuditor:
        return [0, 7, 8, 9];
      case HealoraRole.specialTeamLead:
      case HealoraRole.fieldHealthWorker:
      case HealoraRole.localDoctor:
      case HealoraRole.registeredMedicalDoctor:
        return [5, 9];
      case HealoraRole.patient:
      case HealoraRole.caregiver:
        return [];
    }
  }
}

class HealoraState extends GetxController {
  // Current settings
  HealoraRole _activeRole = HealoraRole.fieldHealthWorker;
  final RxBool _isBangla = false.obs;
  bool _isOffline = false;
  String _selectedHubId = 'hub_mkg_01';
  int _currentNavIndex = 5;

  HealoraRole get activeRole => _activeRole;
  bool get isBangla => _isBangla.value;
  RxBool get rxIsBangla => _isBangla;
  bool get isOffline => _isOffline;
  String get selectedHubId => _selectedHubId;
  int get currentNavIndex => _currentNavIndex;

  // Language helper
  String t(String en, String bn) => _isBangla.value ? bn : en;

  void setRole(HealoraRole role) {
    if (!role.isTeamClinicalRole) return;
    _activeRole = role;
    if (!accessibleHubIds.contains(_selectedHubId) &&
        accessibleHubIds.isNotEmpty) {
      _selectedHubId = accessibleHubIds.first;
    }
    if (!role.allowedNavIndexes.contains(_currentNavIndex)) {
      _currentNavIndex = role.allowedNavIndexes.first;
    }
    update();
  }

  void setLanguage(bool isBangla) {
    _isBangla.value = isBangla;
    update();
  }

  void toggleLanguage() {
    _isBangla.value = !_isBangla.value;
    update();
  }

  void toggleOfflineMode() {
    _isOffline = !_isOffline;
    if (!_isOffline && _offlineOutbox.isNotEmpty) {
      syncOutbox();
    }
    _addAudit(
      action: _isOffline
          ? 'NETWORK_OFFLINE_SIMULATED'
          : 'NETWORK_ONLINE_RESTORED',
      entityType: 'SystemNetwork',
      entityId: 'net_01',
      details: _isOffline
          ? 'Rural network outage simulated'
          : 'Network recovered; auto-sync triggered',
      compliance: 'DGHS Telehealth Art 8',
    );
    update();
  }

  void setSelectedHub(String hubId) {
    if (!accessibleHubIds.contains(hubId)) return;
    _selectedHubId = hubId;
    update();
  }

  void setNavIndex(int index) {
    if (!_activeRole.allowedNavIndexes.contains(index)) return;
    _currentNavIndex = index;
    update();
  }

  // Collections
  List<Hub> _hubs = [];
  List<HubSession> _sessions = [];
  List<HubStation> _stations = [];
  List<HubEquipment> _equipment = [];
  List<Appointment> _appointments = [];
  List<QueueTicket> _queue = [];
  List<Encounter> _encounters = [];
  final List<Observation> _offlineOutbox = [];
  List<AuditLogEntry> _auditLogs = [];
  List<ConsentRecord> _consentRecords = [];
  List<NotificationItem> _notifications = [];

  final PatientProfile _currentPatient = const PatientProfile(
    id: 'pat_89211',
    canonicalCode: 'PAT-BD-89211',
    fullName: 'Rahima Begum',
    phone: '+880 1712-345678',
    age: 48,
    gender: 'Female',
    upazila: 'Manikganj Sadar',
    district: 'Manikganj',
    bloodGroup: 'B+',
    emergencyContact: '+880 1819-876543 (Rafiqul Islam, Son)',
    hasActiveConsent: true,
    consentDate: '2026-11-01',
  );

  PatientProfile get currentPatient => _currentPatient;
  List<ConsentRecord> get consentRecords => _consentRecords;
  List<NotificationItem> get notifications => _notifications;

  void addNotification({
    required String category,
    required String title,
    required String body,
    String? appointmentId,
  }) {
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        category: category,
        title: title,
        body: body,
        timestamp: 'Just now',
        isRead: false,
        appointmentId: appointmentId,
      ),
    );
    update();
  }

  void markAllNotificationsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    update();
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      update();
    }
  }

  List<String> get accessibleHubIds {
    if (_activeRole == HealoraRole.platformAdmin ||
        _activeRole == HealoraRole.patient ||
        _activeRole == HealoraRole.caregiver) {
      return _hubs.map((hub) => hub.id).toList();
    }
    if (_activeRole == HealoraRole.regionalManager) {
      return _hubs
          .where((hub) => hub.division == 'Dhaka')
          .map((hub) => hub.id)
          .toList();
    }
    return ['hub_mkg_01'];
  }

  List<Hub> get hubs =>
      _hubs.where((hub) => accessibleHubIds.contains(hub.id)).toList();
  List<HubSession> get sessions => _sessions
      .where((session) => accessibleHubIds.contains(session.hubId))
      .toList();
  List<HubStation> get stations => _stations
      .where((station) => accessibleHubIds.contains(station.hubId))
      .toList();
  List<HubEquipment> get equipment => _equipment
      .where((item) => accessibleHubIds.contains(item.hubId))
      .toList();
  List<Appointment> get appointments => _appointments
      .where((appointment) => accessibleHubIds.contains(appointment.hubId))
      .toList();
  List<QueueTicket> get queue => _queue
      .where((ticket) => accessibleHubIds.contains(ticket.hubId))
      .toList();
  List<Encounter> get encounters => _encounters
      .where((encounter) => accessibleHubIds.contains(encounter.hubId))
      .toList();
  List<Observation> get offlineOutbox => _offlineOutbox;
  List<AuditLogEntry> get auditLogs => _auditLogs
      .where((entry) => accessibleHubIds.contains(entry.hubId))
      .toList();

  Hub get currentHub => _hubs.firstWhere(
    (h) => h.id == _selectedHubId,
    orElse: () => _hubs.first,
  );

  HealoraState() {
    _initSeedData();
  }

  void _initSeedData() {
    _hubs = [
      const Hub(
        id: 'hub_mkg_01',
        code: 'HUB-MKG-01',
        name: 'Manikganj Rural Care Hub',
        status: HubStatus.active,
        division: 'Dhaka',
        district: 'Manikganj',
        upazila: 'Singair',
        catchmentArea: 'Singair Sadar, Joymontop & Baira Unions',
        address: 'Holding 42, Singair Bus Stand Road, Manikganj',
        contactNumber: '+880 1711 029384',
        operatingHours: 'Saturday – Thursday, 08:30 AM – 04:30 PM',
        supportedServices: [
          'Basic Vitals & Anthropometry',
          'Blood Glucose & POC Diagnostics',
          'Local Doctor Review',
          'Specialist Teleconsultation Handoff',
        ],
        languages: ['Bangla', 'English'],
        managerName: 'Kazi M. Rahman',
        nearestReferralFacility: 'Manikganj Sadar 250-Bed Hospital',
        emergencyHotline: '16263 / +880 1713 000999',
        activeStationsCount: 4,
        totalEquipmentCount: 8,
      ),
      const Hub(
        id: 'hub_nlp_02',
        code: 'HUB-NLP-02',
        name: 'Nilphamari North Hub & Camp',
        status: HubStatus.active,
        division: 'Rangpur',
        district: 'Nilphamari',
        upazila: 'Saidpur',
        catchmentArea: 'Saidpur Municipality & Botlagari Union',
        address: 'College Road, Near Upazila Health Complex, Saidpur',
        contactNumber: '+880 1722 839102',
        operatingHours: 'Sunday – Thursday, 09:00 AM – 05:00 PM',
        supportedServices: [
          'Basic Vitals & Anthropometry',
          'Blood Glucose & POC Diagnostics',
          'Mobile Health Camp Sessions',
        ],
        languages: ['Bangla', 'English'],
        managerName: 'Farhana Akhter',
        nearestReferralFacility: 'Saidpur 100-Bed Hospital',
        emergencyHotline: '16263',
        activeStationsCount: 3,
        totalEquipmentCount: 6,
      ),
      const Hub(
        id: 'hub_cxb_03',
        code: 'HUB-CXB-03',
        name: 'Cox\'s Bazar Coastal Care Hub',
        status: HubStatus.active,
        division: 'Chattogram',
        district: 'Cox\'s Bazar',
        upazila: 'Ramu',
        catchmentArea: 'Ramu Sadar, Fatekharkul & Joarianala',
        address: 'Bypass Road, Ramu Chowmuhani',
        contactNumber: '+880 1819 443210',
        operatingHours: 'Saturday – Thursday, 08:00 AM – 04:00 PM',
        supportedServices: [
          'Basic Vitals & Anthropometry',
          'Maternal & Child Health Check',
          'Specialist Teleconsultation Handoff',
        ],
        languages: ['Bangla', 'Rohingya Dialect', 'English'],
        managerName: 'Mohammad Shahidullah',
        nearestReferralFacility: 'Cox\'s Bazar Sadar District Hospital',
        emergencyHotline: '16263 / +880 1819 000112',
        activeStationsCount: 3,
        totalEquipmentCount: 7,
      ),
      const Hub(
        id: 'hub_syl_04',
        code: 'HUB-SYL-04',
        name: 'Sylhet Sreemangal Tea Estate Hub',
        status: HubStatus.active,
        division: 'Sylhet',
        district: 'Moulvibazar',
        upazila: 'Sreemangal',
        catchmentArea: 'Sreemangal Tea Gardens & Kalighat',
        address: 'Station Road, Kalighat Union',
        contactNumber: '+880 1733 908172',
        operatingHours: 'Saturday – Wednesday, 09:00 AM – 03:30 PM',
        supportedServices: [
          'Basic Vitals & Anthropometry',
          'Hypertension & Diabetes Screening',
          'Local Doctor Review',
        ],
        languages: ['Bangla', 'English'],
        managerName: 'Anil Barua',
        nearestReferralFacility: 'Moulvibazar 250-Bed District Hospital',
        emergencyHotline: '16263',
        activeStationsCount: 2,
        totalEquipmentCount: 5,
      ),
    ];

    _sessions = [
      const HubSession(
        id: 'ses_20261104_01',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        title: 'Morning Chronic Care & Vitals Clinic',
        serviceType: 'Basic Vitals & Diabetes Review',
        date: '2026-11-04',
        startTime: '09:00 AM',
        endTime: '01:00 PM',
        sessionType: 'Standard Clinic',
        status: SessionStatus.inProgress,
        slotCapacity: 25,
        bookedCount: 19,
        walkInCapacity: 10,
        walkInCurrent: 4,
        requiredRoles: [
          'Field Health Worker',
          'Special Team Lead',
          'Local Doctor',
        ],
        requiredEquipment: [
          'Digital BP Monitor',
          'Glucometer',
          'Pulse Oximeter',
          'Scale',
        ],
        assignedLead: 'Nasrin Sultana (Team Lead)',
        notes: 'Priority focus on diabetic & hypertensive follow-up patients from Singair.',
      ),
      const HubSession(
        id: 'ses_20261104_02',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        title: 'Afternoon Doctor Review & Overseas Consultation',
        serviceType: 'Specialist Teleconsultation Review',
        date: '2026-11-04',
        startTime: '02:00 PM',
        endTime: '05:00 PM',
        sessionType: 'Standard Clinic',
        status: SessionStatus.published,
        slotCapacity: 15,
        bookedCount: 8,
        walkInCapacity: 5,
        walkInCurrent: 0,
        requiredRoles: ['Local Doctor', 'Assistant Doctor'],
        requiredEquipment: [
          'BP Monitor',
          'Digital Stethoscope',
          'Video Terminal',
        ],
        assignedLead: 'Dr. Tariqul Islam (BMDC A-54910)',
        notes: 'Pre-teleconsultation vitals validation for Chennai cardiology referrals.',
      ),
      const HubSession(
        id: 'ses_20261105_01',
        hubId: 'hub_nlp_02',
        hubName: 'Nilphamari North Hub & Camp',
        title: 'Saidpur Community Health Camp Day 1',
        serviceType: 'Health Camp Screening',
        date: '2026-11-05',
        startTime: '08:30 AM',
        endTime: '04:00 PM',
        sessionType: 'Special Camp',
        status: SessionStatus.openForBooking,
        slotCapacity: 50,
        bookedCount: 38,
        walkInCapacity: 25,
        walkInCurrent: 0,
        requiredRoles: [
          'Special Team Lead',
          'Field Health Worker (x2)',
          'Local Doctor',
        ],
        requiredEquipment: [
          'Mobile Vitals Kit',
          'Glucometer (x2)',
          'Digital BP (x2)',
        ],
        assignedLead: 'Farhana Akhter',
        notes: 'Organized outreach at Botlagari High School ground.',
      ),
    ];

    _stations = [
      const HubStation(
        id: 'st_01',
        hubId: 'hub_mkg_01',
        name: 'Station 1: Reception & Check-in',
        stationType: 'Registration',
        status: StationStatus.available,
        assignedStaff: 'Sharmin Begum (Receptionist)',
        activeQueueLength: 2,
      ),
      const HubStation(
        id: 'st_02',
        hubId: 'hub_mkg_01',
        name: 'Station 2: Vitals & Anthropometry',
        stationType: 'Vitals Capture',
        status: StationStatus.busy,
        assignedStaff: 'Nasrin Sultana (Health Worker)',
        activeQueueLength: 3,
      ),
      const HubStation(
        id: 'st_03',
        hubId: 'hub_mkg_01',
        name: 'Station 3: Blood Glucose & POC Diagnostics',
        stationType: 'POC Diagnostics',
        status: StationStatus.busy,
        assignedStaff: 'Kamrul Hasan (Health Assistant)',
        activeQueueLength: 2,
      ),
      const HubStation(
        id: 'st_04',
        hubId: 'hub_mkg_01',
        name: 'Station 4: Local Doctor Consultation & Review',
        stationType: 'Doctor Review',
        status: StationStatus.available,
        assignedStaff: 'Dr. Tariqul Islam (BMDC A-54910)',
        activeQueueLength: 1,
      ),
    ];

    _equipment = [
      const HubEquipment(
        id: 'eq_01',
        hubId: 'hub_mkg_01',
        stationId: 'st_02',
        category: 'Blood Pressure',
        name: 'Omron Digital BP Monitor',
        model: 'HEM-7120',
        serialNumber: 'SN-OMR-98214',
        status: EquipmentStatus.available,
        lastCalibration: '2026-10-15',
        nextCalibrationDue: '2027-01-15',
        supportedMeasurements: ['Systolic BP', 'Diastolic BP', 'Pulse Rate'],
        notes: 'Calibrated with certified mercury sphygmomanometer standard.',
      ),
      const HubEquipment(
        id: 'eq_02',
        hubId: 'hub_mkg_01',
        stationId: 'st_03',
        category: 'Glucometer',
        name: 'Accu-Chek Instant Blood Glucose Meter',
        model: 'Instant 921',
        serialNumber: 'SN-ROCHE-44102',
        status: EquipmentStatus.available,
        lastCalibration: '2026-10-20',
        nextCalibrationDue: '2026-12-20',
        supportedMeasurements: [
          'Fasting Glucose',
          'Postprandial Glucose',
          'Random Glucose',
        ],
        notes: 'Using Lot #2026B strips; control solution test passed.',
      ),
      const HubEquipment(
        id: 'eq_03',
        hubId: 'hub_mkg_01',
        stationId: 'st_02',
        category: 'Pulse Oximeter',
        name: 'Nonin Onyx Vantage Fingertip Oximeter',
        model: '9590',
        serialNumber: 'SN-NONIN-11029',
        status: EquipmentStatus.available,
        lastCalibration: '2026-09-01',
        nextCalibrationDue: '2026-12-01',
        supportedMeasurements: ['SpO2 Oxygen Saturation', 'Pulse Rate'],
        notes: 'New AAA lithium batteries installed 1 Nov 2026.',
      ),
      const HubEquipment(
        id: 'eq_04',
        hubId: 'hub_mkg_01',
        stationId: 'st_02',
        category: 'Anthropometry',
        name: 'Seca 874 Electronic Flat Scale & Stadiometer',
        model: 'Seca 874',
        serialNumber: 'SN-SECA-88390',
        status: EquipmentStatus.available,
        lastCalibration: '2026-08-10',
        nextCalibrationDue: '2027-02-10',
        supportedMeasurements: ['Body Weight (kg)', 'Height (cm)'],
        notes: 'Levelled on firm concrete surface in Station 2.',
      ),
      const HubEquipment(
        id: 'eq_05',
        hubId: 'hub_mkg_01',
        stationId: 'st_02',
        category: 'Thermometer',
        name: 'Braun ThermoScan Ear Thermometer',
        model: 'PRO 6000',
        serialNumber: 'SN-BRN-33219',
        status: EquipmentStatus.calibrationDue,
        lastCalibration: '2026-07-04',
        nextCalibrationDue: '2026-11-04',
        supportedMeasurements: ['Body Temperature (°C / °F)'],
        notes: 'Annual calibration check due today; backup forehead probe available.',
      ),
      const HubEquipment(
        id: 'eq_06',
        hubId: 'hub_mkg_01',
        stationId: 'st_03',
        category: 'Centrifuge / POC',
        name: 'Eppendorf MiniSpin Clinical Centrifuge',
        model: 'MiniSpin Plus',
        serialNumber: 'SN-EPP-77201',
        status: EquipmentStatus.outOfService,
        lastCalibration: '2026-06-12',
        nextCalibrationDue: '2026-12-12',
        supportedMeasurements: ['Microhematocrit'],
        notes: 'Rotor lock warning. Scheduled technician visit 6 Nov.',
      ),
    ];

    _appointments = [
      const Appointment(
        id: 'apt_01',
        appointmentCode: 'APT-2026-0812',
        patientId: 'pat_bd_01',
        patientName: 'Rahima Begum',
        patientPhone: '+880 1711 234567',
        patientAge: 52,
        patientGender: 'Female',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        sessionId: 'ses_20261104_01',
        sessionTitle: 'Morning Chronic Care & Vitals Clinic',
        date: '2026-11-04',
        slotTime: '09:15 AM',
        bookingSource: 'patient_app',
        status: AppointmentStatus.inService,
      ),
      const Appointment(
        id: 'apt_02',
        appointmentCode: 'APT-2026-0813',
        patientId: 'pat_bd_02',
        patientName: 'Mohammad Rafiqul Islam',
        patientPhone: '+880 1819 987654',
        patientAge: 58,
        patientGender: 'Male',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        sessionId: 'ses_20261104_01',
        sessionTitle: 'Morning Chronic Care & Vitals Clinic',
        date: '2026-11-04',
        slotTime: '09:30 AM',
        bookingSource: 'walk_in',
        status: AppointmentStatus.checkedIn,
      ),
      const Appointment(
        id: 'apt_03',
        appointmentCode: 'APT-2026-0814',
        patientId: 'pat_bd_03',
        patientName: 'Anowara Khatun',
        patientPhone: '+880 1912 345678',
        patientAge: 46,
        patientGender: 'Female',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        sessionId: 'ses_20261104_01',
        sessionTitle: 'Morning Chronic Care & Vitals Clinic',
        date: '2026-11-04',
        slotTime: '09:45 AM',
        bookingSource: 'referral',
        status: AppointmentStatus.checkedIn,
      ),
      const Appointment(
        id: 'apt_04',
        appointmentCode: 'APT-2026-0815',
        patientId: 'pat_bd_04',
        patientName: 'Abdul Mannan Sikder',
        patientPhone: '+880 1714 556677',
        patientAge: 64,
        patientGender: 'Male',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        sessionId: 'ses_20261104_01',
        sessionTitle: 'Morning Chronic Care & Vitals Clinic',
        date: '2026-11-04',
        slotTime: '10:00 AM',
        bookingSource: 'patient_app',
        status: AppointmentStatus.confirmed,
      ),
      const Appointment(
        id: 'apt_05',
        appointmentCode: 'APT-2026-0816',
        patientId: 'pat_bd_05',
        patientName: 'Farida Yasmin',
        patientPhone: '+880 1622 998877',
        patientAge: 39,
        patientGender: 'Female',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        sessionId: 'ses_20261104_01',
        sessionTitle: 'Morning Chronic Care & Vitals Clinic',
        date: '2026-11-04',
        slotTime: '10:15 AM',
        bookingSource: 'campaign',
        status: AppointmentStatus.confirmed,
      ),
    ];

    _queue = [
      const QueueTicket(
        ticketId: 'tkt_01',
        tokenNumber: 'HUB-MKG-014',
        appointmentId: 'apt_01',
        patientId: 'pat_bd_01',
        patientCode: 'PAT-BD-89211',
        patientName: 'Rahima Begum',
        hubId: 'hub_mkg_01',
        sessionId: 'ses_20261104_01',
        currentStationId: 'st_02',
        currentStationName: 'Station 2: Vitals & Anthropometry',
        status: QueueStatus.inService,
        arrivalTime: '09:08 AM',
        waitDurationMinutes: 12,
        assignedWorker: 'Nasrin Sultana',
      ),
      const QueueTicket(
        ticketId: 'tkt_02',
        tokenNumber: 'HUB-MKG-015',
        appointmentId: 'apt_02',
        patientId: 'pat_bd_02',
        patientCode: 'PAT-BD-89212',
        patientName: 'Mohammad Rafiqul Islam',
        hubId: 'hub_mkg_01',
        sessionId: 'ses_20261104_01',
        currentStationId: 'st_02',
        currentStationName: 'Station 2: Vitals & Anthropometry',
        status: QueueStatus.waiting,
        arrivalTime: '09:22 AM',
        waitDurationMinutes: 16,
        assignedWorker: 'Nasrin Sultana',
      ),
      const QueueTicket(
        ticketId: 'tkt_03',
        tokenNumber: 'HUB-MKG-016',
        appointmentId: 'apt_03',
        patientId: 'pat_bd_03',
        patientCode: 'PAT-BD-89213',
        patientName: 'Anowara Khatun',
        hubId: 'hub_mkg_01',
        sessionId: 'ses_20261104_01',
        currentStationId: 'st_03',
        currentStationName: 'Station 3: Blood Glucose & POC',
        status: QueueStatus.waiting,
        arrivalTime: '09:35 AM',
        waitDurationMinutes: 8,
        assignedWorker: 'Kamrul Hasan',
      ),
    ];

    _encounters = [
      Encounter(
        id: 'enc_01',
        appointmentId: 'apt_01',
        ticketId: 'tkt_01',
        patientId: 'pat_bd_01',
        patientCode: 'PAT-BD-89211',
        patientName: 'Rahima Begum',
        patientAge: 52,
        patientGender: 'Female',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Rural Care Hub',
        sessionId: 'ses_20261104_01',
        openedAt: '2026-11-04 09:12 AM',
        assignedWorker: 'Nasrin Sultana',
        assignedDoctor: 'Dr. Tariqul Islam (BMDC A-54910)',
        status: EncounterStatus.inProgress,
        disposition: EncounterDisposition.inProgress,
        overallSyncState: SyncState.synced,
        observations: [
          const Observation(
            id: 'obs_01',
            encounterId: 'enc_01',
            patientId: 'pat_bd_01',
            code: 'bp_sys',
            label: 'Systolic Blood Pressure',
            value: '138',
            unit: 'mmHg',
            contextNote: 'Right arm, seated after 5 min rest',
            deviceAttribution: 'Omron HEM-7120 #SN-OMR-98214',
            performerName: 'Nasrin Sultana',
            measuredAt: '09:15 AM',
            isRepeat: false,
            isFlaggedAbnormal: false,
            syncState: SyncState.synced,
            idempotencyKey: 'idemp_obs_01_981',
          ),
          const Observation(
            id: 'obs_02',
            encounterId: 'enc_01',
            patientId: 'pat_bd_01',
            code: 'bp_dia',
            label: 'Diastolic Blood Pressure',
            value: '88',
            unit: 'mmHg',
            contextNote: 'Right arm, seated',
            deviceAttribution: 'Omron HEM-7120 #SN-OMR-98214',
            performerName: 'Nasrin Sultana',
            measuredAt: '09:15 AM',
            isRepeat: false,
            isFlaggedAbnormal: false,
            syncState: SyncState.synced,
            idempotencyKey: 'idemp_obs_02_982',
          ),
          const Observation(
            id: 'obs_03',
            encounterId: 'enc_01',
            patientId: 'pat_bd_01',
            code: 'pulse',
            label: 'Pulse Rate',
            value: '76',
            unit: 'bpm',
            contextNote: 'Regular rhythm',
            deviceAttribution: 'Omron HEM-7120 #SN-OMR-98214',
            performerName: 'Nasrin Sultana',
            measuredAt: '09:15 AM',
            isRepeat: false,
            isFlaggedAbnormal: false,
            syncState: SyncState.synced,
            idempotencyKey: 'idemp_obs_03_983',
          ),
          const Observation(
            id: 'obs_04',
            encounterId: 'enc_01',
            patientId: 'pat_bd_01',
            code: 'spo2',
            label: 'Oxygen Saturation',
            value: '98',
            unit: '%',
            contextNote: 'Room air, warm index finger',
            deviceAttribution: 'Nonin Onyx #SN-NONIN-11029',
            performerName: 'Nasrin Sultana',
            measuredAt: '09:17 AM',
            isRepeat: false,
            isFlaggedAbnormal: false,
            syncState: SyncState.synced,
            idempotencyKey: 'idemp_obs_04_984',
          ),
          const Observation(
            id: 'obs_05',
            encounterId: 'enc_01',
            patientId: 'pat_bd_01',
            code: 'glucose_fasting',
            label: 'Fasting Blood Glucose',
            value: '7.4',
            unit: 'mmol/L',
            contextNote: 'Fasting > 10 hours confirmed',
            deviceAttribution: 'Accu-Chek Instant #SN-ROCHE-44102',
            performerName: 'Kamrul Hasan',
            measuredAt: '09:20 AM',
            isRepeat: false,
            isFlaggedAbnormal: true, // Slightly elevated fasting
            syncState: SyncState.synced,
            idempotencyKey: 'idemp_obs_05_985',
          ),
          const Observation(
            id: 'obs_06',
            encounterId: 'enc_01',
            patientId: 'pat_bd_01',
            code: 'weight',
            label: 'Body Weight',
            value: '64.5',
            unit: 'kg',
            contextNote: 'Light clothing, shoes removed',
            deviceAttribution: 'Seca 874 #SN-SECA-88390',
            performerName: 'Nasrin Sultana',
            measuredAt: '09:22 AM',
            isRepeat: false,
            isFlaggedAbnormal: false,
            syncState: SyncState.synced,
            idempotencyKey: 'idemp_obs_06_986',
          ),
        ],
      ),
    ];

    _auditLogs = [
      AuditLogEntry(
        id: 'aud_01',
        timestamp: '2026-11-04 09:22:15',
        actorName: 'Nasrin Sultana',
        actorRole: 'Field Health Worker',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Hub',
        action: 'OBSERVATION_SUBMITTED',
        entityType: 'Observation',
        entityId: 'enc_01',
        details: 'Submitted 6 structured observations for encounter enc_01 with device attribution.',
        complianceStandard: 'PDPA 2026 Sec 22',
      ),
      AuditLogEntry(
        id: 'aud_02',
        timestamp: '2026-11-04 09:12:00',
        actorName: 'Sharmin Begum',
        actorRole: 'Receptionist',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Hub',
        action: 'PATIENT_CHECKED_IN',
        entityType: 'QueueTicket',
        entityId: 'tkt_01',
        details: 'Verified identity and visit consent; generated queue token HUB-MKG-014.',
        complianceStandard: 'DGHS Telehealth Art 4',
      ),
      AuditLogEntry(
        id: 'aud_03',
        timestamp: '2026-11-04 08:30:10',
        actorName: 'Kazi M. Rahman',
        actorRole: 'Hub Manager',
        hubId: 'hub_mkg_01',
        hubName: 'Manikganj Hub',
        action: 'SESSION_STARTED',
        entityType: 'HubSession',
        entityId: 'ses_20261104_01',
        details: 'Validated minimum staffing (3/3 roles) and mandatory equipment (4/4 items).',
        complianceStandard: 'Clinical Safety Protocol v2',
      ),
    ];

    _consentRecords = [
      const ConsentRecord(
        consentId: 'cns_89211_01',
        patientId: 'pat_89211',
        patientName: 'Rahima Begum',
        consentHubService: true,
        consentDataProcessing: true,
        consentTelehealthConsult: true,
        capturedBy: 'Nasrin Sultana (Field Health Worker)',
        capturedAt: '2026-11-01 09:30 BST',
        legalBasis: 'PDPA 2026 Section 14',
      ),
    ];

    _notifications = [
      const NotificationItem(
        id: 'notif_01',
        category: 'Appointment',
        title: 'Upcoming Visit Reminder',
        body: 'Your visit at Manikganj Rural Care Hub is scheduled for Thu 12 Nov at 10:30 AM.',
        timestamp: '10 mins ago',
        isRead: false,
        appointmentId: 'apt_01',
      ),
      const NotificationItem(
        id: 'notif_02',
        category: 'Queue',
        title: 'Queue Token Issued',
        body: 'Token HUB-MKG-014 has been issued for Vitals Station 1.',
        timestamp: '1 hour ago',
        isRead: false,
        appointmentId: 'apt_01',
      ),
      const NotificationItem(
        id: 'notif_03',
        category: 'Clinical',
        title: 'Clinical Results Verified',
        body: 'Dr. Tariqul Islam has signed and verified your health checkup results.',
        timestamp: '2 hours ago',
        isRead: true,
      ),
      const NotificationItem(
        id: 'notif_04',
        category: 'Consent',
        title: 'Consent Stored under PDPA 2026',
        body: 'Your voluntary health measurement consent has been recorded securely.',
        timestamp: '1 day ago',
        isRead: true,
      ),
    ];
  }

  void _addAudit({
    required String action,
    required String entityType,
    required String entityId,
    required String details,
    required String compliance,
  }) {
    final BuildContext? ctx = navigatorKey.currentContext;
    final String timeStr = ctx != null
        ? TimeOfDay.now().format(ctx)
        : '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';

    _auditLogs.insert(
      0,
      AuditLogEntry(
        id: 'aud_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: '2026-11-04 $timeStr',
        actorName: activeRole.displayName,
        actorRole: activeRole.displayName,
        hubId: currentHub.id,
        hubName: currentHub.name,
        action: action,
        entityType: entityType,
        entityId: entityId,
        details: details,
        complianceStandard: compliance,
      ),
    );
  }

  // Check in an existing appointment
  bool checkInAppointment(
    String appointmentId, {
    required bool consentConfirmed,
  }) {
    if (!_canManageCheckIn || !consentConfirmed) return false;
    final int apptIdx = _appointments.indexWhere((a) => a.id == appointmentId);
    if (apptIdx == -1) return false;

    final Appointment appt = _appointments[apptIdx];
    if (!accessibleHubIds.contains(appt.hubId)) return false;
    if (appt.status != AppointmentStatus.confirmed &&
        appt.status != AppointmentStatus.arrived) {
      return false;
    }
    if (_queue.any((ticket) => ticket.appointmentId == appt.id)) return false;
    final int sessionIndex = _sessions.indexWhere(
      (item) => item.id == appt.sessionId,
    );
    if (sessionIndex == -1 ||
        !accessibleHubIds.contains(_sessions[sessionIndex].hubId)) {
      return false;
    }
    _addAudit(
      action: 'HUB_SERVICE_CONSENT_CONFIRMED',
      entityType: 'Appointment',
      entityId: appt.id,
      details: 'Patient or authorised representative confirmed in-person hub measurement consent.',
      compliance: 'Patient consent workflow',
    );
    _appointments[apptIdx] = appt.copyWith(status: AppointmentStatus.checkedIn);

    final String token =
        'HUB-MKG-${(14 + _queue.length).toString().padLeft(3, '0')}';
    final QueueTicket ticket = QueueTicket(
      ticketId: 'tkt_${DateTime.now().millisecondsSinceEpoch}',
      tokenNumber: token,
      appointmentId: appt.id,
      patientId: appt.patientId,
      patientCode: 'PAT-BD-${89210 + _queue.length}',
      patientName: appt.patientName,
      hubId: appt.hubId,
      sessionId: appt.sessionId,
      currentStationId: 'st_01',
      currentStationName: 'Station 1: Reception & Check-in',
      status: QueueStatus.waiting,
      arrivalTime: '09:40 AM',
      waitDurationMinutes: 0,
      assignedWorker: '',
    );
    _queue.add(ticket);

    // Create encounter
    final Encounter encounter = Encounter(
      id: 'enc_${DateTime.now().millisecondsSinceEpoch}',
      appointmentId: appt.id,
      ticketId: ticket.ticketId,
      patientId: appt.patientId,
      patientCode: ticket.patientCode,
      patientName: appt.patientName,
      patientAge: appt.patientAge,
      patientGender: appt.patientGender,
      hubId: appt.hubId,
      hubName: appt.hubName,
      sessionId: appt.sessionId,
      openedAt: '2026-11-04 09:40 AM',
      assignedWorker: '',
      assignedDoctor: 'Dr. Tariqul Islam (BMDC A-54910)',
      status: EncounterStatus.created,
      disposition: EncounterDisposition.inProgress,
      observations: [],
      overallSyncState: _isOffline ? SyncState.capturedLocal : SyncState.synced,
    );
    _encounters.add(encounter);

    _addAudit(
      action: 'PATIENT_CHECKED_IN',
      entityType: 'QueueTicket',
      entityId: ticket.ticketId,
      details:
          'Appointment ${appt.appointmentCode} checked in. Token $token issued.',
      compliance: 'PDPA 2026 Sec 14',
    );

    update();
    return true;
  }

  // Register an assisted walk-in against available capacity for this hub.
  bool registerWalkIn({
    required String fullName,
    required String phone,
    required int age,
    required String gender,
    required bool consentConfirmed,
  }) {
    if (!_canManageCheckIn ||
        !consentConfirmed ||
        fullName.trim().isEmpty ||
        age < 0 ||
        age > 120 ||
        gender.trim().isEmpty) {
      return false;
    }
    final int sessionIndex = _sessions.indexWhere(
      (session) =>
          session.hubId == currentHub.id &&
          (session.status == SessionStatus.inProgress ||
              session.status == SessionStatus.openForBooking) &&
          session.walkInCurrent < session.walkInCapacity,
    );
    if (sessionIndex == -1) return false;

    final String normalizedPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (normalizedPhone.isNotEmpty &&
        _appointments.any(
          (appointment) =>
              appointment.patientPhone.replaceAll(RegExp(r'\D'), '') ==
              normalizedPhone,
        )) {
      return false;
    }
    final String apptId = 'apt_${DateTime.now().millisecondsSinceEpoch}';
    final String apptCode =
        'WALK-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final String patId =
        'pat_bd_${DateTime.now().millisecondsSinceEpoch % 10000}';
    final HubSession session = _sessions[sessionIndex];

    final Appointment walkInAppt = Appointment(
      id: apptId,
      appointmentCode: apptCode,
      patientId: patId,
      patientName: fullName.trim(),
      patientPhone: phone.trim(),
      patientAge: age,
      patientGender: gender,
      hubId: currentHub.id,
      hubName: currentHub.name,
      sessionId: session.id,
      sessionTitle: session.title,
      date: session.date,
      slotTime: 'Walk-in Now',
      bookingSource: 'walk_in',
      status: AppointmentStatus.confirmed,
    );
    _appointments.insert(0, walkInAppt);
    _sessions[sessionIndex] = session.copyWith(
      walkInCurrent: session.walkInCurrent + 1,
    );
    _addAudit(
      action: 'HUB_SERVICE_CONSENT_RECORDED',
      entityType: 'Appointment',
      entityId: apptId,
      details:
          'In-person hub measurement consent confirmed for assisted walk-in.',
      compliance: 'Patient consent workflow',
    );
    return checkInAppointment(apptId, consentConfirmed: true);
  }

  // Update Queue Ticket Status
  void updateQueueStatus(
    String ticketId,
    QueueStatus newStatus, {
    String? delayReason,
  }) {
    if (!_canManageQueue) return;
    final int idx = _queue.indexWhere((q) => q.ticketId == ticketId);
    if (idx != -1) {
      if (!accessibleHubIds.contains(_queue[idx].hubId)) return;
      if (newStatus == QueueStatus.completed ||
          newStatus == QueueStatus.awaitingReview) {
        return;
      }
      _queue[idx] = _queue[idx].copyWith(
        status: newStatus,
        delayReason: delayReason,
      );
      final QueueTicket ticket = _queue[idx];
      final int appointmentIndex = _appointments.indexWhere(
        (appointment) => appointment.id == ticket.appointmentId,
      );
      if (newStatus == QueueStatus.inService && appointmentIndex != -1) {
        _appointments[appointmentIndex] = _appointments[appointmentIndex]
            .copyWith(status: AppointmentStatus.inService);
      }
      final int encounterIndex = _encounters.indexWhere(
        (encounter) => encounter.appointmentId == ticket.appointmentId,
      );
      if (encounterIndex != -1 && newStatus == QueueStatus.inService) {
        _encounters[encounterIndex] = _encounters[encounterIndex].copyWith(
          status: EncounterStatus.inProgress,
        );
      }

      _addAudit(
        action: 'QUEUE_STATUS_UPDATED',
        entityType: 'QueueTicket',
        entityId: ticketId,
        details:
            'Status changed to ${newStatus.name}. Delay reason: ${delayReason ?? "None"}',
        compliance: 'Clinical Operations SOP',
      );
      update();
    }
  }

  // Add observation (Field health worker capture)
  void addObservation({
    required String encounterId,
    required String code,
    required String label,
    required String value,
    required String unit,
    String? contextNote,
    required String deviceAttribution,
    required bool isRepeat,
    String? repeatReason,
    bool isAbnormal = false,
  }) {
    if (_activeRole != HealoraRole.fieldHealthWorker) return;
    final int encIdx = _encounters.indexWhere((e) => e.id == encounterId);
    if (encIdx == -1) return;
    if (!accessibleHubIds.contains(_encounters[encIdx].hubId)) return;
    if (_encounters[encIdx].status == EncounterStatus.completed ||
        _encounters[encIdx].status == EncounterStatus.submittedForReview ||
        _encounters[encIdx].status == EncounterStatus.awaitingSync) {
      return;
    }
    final double? numericValue = double.tryParse(value.trim());
    if (value.trim().isEmpty ||
        numericValue == null ||
        !numericValue.isFinite ||
        numericValue <= 0) {
      return;
    }

    final String obsId = 'obs_${DateTime.now().millisecondsSinceEpoch}';
    final String idempotencyKey =
        'idemp_${DateTime.now().millisecondsSinceEpoch}_${code.hashCode}';

    final SyncState syncStatus = _isOffline
        ? SyncState.capturedLocal
        : SyncState.synced;

    final Observation obs = Observation(
      id: obsId,
      encounterId: encounterId,
      patientId: _encounters[encIdx].patientId,
      code: code,
      label: label,
      value: value,
      unit: unit,
      contextNote: contextNote,
      deviceAttribution: deviceAttribution,
      performerName: 'Nasrin Sultana (Special Team)',
      measuredAt: '09:42 AM',
      isRepeat: isRepeat,
      repeatReason: repeatReason,
      isFlaggedAbnormal: isAbnormal,
      syncState: syncStatus,
      idempotencyKey: idempotencyKey,
    );

    final List<Observation> updatedObs = List.from(
      _encounters[encIdx].observations,
    )..add(obs);
    _encounters[encIdx] = _encounters[encIdx].copyWith(
      observations: updatedObs,
      status: EncounterStatus.inProgress,
      overallSyncState: _isOffline ? SyncState.capturedLocal : SyncState.synced,
    );

    if (_isOffline) {
      _offlineOutbox.add(obs);
    }

    _addAudit(
      action: isRepeat ? 'OBSERVATION_REPEAT_RECORDED' : 'OBSERVATION_RECORDED',
      entityType: 'Observation',
      entityId: obsId,
      details:
          '$label recorded. Device: $deviceAttribution. Sync: ${syncStatus.name}.',
      compliance: 'PDPA 2026 Sec 22',
    );

    update();
  }

  // Sync offline outbox safely with idempotency
  void syncOutbox() {
    if (_offlineOutbox.isEmpty) return;

    final int count = _offlineOutbox.length;
    _offlineOutbox.clear();

    // Mark all observations in encounters as synced
    for (int i = 0; i < _encounters.length; i++) {
      final List<Observation> syncedObs = _encounters[i].observations.map((o) {
        return o.copyWith(syncState: SyncState.synced);
      }).toList();

      final Encounter encounter = _encounters[i];
      final bool readyForReview =
          encounter.status == EncounterStatus.awaitingSync;
      _encounters[i] = encounter.copyWith(
        observations: syncedObs,
        overallSyncState: SyncState.synced,
        status: readyForReview ? EncounterStatus.submittedForReview : null,
      );
      if (readyForReview) {
        final int ticketIndex = _queue.indexWhere(
          (ticket) => ticket.appointmentId == encounter.appointmentId,
        );
        if (ticketIndex != -1) {
          _queue[ticketIndex] = _queue[ticketIndex].copyWith(
            status: QueueStatus.awaitingReview,
          );
        }
      }
    }

    _addAudit(
      action: 'OFFLINE_OUTBOX_SYNC_COMPLETED',
      entityType: 'SyncService',
      entityId: 'sync_${DateTime.now().millisecondsSinceEpoch}',
      details:
          'Successfully acknowledged $count pending observations with idempotency verification.',
      compliance: 'DGHS Telehealth Data Integrity',
    );

    update();
  }

  void submitEncounterForReview(String encounterId) {
    if (_activeRole != HealoraRole.fieldHealthWorker) return;
    final int encounterIndex = _encounters.indexWhere(
      (e) => e.id == encounterId,
    );
    if (encounterIndex == -1 ||
        _encounters[encounterIndex].observations.isEmpty) {
      return;
    }
    final Encounter encounter = _encounters[encounterIndex];
    if (!accessibleHubIds.contains(encounter.hubId)) return;
    if (encounter.status == EncounterStatus.completed ||
        encounter.status == EncounterStatus.submittedForReview ||
        encounter.status == EncounterStatus.awaitingSync) {
      return;
    }
    final bool awaitingSync =
        _isOffline ||
        encounter.observations.any(
          (observation) => observation.syncState != SyncState.synced,
        );
    _encounters[encounterIndex] = encounter.copyWith(
      status: awaitingSync
          ? EncounterStatus.awaitingSync
          : EncounterStatus.submittedForReview,
    );
    if (!awaitingSync) {
      final int ticketIndex = _queue.indexWhere(
        (ticket) => ticket.appointmentId == encounter.appointmentId,
      );
      if (ticketIndex != -1) {
        _queue[ticketIndex] = _queue[ticketIndex].copyWith(
          status: QueueStatus.awaitingReview,
        );
      }
    }
    _addAudit(
      action: awaitingSync
          ? 'ENCOUNTER_WAITING_FOR_SYNC'
          : 'ENCOUNTER_SUBMITTED_FOR_DOCTOR_REVIEW',
      entityType: 'Encounter',
      entityId: encounterId,
      details: awaitingSync
          ? 'Encounter retained locally and marked as awaiting central acknowledgement.'
          : 'Assigned measurement task submitted to the local doctor review queue.',
      compliance: 'Shared encounter workflow',
    );
    update();
  }

  // Submit doctor review and disposition
  void submitDoctorReview({
    required String encounterId,
    required String doctorName,
    required String bmdcNumber,
    required String assessment,
    required String plan,
    required EncounterDisposition disposition,
  }) {
    if (_activeRole != HealoraRole.localDoctor &&
        _activeRole != HealoraRole.registeredMedicalDoctor) {
      return;
    }
    final int encIdx = _encounters.indexWhere((e) => e.id == encounterId);
    if (encIdx == -1) return;
    if (!accessibleHubIds.contains(_encounters[encIdx].hubId)) return;
    if (_encounters[encIdx].status != EncounterStatus.submittedForReview ||
        assessment.trim().isEmpty ||
        plan.trim().isEmpty) {
      return;
    }

    final ClinicalReviewNote note = ClinicalReviewNote(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      encounterId: encounterId,
      doctorName: doctorName,
      doctorBmdcNumber: bmdcNumber,
      clinicalAssessment: assessment,
      managementPlan: plan,
      signedAt: '2026-11-04 09:50 AM',
    );

    _encounters[encIdx] = _encounters[encIdx].copyWith(
      doctorNote: note,
      status: EncounterStatus.completed,
      disposition: disposition,
      closedAt: '2026-11-04 09:50 AM',
    );

    // Update ticket in queue if present
    final int tktIdx = _queue.indexWhere(
      (q) => q.appointmentId == _encounters[encIdx].appointmentId,
    );
    if (tktIdx != -1) {
      _queue[tktIdx] = _queue[tktIdx].copyWith(status: QueueStatus.completed);
    }
    final int appointmentIndex = _appointments.indexWhere(
      (appointment) => appointment.id == _encounters[encIdx].appointmentId,
    );
    if (appointmentIndex != -1) {
      _appointments[appointmentIndex] = _appointments[appointmentIndex]
          .copyWith(status: AppointmentStatus.completed);
    }

    _addAudit(
      action: 'DOCTOR_REVIEW_COMPLETED',
      entityType: 'Encounter',
      entityId: encounterId,
      details:
          'Review signed by $doctorName ($bmdcNumber). Disposition: ${disposition.name}.',
      compliance: 'BMDC Telemedicine Guidelines 2020',
    );

    update();
  }

  // Update equipment status
  void updateEquipmentStatus(
    String equipmentId,
    EquipmentStatus newStatus, {
    String? notes,
  }) {
    if (!_canManageEquipment) return;
    final int idx = _equipment.indexWhere((e) => e.id == equipmentId);
    if (idx != -1) {
      if (!accessibleHubIds.contains(_equipment[idx].hubId)) return;
      _equipment[idx] = _equipment[idx].copyWith(
        status: newStatus,
        notes: notes,
      );

      _addAudit(
        action: 'EQUIPMENT_STATUS_CHANGED',
        entityType: 'Equipment',
        entityId: equipmentId,
        details: '${_equipment[idx].name} updated to ${newStatus.name}. $notes',
        compliance: 'Medical Device SOP',
      );
      update();
    }
  }

  bool get _canManageCheckIn =>
      _activeRole == HealoraRole.platformAdmin ||
      _activeRole == HealoraRole.regionalManager ||
      _activeRole == HealoraRole.hubManager ||
      _activeRole == HealoraRole.receptionist;

  bool get _canManageQueue =>
      _canManageCheckIn || _activeRole == HealoraRole.queueCoordinator;

  bool get _canManageEquipment =>
      _activeRole == HealoraRole.platformAdmin ||
      _activeRole == HealoraRole.regionalManager ||
      _activeRole == HealoraRole.hubManager ||
      _activeRole == HealoraRole.equipmentOfficer;

  // Operational metrics
  OperationalMetrics get metrics {
    final List<Appointment> scopedAppointments = appointments;
    final List<QueueTicket> scopedQueue = queue;
    final List<Encounter> scopedEncounters = encounters;
    final List<HubEquipment> scopedEquipment = equipment;
    final int totalAppts = scopedAppointments.length;
    final int arrived = scopedAppointments
        .where(
          (a) =>
              a.status != AppointmentStatus.confirmed &&
              a.status != AppointmentStatus.pendingConfirmation,
        )
        .length;
    final int checkedIn = scopedAppointments
        .where((a) => a.status == AppointmentStatus.checkedIn)
        .length;
    final int inService = scopedQueue
        .where((q) => q.status == QueueStatus.inService)
        .length;
    final int completed = scopedEncounters
        .where((e) => e.status == EncounterStatus.completed)
        .length;
    final int equipIssues = scopedEquipment
        .where(
          (e) =>
              e.status == EquipmentStatus.outOfService ||
              e.status == EquipmentStatus.calibrationDue,
        )
        .length;

    return OperationalMetrics(
      activeHubs: hubs.where((h) => h.status == HubStatus.active).length,
      todaySessions: sessions.length,
      totalAppointments: totalAppts,
      arrivedCount: arrived,
      checkedInCount: checkedIn,
      inServiceCount: inService,
      completedCount: completed,
      syncPendingCount: _offlineOutbox.length,
      syncFailedCount: 0,
      equipmentIssuesCount: equipIssues,
      averageWaitMinutes: 14,
      averageServiceMinutes: 18,
      syncSuccessRate: 99.4,
      requiredDataCompleteness: 98.2,
    );
  }
}

// Global navigator key for contexts
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
