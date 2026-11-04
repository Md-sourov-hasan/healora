import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/features/clinical/controllers/clinical_controller.dart';

class ClinicalScreen extends StatelessWidget {
  final ClinicalController controller;

  const ClinicalScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final activeEncounter = controller.activeEncounter;

    final double? bmi = controller.bmi;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
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
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
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
                  SizedBox(height: 4.h),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: HealoraColors.warnBg,
                        borderRadius: HealoraSpacing.borderControl,
                        border: Border.all(color: HealoraColors.warn, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sync_problem,
                            size: 18,
                            color: HealoraColors.warnFg,
                          ),
                          SizedBox(width: 8.w),
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
                    SizedBox(width: 10.w),
                    HealoraButton.small(
                      label: state.t('Sync Outbox Now', 'এখনই সিঙ্ক করুন'),
                      onPressed: () {
                        controller.syncOutbox();
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
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
                          SizedBox(width: 8.w),
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

          SizedBox(height: 24.h),

          if (activeEncounter == null) ...[
            HealoraCard.tint(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
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
                        width: 52.w,
                        height: 52.h,
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
                      SizedBox(width: 16.w),
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
                                SizedBox(width: 10.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
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
                                SizedBox(width: 8.w),
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
                            SizedBox(height: 4.h),
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
                            controller.ticketLabel(activeEncounter.ticketId),
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

            SizedBox(height: 24.h),

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
                          Expanded(
                            child: Text(
                              state.t(
                                'Standard Vitals Checklist',
                                'স্ট্যান্ডার্ড ভাইটালস চেকপয়েন্ট',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: HealoraTypography.h3(
                                isBangla: state.isBangla,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
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
                      SizedBox(height: 6.h),
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

                      SizedBox(height: 16.h),

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
                      SizedBox(height: 6.h),
                      Container(
                        height: 52.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
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

                      SizedBox(height: 16.h),

                      // Blood Pressure Row
                      Row(
                        children: [
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.systolicController,
                              label: state.t(
                                'Systolic BP (mmHg)',
                                'সিস্টোলিক রক্তচাপ (mmHg)',
                              ),
                              keyboardType: TextInputType.number,
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.diastolicController,
                              label: state.t(
                                'Diastolic BP (mmHg)',
                                'ডায়াস্টোলিক রক্তচাপ (mmHg)',
                              ),
                              keyboardType: TextInputType.number,
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.pulseController,
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

                      SizedBox(height: 14.h),

                      // SpO2 and Temperature
                      Row(
                        children: [
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.spo2Controller,
                              label: state.t(
                                'Oxygen SpO2 (%)',
                                'অক্সিজেন মাত্রা (%)',
                              ),
                              keyboardType: TextInputType.number,
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.temperatureController,
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

                      SizedBox(height: 14.h),

                      // Blood Glucose & Context
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: HealoraTextField(
                              controller: controller.glucoseController,
                              label: state.t(
                                'Blood Glucose (mmol/L)',
                                'রক্তের গ্লুকোজ (mmol/L)',
                              ),
                              keyboardType: TextInputType.number,
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.t('Glucose Context', 'গ্লুকোজ অবস্থা'),
                                  style: HealoraTypography.caption(
                                    color: HealoraColors.slate,
                                    isBangla: state.isBangla,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  height: 56.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
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

                      SizedBox(height: 14.h),

                      // Height, Weight, Derived BMI
                      Row(
                        children: [
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.heightController,
                              label: state.t('Height (cm)', 'উচ্চতা (cm)'),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => controller.refreshBmi(),
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: HealoraTextField(
                              controller: controller.weightController,
                              label: state.t('Weight (kg)', 'ওজন (kg)'),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => controller.refreshBmi(),
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Container(
                              height: 56.h,
                              margin: EdgeInsets.only(top: 22.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
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
                                    state.t('DERIVED BMI', 'নির্ধারিত বিএমআই'),
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

                      SizedBox(height: 16.h),

                      // Repeat Measurement Section (PRD Rule 5.6: Never overwrite, preserve repeat reason)
                      Container(
                        padding: EdgeInsets.all(12.r),
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
                                SizedBox(width: 6.w),
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
                              SizedBox(height: 8.h),
                              HealoraTextField(
                                controller: controller.repeatReasonController,
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

                      SizedBox(height: 20.h),

                      HealoraButton.primary(
                        fullWidth: true,
                        label: state.t(
                          'Save Structured Observations',
                          'পরিমাপসমূহ সংরক্ষণ ও জমা দিন',
                        ),
                        onPressed: () {
                          controller.saveObservations(activeEncounter.id);
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
                          SizedBox(height: 12.h),

                          if (activeEncounter.observations.isEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
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
                              separatorBuilder: (_, __) => Divider(
                                color: HealoraColors.line,
                                height: 16.h,
                              ),
                              itemBuilder: (context, idx) {
                                final Observation obs =
                                    activeEncounter.observations[idx];

                                return Row(
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: obs.isFlaggedAbnormal
                                            ? HealoraColors.warnBg
                                            : HealoraColors.mist,
                                        borderRadius: BorderRadius.circular(10),
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
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            obs.label,
                                            style: HealoraTypography.bodySmall(
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

                    SizedBox(height: 20.h),

                    // Local Doctor Review Section (PRD Section 6.2 & 9.7)
                    HealoraCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36.w,
                                height: 36.h,
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
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                          SizedBox(height: 16.h),

                          HealoraTextField(
                            controller: controller.doctorAssessmentController,
                            label: state.t(
                              'Clinical Assessment',
                              'ক্লিনিক্যাল মূল্যায়ন',
                            ),
                            maxLines: 2,
                            isBangla: state.isBangla,
                          ),

                          SizedBox(height: 12.h),

                          HealoraTextField(
                            controller: controller.doctorPlanController,
                            label: state.t(
                              'Management Plan & Advice',
                              'ব্যবস্থাপনা পরিকল্পনা ও পরামর্শ',
                            ),
                            maxLines: 2,
                            isBangla: state.isBangla,
                          ),

                          SizedBox(height: 14.h),

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
                          SizedBox(height: 6.h),
                          Container(
                            height: 52.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                                value: controller.selectedDisposition,
                                isExpanded: true,
                                onChanged: (v) {
                                  if (v != null)
                                    controller.selectDisposition(v);
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
                                    value:
                                        EncounterDisposition.referredToHospital,
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

                          SizedBox(height: 20.h),

                          HealoraButton.primary(
                            fullWidth: true,
                            label: state.t(
                              'Sign & Close Clinical Encounter',
                              'স্বাক্ষর ও চেকআপ সমাপ্ত করুন',
                            ),
                            onPressed: () {
                              controller.submitReview(activeEncounter.id);
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
                      SizedBox(width: 24.w),
                      Expanded(flex: 5, child: observationsAndDoctor),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      vitalsForm,
                      SizedBox(height: 24.h),
                      observationsAndDoctor,
                    ],
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
