import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Named type scale (Inter). Weights lean regular/medium/semibold —
/// heavy bold is reserved for the few places that need real emphasis
/// (unread state, primary buttons), not used everywhere.
class AppTypography {
  const AppTypography._();

  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 28,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headingMedium =>
      GoogleFonts.inter(fontSize: 22, height: 1.3, fontWeight: FontWeight.w600);

  static TextStyle get headingSmall =>
      GoogleFonts.inter(fontSize: 18, height: 1.3, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge =>
      GoogleFonts.inter(fontSize: 16, height: 1.4, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      GoogleFonts.inter(fontSize: 14, height: 1.4, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall =>
      GoogleFonts.inter(fontSize: 13, height: 1.4, fontWeight: FontWeight.w400);

  static TextStyle get labelLarge =>
      GoogleFonts.inter(fontSize: 14, height: 1.2, fontWeight: FontWeight.w600);

  static TextStyle get labelMedium =>
      GoogleFonts.inter(fontSize: 13, height: 1.2, fontWeight: FontWeight.w500);

  static TextStyle get caption =>
      GoogleFonts.inter(fontSize: 11, height: 1.2, fontWeight: FontWeight.w600);

  /// Maps the named scale onto Material's [TextTheme] slots so existing
  /// `Theme.of(context).textTheme.*` call sites keep working unchanged,
  /// with [color] applied as the default text color.
  static TextTheme textTheme(Color color) {
    return TextTheme(
      headlineSmall: headingLarge.copyWith(color: color),
      titleLarge: headingMedium.copyWith(color: color),
      titleMedium: headingSmall.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      bodySmall: bodySmall.copyWith(color: color),
      labelLarge: labelLarge.copyWith(color: color),
      labelMedium: labelMedium.copyWith(color: color),
      labelSmall: caption.copyWith(color: color),
    );
  }
}
