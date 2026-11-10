import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/consent/controllers/consent_controller.dart';

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConsentController controller = Get.put(ConsentController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context, controller),
            16.verticalSpace,
            _buildComplianceBadge(controller),
            16.verticalSpace,
            _buildConsentToggles(context, controller),
            16.verticalSpace,
            _buildCaregiverCard(controller),
            16.verticalSpace,
            _buildDataRightsSection(context, controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ConsentController controller) {
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
                    ? 'সম্মতি ও অনুমতি ব্যবস্থাপনা'
                    : 'Consent & Authorisation',
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                controller.isBangla
                    ? 'ব্যক্তিগত স্বাস্থ্য তথ্যের সুরক্ষা ও নিয়ন্ত্রণ'
                    : 'Scope-aware privacy controls & patient rights',
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

  Widget _buildComplianceBadge(ConsentController controller) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.sage),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.teal, size: 22.sp),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isBangla
                      ? 'বাংলাদেশ ব্যক্তিগত উপাত্ত সুরক্ষা আইন, ২০২৬'
                      : 'Personal Data Protection Act, 2026 (Act 63)',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pine,
                  ),
                ),
                3.verticalSpace,
                Text(
                  controller.isBangla
                      ? 'ডিজিএইচএস টেলিহেলথ নির্দেশিকা অনুযায়ী আপনার স্বাস্থ্য তথ্য বাংলাদেশে সংরক্ষিত এবং আপনার প্রত্যক্ষ সম্মতি ছাড়া অন্য কোথাও শেয়ার করা হয় না।'
                      : 'Compliant with DGHS National Telehealth Guidelines (2026). Health data is treated as sensitive personal data with local data residency.',
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

  Widget _buildConsentToggles(
    BuildContext context,
    ConsentController controller,
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
                ? 'অনুমোদিত সেবাসমূহের সম্মতি'
                : 'Service Consents & Data Use',
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          4.verticalSpace,
          Text(
            controller.isBangla
                ? 'প্রতিটি সেবার জন্য স্বতন্ত্র সম্মতি প্রদান বা প্রত্যাহার করতে পারেন (PRD 9.5)'
                : 'Specific, voluntary consent per purpose (PRD 9.5)',
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          12.verticalSpace,
          const Divider(color: AppColors.line, height: 1),
          12.verticalSpace,

          // 1. Hub Physical Measurement Consent
          Obx(
            () => _buildConsentTile(
              title: controller.isBangla
                  ? 'হাবে স্বাস্থ্য পরিমাপ সম্মতি'
                  : 'Hub Physical Measurements & Checkup',
              description: controller.isBangla
                  ? 'হিলোরা হাবে প্রশিক্ষিত মাঠ স্বাস্থ্যকর্মীর মাধ্যমে রক্তচাপ, সুগার ইত্যাদি পরিমাপের অনুমতি।'
                  : 'Authorises authorised health workers to collect approved vital signs & observations at the physical hub.',
              value: controller.consentHubService.value,
              onChanged: (val) => controller.toggleConsent('hub', val),
            ),
          ),
          12.verticalSpace,
          const Divider(color: AppColors.line, height: 1),
          12.verticalSpace,

          // 2. Health Data Processing & Storage Consent
          Obx(
            () => _buildConsentTile(
              title: controller.isBangla
                  ? 'স্বাস্থ্য উপাত্ত প্রক্রিয়াকরণ ও সংরক্ষণ'
                  : 'Health Data Processing & Storage',
              description: controller.isBangla
                  ? 'পিডিএফএ ২০২৬ ধারা ১৪ অনুযায়ী এনক্রিপ্টকৃত স্বাস্থ্য তথ্য নিরাপদে সংরক্ষণ ও টাইমলাইনে প্রদর্শনের অনুমতি।'
                  : 'Processing sensitive personal health data under PDPA 2026 Section 14 in secured local Bangladesh cloud.',
              value: controller.consentDataProcessing.value,
              onChanged: (val) => controller.toggleConsent('data', val),
            ),
          ),
          12.verticalSpace,
          const Divider(color: AppColors.line, height: 1),
          12.verticalSpace,

          // 3. Telehealth & Doctor Review Consent
          Obx(
            () => _buildConsentTile(
              title: controller.isBangla
                  ? 'স্থানীয় ডাক্তারের পর্যালোচনা ও টেলিহেলথ'
                  : 'Local Doctor Review & Teleconsultation',
              description: controller.isBangla
                  ? 'বিএমডিসি নির্দেশনা অনুযায়ী নিবন্ধিত ডাক্তারের মাধ্যমে আপনার রিপোর্ট পর্যালোচনা ও পরামর্শ গ্রহণের সম্মতি।'
                  : 'Allows registered doctors to review hub encounters and coordinate teleconsultation per BMDC guidelines.',
              value: controller.consentTelehealth.value,
              onChanged: (val) => controller.toggleConsent('telehealth', val),
            ),
          ),
          12.verticalSpace,
          const Divider(color: AppColors.line, height: 1),
          12.verticalSpace,

          // 4. Overseas Specialist Disclosure Consent
          Obx(
            () => _buildConsentTile(
              title: controller.isBangla
                  ? 'বিদেশের বিশেষজ্ঞ চিকিৎসকের নিকট প্রকাশ'
                  : 'Overseas Specialist Cross-Border Review',
              description: controller.isBangla
                  ? 'বিদেশী হাসপাতালের বিশেষজ্ঞদের দ্বিতীয় মতামতের জন্য আপনার স্বাস্থ্য রেকর্ড সীমিতভাবে শেয়ারের অনুমতি।'
                  : 'Strict patient opt-in: Disclose specific encounter vitals to overseas hospital specialists for second opinions.',
              value: controller.consentOverseasSharing.value,
              onChanged: (val) => controller.toggleConsent('overseas', val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              3.verticalSpace,
              Text(
                description,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        Switch(
          value: value,
          activeThumbColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCaregiverCard(ConsentController controller) {
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
              Text(
                controller.isBangla
                    ? 'অনুমোদিত পরিচর্যাকারী (কেয়ারগিভার)'
                    : 'Authorised Caregiver / Representative',
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.okBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Active Authority',
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.okFg,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            controller.isBangla
                ? 'পরিবারের সদস্য বা অভিভাবককে অ্যাপয়েন্টমেন্ট বুকিং ও চেক-ইন সহায়তা প্রদানের আইনি অনুমতি (PRD 6.3)'
                : 'Recorded legal authority for adult representative to assist with hub visits (PRD 6.3)',
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          12.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Icons.family_restroom, size: 24.sp, color: AppColors.teal),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rafiqul Islam (Son)',
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Phone: +880 1819-876543 · Basis: Written Patient Authority',
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRightsSection(
    BuildContext context,
    ConsentController controller,
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
                  ? 'উপাত্ত সংক্রান্ত রোগীর অধিকার'
                  : 'Patient Rights & Data Portability',
              style: getTextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            10.verticalSpace,
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.download_outlined,
                color: AppColors.teal,
                size: 20.sp,
              ),
              title: Text(
                controller.isBangla
                    ? 'আমার উপাত্তের কপি ডাউনলোড করুন'
                    : 'Request Copy of Health Records',
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'PDF summary of verified measurements and doctor notes',
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.line),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Export request generated. Ready in My Health Results.',
                    ),
                  ),
                );
              },
            ),
            const Divider(color: AppColors.line, height: 1),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.history_outlined,
                color: AppColors.slate,
                size: 20.sp,
              ),
              title: Text(
                controller.isBangla
                    ? 'উপাত্ত অ্যাক্সেস অডিট লগ'
                    : 'Access & Audit Log',
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'See who accessed your records (Reception, Worker, Doctor)',
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.line),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'All medical access is strictly logged under PDPA 2026.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
