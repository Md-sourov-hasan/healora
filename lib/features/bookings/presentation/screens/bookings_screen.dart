import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/common/widgets/customize_filled_button.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/bookings/controllers/bookings_controller.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingsController controller = Get.put(BookingsController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context, controller),
            16.verticalSpace,
            _buildSegmentedTabs(controller),
            16.verticalSpace,
            _buildAppointmentsList(context, controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, BookingsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.isBangla
                          ? 'আমার অ্যাপয়েন্টমেন্ট'
                          : 'My Appointments',
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      controller.isBangla
                          ? 'হাবে নির্ধারিত স্বাস্থ্য পরীক্ষার তালিকা'
                          : 'Scheduled visits & encounter history',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        8.horizontalSpace,
        IconButton(
          onPressed: () => context.go('/hubs'),
          icon: Icon(Icons.add_circle, color: AppColors.primary, size: 28.sp),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabs(BookingsController controller) {
    return Obx(() {
      final isUpcoming = controller.selectedTab.value == 0;
      return Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isUpcoming ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      controller.isBangla
                          ? 'আসন্ন অ্যাপয়েন্টমেন্ট (${controller.upcomingAppointments.length})'
                          : 'Upcoming Visits (${controller.upcomingAppointments.length})',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: isUpcoming
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isUpcoming
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: !isUpcoming ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      controller.isBangla
                          ? 'পূর্ববর্তী ভিজিট (${controller.pastAppointments.length})'
                          : 'Past Visits (${controller.pastAppointments.length})',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: !isUpcoming
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: !isUpcoming
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAppointmentsList(
    BuildContext context,
    BookingsController controller,
  ) {
    return Obx(() {
      final isUpcoming = controller.selectedTab.value == 0;
      final list = isUpcoming
          ? controller.upcomingAppointments
          : controller.pastAppointments;

      if (list.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 48.sp,
                color: AppColors.textMuted,
              ),
              12.verticalSpace,
              Text(
                isUpcoming
                    ? (controller.isBangla
                          ? 'কোনো আসন্ন অ্যাপয়েন্টমেন্ট নেই'
                          : 'No Upcoming Appointments')
                    : (controller.isBangla
                          ? 'কোনো পূর্ববর্তী অ্যাপয়েন্টমেন্ট নেই'
                          : 'No Past Appointments Found'),
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              8.verticalSpace,
              Text(
                controller.isBangla
                    ? 'আপনার এলাকার হিলোরা হাবে নতুন স্বাস্থ্য পরীক্ষা বুক করুন।'
                    : 'Book a convenient slot at a Healora Hub near you.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              16.verticalSpace,
              CustomFilledButton(
                text: controller.isBangla ? 'হাব খুঁজুন' : 'Find Healora Hub',
                width: 180.w,
                height: 40.h,
                onPressed: () => context.go('/hubs'),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, _) => 14.verticalSpace,
        itemBuilder: (context, index) {
          final appointment = list[index];
          return _buildAppointmentCard(
            context,
            controller,
            appointment,
            isUpcoming,
          );
        },
      );
    });
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    BookingsController controller,
    Appointment appointment,
    bool isUpcoming,
  ) {
    Color statusBg = AppColors.mist;
    Color statusFg = AppColors.teal;
    if (appointment.status == AppointmentStatus.completed) {
      statusBg = AppColors.okBg;
      statusFg = AppColors.okFg;
    } else if (appointment.status == AppointmentStatus.cancelled ||
        appointment.status == AppointmentStatus.noShow) {
      statusBg = AppColors.badBg;
      statusFg = AppColors.badFg;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appointment.appointmentCode,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.teal,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  appointment.statusLabel,
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            appointment.hubName,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          2.verticalSpace,
          Text(
            appointment.sessionTitle,
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          12.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 16.sp,
                  color: AppColors.teal,
                ),
                8.horizontalSpace,
                Text(
                  '${appointment.date} · ${appointment.slotTime}',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  appointment.bookingSource == 'patient_app'
                      ? 'App Booking'
                      : appointment.bookingSource,
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (appointment.cancellationReason != null) ...[
            8.verticalSpace,
            Text(
              'Reason: ${appointment.cancellationReason}',
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.bad,
              ),
            ),
          ],
          if (isUpcoming &&
              appointment.status != AppointmentStatus.cancelled) ...[
            14.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomFilledButton(
                    text: controller.isBangla
                        ? 'চেক-ইন কিউআর ও টোকেন'
                        : 'Arrival & QR Token',
                    height: 40.h,
                    onPressed: () => context.push('/check-in'),
                  ),
                ),
                8.horizontalSpace,
                OutlinedButton(
                  onPressed: () =>
                      _showRescheduleDialog(context, controller, appointment),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text(
                    controller.isBangla ? 'রিশিডিউল' : 'Reschedule',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                8.horizontalSpace,
                IconButton(
                  onPressed: () =>
                      _showCancelDialog(context, controller, appointment),
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: AppColors.bad,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    BookingsController controller,
    Appointment appointment,
  ) {
    final reasons = [
      'Scheduling conflict',
      'Feeling unwell / unable to travel',
      'Transportation issue',
      'Visiting another clinic',
      'Other',
    ];
    String selectedReason = reasons.first;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                controller.isBangla
                    ? 'অ্যাপয়েন্টমেন্ট বাতিল করবেন?'
                    : 'Cancel Appointment?',
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isBangla
                        ? 'অনুগ্রহ করে বাতিলের কারণ নির্বাচন করুন:'
                        : 'Please select a reason for cancelling (PRD 9.10):',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  12.verticalSpace,
                  RadioGroup<String>(
                    groupValue: selectedReason,
                    onChanged: (val) {
                      if (val != null) setState(() => selectedReason = val);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: reasons.map((r) {
                        return RadioListTile<String>(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            r,
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          value: r,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    controller.isBangla ? 'ফিরে যান' : 'Keep Visit',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.cancelAppointment(appointment, selectedReason);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bad,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    controller.isBangla ? 'বাতিল করুন' : 'Confirm Cancel',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    BookingsController controller,
    Appointment appointment,
  ) {
    final newDates = ['16 Nov 2026', '17 Nov 2026', '18 Nov 2026'];
    final newSlots = ['10:00 AM', '11:30 AM', '02:30 PM'];
    String selDate = newDates.first;
    String selSlot = newSlots.first;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                controller.isBangla
                    ? 'অ্যাপয়েন্টমেন্ট সময় বদলান'
                    : 'Reschedule Visit',
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appointment.hubName} · ${appointment.appointmentCode}',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    controller.isBangla ? 'নতুন তারিখ' : 'New Date',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  8.verticalSpace,
                  DropdownButtonFormField<String>(
                    initialValue: selDate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppColors.line),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                    items: newDates
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selDate = val);
                    },
                  ),
                  12.verticalSpace,
                  Text(
                    controller.isBangla ? 'নতুন সময়' : 'New Time Slot',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  8.verticalSpace,
                  DropdownButtonFormField<String>(
                    initialValue: selSlot,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppColors.line),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                    items: newSlots
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selSlot = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    controller.isBangla ? 'বাতিল' : 'Cancel',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.rescheduleAppointment(
                      appointment,
                      selDate,
                      selSlot,
                    );
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    controller.isBangla ? 'পরিবর্তন করুন' : 'Confirm',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
