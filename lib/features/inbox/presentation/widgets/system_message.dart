import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// A small, centered, muted activity line in the message thread (e.g.
/// "Assigned to X") — visually distinct from a real chat message so it
/// reads as metadata, not something either party said.
class SystemMessage extends StatelessWidget {
  const SystemMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: AppRadius.fullAll,
          border: Border.all(color: colors.border),
        ),
        child: Text(
          text,
          style: AppTypography.caption.copyWith(color: colors.textMuted),
        ),
      ),
    );
  }
}
