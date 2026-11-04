import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/services/healora_state.dart';
import 'package:healora/core/common/widgets/healora_card.dart';

class ReportsScreen extends StatelessWidget {
  final HealoraState state;

  const ReportsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final metrics = state.metrics;

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
                      'Operational Reports & SLA Performance',
                      'অপারেশনাল রিপোর্ট ও এসএলএ পারফরম্যান্স',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.t(
                      'Aggregated metrics on hub capacity utilisation, waiting duration, data completeness, and sync health.',
                      'হাব ক্যাপাসিটি ব্যবহার, অপেক্ষার সময়কাল, তথ্য পূর্ণতা এবং ডাটাবেজ সিঙ্ক নির্ভরযোগ্যতার সামগ্রিক হিসাব।',
                    ),
                    style: HealoraTypography.caption(
                      color: HealoraColors.slate,
                      isBangla: state.isBangla,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: HealoraColors.paper,
                  borderRadius: HealoraSpacing.borderControl,
                  border: Border.all(color: HealoraColors.line, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.refresh,
                      size: 16,
                      color: HealoraColors.teal,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      state.t(
                        'Refreshed: 09:50 AM BST',
                        'আপডেট: ০৯:৫০ সকাল (বাংলাদেশ সময়)',
                      ),
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

          const SizedBox(height: 20),

          // PRD Section 8.11 Ethical Metrics Notice
          HealoraCard.tint(
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
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
                          'Clinical Safety Governance Principle (PRD 8.11 & 19)',
                          'ক্লিনিক্যাল নিরাপত্তা ও নীতিগত মূল্যায়ন নীতিমালা',
                        ),
                        style: HealoraTypography.body(
                          fontWeight: FontWeight.w600,
                          color: HealoraColors.pine,
                          isBangla: state.isBangla,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.t(
                          'Healora strictly avoids individual staff leaderboards based solely on patient throughput, as speed-based incentives risk rushed measurements or skipped clinical steps. Aggregate process quality and protocol adherence are measured.',
                          'গতি বৃদ্ধির প্রতিযোগিতায় যাতে ক্লিনিক্যাল গুণগত মান বা সতর্কতা ব্যাহত না হয়, সেজন্য ব্যক্তিভিত্তিক সংখ্যাগত তুলনা পরিহার করে সামগ্রিক সেবার মান ও প্রটোকল অনুসরণ পর্যবেক্ষণ করা হয়।',
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

          // KPI Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final int count = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: count,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.0,
                children: [
                  HealoraStatTile(
                    label: state.t('Sync Success Rate', 'সিঙ্ক সফলতা হার'),
                    value: '${metrics.syncSuccessRate}%',
                    subtitle: state.t(
                      'Zero data loss over 1,420 readings',
                      '১,৪২০টি রিডিংয়ে শূন্য ডেটা লস',
                    ),
                    valueColor: HealoraColors.okFg,
                    icon: const Icon(
                      Icons.sync_alt,
                      color: HealoraColors.okFg,
                      size: 22,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t(
                      'Required Data Completeness',
                      'বাধ্যতামূলক তথ্য পূর্ণতা',
                    ),
                    value: '${metrics.requiredDataCompleteness}%',
                    subtitle: state.t(
                      'Protocol v2.4 adherence',
                      'প্রটোকল ভার্সন ২.৪ মানসম্মত',
                    ),
                    valueColor: HealoraColors.teal,
                    icon: const Icon(
                      Icons.assignment_turned_in,
                      color: HealoraColors.teal,
                      size: 22,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t(
                      'Median Check-in to Service',
                      'গড় চেক-ইন থেকে সেবা সময়',
                    ),
                    value: '${metrics.averageWaitMinutes} min',
                    subtitle: state.t(
                      'Target: under 20 minutes',
                      'লক্ষ্যমাত্রা: ২০ মিনিটের কম',
                    ),
                    valueColor: HealoraColors.ink,
                    icon: const Icon(
                      Icons.timer,
                      color: HealoraColors.ink,
                      size: 22,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t(
                      'Capacity Utilisation Rate',
                      'ধারণক্ষমতা ব্যবহার হার',
                    ),
                    value: '84.6%',
                    subtitle: state.t(
                      '32 filled / 35 maximum',
                      '৩৫ এর মধ্যে ৩২ জন সেবা গ্রহণকারী',
                    ),
                    valueColor: HealoraColors.ink,
                    icon: const Icon(
                      Icons.pie_chart_outline,
                      color: HealoraColors.ink,
                      size: 22,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t('No-Show Rate', 'অনুপস্থিতির হার'),
                    value: '4.8%',
                    subtitle: state.t(
                      'Decreased with SMS reminders',
                      'এসএমএস সতর্কবার্তায় কমেছে',
                    ),
                    valueColor: HealoraColors.okFg,
                    icon: const Icon(
                      Icons.person_off_outlined,
                      color: HealoraColors.okFg,
                      size: 22,
                    ),
                    isBangla: state.isBangla,
                  ),
                  HealoraStatTile(
                    label: state.t(
                      'Equipment Readiness Rate',
                      'যন্ত্রপাতি সক্রিয়তা হার',
                    ),
                    value: '93.3%',
                    subtitle: state.t(
                      '1 device undergoing calibration',
                      '১টি যন্ত্রের ক্যালিব্রেশন চলমান',
                    ),
                    valueColor: HealoraColors.slate,
                    icon: const Icon(
                      Icons.medical_services,
                      color: HealoraColors.slate,
                      size: 22,
                    ),
                    isBangla: state.isBangla,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          // Regional Comparison Card
          Text(
            state.t(
              'Regional Hub Performance Summary',
              'আঞ্চলিক হাব কার্যকারিতা তুলনা',
            ),
            style: HealoraTypography.h2(isBangla: state.isBangla),
          ),
          const SizedBox(height: 12),

          HealoraCard(
            child: Column(
              children: [
                _buildReportRow(
                  'Manikganj Rural Care Hub (HUB-MKG-01)',
                  'Dhaka Division',
                  '88% Utilisation',
                  '14 min wait',
                  '100% Sync',
                  state.isBangla,
                ),
                const Divider(color: HealoraColors.line, height: 20),
                _buildReportRow(
                  'Nilphamari North Hub & Camp (HUB-NLP-02)',
                  'Rangpur Division',
                  '92% Utilisation',
                  '18 min wait',
                  '99.1% Sync',
                  state.isBangla,
                ),
                const Divider(color: HealoraColors.line, height: 20),
                _buildReportRow(
                  'Cox\'s Bazar Coastal Care Hub (HUB-CXB-03)',
                  'Chattogram Division',
                  '79% Utilisation',
                  '12 min wait',
                  '100% Sync',
                  state.isBangla,
                ),
                const Divider(color: HealoraColors.line, height: 20),
                _buildReportRow(
                  'Sylhet Sreemangal Tea Estate Hub (HUB-SYL-04)',
                  'Sylhet Division',
                  '81% Utilisation',
                  '15 min wait',
                  '98.9% Sync',
                  state.isBangla,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(
    String hubName,
    String division,
    String util,
    String wait,
    String sync,
    bool isBangla,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: HealoraColors.mist,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.apartment,
            size: 18,
            color: HealoraColors.pine,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hubName,
                style: HealoraTypography.bodySmall(
                  fontWeight: FontWeight.w600,
                  isBangla: isBangla,
                ),
              ),
              Text(
                division,
                style: HealoraTypography.micro(
                  color: HealoraColors.slate,
                  isBangla: isBangla,
                ),
              ),
            ],
          ),
        ),
        Text(
          util,
          style: HealoraTypography.caption(
            fontWeight: FontWeight.w600,
            color: HealoraColors.ink,
            isBangla: isBangla,
          ),
        ),
        const SizedBox(width: 24),
        Text(
          wait,
          style: HealoraTypography.caption(
            fontWeight: FontWeight.w600,
            color: HealoraColors.slate,
            isBangla: isBangla,
          ),
        ),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: HealoraColors.okBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            sync,
            style: HealoraTypography.label(
              color: HealoraColors.okFg,
              isBangla: isBangla,
            ),
          ),
        ),
      ],
    );
  }
}
