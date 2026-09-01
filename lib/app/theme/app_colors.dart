import 'package:flutter/material.dart';

/// Raw brand palette — literal colors that don't change between light and
/// dark (channel brand colors, the accent itself). UI chrome colors that
/// *do* change with brightness (surfaces, borders, text) live in
/// [AppSemanticColors] instead, not here.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF5B8DFF);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Channel brand colors, used by ChannelBadge.
  static const Color instagram = Color(0xFFE1306C);
  static const Color facebookMessenger = Color(0xFF0084FF);
  static const Color whatsapp = Color(0xFF25D366);
}
