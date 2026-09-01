import 'package:flutter/material.dart';

/// Brand and semantic colors shared across the light/dark themes.
///
/// Kept centralized so every screen draws from the same palette instead of
/// hardcoding colors inline (see rule 12 — one design language everywhere).
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF5B5BF3);
  static const Color primaryDark = Color(0xFF7C7CFF);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  static const Color lightBackground = Color(0xFFF7F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7EB);

  static const Color darkBackground = Color(0xFF121218);
  static const Color darkSurface = Color(0xFF1B1B24);
  static const Color darkBorder = Color(0xFF2D2D3A);

  // Channel brand colors, used by ChannelBadge in a later stage.
  static const Color instagram = Color(0xFFE1306C);
  static const Color facebookMessenger = Color(0xFF0084FF);
  static const Color whatsapp = Color(0xFF25D366);
}
