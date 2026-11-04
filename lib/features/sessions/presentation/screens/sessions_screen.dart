import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/features/sessions/controllers/sessions_controller.dart';

class SessionsScreen extends StatelessWidget {
  final SessionsController controller;

  const SessionsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
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
                      'Hub Operating Sessions & Health Camps',
                      'হাব অপারেটিং সেশন ও হেলথ ক্যাম্প',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.t(
                      'Manage scheduled clinic days, mobile camps, capacity slots, and mandatory staffing gates.',
                      'ক্লিনিক সেশন, স্বাস্থ্য ক্যাম্প, অ্যাপয়েন্টমেন্ট ক্যাপাসিটি এবং প্রয়োজনীয় টিম পরিচালনা।',
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
                  'Create Session or Camp',
                  'নতুন সেশন / ক্যাম্প খুলুন',
                ),
                onPressed: () => _showCreateSessionModal(context),
                isBangla: state.isBangla,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // PRD Acceptance Rule Card (Section 9.1 & 12.2)
          HealoraCard.tint(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  color: HealoraColors.teal,
                  size: 24,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.t(
                          'Pre-Publish Clinical & Staffing Validation Gate',
                          'প্রকাশের পূর্বে ক্লিনিক্যাল ও জনবল যাচাইকরণ নীতিমালা',
                        ),
                        style: HealoraTypography.body(
                          fontWeight: FontWeight.w600,
                          color: HealoraColors.pine,
                          isBangla: state.isBangla,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.t(
                          'Per PRD G-07: A session cannot be published or accept patient bookings unless mandatory team roles (Special Team Lead, Field Worker, Local Doctor) and calibrated medical equipment are actively confirmed.',
                          'PRD G-07 অনুচ্ছেদ অনুযায়ী: ন্যূনতম প্রয়োজনীয় স্বাস্থ্যকর্মী, অনুমোদিত ডাক্তার এবং সক্রিয় পরিমাপক যন্ত্রপাতি নিশ্চিত না হওয়া পর্যন্ত কোনো সেশন বুকিংয়ের জন্য উন্মুক্ত করা যাবে না।',
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

          const SizedBox(height: 24),

          // List of Sessions
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, idx) {
              final HubSession session = state.sessions[idx];

              return HealoraCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: session.sessionType == 'Special Camp'
                                ? const Color(0xFFFBE4E4)
                                : HealoraColors.sage200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            session.sessionType == 'Special Camp'
                                ? Icons.campaign
                                : Icons.calendar_today,
                            color: session.sessionType == 'Special Camp'
                                ? HealoraColors.bad
                                : HealoraColors.pine,
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
                                    session.title,
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
                                      session.sessionType,
                                      style: HealoraTypography.label(
                                        color: HealoraColors.pine,
                                        isBangla: state.isBangla,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                              const SizedBox(height: 4),
                              Text(
                                '${session.hubName} · ${session.date} (${session.startTime} – ${session.endTime})',
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
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: session.isFull
                                    ? HealoraColors.clay
                                    : HealoraColors.ink,
                              ),
                            ),
                            Text(
                              state.t(
                                '${session.bookedCount} Booked + ${session.walkInCurrent} Walk-in',
                                '${session.bookedCount} বুকড + ${session.walkInCurrent} ওয়াক-ইন',
                              ),
                              style: HealoraTypography.caption(
                                color: HealoraColors.slate,
                                isBangla: state.isBangla,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: HealoraColors.line, height: 1),
                    const SizedBox(height: 16),

                    // Required Staffing & Equipment Checklist Chips
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.t(
                                  'MANDATORY STAFF ROSTER (VERIFIED)',
                                  'অনুমোদিত স্টাফ রোস্টার',
                                ),
                                style: HealoraTypography.label(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: session.requiredRoles.map((role) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HealoraColors.okBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: HealoraColors.okFg,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          role,
                                          style: HealoraTypography.caption(
                                            color: HealoraColors.okFg,
                                            isBangla: state.isBangla,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.t(
                                  'MANDATORY EQUIPMENT (CALIBRATED)',
                                  'প্রয়োজনীয় পরিমাপক যন্ত্রপাতি',
                                ),
                                style: HealoraTypography.label(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: session.requiredEquipment.map((eq) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HealoraColors.mist,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.medical_services,
                                          size: 12,
                                          color: HealoraColors.teal,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          eq,
                                          style: HealoraTypography.caption(
                                            color: HealoraColors.pine,
                                            isBangla: state.isBangla,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Notes & Lead
                    Row(
                      children: [
                        const Icon(
                          Icons.notes,
                          size: 16,
                          color: HealoraColors.slate,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            session.notes,
                            style: HealoraTypography.caption(
                              color: HealoraColors.slate,
                              isBangla: state.isBangla,
                            ),
                          ),
                        ),
                        HealoraButton.small(
                          label: state.t('View Booked Roster', 'রোগী তালিকা'),
                          onPressed: () => controller.openQueue(),
                          isBangla: state.isBangla,
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

  void _showCreateSessionModal(BuildContext context) {
    final state = controller.state;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: HealoraSpacing.borderCard,
          ),
          backgroundColor: HealoraColors.paper,
          title: Text(
            state.t(
              'Schedule New Session / Health Camp',
              'নতুন সেশন অথবা স্বাস্থ্য ক্যাম্প শিডিউল করুন',
            ),
            style: HealoraTypography.h2(isBangla: state.isBangla),
          ),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HealoraTextField(
                  label: state.t('Session Title', 'সেশনের শিরোনাম'),
                  hintText: 'e.g. Chronic Care Outreach Camp - Day 2',
                  isBangla: state.isBangla,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: HealoraTextField(
                        label: state.t('Date', 'তারিখ'),
                        hintText: '2026-11-06',
                        isBangla: state.isBangla,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HealoraTextField(
                        label: state.t('Operating Hours', 'সময়সূচী'),
                        hintText: '09:00 AM – 02:00 PM',
                        isBangla: state.isBangla,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: HealoraTextField(
                        label: state.t(
                          'Online Slot Capacity',
                          'অ্যাপয়েন্টমেন্ট কোটা',
                        ),
                        hintText: '30',
                        isBangla: state.isBangla,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HealoraTextField(
                        label: state.t(
                          'Reserved Walk-in Capacity',
                          'সংরক্ষিত ওয়াক-ইন কোটা',
                        ),
                        hintText: '15',
                        isBangla: state.isBangla,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            HealoraButton.secondary(
              label: state.t('Cancel', 'বাতিল'),
              onPressed: () => Navigator.pop(ctx),
              isBangla: state.isBangla,
            ),
            HealoraButton.primary(
              label: state.t(
                'Validate Prerequisites & Publish',
                'যাচাইপূর্বক প্রকাশ করুন',
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealoraColors.ink,
                    content: Text(
                      state.t(
                        'Session created and published to Patient & Team apps',
                        'সেশন অনুমোদিত ও প্রকাশিত হয়েছে',
                      ),
                    ),
                  ),
                );
              },
              isBangla: state.isBangla,
            ),
          ],
        );
      },
    );
  }
}
