import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';

/// One "icon chip + value" row for a contact/customer detail panel —
/// shared by the Contacts feature's [ContactDetailPane] and the Inbox's
/// CustomerDetailPanel so both read as the same design language. The
/// icon sits in a small soft-tinted circle (rather than a bare muted
/// icon) for a slightly more modern, less form-like feel; the value
/// carries a tooltip so a value long enough to truncate is still
/// readable on hover.
class DetailFieldRow extends StatelessWidget {
  const DetailFieldRow({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = iconColor ?? colors.primary;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: tint),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Tooltip(
            message: label,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
