import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';

enum HealoraCardVariant {
  elevated, // Default card with card shadow
  flat,     // 1px border, no shadow
  tint,     // Mist background, no shadow
  hero,     // Ink background, white text
}

class HealoraCard extends StatefulWidget {
  final Widget child;
  final HealoraCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const HealoraCard({
    super.key,
    required this.child,
    this.variant = HealoraCardVariant.elevated,
    this.padding,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
  });

  const HealoraCard.flat({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
  }) : variant = HealoraCardVariant.flat;

  const HealoraCard.tint({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
  }) : variant = HealoraCardVariant.tint;

  const HealoraCard.hero({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
  }) : variant = HealoraCardVariant.hero;

  @override
  State<HealoraCard> createState() => _HealoraCardState();
}

class _HealoraCardState extends State<HealoraCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = widget.borderRadius ?? HealoraSpacing.borderCard;
    final EdgeInsetsGeometry pad = widget.padding ?? EdgeInsets.all(20.r);

    Color bgColor;
    Border? border;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case HealoraCardVariant.elevated:
        bgColor = HealoraColors.paper;
        border = Border.all(color: HealoraColors.line.withValues(alpha: 0.4), width: 0.5);
        // Chapter 12: On desktop web hover: cards lift to Float shadow
        shadows = (_isHovered && widget.onTap != null)
            ? HealoraColors.floatShadow
            : HealoraColors.cardShadow;
        break;
      case HealoraCardVariant.flat:
        bgColor = _isHovered && widget.onTap != null ? HealoraColors.mist : HealoraColors.paper;
        border = Border.all(color: HealoraColors.line, width: 1);
        shadows = null;
        break;
      case HealoraCardVariant.tint:
        bgColor = HealoraColors.mist;
        border = null;
        shadows = null;
        break;
      case HealoraCardVariant.hero:
        bgColor = HealoraColors.ink;
        border = null;
        shadows = HealoraColors.floatShadow;
        break;
    }

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      padding: pad,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: border,
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isPressed ? 0.985 : 1.0,
            duration: HealoraSpacing.durationPress,
            curve: HealoraSpacing.easeOut,
            child: content,
          ),
        ),
      );
    }

    return content;
  }
}

/// Stat Tile component from Section 7.6: "Stat tiles are 3-up, r18, flat."
class HealoraStatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? valueColor;
  final bool isBangla;

  const HealoraStatTile({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.isBangla = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: HealoraColors.paper,
        borderRadius: HealoraSpacing.borderTile,
        border: Border.all(color: HealoraColors.line, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HealoraTypography.label(
                    color: HealoraColors.slate,
                    isBangla: isBangla,
                  ),
                ),
              ),
              ?icon,
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: HealoraTypography.tabular(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: valueColor ?? HealoraColors.ink,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: HealoraTypography.caption(
                color: HealoraColors.slate,
                isBangla: isBangla,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
