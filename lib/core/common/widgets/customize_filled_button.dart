import 'package:flutter/material.dart';
import 'package:healora/core/common/styles/global_text_style.dart';
import 'package:healora/core/utils/constants/colors.dart';
import 'package:healora/core/utils/sizer.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? icon;
  final bool isLoading;

  const CustomFilledButton({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
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

