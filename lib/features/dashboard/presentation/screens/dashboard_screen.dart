import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/features/dashboard/controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller;

  const DashboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final metrics = controller.metrics;
    final currentHub = controller.currentHub;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner with Organic Wash or Hero style
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              gradient: HealoraColors.washGradient,
              borderRadius: HealoraSpacing.borderCard,
              border: Border.all(color: HealoraColors.line, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.t(
                          'Operations Dashboard · Today\'s Hub Live Status',
                          'অপারেশনস ড্যাশবোর্ড · আজকের হাব লাইভ স্ট্যাটাস',
                        ),
                        style: HealoraTypography.label(
                          color: HealoraColors.teal,
                          isBangla: state.isBangla,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.t(
                          currentHub.name,
                          'মানিকগঞ্জ গ্রামীণ কেয়ার হাব',
                        ),
                        style: HealoraTypography.h1(
                          isBangla: state.isBangla,
                          color: HealoraColors.pine,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        state.t(
                          'Catchment: ${currentHub.catchmentArea} · Hours: ${currentHub.operatingHours}',
                          'সার্ভিস এলাকা: সিংগাইর ও বায়রা ইউনিয়ন · সময়: শনি–বৃহস্পতি, সকাল ৮:৩০–বিকাল ৪:৩০',
                        ),
                        style: HealoraTypography.caption(
                          color: HealoraColors.slate,
                          isBangla: state.isBangla,
                        ),
                      ),
                    ],
                  ),
                ),
                HealoraStatusPill(
                  label: currentHub.statusLabel,
                  type: currentHub.status == HubStatus.active
                      ? HealoraPillType.completed
                      : HealoraPillType.awaiting,
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Operational Stat Tiles (Section 7.6: "Stat tiles are 3-up, r18, flat.")
          LayoutBuilder(
            builder: (context, constraints) {
              final int crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
                children: [
                  HealoraStatTile(
                    label: state.t('Total Booked Today', 'আজকের মোট বুকিং'),
                    value: '${metrics.totalAppointments}',
                    subtitle: state.t(
                      'Capacity: 35 slots',
                      'মোট ধারণক্ষমতা: ৩৫',
                    ),
                    icon: const Icon(
                      Icons.people_alt_outlined,
                      color: HealoraColors.teal,
                      size: 20,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t(
                      'Checked-in / In Service',
                      'উপস্থিত / সেবাধীন',
                    ),
                    value: '${metrics.checkedInCount + metrics.inServiceCount}',
                    subtitle: state.t(
                      'Avg wait: ${metrics.averageWaitMinutes}m',
                      'গড় অপেক্ষা: ১৪ মিনিট',
                    ),
                    valueColor: HealoraColors.teal,
                    icon: const Icon(
                      Icons.timer_outlined,
                      color: HealoraColors.teal,
                      size: 20,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t('Encounters Completed', 'সম্পন্ন চেকআপ'),
                    value: '${metrics.completedCount}',
                    subtitle: state.t(
                      'Verified central sync',
                      'কেন্দ্রীয় রেকর্ডে যুক্ত',
                    ),
                    valueColor: HealoraColors.okFg,
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: HealoraColors.okFg,
                      size: 20,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t(
                      'Sync Outbox / Alerts',
                      'সিঙ্ক আউটবক্স / অ্যালার্ট',
                    ),
                    value: '${metrics.syncPendingCount}',
                    subtitle: state.isOffline
                        ? state.t(
                            'Offline: pending auto-sync',
                            'অফলাইন: অপেক্ষমাণ',
                          )
                        : state.t(
                            'Network stable 100%',
                            'নেটওয়ার্ক স্থিতিশীল',
                          ),
                    valueColor: metrics.syncPendingCount > 0
                        ? HealoraColors.warnFg
                        : HealoraColors.slate,
                    icon: Icon(
                      metrics.syncPendingCount > 0
                          ? Icons.cloud_queue
                          : Icons.cloud_done,
                      color: metrics.syncPendingCount > 0
                          ? HealoraColors.warnFg
                          : HealoraColors.okFg,
                      size: 20,
                    ),
                    isBangla: state.isBangla,
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 24.h),

          // Operational Action Shortcuts
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              HealoraButton.primary(
                label: state.t(
                  'Patient Check-in / Search',
                  'রোগী চেক-ইন ও অনুসন্ধান',
                ),
                onPressed: () => controller.openSection(4),
                isBangla: state.isBangla,
              ),
              HealoraButton.secondary(
                label: state.t(
                  'View Live Queue (${state.queue.length})',
                  'লাইভ কিউ দেখুন (${state.queue.length})',
                ),
                onPressed: () => controller.openSection(3),
                icon: const Icon(
                  Icons.format_list_numbered,
                  size: 18,
                  color: HealoraColors.ink,
                ),
                isBangla: state.isBangla,
              ),
              HealoraButton.secondary(
                label: state.t(
                  'Special Team Vitals Tool',
                  'স্পেশাল টিম ভাইটালস টুল',
                ),
                onPressed: () => controller.openSection(5),
                icon: const Icon(
                  Icons.monitor_heart,
                  size: 18,
                  color: HealoraColors.teal,
                ),
                isBangla: state.isBangla,
              ),
              HealoraButton.small(
                label: state.t('Stations & Devices', 'স্টেশন ও যন্ত্রপাতি'),
                onPressed: () => controller.openSection(6),
                isBangla: state.isBangla,
              ),
            ],
          ),

          SizedBox(height: 28.h),

          // Today's Operating Sessions Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.t(
                  'Today\'s Hub Sessions & Camps',
                  'আজকের হাব সেশন ও স্বাস্থ্য ক্যাম্প',
                ),
                style: HealoraTypography.h2(isBangla: state.isBangla),
              ),
              HealoraButton.text(
                label: state.t('Manage Sessions', 'সকল সেশন'),
                onPressed: () => controller.openSection(2),
                isBangla: state.isBangla,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.sessions.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, idx) {
              final HubSession session = state.sessions[idx];
              final double fillRatio = session.totalCapacity > 0
                  ? (session.totalAttending / session.totalCapacity).clamp(
                      0.0,
                      1.0,
                    )
                  : 0.0;

              return HealoraCard(
                onTap: () => controller.openSection(2),
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
                            color: session.sessionType == 'Special Camp'
                                ? HealoraColors.mist
                                : HealoraColors.sage200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            session.sessionType == 'Special Camp'
                                ? Icons.campaign
                                : Icons.local_hospital,
                            color: HealoraColors.pine,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    session.title,
                                    style: HealoraTypography.h3(
                                      color: HealoraColors.ink,
                                      isBangla: state.isBangla,
                                    ),
                                  ),
                                  HealoraStatusPill(
                                    label: session.statusLabel,
                                    type:
                                        session.status ==
                                            SessionStatus.inProgress
                                        ? HealoraPillType.inService
                                        : (session.status ==
                                                  SessionStatus.openForBooking
                                              ? HealoraPillType.completed
                                              : HealoraPillType.draft),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${session.hubName} · ${session.startTime} – ${session.endTime}',
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
                              '${session.totalAttending} / ${session.totalCapacity}',
                              style: HealoraTypography.tabular(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: HealoraColors.ink,
                              ),
                            ),
                            Text(
                              state.t('Capacity Filled', 'ক্যাপাসিটি পূর্ণ'),
                              style: HealoraTypography.micro(
                                color: HealoraColors.slate,
                                isBangla: state.isBangla,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 14.h),

                    // Capacity Progress Bar (Chapter 7.5: 4px step bar)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: fillRatio,
                        minHeight: 4,
                        backgroundColor: HealoraColors.sage200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          fillRatio > 0.9
                              ? HealoraColors.warn
                              : HealoraColors.teal,
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_pin,
                                size: 16,
                                color: HealoraColors.slate,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  '${state.t("Lead:", "দায়িত্বপ্রাপ্ত:")} ${session.assignedLead}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HealoraTypography.caption(
                                    color: HealoraColors.slate,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '${session.bookedCount} ${state.t("Booked", "বুকড")} · ${session.walkInCurrent} ${state.t("Walk-ins", "ওয়াক-ইন")}',
                          style: HealoraTypography.caption(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 28.h),

          // Operational Governance & Bangladesh Compliance Banner
          HealoraCard.tint(
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: HealoraColors.sage200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security,
                    color: HealoraColors.pine,
                    size: 22,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.t(
                          'Bangladesh Telehealth & Data Protection Compliance Active',
                          'বাংলাদেশ টেলিহেলথ ও উপাত্ত সুরক্ষা আইন ২০২৬ অনুসারী নিশ্চিতকরণ',
                        ),
                        style: HealoraTypography.body(
                          fontWeight: FontWeight.w600,
                          color: HealoraColors.pine,
                          isBangla: state.isBangla,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        state.t(
                          'Patient measurements are attested via BMDC-compliant health worker profiles and encrypted at rest. Data resides exclusively in Bangladesh per DGHS 2026 Telehealth Directives.',
                          'রোগীর ভাইটালস তথ্য BMDC অনুমোদিত স্বাস্থ্যকর্মী প্রটোকল দ্বারা যাচাইকৃত। DGHS ২০২৬ নীতিমালা মোতাবেক সমস্ত উপাত্ত বাংলাদেশে স্থানীয় সার্ভারে সংরক্ষিত।',
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
        ],
      ),
    );
  }
}
