import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) => FlutterFlowTheme();

  Color get primary => const Color(0xFFCF4A14);
  Color get secondary => const Color(0xFFFFD200);
  Color get primaryText => const Color(0xFF101213);
  Color get secondaryText => const Color(0xFF57636C);
  Color get primaryBackground => const Color(0xFFF1F4F8);
  Color get secondaryBackground => Colors.white;
  Color get alternate => const Color(0xFFE0E3E7);
  Color get error => const Color(0xFFFF5963);
  Color get info => Colors.white;

  TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.normal,
      );

  TextStyle get displaySmall => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w600,
      );

  TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.normal,
      );

  TextStyle get headlineSmall => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.normal,
      );

  TextStyle get titleLarge => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      );

  TextStyle get titleMedium => GoogleFonts.readexPro(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  TextStyle get titleSmall => GoogleFonts.readexPro(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get bodyLarge => GoogleFonts.readexPro(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  TextStyle get bodyMedium => GoogleFonts.readexPro(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get bodySmall => GoogleFonts.readexPro(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  TextStyle get labelLarge => GoogleFonts.readexPro(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  TextStyle get labelMedium => GoogleFonts.readexPro(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get labelSmall => GoogleFonts.readexPro(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );
}

extension FlutterFlowTextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    TextStyle? font,
    Color? color,
    double? fontSize,
    double? letterSpacing,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? lineHeight,
  }) {
    return copyWith(
      color: color,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: lineHeight,
    );
  }
}