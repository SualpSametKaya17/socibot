import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// A "Load more" row appended to the bottom of a client-side-paginated
/// list — reveals the next page of an already-fetched list rather than
/// making a new request, since every list in this app is mock-fetched
/// in full up front.
class LoadMoreRow extends StatelessWidget {
  const LoadMoreRow({super.key, required this.remaining, required this.onTap});

  final int remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: colors.surfaceSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.expand_more, size: 16, color: colors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Load more ($remaining)',
                style: AppTypography.labelMedium.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
