import 'package:flutter/material.dart';

/// Spacing, corner radii, and elevation specs from Chapter 04 & 05
class HealoraSpacing {
  // Spacing scale (4px base)
  static const double space0_5 = 2.0;
  static const double space1 = 4.0;
  static const double space1_5 = 6.0;
  static const double space2 = 8.0;
  static const double space2_5 = 10.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0; // Gutter, header bottom margin
  static const double space6 = 24.0; // Web card padding
  static const double space7 = 28.0; // Section spacing
  static const double space8 = 32.0; // Tablet margins
  static const double space10 = 40.0; // Desktop margins

  // Corner radii
  static const double rPill = 8.0;
  static const double rChip = 10.0;
  static const double rControl = 14.0; // Buttons, inputs, toasts, icon squares
  static const double rTile = 18.0; // Stat tiles
  static const double rBar = 22.0; // Tab bar, banners
  static const double rCard = 24.0; // Cards
  static const double rSheet = 28.0; // Sheets, hero cards

  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(rPill));
  static const BorderRadius borderChip = BorderRadius.all(Radius.circular(rChip));
  static const BorderRadius borderControl = BorderRadius.all(Radius.circular(rControl));
  static const BorderRadius borderTile = BorderRadius.all(Radius.circular(rTile));
  static const BorderRadius borderBar = BorderRadius.all(Radius.circular(rBar));
  static const BorderRadius borderCard = BorderRadius.all(Radius.circular(rCard));
  static const BorderRadius borderSheet = BorderRadius.all(Radius.circular(rSheet));
  static const BorderRadius borderSheetTop = BorderRadius.vertical(top: Radius.circular(rSheet));

  // Breakpoints
  static const double bpTablet = 600.0;
  static const double bpDesktop = 1100.0;
  static const double maxContentWidth = 1200.0;
  static const double sidebarWidth = 248.0;
  static const double iconRailWidth = 88.0;

  // Sizes
  static const double minTouchTarget = 44.0;
  static const double primaryButtonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double chipHeight = 36.0;
  static const double pillHeight = 24.0;
  static const double tabBarHeight = 64.0;

  // Motion timings
  static const Duration durationPress = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationBase = Duration(milliseconds: 200);
  static const Duration durationPush = Duration(milliseconds: 320);
  static const Duration durationSheet = Duration(milliseconds: 350);
  static const Cubic easeOut = Cubic(0.2, 0.8, 0.2, 1.0);
}

