import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/common/widgets/customize_filled_button.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/home/controllers/home_controller.dart';
import 'package:healora/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return CommonBackgroundScaffold(
      body: GetBuilder<HomeController>(
        builder: (controller) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context, controller),
              16.verticalSpace,
              _buildActiveQueueBanner(context, controller),
              _buildNextAppointmentCard(context, controller),
              20.verticalSpace,
              _buildQuickServicesGrid(context, controller),
              20.verticalSpace,
              _buildLatestVitalsCard(context, controller),
              20.verticalSpace,
              _buildHealthCampBanner(context, controller),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, HomeController controller) {
    return GetBuilder<HomeController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: const BoxDecoration(
                    color: AppColors.sage,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'RB',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pine,
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isBangla ? 'সুপ্রভাত,' : 'Good morning,',
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        controller.patient.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mist,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              controller.patient.canonicalCode,
                              style: getTextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                          6.horizontalSpace,
                          Expanded(
                            child: Text(
                              '${controller.patient.upazila}, ${controller.patient.district}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          Row(
            children: [
              GestureDetector(
                onTap: controller.toggleLanguage,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Text(
                    controller.isBangla ? 'বাং' : 'EN',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              ),
              8.horizontalSpace,
              IconButton(
                onPressed: () => context.push('/notifications'),
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 26.sp,
                      color: AppColors.textPrimary,
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.clay,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveQueueBanner(
    BuildContext context,
    HomeController controller,
  ) {
    final ticket = controller.activeTicket;
    if (ticket == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.pine,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.pine.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'ACTIVE TOKEN: ${ticket.tokenNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        ticket.statusLabel.toUpperCase(),
                        style: getTextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                2.verticalSpace,
                Text(
                  '${ticket.currentStationName} · Wait: ~${ticket.waitDurationMinutes} min',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/check-in'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              controller.isBangla ? 'দেখুন' : 'View QR',
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.pine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentCard(
    BuildContext context,
    HomeController controller,
  ) {
    final appointment = controller.nextAppointment;
    if (appointment == null) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.isBangla
                      ? 'কোনো আসন্ন বুকিং নেই'
                      : 'No Upcoming Visit',
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.event_busy,
                  color: AppColors.textSecondary,
                  size: 20.sp,
                ),
              ],
            ),
            8.verticalSpace,
            Text(
              controller.isBangla
                  ? 'আপনার নিকটস্থ হিলোরা হাবে স্বাস্থ্য পরীক্ষার জন্য অ্যাপয়েন্টমেন্ট বুক করুন।'
                  : 'Book a health checkup at your nearest Healora Hub today.',
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            12.verticalSpace,
            CustomFilledButton(
              text: controller.isBangla
                  ? 'হাব খুঁজুন ও বুক করুন'
                  : 'Find Hub & Book',
              height: 40.h,
              onPressed: () => context.go('/hubs'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  controller.isBangla
                      ? 'পরবর্তী অ্যাপয়েন্টমেন্ট'
                      : 'NEXT VISIT',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pine,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.okBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  appointment.statusLabel,
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.okFg,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.local_hospital_outlined,
                  color: AppColors.teal,
                  size: 22.sp,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
            ],
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
                  Icons.calendar_today_outlined,
                  size: 15.sp,
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
                  appointment.appointmentCode,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomFilledButton(
                  text: controller.isBangla
                      ? 'চেক-ইন নির্দেশিকা ও কিউআর'
                      : 'Arrival & QR Token',
                  height: 42.h,
                  onPressed: () => context.push('/check-in'),
                ),
              ),
              10.horizontalSpace,
              OutlinedButton(
                onPressed: () => context.go('/bookings'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                ),
                child: Text(
                  controller.isBangla ? 'বিবরণ' : 'Details',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickServicesGrid(
    BuildContext context,
    HomeController controller,
  ) {
    final items = [
      {
        'title': controller.isBangla ? 'হাব খুঁজুন' : 'Find Hubs',
        'subtitle': controller.isBangla ? 'নিকটস্থ কেন্দ্র' : 'Nearby centres',
        'icon': Icons.location_on_outlined,
        'route': '/hubs',
        'color': AppColors.teal,
      },
      {
        'title': controller.isBangla ? 'অ্যাপয়েন্টমেন্ট' : 'My Bookings',
        'subtitle': controller.isBangla
            ? 'সময়সূচি ও বুকিং'
            : 'Schedule & slots',
        'icon': Icons.calendar_today_outlined,
        'route': '/bookings',
        'color': AppColors.brandBlue,
      },
      {
        'title': controller.isBangla ? 'চেক-ইন কিউআর' : 'Check-In QR',
        'subtitle': controller.isBangla ? 'আগমনের টোকেন' : 'Arrival ticket',
        'icon': Icons.qr_code_2_outlined,
        'route': '/check-in',
        'color': AppColors.pine,
      },
      {
        'title': controller.isBangla ? 'স্বাস্থ্য ফলাফল' : 'Health Results',
        'subtitle': controller.isBangla ? 'ভাইটালস ও রেকর্ড' : 'Vitals & labs',
        'icon': Icons.monitor_heart_outlined,
        'route': '/results',
        'color': AppColors.ok,
      },
      {
        'title': controller.isBangla ? 'ডাক্তারের পরামর্শ' : 'Doctor Advice',
        'subtitle': controller.isBangla ? 'ফলো-আপ নির্দেশ' : 'Follow-up plan',
        'icon': Icons.medication_outlined,
        'route': '/follow-ups',
        'color': AppColors.clay,
      },
      {
        'title': controller.isBangla ? 'অনুমতি ও সম্মতি' : 'Consent & Rights',
        'subtitle': controller.isBangla ? 'পিডিএফএ ২০২৬' : 'PDPA 2026 data',
        'icon': Icons.verified_user_outlined,
        'route': '/consent',
        'color': AppColors.teal,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.isBangla ? 'রোগী সেবা ও সুবিধা' : 'Patient Services',
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        12.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () => AppRoute.navigate(context, item['route'] as String),
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 24.sp,
                      color: item['color'] as Color,
                    ),
                    8.verticalSpace,
                    Text(
                      item['title'] as String,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      item['subtitle'] as String,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLatestVitalsCard(
    BuildContext context,
    HomeController controller,
  ) {
    final encounter = controller.latestEncounter;
    if (encounter == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.line),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    color: AppColors.ok,
                    size: 18.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    controller.isBangla
                        ? 'হাবে যাচাইকৃত সাম্প্রতিক ফলাফল'
                        : 'VERIFIED HUB VITALS',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pine,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.go('/results'),
                child: Text(
                  controller.isBangla ? 'সব দেখুন →' : 'See all →',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            '${encounter.hubName} · ${encounter.openedAt}',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'Recorded by ${encounter.assignedWorker} · Doctor: ${encounter.assignedDoctor}',
            style: getTextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
          14.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('BP', '138/88', 'mmHg', true),
              _buildMetric('Pulse', '76', 'bpm', false),
              _buildMetric('SpO2', '98', '%', false),
              _buildMetric('Glucose', '7.4', 'mmol/L', true),
            ],
          ),
          if (encounter.doctorNote != null) ...[
            14.verticalSpace,
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16.sp, color: AppColors.pine),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      encounter.doctorNote!.managementPlan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.pine,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, String unit, bool isWarning) {
    return Column(
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        4.verticalSpace,
        Text(
          value,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isWarning ? AppColors.clay : AppColors.textPrimary,
          ),
        ),
        Text(
          unit,
          style: getTextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCampBanner(
    BuildContext context,
    HomeController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.pine],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    controller.isBangla
                        ? 'বিশেষ স্বাস্থ্য ক্যাম্প'
                        : 'HEALTH CAMP EVENT',
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                8.verticalSpace,
                Text(
                  controller.isBangla
                      ? 'ডায়াবেটিস ও উচ্চ রক্তচাপ বিশেষ ক্যাম্প'
                      : 'Special Diabetes & Hypertension Camp',
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                4.verticalSpace,
                Text(
                  controller.isBangla
                      ? '১৫ নভেম্বর ২০২৬ · মানিকগঞ্জ সদর হাবে বিশেষজ্ঞ ডাক্তার উপস্থিত থাকবেন।'
                      : '15 Nov 2026 · Manikganj Rural Care Hub with specialist consultations.',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          ElevatedButton(
            onPressed: () => context.go('/hubs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: 0,
            ),
            child: Text(
              controller.isBangla ? 'বুকিং' : 'Book',
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
