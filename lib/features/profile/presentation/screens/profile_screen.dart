import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/profile/controllers/profile_controller.dart';
import 'package:healora/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return CommonBackgroundScaffold(
      body: GetBuilder<ProfileController>(
        builder: (controller) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context, controller),
              16.verticalSpace,
              _buildPatientHeaderCard(context, controller),
              16.verticalSpace,
              _buildHealthDetailsCard(context, controller),
              16.verticalSpace,
              _buildCatchmentAndEmergencyCard(context, controller),
              16.verticalSpace,
              _buildAppSettingsSection(context, controller),
              16.verticalSpace,
              _buildHelplineAndSupportCard(context, controller),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ProfileController controller) {
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
                controller.isBangla ? 'আমার প্রোফাইল' : 'My Profile',
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                controller.isBangla
                    ? 'রোগীর পরিচয় ও ব্যক্তিগত সেটিংস'
                    : 'Canonical patient identity & preferences',
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

  Widget _buildPatientHeaderCard(
    BuildContext context,
    ProfileController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(18.r),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  color: AppColors.sage,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getInitials(controller.patient.fullName),
                    style: getTextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pine,
                    ),
                  ),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    4.verticalSpace,
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.mist,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            controller.patient.canonicalCode,
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.teal,
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Icon(Icons.verified, color: AppColors.ok, size: 16.sp),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      controller.patient.phone,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              _buildInfoBadge(
                controller.isBangla ? 'বয়স' : 'Age',
                '${controller.patient.age} ${controller.isBangla ? 'বছর' : 'yrs'}',
              ),
              8.horizontalSpace,
              _buildInfoBadge(
                controller.isBangla ? 'লিঙ্গ' : 'Gender',
                controller.patient.gender,
              ),
              8.horizontalSpace,
              _buildInfoBadge(
                controller.isBangla ? 'রক্তের গ্রুপ' : 'Blood Group',
                controller.patient.bloodGroup,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            2.verticalSpace,
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDetailsCard(
    BuildContext context,
    ProfileController controller,
  ) {
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
          Text(
            controller.isBangla
                ? 'ঠিকানা ও নির্ধারিত ক্যাচমেন্ট এলাকা'
                : 'Address & Primary Service Area',
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          12.verticalSpace,
          _buildRowItem(
            Icons.location_on_outlined,
            controller.isBangla ? 'উপজেলা ও জেলা' : 'Upazila & District',
            '${controller.patient.upazila}, ${controller.patient.district}, Dhaka',
          ),
          10.verticalSpace,
          _buildRowItem(
            Icons.local_hospital_outlined,
            controller.isBangla ? 'পছন্দের প্রাথমিক হাব' : 'Designated Hub',
            controller.preferredHub?.name ?? 'Manikganj Rural Care Hub',
          ),
        ],
      ),
    );
  }

  Widget _buildCatchmentAndEmergencyCard(
    BuildContext context,
    ProfileController controller,
  ) {
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
          Text(
            controller.isBangla
                ? 'জরুরি যোগাযোগ ও কেয়ারগিভার'
                : 'Emergency Contact & Caregiver',
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          12.verticalSpace,
          _buildRowItem(
            Icons.contact_phone_outlined,
            controller.isBangla ? 'জরুরি যোগাযোগ' : 'Emergency Contact',
            controller.patient.emergencyContact,
          ),
          10.verticalSpace,
          _buildRowItem(
            Icons.family_restroom_outlined,
            controller.isBangla
                ? 'অনুমোদিত পরিচর্যাকারী'
                : 'Authorised Caregiver',
            'Rafiqul Islam (Son) · Authority Verified',
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(
    BuildContext context,
    ProfileController controller,
  ) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.isBangla
                  ? 'অ্যাপ সেটিংস ও অধিকার'
                  : 'Settings & Privacy Rights',
              style: getTextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            12.verticalSpace,
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.language, color: AppColors.teal, size: 22.sp),
              title: Text(
                controller.isBangla ? 'ভাষা (Language)' : 'Language',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                controller.isBangla ? 'বাংলা' : 'English',
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: TextButton(
                onPressed: controller.toggleLanguage,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.mist,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  controller.isBangla ? 'English এ যান' : 'বাংলায় দেখুন',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ),
            const Divider(color: AppColors.line, height: 1),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.verified_user_outlined,
                color: AppColors.teal,
                size: 22.sp,
              ),
              title: Text(
                controller.isBangla
                    ? 'সম্মতি ও উপাত্ত অনুমোদন'
                    : 'Consent & Data Authorisations',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                controller.isBangla
                    ? 'বাংলাদেশ PDPA ২০২৬ সম্মতি সেটিংস পরিচালনা করুন'
                    : 'Manage Bangladesh PDPA 2026 consent preferences',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.line),
              onTap: () => AppRoute.navigate(context, '/consent'),
            ),
            const Divider(color: AppColors.line, height: 1),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.notifications_outlined,
                color: AppColors.teal,
                size: 22.sp,
              ),
              title: Text(
                controller.isBangla ? 'বিজ্ঞপ্তি বার্তা' : 'Notifications',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                controller.isBangla
                    ? 'গুরুত্বপূর্ণ স্বাস্থ্য ও কিউ নোটিফিকেশন দেখুন'
                    : 'View alerts, queue calls and medical reports',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.line),
              onTap: () => AppRoute.navigate(context, '/notifications'),
            ),
            const Divider(color: AppColors.line, height: 1),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.ok,
                size: 22.sp,
              ),
              title: Text(
                controller.isBangla
                    ? 'স্বাস্থ্য অধিদপ্তর ও বিএমডিসি ভেরিফাইড'
                    : 'DGHS Telehealth & BMDC Verified',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Version 1.0.0 (Build 2026.11) · Organic Clinical UI',
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
      ),
    );
  }

  Widget _buildHelplineAndSupportCard(
    BuildContext context,
    ProfileController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sage),
      ),
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent,
              color: AppColors.teal,
              size: 24.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isBangla
                      ? 'জাতীয় স্বাস্থ্য বাতায়ন ১৬২৬৩'
                      : 'National Health Helpline 16263',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pine,
                  ),
                ),
                2.verticalSpace,
                Text(
                  controller.isBangla
                      ? '২৪/৭ বিনামূল্যে সরকারি স্বাস্থ্য ও জরুরি পরামর্শ'
                      : '24/7 free toll-free emergency telehealth',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildRowItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: AppColors.teal),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              2.verticalSpace,
              Text(
                value,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'P';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
