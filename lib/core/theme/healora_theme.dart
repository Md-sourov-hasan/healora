import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';

class HealoraTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: HealoraColors.bone,
      canvasColor: HealoraColors.bone,
      cardColor: HealoraColors.paper,
      dividerColor: HealoraColors.line,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: HealoraColors.ink,
        onPrimary: Colors.white,
        secondary: HealoraColors.teal,
        onSecondary: Colors.white,
        tertiary: HealoraColors.clay,
        onTertiary: Colors.white,
        surface: HealoraColors.paper,
        onSurface: HealoraColors.ink,
        error: HealoraColors.bad,
        onError: Colors.white,
        outline: HealoraColors.line,
      ),
      textTheme: GoogleFonts.instrumentSansTextTheme().apply(
        bodyColor: HealoraColors.ink,
        displayColor: HealoraColors.pine,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: HealoraColors.ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HealoraColors.paper,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: HealoraSpacing.borderControl,
          borderSide: const BorderSide(color: HealoraColors.line, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: HealoraSpacing.borderControl,
          borderSide: const BorderSide(color: HealoraColors.line, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: HealoraSpacing.borderControl,
          borderSide: const BorderSide(color: HealoraColors.teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: HealoraSpacing.borderControl,
          borderSide: const BorderSide(color: HealoraColors.bad, width: 1.5),
        ),
      ),
    );
  }
}

