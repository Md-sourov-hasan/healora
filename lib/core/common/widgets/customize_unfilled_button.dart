import 'package:flutter/material.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';

class CustomUnfilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? icon;

  const CustomUnfilledButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor = AppColors.primary,
    this.borderColor = AppColors.primary,
    this.backgroundColor = Colors.transparent,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              8.horizontalSpace,
            ],
            Text(
              text,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

