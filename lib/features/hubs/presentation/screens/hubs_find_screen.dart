import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/common/widgets/customize_filled_button.dart';
import 'package:healora/core/models/hub_models.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/hubs/controllers/hubs_find_controller.dart';

class HubsFindScreen extends StatelessWidget {
  const HubsFindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HubsFindController controller = Get.put(HubsFindController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context, controller),
            16.verticalSpace,
            _buildSearchBar(controller),
            12.verticalSpace,
            _buildFilterChips(controller),
            16.verticalSpace,
            _buildCatchmentRecommendation(controller),
            16.verticalSpace,
            _buildHubsList(context, controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, HubsFindController controller) {
    return Row(
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
                controller.isBangla ? 'হিলোরা হাব খুঁজুন' : 'Find Healora Hubs',
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                controller.isBangla
                    ? 'আপনার এলাকার অনুমোদিত স্বাস্থ্যসেবা কেন্দ্র'
                    : 'Area-based physical care & checkup centres',
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
    );
  }

  Widget _buildSearchBar(HubsFindController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.setSearchQuery,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: controller.isBangla
              ? 'উপজেলা, জেলা বা হাবের নাম দিয়ে খুঁজুন...'
              : 'Search by upazila, district, or hub name...',
          hintStyle: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 22.sp,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(HubsFindController controller) {
    final divisions = ['All', 'Dhaka', 'Chittagong'];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: divisions.map((div) {
            final isSelected = controller.selectedDivision.value == div;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(
                  div == 'All'
                      ? (controller.isBangla ? 'সব বিভাগ' : 'All Divisions')
                      : div,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.line,
                  ),
                ),
                onSelected: (_) => controller.setDivision(div),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCatchmentRecommendation(HubsFindController controller) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.sage),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.near_me, color: AppColors.teal, size: 20.sp),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isBangla
                      ? 'আপনার ঠিকানার জন্য নির্ধারিত ক্যাচমেন্ট হাব'
                      : 'Recommended Hub for Your Catchment',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pine,
                  ),
                ),
                2.verticalSpace,
                Text(
                  controller.isBangla
                      ? 'আপনার সংরক্ষিত ঠিকানা (মানিকগঞ্জ সদর) অনুযায়ী নিকটবর্তী মানিকগঞ্জ রুরাল কেয়ার হাব প্রস্তাবিত।'
                      : 'Based on your saved area (${controller.patient.upazila}, ${controller.patient.district}), Manikganj Rural Care Hub is your primary service hub.',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHubsList(BuildContext context, HubsFindController controller) {
    return Obx(() {
      final hubs = controller.filteredHubs;
      if (hubs.isEmpty) {
        return Container(
          padding: EdgeInsets.all(32.r),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48.sp, color: AppColors.textMuted),
              12.verticalSpace,
              Text(
                controller.isBangla
                    ? 'কোনো হাব পাওয়া যায়নি'
                    : 'No Hubs Found Matching Query',
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
        itemCount: hubs.length,
        separatorBuilder: (_, _) => 14.verticalSpace,
        itemBuilder: (context, index) {
          final hub = hubs[index];
          return _buildHubCard(context, controller, hub);
        },
      );
    });
  }

  Widget _buildHubCard(
    BuildContext context,
    HubsFindController controller,
    Hub hub,
  ) {
    final isRecommended = hub.id == 'hub_mkg_01';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isRecommended ? AppColors.teal : AppColors.line,
          width: isRecommended ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      hub.code,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal,
                      ),
                    ),
                  ),
                  if (isRecommended) ...[
                    6.horizontalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.okBg,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        controller.isBangla ? 'আপনার হাব' : 'Your Catchment',
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.okFg,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.okBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: AppColors.ok,
                        shape: BoxShape.circle,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      hub.statusLabel,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.okFg,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            hub.name,
            style: getTextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          4.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.place_outlined,
                size: 15.sp,
                color: AppColors.textSecondary,
              ),
              4.horizontalSpace,
              Expanded(
                child: Text(
                  hub.address,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    4.horizontalSpace,
                    Expanded(
                      child: Text(
                        hub.operatingHours,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 14.sp,
                    color: AppColors.teal,
                  ),
                  4.horizontalSpace,
                  Text(
                    hub.contactNumber,
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: hub.supportedServices.map((service) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  service,
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pine,
                  ),
                ),
              );
            }).toList(),
          ),
          12.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  size: 14.sp,
                  color: AppColors.bad,
                ),
                6.horizontalSpace,
                Expanded(
                  child: Text(
                    'Nearest Referral: ${hub.nearestReferralFacility}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          14.verticalSpace,
          CustomFilledButton(
            text: controller.isBangla
                ? 'এই হাবে অ্যাপয়েন্টমেন্ট বুক করুন'
                : 'Book Visit at this Hub',
            height: 42.h,
            onPressed: () => _showBookingBottomSheet(context, controller, hub),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(
    BuildContext context,
    HubsFindController controller,
    Hub hub,
  ) {
    controller.selectHubForBooking(hub);
    final dates = ['14 Nov 2026', '15 Nov 2026', '16 Nov 2026', '17 Nov 2026'];
    final slots = ['09:30 AM', '10:00 AM', '10:30 AM', '11:15 AM', '02:00 PM'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Obx(
          () => Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                16.verticalSpace,
                Text(
                  controller.isBangla
                      ? 'অ্যাপয়েন্টমেন্ট স্লট নির্বাচন করুন'
                      : 'Select Appointment Slot',
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                4.verticalSpace,
                Text(
                  '${hub.name} · ${hub.upazila}',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                16.verticalSpace,
                Text(
                  controller.isBangla ? 'তারিখ পছন্দ করুন' : 'Choose Date',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                8.verticalSpace,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: dates.map((d) {
                      final isSel = controller.selectedDate.value == d;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(d),
                          selected: isSel,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.backgroundLight,
                          labelStyle: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: isSel
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                          onSelected: (_) => controller.setDate(d),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                16.verticalSpace,
                Text(
                  controller.isBangla
                      ? 'সময় নির্বাচন করুন'
                      : 'Available Time Slots',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                8.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: slots.map((s) {
                    final isSel = controller.selectedSlotTime.value == s;
                    return InkWell(
                      onTap: () => controller.setSlotTime(s),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.mist : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSel ? AppColors.teal : AppColors.line,
                            width: isSel ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          s,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: isSel
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSel
                                ? AppColors.teal
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                20.verticalSpace,
                CustomFilledButton(
                  text: controller.isBangla
                      ? 'বুকিং নিশ্চিত করুন'
                      : 'Confirm Booking',
                  isLoading: controller.isBooking.value,
                  onPressed: () async {
                    final success = await controller.confirmBooking();
                    if (success && context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.ok,
                          content: Text(
                            controller.isBangla
                                ? 'অ্যাপয়েন্টমেন্ট সফলভাবে নিশ্চিত হয়েছে!'
                                : 'Appointment confirmed successfully!',
                          ),
                        ),
                      );
                      context.go('/bookings');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
