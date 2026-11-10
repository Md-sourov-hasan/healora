import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/features/equipment/controllers/equipment_controller.dart';

class EquipmentScreen extends StatelessWidget {
  final EquipmentController controller;

  const EquipmentScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.t(
                      'Stations & Medical Equipment Inventory',
                      'স্টেশন ও মেডিকেল যন্ত্রপাতি ব্যবস্থাপনা',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    state.t(
                      'Manage hub device calibration dates, maintenance history, station assignments, and clinical safety blocks.',
                      'যন্ত্রপাতির ক্যালিব্রেশন মেয়াদ, রক্ষণাবেক্ষণ ইতিহাস, স্টেশন বণ্টন ও নিরাপত্তা নিশ্চিতকরণ।',
                    ),
                    style: HealoraTypography.caption(
                      color: HealoraColors.slate,
                      isBangla: state.isBangla,
                    ),
                  ),
                ],
              ),
              HealoraButton.primary(
                label: state.t(
                  'Log Calibration / Maintenance',
                  'ক্যালিব্রেশন রিপোর্ট লিপিবদ্ধ করুন',
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: HealoraColors.ink,
                      content: Text(
                        state.t(
                          'Calibration event logged to audit stream',
                          'ক্যালিব্রেশন রিপোর্ট সফলভাবে যুক্ত হয়েছে',
                        ),
                      ),
                    ),
                  );
                },
                isBangla: state.isBangla,
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // PRD Clinical Safety Box (Section 8.9 & 13.1)
          HealoraCard.tint(
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: HealoraColors.teal,
                  size: 24,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.t(
                          'Medical Device Safety & Out-of-Service Rule (PRD 8.9)',
                          'চিকিৎসা যন্ত্রের নিরাপত্তা ও সার্ভিস ব্লক নীতিমালা',
                        ),
                        style: HealoraTypography.body(
                          fontWeight: FontWeight.w600,
                          color: HealoraColors.pine,
                          isBangla: state.isBangla,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        state.t(
                          'The system strictly prevents an out-of-service or overdue device from being assigned to any session where that device is mandatory. Calibration logs are tied directly to observation attribution.',
                          'কোনো ত্রুটিপূর্ণ বা মেয়াদোত্তীর্ণ যন্ত্রকে বাধ্যতামূলক ক্লিনিক্যাল সেশনে ব্যবহার থেকে সিস্টেম স্বয়ংক্রিয়ভাবে বিরত রাখে। প্রতিটি রিডিংয়ে যন্ত্রের সিরিয়াল নম্বর সংরক্ষিত হয়।',
                        ),
                        style: HealoraTypography.caption(
                          color: HealoraColors.slate,
                          isBangla: state.isBangla,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // List of Equipment
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.equipment.length,
            separatorBuilder: (_, _) => SizedBox(height: 14.h),
            itemBuilder: (context, idx) {
              final HubEquipment eq = state.equipment[idx];

              HealoraPillType pillType;
              if (eq.status == EquipmentStatus.available) {
                pillType = HealoraPillType.completed;
              } else if (eq.status == EquipmentStatus.calibrationDue) {
                pillType = HealoraPillType.awaiting;
              } else {
                pillType = HealoraPillType.declined;
              }

              return HealoraCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: eq.status == EquipmentStatus.outOfService
                                ? HealoraColors.badBg
                                : HealoraColors.mist,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.biotech_outlined,
                            color: eq.status == EquipmentStatus.outOfService
                                ? HealoraColors.bad
                                : HealoraColors.pine,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    eq.name,
                                    style: HealoraTypography.h3(
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
                                      color: HealoraColors.bone,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: HealoraColors.line,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      eq.category,
                                      style: HealoraTypography.label(
                                        color: HealoraColors.slate,
                                        isBangla: state.isBangla,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  HealoraStatusPill(
                                    label: eq.statusLabel,
                                    type: pillType,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Model: ${eq.model} · Serial: ${eq.serialNumber}',
                                style: HealoraTypography.caption(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Quick toggle status button
                        if (eq.status == EquipmentStatus.outOfService) ...[
                          HealoraButton.small(
                            label: state.t(
                              'Restore to Service',
                              'পুনরায় চালু করুন',
                            ),
                            onPressed: () {
                              controller.updateStatus(
                                eq.id,
                                EquipmentStatus.available,
                                notes:
                                    'Recalibrated and passed bench inspection',
                              );
                            },
                            isBangla: state.isBangla,
                          ),
                        ] else ...[
                          HealoraButton.small(
                            label: state.t(
                              'Flag Maintenance',
                              'রক্ষণাবেক্ষণে পাঠান',
                            ),
                            onPressed: () {
                              controller.updateStatus(
                                eq.id,
                                EquipmentStatus.outOfService,
                                notes:
                                    'Reported faulty during clinical workflow',
                              );
                            },
                            isBangla: state.isBangla,
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 14.h),
                    const Divider(color: HealoraColors.line, height: 1),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: HealoraColors.okFg,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${state.t("Last Calibration:", "সর্বশেষ ক্যালিব্রেশন:")} ${eq.lastCalibration}',
                          style: HealoraTypography.caption(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        const Icon(
                          Icons.event_repeat,
                          size: 16,
                          color: HealoraColors.warnFg,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${state.t("Next Due:", "পরবর্তী মেয়াদ:")} ${eq.nextCalibrationDue}',
                          style:
                              HealoraTypography.caption(
                                color:
                                    eq.status == EquipmentStatus.calibrationDue
                                    ? HealoraColors.warnFg
                                    : HealoraColors.slate,
                                isBangla: state.isBangla,
                              ).copyWith(
                                fontWeight:
                                    eq.status == EquipmentStatus.calibrationDue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          eq.notes,
                          style: HealoraTypography.micro(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
