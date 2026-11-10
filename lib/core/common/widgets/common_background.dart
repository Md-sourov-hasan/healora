import 'package:flutter/material.dart';
import 'package:healora/core/utils/constants/colors.dart';

class CommonBackground extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? backgroundColor;

  const CommonBackground({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.padding,
    this.gradient,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    if (useSafeArea) {
      content = SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        left: safeAreaLeft,
        right: safeAreaRight,
        child: content,
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundLight,
        gradient: gradient ??
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.45, 1.0],
              colors: [
                Color(0xFFE2EBE6),
                Color(0xFFEEF3F0),
                Color(0xFFF5F3EE),
              ],
            ),
      ),
      child: content,
    );
  }
}

class CommonBackgroundScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool useSafeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  const CommonBackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.padding,
    this.backgroundColor,
    this.gradient,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundLight,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      appBar: appBar,
      body: CommonBackground(
        useSafeArea: useSafeArea,
        safeAreaTop: safeAreaTop,
        safeAreaBottom: safeAreaBottom,
        safeAreaLeft: safeAreaLeft,
        safeAreaRight: safeAreaRight,
        padding: padding,
        gradient: gradient,
        backgroundColor: backgroundColor,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
