import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/features/hubs/controllers/hubs_controller.dart';

class HubsScreen extends StatelessWidget {
  final HubsController controller;

  const HubsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final filteredHubs = controller.filteredHubs;
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
                      'Physical Care Hubs & Catchment Directory',
                      'গ্রামীণ ফিজিক্যাল কেয়ার হাব ও এরিয়া ডিরেক্টরি',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.t(
                      'Area-based physical service points operating in rural & peri-urban Bangladesh.',
                      'বাংলাদেশে প্রত্যন্ত ও গ্রামীণ অঞ্চলের রোগীদের জন্য নির্ধারিত সেবাকেন্দ্র।',
                    ),
                    style: HealoraTypography.caption(
                      color: HealoraColors.slate,
                      isBangla: state.isBangla,
                    ),
                  ),
                ],
              ),
              HealoraButton.primary(
                label: state.t('Configure New Hub', 'নতুন হাব যুক্ত করুন'),
                onPressed: () => _showAddHubDialog(context),
                isBangla: state.isBangla,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search and Filters
          Row(
            children: [
              Expanded(
                child: HealoraTextField(
                  hintText: state.t(
                    'Search by hub name, code, district or upazila...',
                    'হাবের নাম, কোড, জেলা বা উপজেলা দিয়ে খুঁজুন...',
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: HealoraColors.slate,
                  ),
                  onChanged: controller.setSearchQuery,
                  isBangla: state.isBangla,
                ),
              ),
              const SizedBox(width: 12),
              // Division filter chip
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: HealoraColors.paper,
                  borderRadius: HealoraSpacing.borderControl,
                  border: Border.all(color: HealoraColors.line, width: 1),
                ),
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: controller.selectedDivisionFilter,
                      hint: Text(
                        state.t('All Divisions', 'সকল বিভাগ'),
                        style: HealoraTypography.bodySmall(
                          color: HealoraColors.slate,
                          isBangla: state.isBangla,
                        ),
                      ),
                      onChanged: controller.setDivisionFilter,
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(state.t('All Divisions', 'সকল বিভাগ')),
                        ),
                        const DropdownMenuItem<String?>(
                          value: 'Dhaka',
                          child: Text('Dhaka (ঢাকা)'),
                        ),
                        const DropdownMenuItem<String?>(
                          value: 'Rangpur',
                          child: Text('Rangpur (রংপুর)'),
                        ),
                        const DropdownMenuItem<String?>(
                          value: 'Chattogram',
                          child: Text('Chattogram (চট্টগ্রাম)'),
                        ),
                        const DropdownMenuItem<String?>(
                          value: 'Sylhet',
                          child: Text('Sylhet (সিলেট)'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Hub Cards Grid / List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredHubs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, idx) {
              final Hub hub = filteredHubs[idx];
              final bool isCurrentlySelected = hub.id == state.selectedHubId;

              return HealoraCard(
                borderRadius: HealoraSpacing.borderCard,
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
                            color: isCurrentlySelected
                                ? HealoraColors.ink
                                : HealoraColors.mist,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.apartment,
                            color: isCurrentlySelected
                                ? Colors.white
                                : HealoraColors.pine,
                            size: 26,
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
                                    hub.name,
                                    style: HealoraTypography.h2(
                                      isBangla: state.isBangla,
                                      color: HealoraColors.ink,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                      hub.code,
                                      style: HealoraTypography.label(
                                        color: HealoraColors.pine,
                                        isBangla: state.isBangla,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  HealoraStatusPill(
                                    label: hub.statusLabel,
                                    type: hub.status == HubStatus.active
                                        ? HealoraPillType.completed
                                        : HealoraPillType.declined,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${hub.address} · ${hub.upazila}, ${hub.district}, ${hub.division}',
                                style: HealoraTypography.caption(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isCurrentlySelected)
                          HealoraButton.small(
                            label: state.t(
                              'Switch to this Hub',
                              'এই হাবে পরিবর্তন করুন',
                            ),
                            onPressed: () {
                              controller.selectHub(hub.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: HealoraColors.ink,
                                  content: Text(
                                    state.t(
                                      'Active hub switched to ${hub.name}',
                                      '${hub.name} সক্রিয় করা হয়েছে',
                                    ),
                                  ),
                                ),
                              );
                            },
                            isBangla: state.isBangla,
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: HealoraColors.okBg,
                              borderRadius: HealoraSpacing.borderPill,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: HealoraColors.okFg,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.t('Active Selection', 'সক্রিয় হাব'),
                                  style: HealoraTypography.caption(
                                    color: HealoraColors.okFg,
                                    isBangla: state.isBangla,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: HealoraColors.line, height: 1),
                    const SizedBox(height: 16),

                    // Hub Meta Info Grid
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        _buildMetaItem(
                          Icons.map_outlined,
                          state.t('Catchment Area', 'সার্ভিস এরিয়া'),
                          hub.catchmentArea,
                          state.isBangla,
                        ),
                        _buildMetaItem(
                          Icons.schedule_outlined,
                          state.t('Operating Hours', 'কার্যসময়'),
                          hub.operatingHours,
                          state.isBangla,
                        ),
                        _buildMetaItem(
                          Icons.person_outline,
                          state.t('Hub Manager', 'হাব ম্যানেজার'),
                          hub.managerName,
                          state.isBangla,
                        ),
                        _buildMetaItem(
                          Icons.local_hospital_outlined,
                          state.t(
                            'Emergency Referral SOP',
                            'জরুরি রেফারেল হাসপাতাল',
                          ),
                          '${hub.nearestReferralFacility} (${hub.emergencyHotline})',
                          state.isBangla,
                          highlight: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Supported services chips
                    Text(
                      state.t(
                        'CLINICALLY APPROVED SERVICES',
                        'অনুমোদিত স্বাস্থ্যসেবা তালিকা',
                      ),
                      style: HealoraTypography.label(
                        color: HealoraColors.slate,
                        isBangla: state.isBangla,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hub.supportedServices.map((service) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: HealoraColors.mist,
                            borderRadius: HealoraSpacing.borderPill,
                          ),
                          child: Text(
                            service,
                            style: HealoraTypography.caption(
                              color: HealoraColors.pine,
                              isBangla: state.isBangla,
                            ),
                          ),
                        );
                      }).toList(),
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

  Widget _buildMetaItem(
    IconData icon,
    String label,
    String value,
    bool isBangla, {
    bool highlight = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: highlight ? HealoraColors.clay : HealoraColors.slate,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: HealoraTypography.micro(
                color: HealoraColors.slate,
                isBangla: isBangla,
              ),
            ),
            Text(
              value,
              style: HealoraTypography.caption(
                color: highlight ? HealoraColors.clay600 : HealoraColors.ink,
                isBangla: isBangla,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddHubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: HealoraSpacing.borderCard,
          ),
          backgroundColor: HealoraColors.paper,
          title: Text(
            controller.state.t(
              'Configure New Physical Hub',
              'নতুন ফিজিক্যাল হাব কনফিগার করুন',
            ),
            style: HealoraTypography.h2(isBangla: controller.state.isBangla),
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.state.t(
                    'Per PRD Section 8.3 & 17, newly provisioned hubs require DGHS Telehealth spatial registration and BMDC clinical supervisory signoff.',
                    'PRD সেকশন ৮.৩ এবং ১৭ অনুযায়ী, নতুন হাবের জন্য স্বাস্থ্য অধিদপ্তরের অনুমোদন ও BMDC সুপারভাইজরি স্বাক্ষর প্রয়োজন।',
                  ),
                  style: HealoraTypography.caption(
                    color: HealoraColors.slate,
                    isBangla: controller.state.isBangla,
                  ),
                ),
                const SizedBox(height: 16),
                HealoraTextField(
                  label: controller.state.t(
                    'Hub Official Name',
                    'হাবের আনুষ্ঠানিক নাম',
                  ),
                  hintText: 'e.g. Bogura Rural Care Hub',
                  isBangla: controller.state.isBangla,
                ),
                const SizedBox(height: 12),
                HealoraTextField(
                  label: controller.state.t(
                    'Catchment Upazila & Unions',
                    'সার্ভিস উপজেলা ও ইউনিয়নসমূহ',
                  ),
                  hintText: 'e.g. Shibganj Sadar & Buriganj',
                  isBangla: controller.state.isBangla,
                ),
                const SizedBox(height: 12),
                HealoraTextField(
                  label: controller.state.t(
                    'Nearest Referral Hospital (Emergency SOP)',
                    'নিকটস্থ রেফারেল হাসপাতাল',
                  ),
                  hintText: 'e.g. Bogura Shaheed Ziaur Rahman Medical College',
                  isBangla: controller.state.isBangla,
                ),
              ],
            ),
          ),
          actions: [
            HealoraButton.secondary(
              label: controller.state.t('Cancel', 'বাতিল'),
              onPressed: () => Navigator.pop(ctx),
              isBangla: controller.state.isBangla,
            ),
            HealoraButton.primary(
              label: controller.state.t(
                'Submit for Regional Approval',
                'অনুমোদনের জন্য পাঠান',
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealoraColors.ink,
                    content: Text(
                      controller.state.t(
                        'Hub provisioning request logged to Regional Operations',
                        'হাবের আবেদন নথিভুক্ত করা হয়েছে',
                      ),
                    ),
                  ),
                );
              },
              isBangla: controller.state.isBangla,
            ),
          ],
        );
      },
    );
  }
}
