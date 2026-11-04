import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/features/checkin/controllers/checkin_controller.dart';

class CheckinScreen extends StatelessWidget {
  final CheckinController controller;

  const CheckinScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final filteredAppointments = controller.filteredAppointments;
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
                      'Patient Arrival & Reception Check-in',
                      'রোগীর আগমন ও রিসেপশন চেক-ইন',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.t(
                      'Search canonical booking records, capture consent, register walk-in patients, and issue queue tokens.',
                      'পূর্বনির্ধারিত অ্যাপয়েন্টমেন্ট অনুসন্ধান, সম্মতি গ্রহণ, ওয়াক-ইন নিবন্ধন ও সিরিয়াল টোকেন ইস্যু।',
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
                  '+ Assisted Walk-in Registration',
                  '+ ওয়াক-ইন রোগী নিবন্ধন',
                ),
                onPressed: () => _showWalkInDialog(context),
                isBangla: state.isBangla,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // PRD Privacy & Least Privilege Box (Section 6.1: Reception restricts raw vitals/diagnoses)
          HealoraCard.tint(
            child: Row(
              children: [
                const Icon(
                  Icons.privacy_tip_outlined,
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
                          'Least-Privilege Security Notice (PRD 6.1 & PDPA 2026)',
                          'ন্যূনতম প্রবেশাধিকার নিরাপত্তা নোটিশ (PRD ৬.১ ও আইন ২০২৬)',
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
                          'Reception staff are permitted to verify patient identity, arrival time, and consent state. Clinical notes, diagnoses, prescriptions, and raw vitals are restricted to authorised clinical personnel only.',
                          'রিসেপশন কর্মীদের কেবল রোগীর পরিচয়, আগমন সময় এবং সম্মতি যাচাইয়ের অনুমতি রয়েছে। রোগীর অতীত রোগ ইতিহাস, প্রেসক্রিপশন এবং ভাইটালস রিডিং সুরক্ষিত এবং কেবল অনুমোদিত চিকিৎসকদের জন্য দৃশ্যমান।',
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

          // Search Box
          HealoraSearchBar(
            controller: controller.searchController,
            hintText: state.t(
              'Search by Appointment Code (APT-...), Patient Name, or Phone Number...',
              'অ্যাপয়েন্টমেন্ট কোড (APT-...), রোগীর নাম বা ফোন নম্বর দিয়ে খুঁজুন...',
            ),
            onChanged: controller.setSearchFilter,
            isBangla: state.isBangla,
          ),

          const SizedBox(height: 24),

          // Today's Booked Roster
          Text(
            state.t(
              'Today\'s Appointments (${filteredAppointments.length})',
              'আজকের অ্যাপয়েন্টমেন্ট তালিকা (${filteredAppointments.length})',
            ),
            style: HealoraTypography.h2(isBangla: state.isBangla),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredAppointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final Appointment appt = filteredAppointments[idx];
              final bool isCheckedIn =
                  appt.status == AppointmentStatus.checkedIn ||
                  appt.status == AppointmentStatus.inService ||
                  appt.status == AppointmentStatus.completed;

              return HealoraCard(
                child: Row(
                  children: [
                    // Slot Time Container
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: HealoraColors.bone,
                        borderRadius: HealoraSpacing.borderControl,
                        border: Border.all(color: HealoraColors.line, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: HealoraColors.teal,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appt.slotTime,
                            textAlign: TextAlign.center,
                            style: HealoraTypography.tabular(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: HealoraColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Patient Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                appt.patientName,
                                style: HealoraTypography.h3(
                                  color: HealoraColors.ink,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              const SizedBox(width: 8),
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
                                  appt.appointmentCode,
                                  style: HealoraTypography.label(
                                    color: HealoraColors.pine,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              HealoraStatusPill(
                                label: appt.statusLabel,
                                type: isCheckedIn
                                    ? HealoraPillType.completed
                                    : HealoraPillType.draft,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${appt.patientAge} ${state.t("yrs", "বছর")}, ${appt.patientGender} · ${appt.patientPhone} · ${appt.sessionTitle}',
                            style: HealoraTypography.caption(
                              color: HealoraColors.slate,
                              isBangla: state.isBangla,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.t("Source:", "উৎস:")} ${appt.bookingSource == "patient_app" ? "Patient App (Self-booked)" : (appt.bookingSource == "walk_in" ? "Assisted Walk-in" : "Referral")}',
                            style: HealoraTypography.micro(
                              color: HealoraColors.teal,
                              isBangla: state.isBangla,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action
                    if (!isCheckedIn) ...[
                      HealoraButton.primary(
                        label: state.t(
                          'Confirm Arrival & Issue Token',
                          'উপস্থিতি ও টোকেন দিন',
                        ),
                        onPressed: () {
                          controller.checkInAppointment(appt.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: HealoraColors.ink,
                              content: Text(
                                state.t(
                                  'Checked in ${appt.patientName}. Token issued & queued to Station 2.',
                                  '${appt.patientName} চেক-ইন সম্পন্ন ও টোকেন ইস্যু করা হয়েছে।',
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
                              Icons.check_circle,
                              size: 18,
                              color: HealoraColors.okFg,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.t(
                                'In Hub Workflow',
                                'হাব কার্যক্রমে সক্রিয়',
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
              );
            },
          ),
        ],
      ),
    );
  }

  void _showWalkInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: HealoraSpacing.borderCard,
              ),
              backgroundColor: HealoraColors.paper,
              title: Text(
                controller.state.t(
                  'Assisted Walk-in Registration & Consent',
                  'সহায়তাকৃত ওয়াক-ইন নিবন্ধন ও সম্মতি',
                ),
                style: HealoraTypography.h2(
                  isBangla: controller.state.isBangla,
                ),
              ),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HealoraTextField(
                      controller: controller.walkInNameController,
                      label: controller.state.t(
                        'Patient Full Name',
                        'রোগীর পুরো নাম',
                      ),
                      hintText: 'e.g. Joynal Abedin',
                      isBangla: controller.state.isBangla,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: HealoraTextField(
                            controller: controller.walkInPhoneController,
                            label: controller.state.t(
                              'Mobile Number',
                              'মোবাইল নম্বর',
                            ),
                            hintText: '+880 17...',
                            isBangla: controller.state.isBangla,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: HealoraTextField(
                            controller: controller.walkInAgeController,
                            label: controller.state.t('Age', 'বয়স'),
                            hintText: '54',
                            isBangla: controller.state.isBangla,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Gender Selector
                    Text(
                      controller.state.t('Gender', 'লিঙ্গ'),
                      style: HealoraTypography.caption(
                        color: HealoraColors.slate,
                        isBangla: controller.state.isBangla,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: ['Female', 'Male', 'Other'].map((g) {
                        final bool isSel = controller.walkInGender == g;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(g),
                            selected: isSel,
                            selectedColor: HealoraColors.ink,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : HealoraColors.ink,
                              fontWeight: FontWeight.w500,
                            ),
                            onSelected: (_) => setModalState(
                              () => controller.selectWalkInGender(g),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // PDPA 2026 Consent Checkbox
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: HealoraColors.mist,
                        borderRadius: HealoraSpacing.borderControl,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: controller.walkInConsentChecked,
                            activeColor: HealoraColors.teal,
                            onChanged: (v) => setModalState(
                              () => controller.setWalkInConsent(v ?? false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.state.t(
                                'Informed Consent Confirmed: Patient agreed to in-person measurement collection and shared electronic health record creation under Bangladesh Personal Data Protection Act 2026.',
                                'অবহিত সম্মতি নিশ্চিতকরণ: রোগী ব্যক্তিগত তথ্য সুরক্ষা আইন ২০২৬ মোতাবেক পরিমাপ গ্রহণ এবং কেন্দ্রীয় স্বাস্থ্য নথিতে তথ্য সংরক্ষণে সম্মতি জানিয়েছেন।',
                              ),
                              style: HealoraTypography.micro(
                                color: HealoraColors.pine,
                                isBangla: controller.state.isBangla,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    'Register & Generate Token',
                    'নিবন্ধন ও টোকেন তৈরি করুন',
                  ),
                  onPressed: () {
                    if (!controller.registerWalkIn()) return;
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: HealoraColors.ink,
                        content: Text(
                          controller.state.t(
                            'Walk-in patient registered and token issued to queue',
                            'ওয়াক-ইন রোগী নিবন্ধিত এবং সিরিয়ালে যুক্ত করা হয়েছে',
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
      },
    );
  }
}
