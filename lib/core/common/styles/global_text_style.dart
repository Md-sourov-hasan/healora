import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  double? lineHeight,
  String fontFamily = 'SF Pro Display',
}) {
  return GoogleFonts.instrumentSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: lineHeight != null ? lineHeight / fontSize : null,
    textStyle: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: const [
        'Noto Sans Bengali',
        'system-ui',
        '-apple-system',
        'Segoe UI',
        'Roboto',
        'sans-serif',
      ],
    ),
  );
}

