import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// One selectable option for [AppDropdownField].
class AppDropdownItem<T> {
  const AppDropdownItem(this.value, this.label);

  final T value;
  final String label;
}

/// A labeled dropdown matching [AppTextField]'s visual weight (same
/// height, radius, and border via the shared [InputDecorationTheme]) so
/// a form mixing text fields and selects reads as one consistent set of
/// controls rather than two different widget styles.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

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
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          icon: Icon(Icons.expand_more, size: 18, color: colors.textMuted),
          style: AppTypography.bodySmall.copyWith(color: colors.textPrimary),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? colors.surface : colors.surfaceSecondary,
          ),
          items: [
            for (final item in items)
              DropdownMenuItem(value: item.value, child: Text(item.label)),
          ],
        ),
      ],
    );
  }
}
