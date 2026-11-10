import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';
import 'package:healora/core/common/widgets/healora_button.dart';
import 'package:healora/core/common/widgets/healora_status_pill.dart';
import 'package:healora/core/common/widgets/healora_input.dart';
import 'package:healora/core/common/widgets/ticket_qr_download_button.dart';
import 'package:healora/features/checkin/controllers/checkin_controller.dart';

class CheckinScreen extends StatelessWidget {
  final CheckinController controller;

  const CheckinScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final filteredAppointments = controller.filteredAppointments;
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
                      'Patient Arrival & Reception Check-in',
                      'রোগীর আগমন ও রিসেপশন চেক-ইন',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  SizedBox(height: 4.h),
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

          SizedBox(height: 20.h),

          // PRD Privacy & Least Privilege Box (Section 6.1: Reception restricts raw vitals/diagnoses)
          HealoraCard.tint(
            child: Row(
              children: [
                const Icon(
                  Icons.privacy_tip_outlined,
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
                          'Least-Privilege Security Notice (PRD 6.1 & PDPA 2026)',
                          'ন্যূনতম প্রবেশাধিকার নিরাপত্তা নোটিশ (PRD ৬.১ ও আইন ২০২৬)',
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

          SizedBox(height: 24.h),

          // Search Box
          HealoraSearchBar(
            controller: controller.searchController,
            hintText: state.t(
              'Search by Healora patient code, appointment code, or registered phone...',
              'অ্যাপয়েন্টমেন্ট কোড (APT-...), রোগীর নাম বা ফোন নম্বর দিয়ে খুঁজুন...',
            ),
            onChanged: controller.setSearchFilter,
            isBangla: state.isBangla,
          ),

          SizedBox(height: 24.h),

          // Today's Booked Roster
          Text(
            state.t(
              'Today\'s Appointments (${filteredAppointments.length})',
              'আজকের অ্যাপয়েন্টমেন্ট তালিকা (${filteredAppointments.length})',
            ),
            style: HealoraTypography.h2(isBangla: state.isBangla),
          ),
          SizedBox(height: 12.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredAppointments.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, idx) {
              final Appointment appt = filteredAppointments[idx];
              final bool isCheckedIn =
                  appt.status == AppointmentStatus.checkedIn ||
                  appt.status == AppointmentStatus.inService ||
                  appt.status == AppointmentStatus.completed;
              final bool canConfirmArrival =
                  appt.status == AppointmentStatus.confirmed ||
                  appt.status == AppointmentStatus.arrived;
              final matchingTickets = state.queue
                  .where((ticket) => ticket.appointmentId == appt.id)
                  .toList();
              final QueueTicket? ticket = matchingTickets.isEmpty
                  ? null
                  : matchingTickets.first;

              return HealoraCard(
                child: Row(
                  children: [
                    // Slot Time Container
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 12.h,
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
                          SizedBox(height: 4.h),
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

                    SizedBox(width: 16.w),

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
                              SizedBox(width: 8.w),
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
                                  appt.appointmentCode,
                                  style: HealoraTypography.label(
                                    color: HealoraColors.pine,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              HealoraStatusPill(
                                label: appt.statusLabel,
                                type: isCheckedIn
                                    ? HealoraPillType.completed
                                    : HealoraPillType.draft,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${appt.appointmentCode} · ${appt.sessionTitle}',
                            style: HealoraTypography.caption(
                              color: HealoraColors.slate,
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(height: 2.h),
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
                    if (canConfirmArrival) ...[
                      HealoraButton.primary(
                        label: state.t(
                          'Confirm Arrival & Issue Token',
                          'উপস্থিতি ও টোকেন দিন',
                        ),
                        onPressed: () => _confirmCheckIn(context, appt),
                        isBangla: state.isBangla,
                      ),
                    ] else if (isCheckedIn) ...[
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
                              Icons.check_circle,
                              size: 18,
                              color: HealoraColors.okFg,
                            ),
                            SizedBox(width: 6.w),
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
                    ] else ...[
                      HealoraStatusPill(
                        label: appt.statusLabel,
                        type: HealoraPillType.draft,
                      ),
                    ],
                    if (isCheckedIn && ticket != null)
                      TicketQrDownloadButton(
                        ticket: ticket,
                        hubName: state.hubs
                            .firstWhere((hub) => hub.id == ticket.hubId)
                            .name,
                        isBangla: state.isBangla,
                        compact: true,
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

  Future<void> _confirmCheckIn(
    BuildContext context,
    Appointment appointment,
  ) async {
    bool verifiedAndConsented = false;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            controller.state.t(
              'Verify identity and consent',
              'পরিচয় ও সম্মতি যাচাই করুন',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${appointment.patientName} | ${appointment.appointmentCode}',
              ),
              SizedBox(height: 12.h),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: verifiedAndConsented,
                onChanged: (value) =>
                    setDialogState(() => verifiedAndConsented = value ?? false),
                title: Text(
                  controller.state.t(
                    'I verified this is the intended patient or authorised representative and explained this hub visit.',
                    'আমি রোগী বা অনুমোদিত প্রতিনিধির পরিচয় যাচাই করেছি এবং হাব ভিজিটের তথ্য জানিয়েছি।',
                  ),
                ),
              ),
              Text(
                controller.state.t(
                  'Consent applies to this visit only. Telemedicine and overseas sharing need separate permission.',
                  'সম্মতি শুধু এই ভিজিটের জন্য। টেলিমেডিসিন ও বিদেশে তথ্য শেয়ারে আলাদা অনুমতি প্রয়োজন।',
                ),
                style: HealoraTypography.micro(
                  color: HealoraColors.slate,
                  isBangla: controller.state.isBangla,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(controller.state.t('Cancel', 'বাতিল')),
            ),
            FilledButton(
              onPressed: verifiedAndConsented
                  ? () => Navigator.pop(dialogContext, true)
                  : null,
              child: Text(
                controller.state.t('Confirm check-in', 'চেক-ইন নিশ্চিত করুন'),
              ),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final checkedIn = controller.checkInAppointment(
      appointment.id,
      consentConfirmed: true,
    );
    if (!checkedIn) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: HealoraColors.ink,
        content: Text(
          controller.state.t(
            'Consent recorded. Patient checked in and added to the reception queue.',
            'সম্মতি সংরক্ষিত। রোগীর চেক-ইন সম্পন্ন, রিসেপশন কিউতে যোগ হয়েছে।',
          ),
        ),
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
                width: 480.w,
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
                    SizedBox(height: 12.h),
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
                        SizedBox(width: 12.w),
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
                    SizedBox(height: 12.h),

                    // Gender Selector
                    Text(
                      controller.state.t('Gender', 'লিঙ্গ'),
                      style: HealoraTypography.caption(
                        color: HealoraColors.slate,
                        isBangla: controller.state.isBangla,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: ['Female', 'Male', 'Other'].map((g) {
                        final bool isSel = controller.walkInGender == g;
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
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

                    SizedBox(height: 16.h),

                    // PDPA 2026 Consent Checkbox
                    Container(
                      padding: EdgeInsets.all(12.r),
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
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              controller.state.t(
                                'Consent covers measurements for this hub visit and the linked Healora encounter only. Telemedicine or overseas sharing needs separate permission.',
                                'এই হাব ভিজিটের মাপ ও সংশ্লিষ্ট Healora encounter-এর জন্যই সম্মতি। টেলিমেডিসিন বা বিদেশে তথ্য শেয়ারে আলাদা অনুমতি লাগবে।',
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
                    if (!controller.registerWalkIn()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            controller.state.t(
                              'Check the required fields and consent, or use an available walk-in session.',
                              'Complete the required fields and consent, or choose an available walk-in session.',
                            ),
                          ),
                        ),
                      );
                      return;
                    }
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
