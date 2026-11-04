import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healora/core/theme/healora_colors.dart';

/// Typography matching Chapter 03 of Healora Design System
class HealoraTypography {
  static const List<String> fontFallbacks = [
    'Noto Sans Bengali',
    'system-ui',
    '-apple-system',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];

  static const List<String> serifFallbacks = [
    'Georgia',
    'Cambria',
    'Times New Roman',
    'serif',
  ];

  // Helper for Instrument Sans with Bangla fallback
  static TextStyle _sans({
    required double fontSize,
    required double lineHeightPx,
    FontWeight fontWeight = FontWeight.w400,
    Color color = HealoraColors.ink,
    double letterSpacing = 0.0,
    bool isBangla = false,
    bool tabular = false,
  }) {
    final double height = (lineHeightPx / fontSize) * (isBangla ? 1.10 : 1.0);
    return GoogleFonts.instrumentSans(
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
      textStyle: const TextStyle(fontFamilyFallback: fontFallbacks),
    );
  }

  // Helper for Instrument Serif (Display moments only)
  static TextStyle _serif({
    required double fontSize,
    required double lineHeightPx,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    Color color = HealoraColors.pine,
    double letterSpacing = -0.005,
    bool isBangla = false,
  }) {
    final double height = (lineHeightPx / fontSize) * (isBangla ? 1.10 : 1.0);
    return GoogleFonts.instrumentSerif(
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing * fontSize,
      textStyle: const TextStyle(fontFamilyFallback: serifFallbacks),
    );
  }

  // Display: Serif 400 (Mobile 34/38, Desktop 56/60)
  static TextStyle display({
    bool isDesktop = false,
    bool isBangla = false,
    Color color = HealoraColors.pine,
  }) {
    return _serif(
      fontSize: isDesktop ? 56.0 : 34.0,
      lineHeightPx: isDesktop ? 60.0 : 38.0,
      fontWeight: FontWeight.w400,
      color: color,
      letterSpacing: -0.005,
      isBangla: isBangla,
    );
  }

  // H1: 600 (Mobile 28/34, Desktop 40/48)
  static TextStyle h1({
    bool isDesktop = false,
    bool isBangla = false,
    Color color = HealoraColors.ink,
  }) {
    return _sans(
      fontSize: isDesktop ? 40.0 : 28.0,
      lineHeightPx: isDesktop ? 48.0 : 34.0,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: -0.01 * (isDesktop ? 40.0 : 28.0),
      isBangla: isBangla,
    );
  }

  // H2: 600 (Mobile 22/28, Desktop 28/36)
  static TextStyle h2({
    bool isDesktop = false,
    bool isBangla = false,
    Color color = HealoraColors.ink,
  }) {
    return _sans(
      fontSize: isDesktop ? 28.0 : 22.0,
      lineHeightPx: isDesktop ? 36.0 : 28.0,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: -0.005 * (isDesktop ? 28.0 : 22.0),
      isBangla: isBangla,
    );
  }

  // H3: 600 (Mobile 18/24, Desktop 20/28)
  static TextStyle h3({
    bool isDesktop = false,
    bool isBangla = false,
    Color color = HealoraColors.ink,
  }) {
    return _sans(
      fontSize: isDesktop ? 20.0 : 18.0,
      lineHeightPx: isDesktop ? 28.0 : 24.0,
      fontWeight: FontWeight.w600,
      color: color,
      isBangla: isBangla,
    );
  }

  // Body: 400 (16/24, max 68ch)
  static TextStyle body({
    bool isDesktop = false,
    bool isBangla = false,
    Color color = HealoraColors.ink,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return _sans(
      fontSize: 16.0,
      lineHeightPx: isDesktop ? 26.0 : 24.0,
      fontWeight: fontWeight,
      color: color,
      isBangla: isBangla,
    );
  }

  // Body small: 400 (15/22)
  static TextStyle bodySmall({
    bool isBangla = false,
    Color color = HealoraColors.ink,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return _sans(
      fontSize: 15.0,
      lineHeightPx: 22.0,
      fontWeight: fontWeight,
      color: color,
      isBangla: isBangla,
    );
  }

  // Caption: 500 (13/18, slate)
  static TextStyle caption({
    bool isDesktop = false,
    bool isBangla = false,
    Color color = HealoraColors.slate,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return _sans(
      fontSize: isDesktop ? 14.0 : 13.0,
      lineHeightPx: isDesktop ? 20.0 : 18.0,
      fontWeight: fontWeight,
      color: color,
      isBangla: isBangla,
    );
  }

  // Label: 600 (12/16, caps +0.04em tracking)
  static TextStyle label({
    bool isBangla = false,
    Color color = HealoraColors.slate,
  }) {
    return _sans(
      fontSize: 12.0,
      lineHeightPx: 16.0,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.04 * 12.0,
      isBangla: isBangla,
    );
  }

  // Micro: 500 (11/13)
  static TextStyle micro({
    bool isBangla = false,
    Color color = HealoraColors.slate,
  }) {
    return _sans(
      fontSize: 11.0,
      lineHeightPx: 13.0,
      fontWeight: FontWeight.w500,
      color: color,
      isBangla: isBangla,
    );
  }

  // Tabular Numbers for counts, dates, times, measurements
  static TextStyle tabular({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w600,
    Color color = HealoraColors.ink,
  }) {
    return _sans(
      fontSize: fontSize,
      lineHeightPx: fontSize * 1.2,
      fontWeight: fontWeight,
      color: color,
      tabular: true,
    );
  }

  // Price style: 600, 34/40 tabular, clay
  static TextStyle price({
    double fontSize = 34.0,
    Color color = HealoraColors.clay,
  }) {
    return _sans(
      fontSize: fontSize,
      lineHeightPx: fontSize * 1.18,
      fontWeight: FontWeight.w600,
      color: color,
      tabular: true,
    );
  }
}
