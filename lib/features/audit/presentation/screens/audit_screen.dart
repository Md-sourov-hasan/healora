import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';
import 'package:healora/features/audit/controllers/audit_controller.dart';
import 'package:healora/core/models/audit_models.dart';
import 'package:healora/core/common/widgets/healora_card.dart';

class AuditScreen extends StatelessWidget {
  final AuditController controller;

  const AuditScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
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
                      'Regulatory Compliance & Audit Stream',
                      'আইনগত কমপ্লায়েন্স ও অপরিবর্তনীয় অডিট লগ',
                    ),
                    style: HealoraTypography.h1(isBangla: state.isBangla),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    state.t(
                      'Immutable cryptographic event trail aligned with Bangladesh Personal Data Protection Act 2026 & DGHS Directives.',
                      'ব্যক্তিগত উপাত্ত সুরক্ষা আইন ২০২৬ এবং স্বাস্থ্য অধিদপ্তরের টেলিহেলথ নীতিমালা মোতাবেক সংরক্ষিত অডিট হিসেব।',
                    ),
                    style: HealoraTypography.caption(
                      color: HealoraColors.slate,
                      isBangla: state.isBangla,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: HealoraColors.okBg,
                  borderRadius: HealoraSpacing.borderPill,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: HealoraColors.okFg,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'APPEND-ONLY VERIFIED',
                      style: HealoraTypography.label(
                        color: HealoraColors.okFg,
                        isBangla: state.isBangla,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Bangladesh Regulatory Gates Overview (PRD Section 17)
          LayoutBuilder(
            builder: (context, constraints) {
              final int count = constraints.maxWidth > 800 ? 3 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: count,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
                children: [
                  HealoraCard.tint(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PDPA 2026 (Act 63/2026)',
                          style: HealoraTypography.h3(
                            color: HealoraColors.pine,
                            isBangla: state.isBangla,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          state.t(
                            'Health data treated as sensitive personal data. Specific informed consent verified for each physical encounter.',
                            'স্বাস্থ্য উপাত্ত সংবেদনশীল হিসেবে শ্রেণিবদ্ধ। প্রতিটি এনকাউন্টারের জন্য সুনির্দিষ্ট সম্মতি নিশ্চিত।',
                          ),
                          style: HealoraTypography.micro(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ),
                        ),
                      ],
                    ),
                  ),
                  HealoraCard.tint(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DGHS Telehealth Guideline 2026',
                          style: HealoraTypography.h3(
                            color: HealoraColors.pine,
                            isBangla: state.isBangla,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          state.t(
                            'Local Bangladesh data residency enforced. Overseas specialist sharing restricted to explicit teleconsultations.',
                            'বাংলাদেশের মাটিতে স্থানীয় ডাটা সেন্টার বাধ্যতামূলক। বিদেশে কেবল সুনির্দিষ্ট সম্মতিতেই তথ্য প্রযোজ্য।',
                          ),
                          style: HealoraTypography.micro(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ),
                        ),
                      ],
                    ),
                  ),
                  HealoraCard.tint(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BMDC Guidance 2020',
                          style: HealoraTypography.h3(
                            color: HealoraColors.pine,
                            isBangla: state.isBangla,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          state.t(
                            'Doctor identity & BMDC registration verified. Health workers operate strictly under permitted scope.',
                            'ডাক্তারের BMDC নিবন্ধন যাচাইকরণ ও স্বাস্থ্যকর্মীর সুনির্দিষ্ট অনুমোদন নিশ্চিতকরণ।',
                          ),
                          style: HealoraTypography.micro(
                            color: HealoraColors.slate,
                            isBangla: state.isBangla,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 28.h),

          // Audit Entries List
          Text(
            state.t(
              'Immutable Audit Trail Events (${controller.eventCount})',
              'অডিট ট্রেইল ইভেন্ট লগ (${controller.eventCount})',
            ),
            style: HealoraTypography.h2(isBangla: state.isBangla),
          ),
          SizedBox(height: 12.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.auditLogs.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, idx) {
              final AuditLogEntry log = state.auditLogs[idx];

              return HealoraCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: HealoraColors.bone,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HealoraColors.line, width: 1),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fingerprint,
                          size: 20,
                          color: HealoraColors.teal,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
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
                                  log.action,
                                  style: HealoraTypography.label(
                                    color: HealoraColors.pine,
                                    isBangla: state.isBangla,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${log.actorName} (${log.actorRole})',
                                style: HealoraTypography.caption(
                                  fontWeight: FontWeight.w600,
                                  color: HealoraColors.ink,
                                  isBangla: state.isBangla,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                log.timestamp,
                                style: HealoraTypography.tabular(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: HealoraColors.slate,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            log.details,
                            style: HealoraTypography.bodySmall(
                              color: HealoraColors.ink,
                              isBangla: state.isBangla,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              const Icon(
                                Icons.gavel,
                                size: 14,
                                color: HealoraColors.teal,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                log.complianceStandard,
                                style: HealoraTypography.micro(
                                  color: HealoraColors.teal,
                                  isBangla: state.isBangla,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                '${state.t("Hub:", "হাব:")} ${log.hubName}',
                                style: HealoraTypography.micro(
                                  color: HealoraColors.slate,
                                  isBangla: state.isBangla,
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
            },
          ),
        ],
      ),
    );
  }
}
