import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/common/widgets/customize_filled_button.dart';
import 'package:healora/core/common/widgets/customize_unfilled_button.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/follow_ups/controllers/follow_ups_controller.dart';

class FollowUpsScreen extends StatelessWidget {
  const FollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FollowUpsController controller = Get.put(FollowUpsController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context, controller),
            16.verticalSpace,
            _buildDoctorReviewCard(context, controller),
            16.verticalSpace,
            _buildManagementPlanCard(context, controller),
            16.verticalSpace,
            _buildNextVisitCard(context, controller),
            16.verticalSpace,
            _buildSpecialistTelehealthCard(context, controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, FollowUpsController controller) {
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
                controller.isBangla
                    ? 'ডাক্তারের ফলো-আপ পরামর্শ'
                    : 'Follow-Up Instructions',
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                controller.isBangla
                    ? 'স্থানীয় চিকিৎসকের স্বাক্ষরিত পর্যালোচনা ও প্রেসক্রিপশন'
                    : 'Doctor-reviewed clinical advice & management plan',
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

  Widget _buildDoctorReviewCard(
    BuildContext context,
    FollowUpsController controller,
  ) {
    final note = controller.latestNote;
    final enc = controller.latestReviewedEncounter;

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
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
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
                      note != null
                          ? note.doctorName
                          : 'Dr. Tariqul Islam, MBBS',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'BMDC Registration: ${note?.doctorBmdcNumber ?? "A-54910"} · Local Doctor',
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.okBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'BMDC Verified',
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.okFg,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          const Divider(color: AppColors.line, height: 1),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Encounter: ${enc?.hubName ?? "Manikganj Hub"}',
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Signed: ${note?.signedAt ?? "4 Nov 2026"}',
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isBangla
                      ? 'ডাক্তারের ক্লিনিক্যাল পর্যবেক্ষণ (Assessment)'
                      : 'Clinical Assessment',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pine,
                  ),
                ),
                4.verticalSpace,
                Text(
                  note != null ? note.clinicalAssessment : 'Stage 1 Hypertension; blood glucose levels stable on current diet.',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementPlanCard(
    BuildContext context,
    FollowUpsController controller,
  ) {
    final planItems = [
      {
        'title': controller.isBangla
            ? 'খাদ্যাভ্যাস নিয়ন্ত্রণ (লবণ পরিহার)'
            : 'Dietary Sodium Restriction',
        'desc': controller.isBangla
            ? 'খাবারে অতিরিক্ত কাঁচা লবণ বর্জন করুন এবং প্রতিদিন লবণের পরিমাণ ৫ গ্রামের কম রাখুন।'
            : 'Avoid added raw table salt; limit sodium intake to < 5g daily. Increase green vegetables and seasonal fruits.',
      },
      {
        'title': controller.isBangla
            ? 'দৈনিক শারীরিক ব্যায়াম'
            : 'Daily Physical Exercise',
        'desc': controller.isBangla
            ? 'প্রতিদিন সকালে অথবা বিকেলে অন্তত ৩০ মিনিট দ্রুত হাঁটার অভ্যাস গড়ে তুলুন।'
            : 'Maintain a minimum of 30 minutes brisk walking daily in the morning or evening.',
      },
      {
        'title': controller.isBangla
            ? 'হিলোরা হাবে ফলো-আপ চেকআপ'
            : 'Follow-Up Hub Checkup in 14 Days',
        'desc': controller.isBangla
            ? '১৮ নভেম্বর ২০২৬ তারিখে মানিকগঞ্জ হাবে পুনরায় রক্তচাপ ও সুগার পরীক্ষার জন্য উপস্থিত হন।'
            : 'Scheduled repeat checkup on 18 Nov 2026 at Manikganj Rural Care Hub to observe BP trend.',
      },
      {
        'title': controller.isBangla
            ? 'বর্তমান ঔষধ নিয়মিত সেবন'
            : 'Continue Prescribed Medications',
        'desc': controller.isBangla
            ? 'ট্যাবলেট অ্যামলোডিপিন ৫ মিগ্রা প্রতিদিন সকালে খাবারের পর সেবন অব্যাহত রাখুন।'
            : 'Continue Tab. Amlodipine 5mg once daily in the morning after meal. Do not stop without consulting doctor.',
      },
    ];

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
            children: [
              Icon(
                Icons.assignment_outlined,
                color: AppColors.teal,
                size: 20.sp,
              ),
              8.horizontalSpace,
              Text(
                controller.isBangla
                    ? 'ব্যবস্থাপনা ও পরিচর্যা পরিকল্পনা'
                    : 'Management & Care Plan',
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ...planItems.map((p) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                      color: AppColors.okBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12.sp,
                      color: AppColors.okFg,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title']!,
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          p['desc']!,
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
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNextVisitCard(
    BuildContext context,
    FollowUpsController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.pine,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.isBangla
                    ? 'পরবর্তী ফলো-আপ তারিখ'
                    : 'RECOMMENDED FOLLOW-UP',
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.sage,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Due in 8 days',
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'Wednesday, 18 November 2026',
            style: getTextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            'Manikganj Rural Care Hub · 10:00 AM Slot',
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          14.verticalSpace,
          CustomFilledButton(
            text: controller.isBangla
                ? 'এই তারিখে হাবে বুকিং নিশ্চিত করুন'
                : 'Confirm Booking for 18 Nov',
            backgroundColor: Colors.white,
            textColor: AppColors.pine,
            height: 42.h,
            onPressed: () => context.go('/hubs'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistTelehealthCard(
    BuildContext context,
    FollowUpsController controller,
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
          Row(
            children: [
              Icon(
                Icons.video_call_outlined,
                color: AppColors.teal,
                size: 22.sp,
              ),
              8.horizontalSpace,
              Text(
                controller.isBangla
                    ? 'বিশেষজ্ঞ চিকিৎসকের টেলি-পরামর্শ'
                    : 'Specialist Teleconsultation Handoff',
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            controller.isBangla
                ? 'যদি কোনো তীব্র উপসর্গ (যেমন বুকে ব্যথা, শ্বাসকষ্ট বা অতিরিক্ত মাথা ঘোরা) দেখা দেয়, তবে অনতিবিলম্বে হিলোরা টেলিহেলথের মাধ্যমে হৃদরোগ বিশেষজ্ঞের সাথে যুক্ত হতে পারবেন (PRD 13.4)।'
                : 'Under PRD 13.4 teleconsultation protocol: If red flag symptoms appear or your blood pressure does not respond to lifestyle changes, you can schedule a remote consult with a senior cardiologist.',
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          14.verticalSpace,
          CustomUnfilledButton(
            text: controller.isBangla
                ? 'টেলিমেডিসিন ডাক্তার খুঁজুন'
                : 'Schedule Specialist Teleconsult',
            height: 40.h,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Teleconsultation booking initiated with specialist.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
