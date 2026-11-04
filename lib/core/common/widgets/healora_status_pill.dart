import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';

enum HealoraPillType {
  completed,
  awaiting,
  declined,
  upcoming,
  draft,
  inService,
  outOfService,
  custom,
}

class HealoraStatusPill extends StatelessWidget {
  final String label;
  final HealoraPillType type;
  final Color? customBg;
  final Color? customFg;
  final Color? customDot;
  final bool showDot;

  const HealoraStatusPill({
    super.key,
    required this.label,
    this.type = HealoraPillType.upcoming,
    this.customBg,
    this.customFg,
    this.customDot,
    this.showDot = true,
  });

  const HealoraStatusPill.completed({
    super.key,
    this.label = 'Completed',
    this.showDot = true,
  })  : type = HealoraPillType.completed,
        customBg = null,
        customFg = null,
        customDot = null;

  const HealoraStatusPill.awaiting({
    super.key,
    this.label = 'Awaiting review',
    this.showDot = true,
  })  : type = HealoraPillType.awaiting,
        customBg = null,
        customFg = null,
        customDot = null;

  const HealoraStatusPill.declined({
    super.key,
    this.label = 'Declined',
    this.showDot = true,
  })  : type = HealoraPillType.declined,
        customBg = null,
        customFg = null,
        customDot = null;

  const HealoraStatusPill.upcoming({
    super.key,
    this.label = 'Upcoming',
    this.showDot = true,
  })  : type = HealoraPillType.upcoming,
        customBg = null,
        customFg = null,
        customDot = null;

  const HealoraStatusPill.draft({
    super.key,
    this.label = 'Draft',
    this.showDot = true,
  })  : type = HealoraPillType.draft,
        customBg = null,
        customFg = null,
        customDot = null;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color dot;

    switch (type) {
      case HealoraPillType.completed:
        bg = HealoraColors.okBg;
        fg = HealoraColors.okFg;
        dot = HealoraColors.okFg;
        break;
      case HealoraPillType.awaiting:
        bg = HealoraColors.warnBg;
        fg = HealoraColors.warnFg;
        dot = HealoraColors.warnFg;
        break;
      case HealoraPillType.declined:
      case HealoraPillType.outOfService:
        bg = HealoraColors.badBg;
        fg = HealoraColors.badFg;
        dot = HealoraColors.badFg;
        break;
      case HealoraPillType.inService:
        bg = HealoraColors.mist;
        fg = HealoraColors.teal;
        dot = HealoraColors.teal;
        break;
      case HealoraPillType.upcoming:
        bg = HealoraColors.infoBg;
        fg = HealoraColors.infoFg;
        dot = HealoraColors.infoFg;
        break;
      case HealoraPillType.draft:
        bg = HealoraColors.draftBg;
        fg = HealoraColors.draftFg;
        dot = HealoraColors.draftFg;
        break;
      case HealoraPillType.custom:
        bg = customBg ?? HealoraColors.mist;
        fg = customFg ?? HealoraColors.ink;
        dot = customDot ?? fg;
        break;
    }

    return Container(
      height: HealoraSpacing.pillHeight,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: HealoraSpacing.borderPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showDot) ...[
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: dot,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: HealoraTypography.label(
              color: fg,
            ).copyWith(letterSpacing: 0.0),
          ),
        ],
      ),
    );
  }
}
