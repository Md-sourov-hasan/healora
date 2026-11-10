import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';

enum HealoraButtonVariant {
  primary,
  secondary,
  small,
  text,
  icon,
  destructive,
}

class HealoraButton extends StatefulWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final HealoraButtonVariant variant;
  final bool fullWidth;
  final double? width;
  final bool showArrowChip;
  final bool isBangla;

  const HealoraButton({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    this.variant = HealoraButtonVariant.primary,
    this.fullWidth = false,
    this.width,
    this.showArrowChip = true,
    this.isBangla = false,
  });

  const HealoraButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
    this.width,
    this.showArrowChip = true,
    this.isBangla = false,
  })  : icon = null,
        variant = HealoraButtonVariant.primary;

  const HealoraButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.width,
    this.isBangla = false,
  })  : variant = HealoraButtonVariant.secondary,
        showArrowChip = false;

  const HealoraButton.small({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isBangla = false,
  })  : variant = HealoraButtonVariant.small,
        fullWidth = false,
        width = null,
        showArrowChip = false;

  const HealoraButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isBangla = false,
  })  : icon = null,
        variant = HealoraButtonVariant.text,
        fullWidth = false,
        width = null,
        showArrowChip = false;

  const HealoraButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
  })  : label = null,
        variant = HealoraButtonVariant.icon,
        fullWidth = false,
        width = null,
        showArrowChip = false,
        isBangla = false;

  @override
  State<HealoraButton> createState() => _HealoraButtonState();
}

class _HealoraButtonState extends State<HealoraButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;

    // Spec: All buttons scale to 0.985 on press over 100ms
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.985 : 1.0,
          duration: HealoraSpacing.durationPress,
          curve: HealoraSpacing.easeOut,
          child: AnimatedOpacity(
            opacity: isEnabled ? 1.0 : 0.45,
            duration: HealoraSpacing.durationFast,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.variant) {
      case HealoraButtonVariant.primary:
        return _buildPrimary();
      case HealoraButtonVariant.secondary:
        return _buildSecondary();
      case HealoraButtonVariant.small:
        return _buildSmall();
      case HealoraButtonVariant.text:
        return _buildText();
      case HealoraButtonVariant.icon:
        return _buildIcon();
      case HealoraButtonVariant.destructive:
        return _buildDestructive();
    }
  }

  Widget _buildPrimary() {
    final Color bgColor = _isPressed
        ? const Color(0xFF06141A)
        : (_isHovered ? const Color(0xFF13302F) : HealoraColors.ink);

    return Container(
      height: HealoraSpacing.primaryButtonHeight,
      width: widget.fullWidth ? double.infinity : widget.width,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: HealoraSpacing.borderControl,
      ),
      child: Row(
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.label ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HealoraTypography.body(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                isBangla: widget.isBangla,
              ),
            ),
          ),
          if (widget.showArrowChip) ...[
            SizedBox(width: 12.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: const BoxDecoration(
                color: Color(0x24FFFFFF), // white 14%
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_outward,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecondary() {
    final Color bgColor = _isHovered ? HealoraColors.mist : HealoraColors.paper;

    return Container(
      height: HealoraSpacing.primaryButtonHeight,
      width: widget.fullWidth ? double.infinity : widget.width,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: HealoraSpacing.borderControl,
        border: Border.all(color: HealoraColors.line, width: 1),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                widget.label ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HealoraTypography.body(
                  color: HealoraColors.ink,
                  fontWeight: FontWeight.w600,
                  isBangla: widget.isBangla,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmall() {
    final Color bgColor = _isHovered ? HealoraColors.mist : HealoraColors.paper;

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: HealoraSpacing.borderControl,
        border: Border.all(color: HealoraColors.line, width: 1),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              SizedBox(width: 6.w),
            ],
            Flexible(
              child: Text(
                widget.label ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HealoraTypography.bodySmall(
                  color: HealoraColors.ink,
                  fontWeight: FontWeight.w600,
                  isBangla: widget.isBangla,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    final Color textColor = _isHovered ? HealoraColors.pine : HealoraColors.teal;

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Center(
        child: Text(
          widget.label ?? '',
          style: HealoraTypography.bodySmall(
            color: textColor,
            fontWeight: FontWeight.w600,
            isBangla: widget.isBangla,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final Color bgColor = _isHovered ? HealoraColors.mist : HealoraColors.paper;

    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: HealoraColors.line, width: 1),
      ),
      child: Center(
        child: widget.icon ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDestructive() {
    return Container(
      height: HealoraSpacing.primaryButtonHeight,
      width: widget.fullWidth ? double.infinity : widget.width,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: HealoraColors.bad,
        borderRadius: HealoraSpacing.borderControl,
      ),
      child: Center(
        child: Text(
          widget.label ?? '',
          style: HealoraTypography.body(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            isBangla: widget.isBangla,
          ),
        ),
      ),
    );
  }
}

