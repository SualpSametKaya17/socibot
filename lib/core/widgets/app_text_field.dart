import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// A labeled text input built on the app's global [InputDecorationTheme]
/// — every Settings form field shares this instead of each screen
/// hand-rolling its own label + [TextField] pairing.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? helperText;
  final bool readOnly;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: readOnly,
          enabled: enabled,
          onChanged: onChanged,
          style: AppTypography.bodySmall.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: readOnly ? colors.surfaceSecondary : colors.surface,
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            helperText!,
            style: AppTypography.caption.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
