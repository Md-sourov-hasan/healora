import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/common/widgets/common_background.dart';
import 'package:healora/core/common/widgets/customize_filled_button.dart';
import 'package:healora/core/models/appointment_models.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/features/checkin/controllers/checkin_patient_controller.dart';

class CheckInPatientScreen extends StatelessWidget {
  const CheckInPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckInPatientController controller = Get.put(
      CheckInPatientController(),
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
            _buildArrivalQrCard(context, controller),
            16.verticalSpace,
            _buildLiveQueueTracker(context, controller),
            16.verticalSpace,
            _buildStepByStepGuide(context, controller),
            16.verticalSpace,
            _buildWhatToBringCard(context, controller),
            16.verticalSpace,
            _buildHubFacilityDetails(context, controller),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CheckInPatientController controller) {
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
                    ? 'হাবে আগমন ও চেক-ইন নির্দেশিকা'
                    : 'Arrival & Check-In Guide',
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                controller.isBangla
                    ? 'ডিজিটাল টিকিট ও আগমনের ধাপসমূহ'
                    : 'Digital QR token & physical hub check-in',
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

  Widget _buildArrivalQrCard(
    BuildContext context,
    CheckInPatientController controller,
  ) {
    final appt = controller.nextAppointment;
    final ticket = controller.activeTicket;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isBangla
                        ? 'হিলোরা চেক-ইন টোকেন'
                        : 'HEALORA ARRIVAL TICKET',
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.teal,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    controller.patient.fullName,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  controller.patient.canonicalCode,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pine,
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Visual QR Container
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_2,
                  size: 160.sp,
                  color: AppColors.textPrimary,
                ),
                8.verticalSpace,
                Text(
                  ticket != null
                      ? 'QUEUE TOKEN: ${ticket.tokenNumber}'
                      : (appt != null
                            ? 'BOOKING: ${appt.appointmentCode}'
                            : 'PATIENT: ${controller.patient.canonicalCode}'),
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.pine,
                  ),
                ),
                4.verticalSpace,
                Text(
                  controller.isBangla
                      ? 'হাবে পৌঁছার পর রিসেপশন ডেস্কে এই কিউআর স্ক্যান করান'
                      : 'Show this QR code at hub reception upon physical arrival',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          16.verticalSpace,

          if (appt != null && appt.status != AppointmentStatus.checkedIn)
            Obx(
              () => CustomFilledButton(
                text: controller.isBangla
                    ? 'হাবে পৌঁছেছি (চেক-ইন নিশ্চিত করুন)'
                    : 'I Have Arrived at Hub (Self Check-In)',
                isLoading: controller.isCheckingIn.value,
                onPressed: () => controller.confirmSelfArrival(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLiveQueueTracker(
    BuildContext context,
    CheckInPatientController controller,
  ) {
    return Obx(() {
      final ticket = controller.activeTicket;
      if (ticket == null) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.teal),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withValues(alpha: 0.08),
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
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    6.horizontalSpace,
                    Text(
                      controller.isBangla
                          ? 'লাইভ কিউ ট্র্যাকার'
                          : 'LIVE QUEUE STATUS',
                      style: getTextStyle(
                        fontSize: 12.sp,
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
                    ticket.statusLabel,
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.okFg,
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              ticket.currentStationName,
              style: getTextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            4.verticalSpace,
            Text(
              'Assigned Staff: ${ticket.assignedWorker ?? "Special Team Member"}',
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Wait',
                          style: getTextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          '~${ticket.waitDurationMinutes} min',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Arrival Time',
                          style: getTextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          ticket.arrivalTime,
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStepByStepGuide(
    BuildContext context,
    CheckInPatientController controller,
  ) {
    final steps = [
      {
        'num': '1',
        'title': controller.isBangla
            ? 'হাবে আগমন ও পরিচয় নিশ্চিতকরণ'
            : 'Arrival & Identification',
        'desc': controller.isBangla
            ? 'রিসেপশনে আপনার ডিজিটাল কিউআর কোড বা ফোন নম্বর প্রদর্শন করুন।'
            : 'Show your digital QR code or phone number to the reception desk. Staff confirms identity against canonical Healora ID.',
      },
      {
        'num': '2',
        'title': controller.isBangla
            ? 'কিউ টোকেন গ্রহণ ও অপেক্ষাগার'
            : 'Receive Queue Token',
        'desc': controller.isBangla
            ? 'রিসেপশন থেকে কিউ টোকেন গ্রহণ করে অপেক্ষাগারে বসুন।'
            : 'Collect your queue ticket and proceed to the designated waiting area until your number is called.',
      },
      {
        'num': '3',
        'title': controller.isBangla
            ? 'স্টেশনে শারীরিক পরিমাপ (ভাইটালস)'
            : 'Vitals & Observation Station',
        'desc': controller.isBangla
            ? 'অনুমোদিত মাঠ স্বাস্থ্যকর্মীর মাধ্যমে রক্তচাপ, সুগার ইত্যাদি পরিমাপ সম্পন্ন হবে।'
            : 'Authorised Field Health Worker records BP, blood glucose, pulse, oxygen saturation, and weight.',
      },
      {
        'num': '4',
        'title': controller.isBangla
            ? 'স্থানীয় ডাক্তারের পর্যালোচনা ও ফলাফল'
            : 'Doctor Review & Shared Record',
        'desc': controller.isBangla
            ? 'স্থানীয় ডাক্তার রিপোর্ট পর্যালোচনা করে অ্যাপে ফলাফল ও পরবর্তী পরামর্শ দেবেন।'
            : 'Local doctor reviews observations, signs clinical notes, and synced results become available in your app.',
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
          Text(
            controller.isBangla
                ? 'হাবে সেবা গ্রহণের ধাপসমূহ (PRD 9.4)'
                : 'Encounter Steps at Hub (PRD 9.4)',
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          12.verticalSpace,
          ...steps.map((s) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: AppColors.mist,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        s['num']!,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.teal,
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
                          s['title']!,
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          s['desc']!,
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

  Widget _buildWhatToBringCard(
    BuildContext context,
    CheckInPatientController controller,
  ) {
    final items = [
      'Original NID card or active registered mobile phone',
      'Previous prescriptions, lab test reports, or hospital discharge papers',
      'Current medicines or insulin vials you are taking',
      'Spectacles / reading glasses if you use them',
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
              Icon(Icons.checklist, color: AppColors.teal, size: 20.sp),
              8.horizontalSpace,
              Text(
                controller.isBangla
                    ? 'হাবে আসার সময় সাথে কী আনবেন'
                    : 'What to Bring to the Hub',
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          ...items.map((it) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16.sp,
                    color: AppColors.ok,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      it,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
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

  Widget _buildHubFacilityDetails(
    BuildContext context,
    CheckInPatientController controller,
  ) {
    final hub = controller.currentHub;
    if (hub == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sage),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hub.name,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.pine,
            ),
          ),
          4.verticalSpace,
          Text(
            hub.address,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          8.verticalSpace,
          Row(
            children: [
              Icon(Icons.support_agent, size: 16.sp, color: AppColors.teal),
              6.horizontalSpace,
              Text(
                'Hub Contact: ${hub.contactNumber}',
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Icon(Icons.local_hospital, size: 16.sp, color: AppColors.bad),
              6.horizontalSpace,
              Expanded(
                child: Text(
                  'Emergency Referral: ${hub.nearestReferralFacility}',
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
        ],
      ),
    );
  }
}

