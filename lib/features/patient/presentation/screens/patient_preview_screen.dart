import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/features/patient/controllers/patient_preview_controller.dart';

class PatientPreviewScreen extends StatelessWidget {
  final PatientPreviewController controller;

  const PatientPreviewScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: HealoraColors.bone,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: HealoraColors.line, width: 2),
          boxShadow: HealoraColors.floatShadow,
        ),
        margin: const EdgeInsets.symmetric(vertical: 20),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Safe Area & Dynamic Island / Status Bar simulator
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                color: const Color(0xFFD7E6E0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: HealoraTypography.tabular(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.signal_cellular_alt, size: 14),
                        SizedBox(width: 4),
                        Icon(Icons.wifi, size: 14),
                        SizedBox(width: 4),
                        Icon(Icons.battery_full, size: 16),
                      ],
                    ),
                  ],
                ),
              ),

              // Patient Header with Avatar & Greeting (Design System Chapter 7.8)
              Container(
                decoration: const BoxDecoration(
                  gradient: HealoraColors.washGradient,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar: RB (Rahima Begum)
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: HealoraColors.sage200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'RB',
                              style: HealoraTypography.caption(
                                color: HealoraColors.pine,
                                isBangla: state.isBangla,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.t(
                                  'Good morning, Rahima',
                                  'সুপ্রভাত, রহিমা বেগম',
                                ),
                                style: HealoraTypography.h2(
                                  color: HealoraColors.ink,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              Text(
                                state.t(
                                  'Tuesday, 10 November · Dhaka',
                                  'মঙ্গলবার, ১০ নভেম্বর · ঢাকা',
                                ),
                                style: HealoraTypography.caption(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification Icon with Clay Badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: HealoraColors.paper,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: HealoraColors.line,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                size: 20,
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: HealoraColors.clay,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Search with Voice Bar (Chapter 7.3)
                    HealoraSearchBar(
                      hintText: state.t(
                        'Ask anything — in Bangla or English',
                        'যেকোনো প্রশ্ন করুন — বাংলায় বা ইংরেজিতে',
                      ),
                      onVoice: () {},
                      isBangla: state.isBangla,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NEXT APPOINTMENT CARD (Design System Chapter 08 Dashboard)
                    HealoraCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.t(
                                  'NEXT APPOINTMENT',
                                  'পরবর্তী অ্যাপয়েন্টমেন্ট',
                                ),
                                style: HealoraTypography.label(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              HealoraStatusPill(
                                label: state.t('Upcoming', 'আসন্ন'),
                                type: HealoraPillType.upcoming,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: HealoraColors.mist,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: HealoraColors.teal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dr. Arjun Mehta',
                                      style: HealoraTypography.h3(
                                        color: HealoraColors.ink,
                                        isBangla: state.isBangla,
                                      ),
                                    ),
                                    Text(
                                      'Interventional Cardiologist · Meridian Heart Institute',
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
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: HealoraColors.bone,
                              borderRadius: HealoraSpacing.borderControl,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: HealoraColors.teal,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.t(
                                      'Thu 12 Nov · 11:30 Dhaka · 11:00 Chennai',
                                      'বৃহস্পতি ১২ নভে · ১১:৩০ ঢাকা · ১১:০০ চেন্নাই',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: HealoraTypography.caption(
                                      color: HealoraColors.ink,
                                      isBangla: state.isBangla,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: HealoraButton.primary(
                                  label: state.t('Join call', 'কল জয়েন করুন'),
                                  onPressed: () {},
                                  showArrowChip: false,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              const SizedBox(width: 10),
                              HealoraButton.small(
                                label: state.t('Reschedule', 'সময় বদলান'),
                                onPressed: () {},
                                isBangla: state.isBangla,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // HERO ACTION CARD (Design System Chapter 7.7)
                    HealoraCard.hero(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x24FFFFFF),
                              borderRadius: HealoraSpacing.borderPill,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  state.t(
                                    'Free to compare',
                                    'বিনামূল্যে যাচাই করুন',
                                  ),
                                  style: HealoraTypography.micro(
                                    color: Colors.white,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.t(
                              'Know the cost before you travel',
                              'ভ্রমণের আগেই চিকিৎসার মোট খরচ জানুন',
                            ),
                            style: HealoraTypography.display(
                              color: Colors.white,
                              isBangla: state.isBangla,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.t(
                              'Real quotes from 5 or 48 hospitals: cost, stay and recovery time.',
                              'ভারত ও থাইল্যান্ডের অনুমোদিত হাসপাতাল থেকে যাচাইকৃত চিকিৎসা খরচ ও বিবরণী।',
                            ),
                            style: HealoraTypography.caption(
                              color: Colors.white70,
                              isBangla: state.isBangla,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Price in Clay format (Chapter 03)
                          Text(
                            '\$4,200–\$5,600',
                            style: HealoraTypography.price(
                              fontSize: 26,
                              color: HealoraColors.clay,
                            ),
                          ),
                          Text(
                            '≈ ৳৫,১২,৪০০ – ৳৬,৮৩,২০০ (Dhaka Bank rate)',
                            style: HealoraTypography.caption(
                              color: Colors.white70,
                              isBangla: true,
                            ),
                          ),
                          const SizedBox(height: 14),
                          HealoraButton.secondary(
                            fullWidth: true,
                            label: state.t('Get quote', 'কোটেশন পান'),
                            onPressed: () {},
                            isBangla: state.isBangla,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Segmented Control (Appointments / Quotes / Prescriptions / Orders)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAE8E1),
                        borderRadius: HealoraSpacing.borderControl,
                      ),
                      child: Row(
                        children: [
                          _buildSegment('Appointments', 'অ্যাপয়েন্টমেন্ট', 0),
                          _buildSegment('Quotes', 'কোটেশন', 1),
                          _buildSegment('Prescriptions', 'প্রেসক্রিপশন', 2),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // VERIFIED HUB VITALS CARD (Shows results uploaded from hub encounter!)
                    HealoraCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.t(
                                    'HUB VITALS & CLINICAL CHECK',
                                    'হাবে পরিমাপকৃত ভাইটালস ফলাফল',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HealoraTypography.label(
                                    color: HealoraColors.slate,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              HealoraStatusPill(
                                label: state.t(
                                  'Verified at Hub',
                                  'হাবে যাচাইকৃত',
                                ),
                                type: HealoraPillType.completed,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Manikganj Rural Care Hub · 4 Nov 2026',
                            style: HealoraTypography.h3(
                              color: HealoraColors.ink,
                              isBangla: state.isBangla,
                            ),
                          ),
                          Text(
                            'Attested by Nasrin Sultana (Special Team) · Reviewed by Dr. Tariqul Islam (BMDC A-54910)',
                            style: HealoraTypography.micro(
                              color: HealoraColors.slate,
                              isBangla: state.isBangla,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Divider(color: HealoraColors.line, height: 1),
                          const SizedBox(height: 12),

                          // Vitals Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildVitalItem('BP', '138/88', 'mmHg', false),
                              _buildVitalItem('Pulse', '76', 'bpm', false),
                              _buildVitalItem('SpO2', '98', '%', false),
                              _buildVitalItem('Glucose', '7.4', 'mmol/L', true),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Doctor signed follow-up instructions
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: HealoraColors.mist,
                              borderRadius: HealoraSpacing.borderControl,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: HealoraColors.okFg,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.t(
                                      'Doctor\'s Advice: Stage 1 Hypertension lifestyle modification. Scheduled follow-up in 14 days at hub.',
                                      'ডাক্তারের পরামর্শ: রক্তচাপ নিয়ন্ত্রণে খাদ্যে লবণের মাত্রা কমান। ১৪ দিন পর হাবে দ্বিতীয়বার চেকআপ করুন।',
                                    ),
                                    style: HealoraTypography.caption(
                                      color: HealoraColors.pine,
                                      isBangla: state.isBangla,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(String titleEn, String titleBn, int index) {
    final bool isSel = controller.selectedSectionIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectSection(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSel
                ? [
                    const BoxShadow(
                      color: Color(0x1F0B1F22),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              controller.state.t(titleEn, titleBn),
              style: HealoraTypography.caption(
                color: isSel ? HealoraColors.ink : HealoraColors.slate,
                isBangla: controller.state.isBangla,
              ).copyWith(fontWeight: isSel ? FontWeight.w700 : FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalItem(
    String label,
    String value,
    String unit,
    bool isWarning,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: HealoraTypography.micro(
            color: HealoraColors.slate,
            isBangla: controller.state.isBangla,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: HealoraTypography.tabular(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isWarning ? HealoraColors.clay : HealoraColors.ink,
          ),
        ),
        Text(
          unit,
          style: HealoraTypography.micro(
            color: HealoraColors.slate,
            isBangla: controller.state.isBangla,
          ),
        ),
      ],
    );
  }
}
