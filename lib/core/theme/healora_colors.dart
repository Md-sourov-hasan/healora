import 'package:flutter/material.dart';

/// Design tokens matching "Healora Design System v1.0 - Organic Clinical"
class HealoraColors {
  // Neutrals - The canvas
  static const Color bone = Color(0xFFF5F3EE); // App background, flow footers
  static const Color paper = Color(0xFFFFFFFF); // Cards, sheets, inputs, tab bar, secondary buttons
  static const Color line = Color(0xFFDDE5E1); // Hairlines, borders, dividers, inactive switch
  static const Color slate = Color(0xFF5B6B6E); // Secondary text, captions, labels, inactive tabs
  static const Color ink = Color(0xFF0B1F22); // Primary text, primary buttons, selected chips, toasts

  // Sage greens - Calm, clinical trust
  static const Color mist = Color(0xFFE6EEEA); // Tint cards, hover fills, image placeholders
  static const Color sage200 = Color(0xFFCFE0D8); // Icon squares, progress tracks, step bar rest
  static const Color sage400 = Color(0xFF8FB3A3); // Radio rings, timeline rest dots, decorative rings
  static const Color teal = Color(0xFF1D6B66); // Selection, progress fill, links, focus ring, active dot
  static const Color pine = Color(0xFF0F3D3A); // Display headlines, text on mist, link hover

  // Accents - Used sparingly
  static const Color clay = Color(0xFFC0633F); // Price totals at 24px+, Best value tag, quote heart, badge
  static const Color clay600 = Color(0xFFA4502F); // Clay text below 24px, prices on white
  static const Color amber = Color(0xFFE3A83B); // Star ratings only

  // System status
  static const Color ok = Color(0xFF2F855A); // Success icons, verified states
  static const Color okBg = Color(0xFFE3F1E8); // Completed pill background
  static const Color okFg = Color(0xFF22643F); // Completed pill text

  static const Color warn = Color(0xFFB7791F); // Pending and attention icons
  static const Color warnBg = Color(0xFFF8EDD8); // Awaiting pill background
  static const Color warnFg = Color(0xFF80540F); // Awaiting pill text

  static const Color bad = Color(0xFFC53030); // End call, destructive actions, errors
  static const Color badBg = Color(0xFFFBE4E4); // Declined pill background
  static const Color badFg = Color(0xFF9B2424); // Declined pill text

  static const Color infoBg = Color(0xFFE6EEEA); // Upcoming pill background
  static const Color infoFg = Color(0xFF0F3D3A); // Upcoming pill text

  static const Color draftBg = Color(0xFFEEEDE8); // Draft pill background
  static const Color draftFg = Color(0xFF5B6B6E); // Draft pill text

  // Gradients
  static const LinearGradient washGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.55, 1.0],
    colors: [
      Color(0xFFD7E6E0),
      Color(0xFFEEF3F0),
      Color(0xFFF5F3EE),
    ],
  );

  // Organic background blob colors
  static const Color blob1 = Color(0xFFDCE7E0);
  static const Color blob2 = Color(0xFFE3ECE6);

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F0B1F22), // 6% ink
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color(0x1F0B1F22), // 12% ink
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -12,
    ),
  ];

  static const List<BoxShadow> floatShadow = [
    BoxShadow(
      color: Color(0x470B1F22), // 28% ink
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: -10,
    ),
  ];

  static const List<BoxShadow> raisedShadow = [
    BoxShadow(
      color: Color(0x800B1F22), // 50% ink
      offset: Offset(0, 10),
      blurRadius: 20,
      spreadRadius: -8,
    ),
  ];
}

