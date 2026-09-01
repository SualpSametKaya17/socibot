import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic color tokens for UI chrome (surfaces, text, borders) —
/// separate from [AppColors]' raw brand palette so widgets ask for what
/// a color *means* ("sidebar", "textMuted") rather than a literal shade,
/// and get the right value automatically in light and dark.
///
/// Access via `Theme.of(context).extension<AppSemanticColors>()!` or the
/// `context.colors` shorthand below.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.sidebar,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primaryHover,
    required this.primarySoft,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color sidebar;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color primary;
  final Color primaryHover;
  final Color primarySoft;
  final Color success;
  final Color warning;
  final Color error;

  static const AppSemanticColors light = AppSemanticColors(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF6F7F9),
    sidebar: Color(0xFFF5F8FD),
    border: Color(0xFFE5E7EB),
    borderStrong: Color(0xFFD1D5DB),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF4B5563),
    textMuted: Color(0xFF9CA3AF),
    primary: AppColors.primary,
    primaryHover: Color(0xFF1D4ED8),
    primarySoft: Color(0xFFEAF2FE),
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.danger,
  );

  static const AppSemanticColors dark = AppSemanticColors(
    background: Color(0xFF121218),
    surface: Color(0xFF1B1B24),
    surfaceSecondary: Color(0xFF202028),
    sidebar: Color(0xFF17171F),
    border: Color(0xFF2D2D3A),
    borderStrong: Color(0xFF3D3D4D),
    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFFA1A1AA),
    textMuted: Color(0xFF71717A),
    primary: AppColors.primaryDark,
    primaryHover: Color(0xFF8FB4FF),
    primarySoft: Color(0xFF1C3A66),
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.danger,
  );

  @override
  AppSemanticColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSecondary,
    Color? sidebar,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? primaryHover,
    Color? primarySoft,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return AppSemanticColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      sidebar: sidebar ?? this.sidebar,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primarySoft: primarySoft ?? this.primarySoft,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  /// Shorthand for `Theme.of(context).extension<AppSemanticColors>()!`.
  AppSemanticColors get colors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
