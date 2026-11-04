import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/services/healora_state.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/features/clinical/controllers/clinical_controller.dart';

class ClinicalScreen extends StatefulWidget {
  final HealoraState state;

  const ClinicalScreen({super.key, required this.state});

  @override
  State<ClinicalScreen> createState() => _ClinicalScreenState();
}

class _ClinicalScreenState extends State<ClinicalScreen> {
  late final ClinicalController _controller;
  // Input fields for vital signs capture
  final TextEditingController _bpSysCtrl = TextEditingController(text: '136');
  final TextEditingController _bpDiaCtrl = TextEditingController(text: '86');
  final TextEditingController _pulseCtrl = TextEditingController(text: '78');
  final TextEditingController _spo2Ctrl = TextEditingController(text: '98');
  final TextEditingController _tempCtrl = TextEditingController(text: '36.8');
  final TextEditingController _glucoseCtrl = TextEditingController(text: '7.2');
  final TextEditingController _heightCtrl = TextEditingController(text: '162');
  final TextEditingController _weightCtrl = TextEditingController(text: '65.0');
  final TextEditingController _repeatReasonCtrl = TextEditingController();

  // Doctor review fields
  final TextEditingController _doctorAssessmentCtrl = TextEditingController(
    text: 'Stage 1 Hypertension noted with mildly elevated fasting glucose (7.4 mmol/L). Cardiac auscultation normal S1 S2, no pedal edema.',
  );
  final TextEditingController _doctorPlanCtrl = TextEditingController(
    text: 'Prescribed lifestyle modification and dietary salt reduction. Scheduled follow-up vitals check at hub in 14 days. Teleconsultation package with Chennai cardiologist recommended.',
  );
  EncounterDisposition _selectedDisposition = EncounterDisposition.completed;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ClinicalController());
  }

  @override
  void dispose() {
    Get.delete<ClinicalController>();
    _bpSysCtrl.dispose();
    _bpDiaCtrl.dispose();
    _pulseCtrl.dispose();
    _spo2Ctrl.dispose();
    _tempCtrl.dispose();
    _glucoseCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _repeatReasonCtrl.dispose();
    _doctorAssessmentCtrl.dispose();
    _doctorPlanCtrl.dispose();
    super.dispose();
  }

  // Calculate derived BMI
  double? _calculateBMI() {
    final double? hCm = double.tryParse(_heightCtrl.text);
    final double? wKg = double.tryParse(_weightCtrl.text);
    if (hCm != null && wKg != null && hCm > 50 && wKg > 20) {
      final double hM = hCm / 100.0;
      return double.parse((wKg / (hM * hM)).toStringAsFixed(1));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final List<Encounter> encounters = state.encounters;
    final Encounter? activeEncounter = encounters.isNotEmpty
        ? encounters.first
        : null;

    final double? bmi = _calculateBMI();

    return GetBuilder<ClinicalController>(
      init: _controller,
      builder: (controller) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinical Header with Role Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          state.t(
                            'Clinical Execution & Vitals Capture',
                            'ক্লিনিক্যাল এক্সিকিউশন ও ভাইটালস এন্ট্রি',
                          ),
                          style: HealoraTypography.h1(isBangla: state.isBangla),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: HealoraColors.mist,
                            borderRadius: HealoraSpacing.borderPill,
                          ),
                          child: Text(
                            state.t(
                              'Shared Special Team & Doctor App',
                              'শেয়ার্ড স্পেশাল টিম ও ডাক্তার ইন্টারফেস',
                            ),
                            style: HealoraTypography.label(
                              color: HealoraColors.pine,
                              isBangla: state.isBangla,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.t(
                        'Verified health workers capture structured vitals with medical device attribution and offline outbox sync.',
                        'অনুমোদিত স্বাস্থ্যকর্মী কর্তৃক ডিভাইস নম্বরসহ ভাইটালস সংগ্রহ ও স্থানীয় ডাক্তারের রিভিউ ব্যবস্থাপনা।',
                      ),
                      style: HealoraTypography.caption(
                        color: HealoraColors.slate,
                        isBangla: state.isBangla,
                      ),
                    ),
                  ],
                ),

                // Offline Sync Status Banner & Button
                Row(
                  children: [
                    if (state.isOffline || state.offlineOutbox.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: HealoraColors.warnBg,
                          borderRadius: HealoraSpacing.borderControl,
                          border: Border.all(
                            color: HealoraColors.warn,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sync_problem,
                              size: 18,
                              color: HealoraColors.warnFg,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.t(
                                'Offline Outbox: ${state.offlineOutbox.length} pending',
                                'অফলাইন আউটবক্স: ${state.offlineOutbox.length} অপেক্ষমাণ',
                              ),
                              style: HealoraTypography.caption(
                                color: HealoraColors.warnFg,
                                isBangla: state.isBangla,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      HealoraButton.small(
                        label: state.t('Sync Outbox Now', 'এখনই সিঙ্ক করুন'),
                        onPressed: () {
                          state.syncOutbox();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: HealoraColors.ink,
                              content: Text(
                                state.t(
                                  'Outbox acknowledged by central backend',
                                  'সকল উপাত্ত সফলভাবে কেন্দ্রীয় ডাটাবেজে যুক্ত হয়েছে',
                                ),
                              ),
                            ),
                          );
                        },
                        isBangla: state.isBangla,
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: HealoraColors.okBg,
                          borderRadius: HealoraSpacing.borderControl,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cloud_done,
                              size: 18,
                              color: HealoraColors.okFg,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.t(
                                'Central Record Synchronized',
                                'কেন্দ্রীয় রেকর্ড সমলয়কৃত',
                              ),
                              style: HealoraTypography.caption(
                                color: HealoraColors.okFg,
                                isBangla: state.isBangla,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (activeEncounter == null) ...[
              HealoraCard.tint(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      state.t(
                        'No active encounter found. Please check in a patient first.',
                        'কোনো সক্রিয় এনকাউন্টার নেই। অনুগ্রহ করে প্রথমে রোগী চেক-ইন করুন।',
                      ),
                      style: HealoraTypography.body(isBangla: state.isBangla),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Active Encounter Banner
              HealoraCard(
                borderRadius: HealoraSpacing.borderCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: HealoraColors.teal,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    activeEncounter.patientName,
                                    style: HealoraTypography.h2(
                                      color: HealoraColors.ink,
                                      isBangla: state.isBangla,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HealoraColors.mist,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      activeEncounter.patientCode,
                                      style: HealoraTypography.label(
                                        color: HealoraColors.pine,
                                        isBangla: state.isBangla,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  HealoraStatusPill(
                                    label: activeEncounter.statusLabel,
                                    type:
                                        activeEncounter.status ==
                                            EncounterStatus.completed
                                        ? HealoraPillType.completed
                                        : HealoraPillType.inService,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${activeEncounter.patientAge} ${state.t("yrs", "বছর")}, ${activeEncounter.patientGender} · ${activeEncounter.hubName} · ${state.t("Assigned Worker:", "দায়িত্বপ্রাপ্ত স্বাস্থ্যকর্মী:")} ${activeEncounter.assignedWorker}',
                                style: HealoraTypography.caption(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              activeEncounter.ticketId.replaceAll(
                                'tkt_',
                                'TOKEN #',
                              ),
                              style: HealoraTypography.tabular(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: HealoraColors.ink,
                              ),
                            ),
                            Text(
                              activeEncounter.openedAt,
                              style: HealoraTypography.micro(
                                color: HealoraColors.slate,
                                isBangla: state.isBangla,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Two Columns Layout: Left = Vitals Capture Form, Right = Recorded Observations & Doctor Review
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isTwoCol = constraints.maxWidth > 950;

                  final Widget vitalsForm = HealoraCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.t(
                                'Standard Vitals Checklist',
                                'স্ট্যান্ডার্ড ভাইটালস চেকপয়েন্ট',
                              ),
                              style: HealoraTypography.h3(
                                isBangla: state.isBangla,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: HealoraColors.mist,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                state.t(
                                  'CLINICAL PROTOCOL v2.4',
                                  'প্রটোকল ভার্সন ২.৪',
                                ),
                                style: HealoraTypography.label(
                                  color: HealoraColors.pine,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.t(
                            'PRD Rule: Structured numerical inputs with explicit units. Missing values must never be stored as zero.',
                            'PRD নীতিমালা: স্পষ্ট এককসহ পরিমাপ গ্রহণ আবশ্যক। কোনো অনুপস্থিত পরিমাপকে শূন্য হিসেবে গণ্য করা নিষিদ্ধ।',
                          ),
                          style: HealoraTypography.micro(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Device Selection
                        Text(
                          state.t(
                            'Device Attribution (Mandatory per PRD 8.9)',
                            'ব্যবহৃত পরিমাপক যন্ত্র (PRD ৮.৯ অনুযায়ী আবশ্যক)',
                          ),
                          style: HealoraTypography.caption(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: HealoraColors.paper,
                            borderRadius: HealoraSpacing.borderControl,
                            border: Border.all(
                              color: HealoraColors.line,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedDeviceId,
                              isExpanded: true,
                              onChanged: (v) {
                                if (v != null) controller.selectDevice(v);
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: 'Omron HEM-7120 #SN-OMR-98214',
                                  child: Text(
                                    'Omron Digital BP Monitor (SN-OMR-98214)',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Accu-Chek Instant #SN-ROCHE-44102',
                                  child: Text(
                                    'Accu-Chek Instant Glucometer (SN-ROCHE-44102)',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Nonin Onyx #SN-NONIN-11029',
                                  child: Text(
                                    'Nonin Pulse Oximeter (SN-NONIN-11029)',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Seca 874 #SN-SECA-88390',
                                  child: Text(
                                    'Seca Flat Scale & Stadiometer (SN-SECA-88390)',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Blood Pressure Row
                        Row(
                          children: [
                            Expanded(
                              child: HealoraTextField(
                                controller: _bpSysCtrl,
                                label: state.t(
                                  'Systolic BP (mmHg)',
                                  'সিস্টোলিক রক্তচাপ (mmHg)',
                                ),
                                keyboardType: TextInputType.number,
                                isBangla: state.isBangla,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: HealoraTextField(
                                controller: _bpDiaCtrl,
                                label: state.t(
                                  'Diastolic BP (mmHg)',
                                  'ডায়াস্টোলিক রক্তচাপ (mmHg)',
                                ),
                                keyboardType: TextInputType.number,
                                isBangla: state.isBangla,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: HealoraTextField(
                                controller: _pulseCtrl,
                                label: state.t(
                                  'Pulse Rate (bpm)',
                                  'নাড়ির স্পন্দন (bpm)',
                                ),
                                keyboardType: TextInputType.number,
                                isBangla: state.isBangla,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // SpO2 and Temperature
                        Row(
                          children: [
                            Expanded(
                              child: HealoraTextField(
                                controller: _spo2Ctrl,
                                label: state.t(
                                  'Oxygen SpO2 (%)',
                                  'অক্সিজেন মাত্রা (%)',
                                ),
                                keyboardType: TextInputType.number,
                                isBangla: state.isBangla,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: HealoraTextField(
                                controller: _tempCtrl,
                                label: state.t(
                                  'Temperature (°C)',
                                  'শারীরিক তাপমাত্রা (°C)',
                                ),
                                keyboardType: TextInputType.number,
                                isBangla: state.isBangla,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Blood Glucose & Context
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: HealoraTextField(
                                controller: _glucoseCtrl,
                                label: state.t(
                                  'Blood Glucose (mmol/L)',
                                  'রক্তের গ্লুকোজ (mmol/L)',
                                ),
                                keyboardType: TextInputType.number,
                                isBangla: state.isBangla,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.t(
                                      'Glucose Context',
                                      'গ্লুকোজ অবস্থা',
                                    ),
                                    style: HealoraTypography.caption(
                                      color: HealoraColors.slate,
                                      isBangla: state.isBangla,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HealoraColors.paper,
                                      borderRadius:
                                          HealoraSpacing.borderControl,
                                      border: Border.all(
                                        color: HealoraColors.line,
                                        width: 1,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: controller.glucoseContext,
                                        isExpanded: true,
                                        onChanged: (v) {
                                          if (v != null)
                                            controller.selectGlucoseContext(v);
                                        },
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'Fasting',
                                            child: Text('Fasting (>8 hrs)'),
                                          ),
                                          DropdownMenuItem(
                                            value: '2hr Postprandial',
                                            child: Text('2-hr Postprandial'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Random',
                                            child: Text('Random'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Height, Weight, Derived BMI
                        Row(
                          children: [
                            Expanded(
                              child: HealoraTextField(
                                controller: _heightCtrl,
                                label: state.t('Height (cm)', 'উচ্চতা (cm)'),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                isBangla: state.isBangla,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: HealoraTextField(
                                controller: _weightCtrl,
                                label: state.t('Weight (kg)', 'ওজন (kg)'),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                isBangla: state.isBangla,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 56,
                                margin: const EdgeInsets.only(top: 22),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: HealoraColors.mist,
                                  borderRadius: HealoraSpacing.borderControl,
                                  border: Border.all(
                                    color: HealoraColors.line,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.t(
                                        'DERIVED BMI',
                                        'নির্ধারিত বিএমআই',
                                      ),
                                      style: HealoraTypography.micro(
                                        color: HealoraColors.slate,
                                        isBangla: state.isBangla,
                                      ),
                                    ),
                                    Text(
                                      bmi != null ? '$bmi kg/m²' : '--',
                                      style: HealoraTypography.tabular(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: HealoraColors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Repeat Measurement Section (PRD Rule 5.6: Never overwrite, preserve repeat reason)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: HealoraColors.bone,
                            borderRadius: HealoraSpacing.borderControl,
                            border: Border.all(
                              color: HealoraColors.line,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: controller.isRepeatReading,
                                    activeColor: HealoraColors.teal,
                                    onChanged: (v) =>
                                        controller.setRepeatReading(v ?? false),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      state.t(
                                        'This is a Repeat Measurement (PRD Rule: Original reading is preserved, not overwritten)',
                                        'এটি একটি দ্বিতীয়/পুনরাবৃত্তি পরিমাপ (PRD নিয়ম: পূর্বের রিডিং অপরিবর্তিত থাকবে)',
                                      ),
                                      style: HealoraTypography.caption(
                                        color: HealoraColors.ink,
                                        isBangla: state.isBangla,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.isRepeatReading) ...[
                                const SizedBox(height: 8),
                                HealoraTextField(
                                  controller: _repeatReasonCtrl,
                                  label: state.t(
                                    'Clinical Repeat Reason',
                                    'পুনরাবৃত্তির ক্লিনিক্যাল কারণ',
                                  ),
                                  hintText: 'e.g. High initial reading; repeated after 10 min seated rest',
                                  isBangla: state.isBangla,
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        HealoraButton.primary(
                          fullWidth: true,
                          label: state.t(
                            'Save Structured Observations',
                            'পরিমাপসমূহ সংরক্ষণ ও জমা দিন',
                          ),
                          onPressed: () {
                            // Record observations
                            state.addObservation(
                              encounterId: activeEncounter.id,
                              code: 'bp_sys',
                              label: 'Systolic Blood Pressure',
                              value: _bpSysCtrl.text.trim(),
                              unit: 'mmHg',
                              contextNote: 'Right arm seated',
                              deviceAttribution: controller.selectedDeviceId,
                              isRepeat: controller.isRepeatReading,
                              repeatReason: controller.isRepeatReading
                                  ? _repeatReasonCtrl.text
                                  : null,
                            );
                            state.addObservation(
                              encounterId: activeEncounter.id,
                              code: 'bp_dia',
                              label: 'Diastolic Blood Pressure',
                              value: _bpDiaCtrl.text.trim(),
                              unit: 'mmHg',
                              contextNote: 'Right arm seated',
                              deviceAttribution: controller.selectedDeviceId,
                              isRepeat: controller.isRepeatReading,
                              repeatReason: controller.isRepeatReading
                                  ? _repeatReasonCtrl.text
                                  : null,
                            );
                            state.addObservation(
                              encounterId: activeEncounter.id,
                              code: 'pulse',
                              label: 'Pulse Rate',
                              value: _pulseCtrl.text.trim(),
                              unit: 'bpm',
                              deviceAttribution: controller.selectedDeviceId,
                              isRepeat: controller.isRepeatReading,
                            );
                            state.addObservation(
                              encounterId: activeEncounter.id,
                              code: 'glucose',
                              label: 'Blood Glucose',
                              value: _glucoseCtrl.text.trim(),
                              unit: 'mmol/L',
                              contextNote: controller.glucoseContext,
                              deviceAttribution:
                                  'Accu-Chek Instant #SN-ROCHE-44102',
                              isRepeat: controller.isRepeatReading,
                              isAbnormal:
                                  double.tryParse(_glucoseCtrl.text) != null &&
                                  double.parse(_glucoseCtrl.text) > 7.0,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: HealoraColors.ink,
                                content: Text(
                                  state.t(
                                    state.isOffline
                                        ? 'Observations saved locally to encrypted offline outbox'
                                        : 'Observations successfully submitted to central record',
                                    state.isOffline
                                        ? 'তথ্যসমূহ অফলাইন সুরক্ষিত আউটবক্সে সংরক্ষিত'
                                        : 'তথ্যসমূহ কেন্দ্রীয় রেকর্ডে জমা সম্পন্ন হয়েছে',
                                  ),
                                ),
                              ),
                            );
                          },
                          isBangla: state.isBangla,
                        ),
                      ],
                    ),
                  );

                  final Widget observationsAndDoctor = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recorded Observations List Card
                      HealoraCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.t(
                                    'Encounter Observations (${activeEncounter.observations.length})',
                                    'সংগৃহীত ভাইটালস তালিকা (${activeEncounter.observations.length})',
                                  ),
                                  style: HealoraTypography.h3(
                                    isBangla: state.isBangla,
                                  ),
                                ),
                                HealoraStatusPill(
                                  label:
                                      activeEncounter.overallSyncState ==
                                          SyncState.synced
                                      ? 'Synced'
                                      : 'Local Only',
                                  type:
                                      activeEncounter.overallSyncState ==
                                          SyncState.synced
                                      ? HealoraPillType.completed
                                      : HealoraPillType.awaiting,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            if (activeEncounter.observations.isEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    state.t(
                                      'No observations recorded yet',
                                      'এখনো কোনো পরিমাপ সংরক্ষণ করা হয়নি',
                                    ),
                                    style: HealoraTypography.caption(
                                      color: HealoraColors.slate,
                                      isBangla: state.isBangla,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: activeEncounter.observations.length,
                                separatorBuilder: (_, __) => const Divider(
                                  color: HealoraColors.line,
                                  height: 16,
                                ),
                                itemBuilder: (context, idx) {
                                  final Observation obs =
                                      activeEncounter.observations[idx];

                                  return Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: obs.isFlaggedAbnormal
                                              ? HealoraColors.warnBg
                                              : HealoraColors.mist,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          obs.isFlaggedAbnormal
                                              ? Icons.warning_amber
                                              : Icons.check,
                                          size: 20,
                                          color: obs.isFlaggedAbnormal
                                              ? HealoraColors.warnFg
                                              : HealoraColors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              obs.label,
                                              style:
                                                  HealoraTypography.bodySmall(
                                                    fontWeight: FontWeight.w600,
                                                    isBangla: state.isBangla,
                                                  ),
                                            ),
                                            Text(
                                              '${obs.deviceAttribution} · ${obs.measuredAt}',
                                              style: HealoraTypography.micro(
                                                color: HealoraColors.slate,
                                                isBangla: state.isBangla,
                                              ),
                                            ),
                                            if (obs.contextNote != null)
                                              Text(
                                                obs.contextNote!,
                                                style: HealoraTypography.micro(
                                                  color: HealoraColors.teal,
                                                  isBangla: state.isBangla,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${obs.value} ${obs.unit}',
                                            style: HealoraTypography.tabular(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: obs.isFlaggedAbnormal
                                                  ? HealoraColors.clay
                                                  : HealoraColors.ink,
                                            ),
                                          ),
                                          if (obs.isRepeat)
                                            Text(
                                              state.t(
                                                'Repeat Reading',
                                                'পুনরাবৃত্তি রিডিং',
                                              ),
                                              style: HealoraTypography.micro(
                                                color: HealoraColors.slate,
                                                isBangla: state.isBangla,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Local Doctor Review Section (PRD Section 6.2 & 9.7)
                      HealoraCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: HealoraColors.ink,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.medical_information,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.t(
                                          'Local Doctor Review & Disposition',
                                          'স্থানীয় ডাক্তারের পর্যালোচনা ও সিদ্ধান্ত',
                                        ),
                                        style: HealoraTypography.h3(
                                          isBangla: state.isBangla,
                                        ),
                                      ),
                                      Text(
                                        'Dr. Tariqul Islam · BMDC Registration: A-54910',
                                        style: HealoraTypography.micro(
                                          color: HealoraColors.slate,
                                          isBangla: state.isBangla,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            HealoraTextField(
                              controller: _doctorAssessmentCtrl,
                              label: state.t(
                                'Clinical Assessment',
                                'ক্লিনিক্যাল মূল্যায়ন',
                              ),
                              maxLines: 2,
                              isBangla: state.isBangla,
                            ),

                            const SizedBox(height: 12),

                            HealoraTextField(
                              controller: _doctorPlanCtrl,
                              label: state.t(
                                'Management Plan & Advice',
                                'ব্যবস্থাপনা পরিকল্পনা ও পরামর্শ',
                              ),
                              maxLines: 2,
                              isBangla: state.isBangla,
                            ),

                            const SizedBox(height: 14),

                            // Disposition Selector
                            Text(
                              state.t(
                                'Encounter Disposition',
                                'এনকাউন্টারের চূড়ান্ত সিদ্ধান্ত',
                              ),
                              style: HealoraTypography.caption(
                                color: HealoraColors.slate,
                                isBangla: state.isBangla,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: HealoraColors.paper,
                                borderRadius: HealoraSpacing.borderControl,
                                border: Border.all(
                                  color: HealoraColors.line,
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<EncounterDisposition>(
                                  value: _selectedDisposition,
                                  isExpanded: true,
                                  onChanged: (v) {
                                    if (v != null)
                                      setState(() => _selectedDisposition = v);
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: EncounterDisposition.completed,
                                      child: Text(
                                        state.t(
                                          'Routine Completed - Results Sent to Patient App',
                                          'সম্পন্ন - ফলাফল রোগী অ্যাপে প্রেরণ',
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          EncounterDisposition.followUpRequired,
                                      child: Text(
                                        state.t(
                                          'Follow-up Required at Hub in 14 Days',
                                          '১৪ দিন পর ফলো-আপ আবশ্যক',
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: EncounterDisposition
                                          .teleconsultScheduled,
                                      child: Text(
                                        state.t(
                                          'Schedule Specialist Teleconsultation (Chennai/Bangalore)',
                                          'বিশেষজ্ঞ টেলি-কনসাল্টেশন শিডিউল',
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: EncounterDisposition
                                          .referredToHospital,
                                      child: Text(
                                        state.t(
                                          'Urgent Referral to Sadar 250-Bed Hospital',
                                          'জরুরি রেফারেল - সদর হাসপাতাল',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            HealoraButton.primary(
                              fullWidth: true,
                              label: state.t(
                                'Sign & Close Clinical Encounter',
                                'স্বাক্ষর ও চেকআপ সমাপ্ত করুন',
                              ),
                              onPressed: () {
                                state.submitDoctorReview(
                                  encounterId: activeEncounter.id,
                                  doctorName: 'Dr. Tariqul Islam',
                                  bmdcNumber: 'BMDC A-54910',
                                  assessment: _doctorAssessmentCtrl.text.trim(),
                                  plan: _doctorPlanCtrl.text.trim(),
                                  disposition: _selectedDisposition,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: HealoraColors.ink,
                                    content: Text(
                                      state.t(
                                        'Encounter signed by Dr. Tariqul Islam and updated to Patient App timeline.',
                                        'ডাক্তারের স্বাক্ষর সম্পন্ন ও রোগী অ্যাপের টাইমলাইনে যুক্ত হয়েছে।',
                                      ),
                                    ),
                                  ),
                                );
                              },
                              isBangla: state.isBangla,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  if (isTwoCol) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: vitalsForm),
                        const SizedBox(width: 24),
                        Expanded(flex: 5, child: observationsAndDoctor),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        vitalsForm,
                        const SizedBox(height: 24),
                        observationsAndDoctor,
                      ],
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
