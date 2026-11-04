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
  fieldHealthWorker,
  localDoctor,
  patient,
}

extension HealoraRoleExtension on HealoraRole {
  String get displayName {
    switch (this) {
      case HealoraRole.platformAdmin:
        return 'Super Admin';
      case HealoraRole.regionalManager:
        return 'Regional Ops';
      case HealoraRole.hubManager:
        return 'Hub Manager';
      case HealoraRole.receptionist:
        return 'Reception / Check-in';
      case HealoraRole.queueCoordinator:
        return 'Queue Coordinator';
      case HealoraRole.fieldHealthWorker:
        return 'Special Team (Worker)';
      case HealoraRole.localDoctor:
        return 'Local Doctor';
      case HealoraRole.patient:
        return 'Patient App';
    }
  }

  String get bnDisplayName {
    switch (this) {
      case HealoraRole.platformAdmin:
        return 'সুপার অ্যাডমিন';
      case HealoraRole.regionalManager:
        return 'আঞ্চলিক ব্যবস্থাপক';
      case HealoraRole.hubManager:
        return 'হাব ম্যানেজার';
      case HealoraRole.receptionist:
        return 'রিসেপশন / চেক-ইন';
      case HealoraRole.queueCoordinator:
        return 'কিউ কোঅর্ডিনেটর';
      case HealoraRole.fieldHealthWorker:
        return 'স্পেশাল টিম (স্বাস্থ্যকর্মী)';
      case HealoraRole.localDoctor:
        return 'স্থানীয় ডাক্তার';
      case HealoraRole.patient:
        return 'রোগী ভিউ';
    }
  }
}

class HealoraState extends GetxController {
  // Current settings
  HealoraRole _activeRole = HealoraRole.hubManager;
  bool _isBangla = false;
  bool _isOffline = false;
  String _selectedHubId = 'hub_mkg_01';
  int _currentNavIndex = 0;

  HealoraRole get activeRole => _activeRole;
  bool get isBangla => _isBangla;
  bool get isOffline => _isOffline;
  String get selectedHubId => _selectedHubId;
  int get currentNavIndex => _currentNavIndex;

  // Language helper
  String t(String en, String bn) => _isBangla ? bn : en;

  void setRole(HealoraRole role) {
    _activeRole = role;
    update();
  }

  void setLanguage(bool isBangla) {
    _isBangla = isBangla;
    update();
  }

  void toggleLanguage() {
    _isBangla = !_isBangla;
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
    _selectedHubId = hubId;
    update();
  }

  void setNavIndex(int index) {
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

  List<Hub> get hubs => _hubs;
  List<HubSession> get sessions => _sessions;
  List<HubStation> get stations => _stations;
  List<HubEquipment> get equipment => _equipment;
  List<Appointment> get appointments => _appointments;
  List<QueueTicket> get queue => _queue;
  List<Encounter> get encounters => _encounters;
  List<Observation> get offlineOutbox => _offlineOutbox;
  List<AuditLogEntry> get auditLogs => _auditLogs;

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
        details: 'Submitted 6 structured vital signs for patient PAT-BD-89211 with device attribution.',
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
        details: 'Verified canonical identity, verified consent, generated token HUB-MKG-014.',
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
  void checkInAppointment(String appointmentId) {
    final int apptIdx = _appointments.indexWhere((a) => a.id == appointmentId);
    if (apptIdx == -1) return;

    final Appointment appt = _appointments[apptIdx];
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
      currentStationId: 'st_02',
      currentStationName: 'Station 2: Vitals & Anthropometry',
      status: QueueStatus.waiting,
      arrivalTime: '09:40 AM',
      waitDurationMinutes: 0,
      assignedWorker: 'Nasrin Sultana',
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
      assignedWorker: 'Nasrin Sultana',
      assignedDoctor: 'Dr. Tariqul Islam (BMDC A-54910)',
      status: EncounterStatus.assigned,
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
          'Checked in ${appt.patientName} (${appt.appointmentCode}). Token $token issued.',
      compliance: 'PDPA 2026 Sec 14',
    );

    update();
  }

  // Register walk-in patient
  void registerWalkIn({
    required String fullName,
    required String phone,
    required int age,
    required String gender,
  }) {
    final String apptId = 'apt_${DateTime.now().millisecondsSinceEpoch}';
    final String apptCode =
        'WALK-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final String patId =
        'pat_bd_${DateTime.now().millisecondsSinceEpoch % 10000}';

    final Appointment walkInAppt = Appointment(
      id: apptId,
      appointmentCode: apptCode,
      patientId: patId,
      patientName: fullName,
      patientPhone: phone,
      patientAge: age,
      patientGender: gender,
      hubId: currentHub.id,
      hubName: currentHub.name,
      sessionId: _sessions.first.id,
      sessionTitle: _sessions.first.title,
      date: '2026-11-04',
      slotTime: 'Walk-in Now',
      bookingSource: 'walk_in',
      status: AppointmentStatus.checkedIn,
    );
    _appointments.insert(0, walkInAppt);

    // Update walk-in count on session
    _sessions[0] = _sessions[0].copyWith(
      walkInCurrent: _sessions[0].walkInCurrent + 1,
    );

    checkInAppointment(apptId);
  }

  // Update Queue Ticket Status
  void updateQueueStatus(
    String ticketId,
    QueueStatus newStatus, {
    String? delayReason,
  }) {
    final int idx = _queue.indexWhere((q) => q.ticketId == ticketId);
    if (idx != -1) {
      _queue[idx] = _queue[idx].copyWith(
        status: newStatus,
        delayReason: delayReason,
      );

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
    final int encIdx = _encounters.indexWhere((e) => e.id == encounterId);
    if (encIdx == -1) return;

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
          '$label: $value $unit ($deviceAttribution). Sync: ${syncStatus.name}.',
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

      _encounters[i] = _encounters[i].copyWith(
        observations: syncedObs,
        overallSyncState: SyncState.synced,
      );
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

  // Submit doctor review and disposition
  void submitDoctorReview({
    required String encounterId,
    required String doctorName,
    required String bmdcNumber,
    required String assessment,
    required String plan,
    required EncounterDisposition disposition,
  }) {
    final int encIdx = _encounters.indexWhere((e) => e.id == encounterId);
    if (encIdx == -1) return;

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
    final int idx = _equipment.indexWhere((e) => e.id == equipmentId);
    if (idx != -1) {
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

  // Operational metrics
  OperationalMetrics get metrics {
    final int totalAppts = _appointments.length;
    final int arrived = _appointments
        .where(
          (a) =>
              a.status != AppointmentStatus.confirmed &&
              a.status != AppointmentStatus.pendingConfirmation,
        )
        .length;
    final int checkedIn = _appointments
        .where((a) => a.status == AppointmentStatus.checkedIn)
        .length;
    final int inService = _queue
        .where((q) => q.status == QueueStatus.inService)
        .length;
    final int completed = _encounters
        .where((e) => e.status == EncounterStatus.completed)
        .length;
    final int equipIssues = _equipment
        .where(
          (e) =>
              e.status == EquipmentStatus.outOfService ||
              e.status == EquipmentStatus.calibrationDue,
        )
        .length;

    return OperationalMetrics(
      activeHubs: _hubs.where((h) => h.status == HubStatus.active).length,
      todaySessions: _sessions.length,
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
