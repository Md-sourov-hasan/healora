import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/theme/healora_typography.dart';

class HealoraTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isBangla;
  final double height;

  const HealoraTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.isBangla = false,
    this.height = HealoraSpacing.inputHeight,
  });

  @override
  State<HealoraTextField> createState() => _HealoraTextFieldState();
}

class _HealoraTextFieldState extends State<HealoraTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: HealoraTypography.caption(
              color: HealoraColors.slate,
              isBangla: widget.isBangla,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6), // 6px gap from design system
        ],
        Container(
          height: widget.maxLines > 1 ? null : widget.height,
          decoration: BoxDecoration(
            color: HealoraColors.paper,
            borderRadius: HealoraSpacing.borderControl,
            border: Border.all(
              color: _isFocused ? HealoraColors.teal : HealoraColors.line,
              width: _isFocused ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            cursorColor: HealoraColors.teal,
            style: HealoraTypography.body(
              color: HealoraColors.ink,
              isBangla: widget.isBangla,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              hintStyle: HealoraTypography.body(
                color: HealoraColors.slate.withOpacity(0.7),
                isBangla: widget.isBangla,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: widget.prefixIcon,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

/// Search Bar paired with ink button (from Section 7.3)
class HealoraSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;
  final VoidCallback? onVoice;
  final bool isBangla;

  const HealoraSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSearch,
    this.onVoice,
    this.isBangla = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: HealoraColors.paper,
        borderRadius: HealoraSpacing.borderControl,
        border: Border.all(color: HealoraColors.line, width: 1),
      ),
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: Row(
        children: [
          const Icon(Icons.search, color: HealoraColors.slate, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: HealoraColors.teal,
              style: HealoraTypography.body(
                color: HealoraColors.ink,
                isBangla: isBangla,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: HealoraTypography.body(
                  color: HealoraColors.slate.withOpacity(0.7),
                  isBangla: isBangla,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onVoice != null) ...[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: HealoraColors.ink,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.mic, color: Colors.white, size: 20),
                onPressed: onVoice,
                tooltip: isBangla ? 'ভয়েস অনুসন্ধান' : 'Voice search',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

