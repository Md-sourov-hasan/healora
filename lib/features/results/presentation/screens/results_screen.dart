import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/common/widgets/customize_filled_button.dart';
import 'package:healora/core/models/clinical_models.dart';
import 'package:healora/core/services/medical_report_pdf_service.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/results/controllers/results_controller.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResultsController controller = Get.put(ResultsController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context, controller),
            16.verticalSpace,
            _buildEncounterProvenanceHeader(context, controller),
            16.verticalSpace,
            _buildFilterChips(controller),
            16.verticalSpace,
            _buildVitalsCards(context, controller),
            20.verticalSpace,
            _buildDerivedValuesInfo(controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ResultsController controller) {
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
                          ? 'আমার স্বাস্থ্য ফলাফল'
                          : 'My Health Results',
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      controller.isBangla
                          ? 'হাবে সংগৃহীত ও ডাক্তারের যাচাইকৃত রেকর্ড'
                          : 'Verified hub vitals & measurements',
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
          onPressed: () async {
            final enc = controller.latestEncounter;
            if (enc != null) {
              await MedicalReportPdfService.generateAndShareReport(
                patient: controller.patient,
                encounter: enc,
                isBangla: controller.isBangla,
              );
            }
          },
          icon: Icon(Icons.picture_as_pdf, color: AppColors.teal, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildEncounterProvenanceHeader(
    BuildContext context,
    ResultsController controller,
  ) {
    final enc = controller.latestEncounter;
    if (enc == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.teal),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.06),
            blurRadius: 10,
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
                  Icon(Icons.verified, color: AppColors.ok, size: 20.sp),
                  6.horizontalSpace,
                  Text(
                    controller.isBangla
                        ? 'হিলোরা কেন্দ্রীয় রেকর্ডে যাচাইকৃত'
                        : 'CANONICAL HEALORA RECORD',
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pine,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.okBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'SERVER SYNCED',
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.okFg,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            enc.hubName,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          4.verticalSpace,
          Text(
            'Encounter Date: ${enc.openedAt} · Source: Physical Hub Checkup',
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          8.verticalSpace,
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 16.sp,
                  color: AppColors.teal,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attested by: ${enc.assignedWorker}',
                        style: getTextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pine,
                        ),
                      ),
                      Text(
                        'Clinically Reviewed by: ${enc.assignedDoctor} (BMDC A-54910)',
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
          ),
          12.verticalSpace,
          CustomFilledButton(
            text: controller.isBangla
                ? 'ডাক্তারের ফলো-আপ পরামর্শ দেখুন'
                : 'View Doctor’s Clinical Instructions',
            height: 40.h,
            onPressed: () => context.push('/follow-ups'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ResultsController controller) {
    final filters = ['All', 'BP', 'Glucose', 'Vitals', 'Body'];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final isSel = controller.selectedFilter.value == f;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(f),
                selected: isSel,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                labelStyle: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  color: isSel ? Colors.white : AppColors.textSecondary,
                ),
                onSelected: (_) => controller.setFilter(f),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVitalsCards(BuildContext context, ResultsController controller) {
    return Obx(() {
      final obs = controller.filteredObservations;
      if (obs.isEmpty) {
        return Container(
          padding: EdgeInsets.all(24.r),
          alignment: Alignment.center,
          child: Text(
            'No observations recorded in this category.',
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: obs.length,
        separatorBuilder: (_, _) => 12.verticalSpace,
        itemBuilder: (context, index) {
          final item = obs[index];
          return _buildObservationCard(context, controller, item);
        },
      );
    });
  }

  Widget _buildObservationCard(
    BuildContext context,
    ResultsController controller,
    Observation obs,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: obs.isFlaggedAbnormal ? AppColors.clay : AppColors.line,
          width: obs.isFlaggedAbnormal ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
                obs.label,
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (obs.isFlaggedAbnormal)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.warnBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Prompt Review',
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warnFg,
                    ),
                  ),
                ),
            ],
          ),
          10.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                obs.value,
                style: getTextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: obs.isFlaggedAbnormal
                      ? AppColors.clay
                      : AppColors.textPrimary,
                ),
              ),
              6.horizontalSpace,
              Text(
                obs.unit,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (obs.contextNote != null) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    obs.contextNote!,
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          12.verticalSpace,
          const Divider(color: AppColors.line, height: 1),
          8.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.devices_outlined,
                size: 13.sp,
                color: AppColors.textMuted,
              ),
              4.horizontalSpace,
              Expanded(
                child: Text(
                  'Device: ${obs.deviceAttribution}',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Text(
                obs.measuredAt,
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDerivedValuesInfo(ResultsController controller) {
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
          Icon(Icons.info_outline, color: AppColors.teal, size: 18.sp),
          8.horizontalSpace,
          Expanded(
            child: Text(
              controller.isBangla
                  ? 'ক্লিনিক্যাল নীতি (PRD 9.6): বিএমআই এবং সংশ্লিষ্ট মানসমূহ পরিমাপকৃত উচ্চতা ও ওজন থেকে স্বয়ংক্রিয়ভাবে গণনা করা হয়। কোনো অস্বাভাবিক মান দেখা দিলে তা তাৎক্ষণিক মূল্যায়নের নির্দেশ করে, নিজে থেকে কোনো ঔষধ পরিবর্তন করবেন না।'
                  : 'PRD Clinical Rule 9.6: Derived indicators (such as BMI) are computed algorithmically from source height and weight measurements. Value flags are prompts for clinical review, not automated diagnostic conclusions.',
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
}

