import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/notifications/controllers/patient_notifications_controller.dart';
import 'package:healora/routes/app_routes.dart';

class PatientNotificationsScreen extends StatelessWidget {
  const PatientNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientNotificationsController controller = Get.put(
      PatientNotificationsController(),
    );

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context, controller),
            16.verticalSpace,
            _buildPrivacyNote(controller),
            12.verticalSpace,
            _buildCategoryFilter(controller),
            16.verticalSpace,
            _buildNotificationsList(context, controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    PatientNotificationsController controller,
  ) {
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
                      controller.isBangla ? 'বিজ্ঞপ্তি' : 'Notifications',
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      controller.isBangla
                          ? 'অ্যাপয়েন্টমেন্ট, কিউ এবং ফলাফলের বার্তা'
                          : 'Alerts, appointments, queue and results',
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
        TextButton(
          onPressed: controller.markAllAsRead,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            controller.isBangla ? 'সব পঠিত' : 'Mark all read',
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyNote(PatientNotificationsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.sage),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16.sp, color: AppColors.teal),
          8.horizontalSpace,
          Expanded(
            child: Text(
              controller.isBangla
                  ? 'গোপনীয়তার সুরক্ষায় বিজ্ঞপ্তিতে কোনো কাঁচা রক্তচাপ বা সুগারের মান পাঠানো হয় না (PRD 8.12)।'
                  : 'PRD 8.12 Privacy Rule: Notifications use generic summaries to prevent sensitive health exposure on shared device screens.',
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.pine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(PatientNotificationsController controller) {
    final categories = ['All', 'Appointment', 'Queue', 'Clinical', 'Consent'];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final isSel = controller.selectedCategory.value == cat;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSel,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                labelStyle: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  color: isSel ? Colors.white : AppColors.textSecondary,
                ),
                onSelected: (_) => controller.setCategory(cat),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    PatientNotificationsController controller,
  ) {
    return Obx(() {
      final list = controller.filteredNotifications;
      if (list.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                Icons.notifications_none,
                size: 48.sp,
                color: AppColors.textMuted,
              ),
              12.verticalSpace,
              Text(
                controller.isBangla
                    ? 'কোনো বিজ্ঞপ্তি নেই'
                    : 'No Notifications in this Category',
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, _) => 10.verticalSpace,
        itemBuilder: (context, index) {
          final item = list[index];
          return _buildNotificationCard(context, controller, item);
        },
      );
    });
  }

  Widget _buildNotificationCard(
    BuildContext context,
    PatientNotificationsController controller,
    NotificationItem item,
  ) {
    IconData icon = Icons.notifications_outlined;
    Color iconColor = AppColors.teal;
    String targetRoute = '/home';

    if (item.category == 'Appointment') {
      icon = Icons.calendar_today_outlined;
      iconColor = AppColors.brandBlue;
      targetRoute = '/bookings';
    } else if (item.category == 'Queue') {
      icon = Icons.confirmation_number_outlined;
      iconColor = AppColors.secondary;
      targetRoute = '/check-in';
    } else if (item.category == 'Clinical') {
      icon = Icons.monitor_heart_outlined;
      iconColor = AppColors.ok;
      targetRoute = '/results';
    } else if (item.category == 'Consent') {
      icon = Icons.verified_user_outlined;
      iconColor = AppColors.pine;
      targetRoute = '/consent';
    }

    return InkWell(
      onTap: () {
        controller.markSingleAsRead(item.id);
        AppRoute.navigate(context, targetRoute);
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF0F7F4),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: item.isRead ? AppColors.line : AppColors.sage,
          ),
        ),
        padding: EdgeInsets.all(14.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!item.isRead) ...[
                        4.horizontalSpace,
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: AppColors.clay,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    item.body,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    item.timestamp,
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
