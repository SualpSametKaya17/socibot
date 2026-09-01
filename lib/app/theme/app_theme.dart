import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_semantic_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Light/dark Material 3 theme for the app: modern B2B SaaS — white
/// surfaces, a light lavender/cool-gray sidebar, one indigo accent, thin
/// borders instead of shadows, soft (not pill-everywhere) corners.
class AppTheme {
  const AppTheme._();

  static ThemeData get light =>
      _build(AppSemanticColors.light, Brightness.light);

  static ThemeData get dark => _build(AppSemanticColors.dark, Brightness.dark);

  static ThemeData _build(AppSemanticColors colors, Brightness brightness) {
    final onAccent = Colors.white;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: colors.primary,
      surface: colors.surface,
      error: colors.error,
      outline: colors.border,
      onSurfaceVariant: colors.textSecondary,
    );

    final border = BorderSide(
      color: colors.border,
      width: AppSizes.borderWidth,
    );
    final focusedBorder = BorderSide(
      color: colors.primary,
      width: AppSizes.borderWidthFocused,
    );
    final errorBorder = BorderSide(
      color: colors.error,
      width: AppSizes.borderWidth,
    );

    OutlineInputBorder outline(BorderSide side) =>
        OutlineInputBorder(borderRadius: AppRadius.mdAll, borderSide: side);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: AppTypography.textTheme(colors.textPrimary),
      extensions: [colors],
      // Stock Material's touch-sized defaults (buttons, checkboxes, popup
      // menu rows) read as "a Flutter app" on a dense desktop SaaS
      // screen; tightening density and dropping the growing-circle
      // ripple in favor of a flat hover/press overlay is most of the fix.
      visualDensity: VisualDensity.compact,
      splashFactory: NoSplash.splashFactory,
      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(AppRadius.full),
        thumbColor: WidgetStatePropertyAll(
          colors.textMuted.withValues(alpha: 0.35),
        ),
        trackColor: const WidgetStatePropertyAll(Colors.transparent),
        trackBorderColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        titleTextStyle: AppTypography.headingSmall.copyWith(
          color: colors.textPrimary,
          fontSize: 16,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: border,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: AppSizes.borderWidth,
        space: AppSizes.borderWidth,
      ),

      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + 2,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: colors.textMuted),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
        border: outline(border),
        enabledBorder: outline(border),
        focusedBorder: outline(focusedBorder),
        errorBorder: outline(errorBorder),
        focusedErrorBorder: outline(errorBorder),
      ),

      // Primary button.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.controlHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelLarge),
          foregroundColor: WidgetStatePropertyAll(onAccent),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.textMuted.withValues(alpha: 0.3);
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colors.primaryHover;
            }
            return colors.primary;
          }),
        ),
      ),

      // Secondary button.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.controlHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelLarge),
          foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colors.surfaceSecondary;
            }
            return colors.surface;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: colors.border)),
        ),
      ),

      // Ghost button.
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.controlHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelLarge),
          foregroundColor: WidgetStatePropertyAll(colors.primary),
          overlayColor: WidgetStatePropertyAll(colors.primarySoft),
        ),
      ),

      // Icon button. Stock IconButton reserves a 48x48 touch target —
      // fine on mobile, but it visibly bloats icon rows on a dense
      // desktop header/composer/toolbar, so tighten it to match the
      // reference's compact icon spacing.
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          foregroundColor: WidgetStatePropertyAll(colors.textSecondary),
          overlayColor: WidgetStatePropertyAll(colors.surfaceSecondary),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(6)),
          minimumSize: const WidgetStatePropertyAll(Size(32, 32)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.primarySoft,
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: colors.textSecondary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: colors.primary,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: colors.primarySoft,
        indicatorShape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        useIndicator: true,
        selectedIconTheme: IconThemeData(
          color: colors.primary,
          size: AppSizes.iconMd,
        ),
        unselectedIconTheme: IconThemeData(
          color: colors.textMuted,
          size: AppSizes.iconMd,
        ),
        selectedLabelTextStyle: AppTypography.labelMedium.copyWith(
          color: colors.primary,
        ),
        unselectedLabelTextStyle: AppTypography.labelMedium.copyWith(
          color: colors.textMuted,
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: border,
        ),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.textPrimary,
          borderRadius: AppRadius.smAll,
        ),
        textStyle: AppTypography.caption.copyWith(color: colors.background),
      ),
    );
  }
}
