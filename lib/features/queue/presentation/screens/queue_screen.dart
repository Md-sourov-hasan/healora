import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/features/queue/controllers/queue_controller.dart';

class QueueScreen extends StatelessWidget {
  final QueueController controller;

  const QueueScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final filteredQueue = controller.filteredQueue;
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Text(
                          state.t(
                            'Live Hub Queue & Station Flow',
                            'লাইভ হাব কিউ ও স্টেশন প্রবাহ',
                          ),
                          style: HealoraTypography.h1(isBangla: state.isBangla),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: HealoraColors.okBg,
                            borderRadius: HealoraSpacing.borderPill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: HealoraColors.okFg,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                state.t(
                                  'LIVE SYNC ACTIVE',
                                  'সরাসরি আপডেট চালু',
                                ),
                                style: HealoraTypography.label(
                                  color: HealoraColors.okFg,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      state.t(
                        'Real-time token management across registration, measurement stations, and doctor consultation.',
                        'নিবন্ধন, ভাইটালস স্টেশন ও ডাক্তার রিভিউয়ের সার্বক্ষণিক সিরিয়াল ব্যবস্থাপনা।',
                      ),
                      style: HealoraTypography.caption(
                        color: HealoraColors.slate,
                        isBangla: state.isBangla,
                      ),
                    ),
                  ],
                ),
              ),
              // Public Display Toggle (masks patient PII for waiting room monitors)
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.togglePublicDisplayMode();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: controller.isPublicDisplayMode
                            ? HealoraColors.ink
                            : HealoraColors.paper,
                        borderRadius: HealoraSpacing.borderControl,
                        border: Border.all(color: HealoraColors.line, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            controller.isPublicDisplayMode
                                ? Icons.tv
                                : Icons.tv_off,
                            size: 18,
                            color: controller.isPublicDisplayMode
                                ? Colors.white
                                : HealoraColors.slate,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            state.t(
                              controller.isPublicDisplayMode
                                  ? 'Waiting Room TV Mode (PII Masked)'
                                  : 'Staff View (Full)',
                              controller.isPublicDisplayMode
                                  ? 'টিভি মোড (নাম লукানো)'
                                  : 'স্টাফ ভিউ (সম্পূর্ণ)',
                            ),
                            style: HealoraTypography.caption(
                              color: controller.isPublicDisplayMode
                                  ? Colors.white
                                  : HealoraColors.ink,
                              isBangla: state.isBangla,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Station Queues Summary (4 Stations at Manikganj Hub)
          LayoutBuilder(
            builder: (context, constraints) {
              final int count = constraints.maxWidth > 900
                  ? 4
                  : (constraints.maxWidth > 500 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: state.stations.length,
                itemBuilder: (context, index) {
                  final HubStation station = state.stations[index];
                  final bool isFiltered =
                      controller.selectedStationFilter == station.id;

                  return HealoraCard(
                    variant: isFiltered
                        ? HealoraCardVariant.hero
                        : HealoraCardVariant.flat,
                    onTap: () {
                      controller.toggleStationFilter(station.id);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                station.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: HealoraTypography.caption(
                                  color: isFiltered
                                      ? Colors.white
                                      : HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: station.status == StationStatus.available
                                    ? HealoraColors.okFg
                                    : (station.status == StationStatus.busy
                                          ? HealoraColors.teal
                                          : HealoraColors.bad),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${station.activeQueueLength}',
                                  style: HealoraTypography.tabular(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: isFiltered
                                        ? Colors.white
                                        : HealoraColors.ink,
                                  ),
                                ),
                                Text(
                                  state.t('in queue', 'অপেক্ষমাণ'),
                                  style: HealoraTypography.micro(
                                    color: isFiltered
                                        ? Colors.white70
                                        : HealoraColors.slate,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Text(
                                controller.stationLead(station.assignedStaff),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: HealoraTypography.micro(
                                  color: isFiltered
                                      ? Colors.white70
                                      : HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 28.h),

          // Live Queue Table / Cards
          Text(
            controller.selectedStationFilter == null
                ? state.t(
                    'Active Tokens in Hub Queue (${filteredQueue.length})',
                    'চলমান সিরিয়াল তালিকা (${filteredQueue.length})',
                  )
                : state.t(
                    'Filtered by Selected Station',
                    'নির্বাচিত স্টেশনের তালিকা',
                  ),
            style: HealoraTypography.h2(isBangla: state.isBangla),
          ),
          SizedBox(height: 12.h),

          if (filteredQueue.isEmpty) ...[
            HealoraCard.tint(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.done_all,
                        color: HealoraColors.okFg,
                        size: 36,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.t(
                          'No waiting patients at this station',
                          'এই স্টেশনে কোনো রোগী অপেক্ষমাণ নেই',
                        ),
                        style: HealoraTypography.body(
                          fontWeight: FontWeight.w600,
                          isBangla: state.isBangla,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredQueue.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) {
                final QueueTicket tkt = filteredQueue[idx];

                return HealoraCard(
                  child: Row(
                    children: [
                      // Token Badge (Large high contrast)
                      Container(
                        width: 140.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: tkt.status == QueueStatus.inService
                              ? HealoraColors.ink
                              : HealoraColors.mist,
                          borderRadius: HealoraSpacing.borderControl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.t('TOKEN', 'টোকেন'),
                              style: HealoraTypography.label(
                                color: tkt.status == QueueStatus.inService
                                    ? Colors.white70
                                    : HealoraColors.slate,
                                isBangla: state.isBangla,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              tkt.tokenNumber,
                              style: HealoraTypography.tabular(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: tkt.status == QueueStatus.inService
                                    ? Colors.white
                                    : HealoraColors.pine,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 20.w),

                      // Patient & Station Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  controller.patientLabel(tkt),
                                  style: HealoraTypography.h3(
                                    color: HealoraColors.ink,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                if (!controller.isPublicDisplayMode)
                                  Text(
                                    '(${tkt.patientCode})',
                                    style: HealoraTypography.caption(
                                      color: HealoraColors.slate,
                                      isBangla: state.isBangla,
                                    ),
                                  ),
                                SizedBox(width: 10.w),
                                HealoraStatusPill(
                                  label: tkt.statusLabel,
                                  type: tkt.status == QueueStatus.inService
                                      ? HealoraPillType.inService
                                      : (tkt.status == QueueStatus.waiting
                                            ? HealoraPillType.awaiting
                                            : HealoraPillType.completed),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${tkt.currentStationName} · ${state.t("Assigned to:", "দায়িত্বে:")} ${tkt.assignedWorker ?? "Pending"}',
                              style: HealoraTypography.caption(
                                color: HealoraColors.slate,
                                isBangla: state.isBangla,
                              ),
                            ),
                            if (tkt.delayReason != null) ...[
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: HealoraColors.warnFg,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${state.t("Delay note:", "বিলম্ব নোট:")} ${tkt.delayReason}',
                                    style: HealoraTypography.micro(
                                      color: HealoraColors.warnFg,
                                      isBangla: state.isBangla,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Wait Duration
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.hourglass_empty,
                                size: 16,
                                color: HealoraColors.slate,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${tkt.waitDurationMinutes} min',
                                style: HealoraTypography.tabular(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: tkt.waitDurationMinutes > 20
                                      ? HealoraColors.clay
                                      : HealoraColors.ink,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${state.t("Arrived:", "আগমন:")} ${tkt.arrivalTime}',
                            style: HealoraTypography.micro(
                              color: HealoraColors.slate,
                              isBangla: state.isBangla,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 20.w),

                      // Actions
                      if (!controller.isPublicDisplayMode)
                        ..._buildTicketActions(context, controller, tkt),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildTicketActions(
    BuildContext context,
    QueueController controller,
    QueueTicket tkt,
  ) {
    final state = controller.state;
    return [
      if (!controller.isPublicDisplayMode) ...[
        if (tkt.status == QueueStatus.waiting) ...[
          HealoraButton.small(
            label: state.t('Call Patient', 'রোগীকে ডাকুন'),
            onPressed: () {
              controller.callPatient(tkt);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: HealoraColors.ink,
                  content: Text(
                    state.t(
                      'Called ${tkt.tokenNumber} to Station 2',
                      '${tkt.tokenNumber} কে ভাইটালস স্টেশনে ডাকা হয়েছে',
                    ),
                  ),
                ),
              );
            },
            isBangla: state.isBangla,
          ),
        ] else if (tkt.status == QueueStatus.inService) ...[
          HealoraButton.small(
            label: state.t('Open Vitals Tool', 'ভাইটালস এন্ট্রি'),
            onPressed: controller.openVitals,
            isBangla: state.isBangla,
          ),
        ] else ...[
          const Icon(Icons.check_circle, color: HealoraColors.okFg, size: 24),
        ],
      ],
    ];
  }
}
