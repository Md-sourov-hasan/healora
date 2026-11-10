import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';

class NotificationsScreen extends StatelessWidget {
  final HealoraState state;

  const NotificationsScreen({super.key, required this.state});

  List<(String, String, IconData)> _ideas() {
    switch (state.activeRole) {
      case HealoraRole.platformAdmin:
        return [
          (
            'Platform / socket service interruption',
            'লাইভ সেবা বা socket সংযোগ বিচ্ছিন্ন',
            Icons.cloud_off_outlined,
          ),
          (
            'Regional capacity and sync backlog summary',
            'আঞ্চলিক ধারণক্ষমতা ও sync backlog-এর সারাংশ',
            Icons.insights_outlined,
          ),
          (
            'Security or access anomaly',
            'নিরাপত্তা বা প্রবেশ-সংক্রান্ত অস্বাভাবিকতা',
            Icons.gpp_maybe_outlined,
          ),
        ];
      case HealoraRole.regionalManager:
      case HealoraRole.hubManager:
        return [
          (
            'Session capacity, schedule, or cancellation',
            'সেশনের ধারণক্ষমতা, সময়সূচি বা বাতিল',
            Icons.event_busy_outlined,
          ),
          (
            'Queue wait time exceeds service target',
            'কিউয়ের অপেক্ষা নির্ধারিত সীমা ছাড়িয়েছে',
            Icons.hourglass_top_outlined,
          ),
          (
            'Equipment or station unavailable',
            'যন্ত্রপাতি বা স্টেশন ব্যবহার অনুপযোগী',
            Icons.medical_services_outlined,
          ),
          (
            'Hub sync backlog or unresolved operation',
            'হাবের sync backlog বা অমীমাংসিত কাজ',
            Icons.sync_problem_outlined,
          ),
        ];
      case HealoraRole.receptionist:
        return [
          (
            'Appointment confirmed, changed, or cancelled',
            'অ্যাপয়েন্টমেন্ট নিশ্চিত, পরিবর্তিত বা বাতিল',
            Icons.event_note_outlined,
          ),
          (
            'Session capacity reached for walk-ins',
            'walk-in-এর জন্য সেশনের আসন পূর্ণ',
            Icons.group_off_outlined,
          ),
        ];
      case HealoraRole.queueCoordinator:
        return [
          (
            'Queue delay or stopped station',
            'কিউতে বিলম্ব বা স্টেশনে সেবা বন্ধ',
            Icons.pending_actions_outlined,
          ),
          (
            'Ticket blocked and needs reassignment',
            'টিকিট আটকে আছে, পুনরায় বরাদ্দ দরকার',
            Icons.assignment_late_outlined,
          ),
        ];
      case HealoraRole.equipmentOfficer:
        return [
          (
            'Device service or calibration due',
            'যন্ত্রের সার্ভিস বা ক্যালিব্রেশন বাকি',
            Icons.build_outlined,
          ),
          (
            'Device marked unavailable',
            'যন্ত্র ব্যবহার অনুপযোগী হিসেবে চিহ্নিত',
            Icons.medical_services_outlined,
          ),
        ];
      case HealoraRole.readOnlyAuditor:
        return [
          (
            'De-identified audit or access anomaly',
            'পরিচয়বিহীন অডিট বা প্রবেশ-সংক্রান্ত অস্বাভাবিকতা',
            Icons.policy_outlined,
          ),
        ];
      case HealoraRole.fieldHealthWorker:
        return [
          (
            'Encounter accepted into doctor review queue',
            'এনকাউন্টার ডাক্তার review queue-তে গৃহীত',
            Icons.assignment_turned_in_outlined,
          ),
          (
            'Offline submission waiting, synced, or failed',
            'অফলাইন জমা অপেক্ষায়, sync হয়েছে বা ব্যর্থ',
            Icons.sync_outlined,
          ),
        ];
      case HealoraRole.specialTeamLead:
      case HealoraRole.localDoctor:
      case HealoraRole.registeredMedicalDoctor:
        return [
          (
            'Assigned encounter waiting for review',
            'বরাদ্দকৃত এনকাউন্টার review-এর অপেক্ষায়',
            Icons.medical_information_outlined,
          ),
          (
            'Review completed or returned to worker',
            'review সম্পন্ন বা কর্মীর কাছে ফেরত',
            Icons.assignment_return_outlined,
          ),
        ];
      case HealoraRole.patient:
      case HealoraRole.caregiver:
        return [
          (
            'Appointment reminder or change',
            'অ্যাপয়েন্টমেন্টের স্মরণ বা পরিবর্তন',
            Icons.event_available_outlined,
          ),
          (
            'Own visit queue progress',
            'নিজের সাক্ষাতের কিউ অগ্রগতি',
            Icons.format_list_numbered_outlined,
          ),
          (
            'Care plan or follow-up ready',
            'কেয়ার প্ল্যান বা follow-up প্রস্তুত',
            Icons.health_and_safety_outlined,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final ideas = _ideas();
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 920.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.t('Notifications', 'নোটিফিকেশন'),
                style: HealoraTypography.display(isBangla: state.isBangla),
              ),
              SizedBox(height: 8.h),
              Text(
                state.t(
                  'Recommended alerts for ${state.activeRole.displayName}. This is a review preview; no live notifications are connected yet.',
                  '${state.activeRole.bnDisplayName}-এর জন্য প্রস্তাবিত নোটিফিকেশন। এটি review preview; এখনো live notification সংযুক্ত নয়।',
                ),
                style: HealoraTypography.body(
                  color: HealoraColors.slate,
                  isBangla: state.isBangla,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: HealoraColors.infoBg,
                  borderRadius: HealoraSpacing.borderControl,
                  border: Border.all(color: HealoraColors.line),
                ),
                child: Text(
                  state.t(
                    'Suggested Socket.IO approach: persist notifications, then send small user-, role-, and hub-scoped events. Keep clinical details out of lock-screen and general operations alerts.',
                    'প্রস্তাবিত Socket.IO পদ্ধতি: notification সংরক্ষণ করে user, role ও hub অনুযায়ী সীমাবদ্ধ event পাঠান। lock-screen বা সাধারণ operations alert-এ ক্লিনিক্যাল তথ্য দেবেন না।',
                  ),
                  style: HealoraTypography.bodySmall(
                    color: HealoraColors.pine,
                    isBangla: state.isBangla,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ...ideas.map(
                (idea) => Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: HealoraColors.paper,
                    borderRadius: HealoraSpacing.borderControl,
                    border: Border.all(color: HealoraColors.line),
                    boxShadow: HealoraColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Icon(idea.$3, color: HealoraColors.teal, size: 22),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          state.t(idea.$1, idea.$2),
                          style: HealoraTypography.bodySmall(
                            color: HealoraColors.ink,
                            isBangla: state.isBangla,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
