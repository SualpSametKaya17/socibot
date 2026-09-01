import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/settings_section.dart';

/// The desktop/tablet secondary navigation column — mirrors the app
/// shell's own nav-row styling (soft indigo fill + primary text when
/// selected, transparent + muted text otherwise) so Settings reads as
/// the same product rather than a bolted-on sub-app.
class SettingsNavigationPanel extends StatelessWidget {
  const SettingsNavigationPanel({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final SettingsSection selected;
  final ValueChanged<SettingsSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 208,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text('Settings', style: AppTypography.headingSmall),
          ),
          const Gap(2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              'Manage your workspace',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const Gap(AppSpacing.lg),
          for (final section in SettingsSection.values)
            _SettingsNavRow(
              section: section,
              selected: section == selected,
              onTap: () => onSelect(section),
            ),
        ],
      ),
    );
  }
}

class _SettingsNavRow extends StatelessWidget {
  const _SettingsNavRow({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final SettingsSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: selected ? colors.primarySoft : Colors.transparent,
        borderRadius: AppRadius.smAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smAll,
          hoverColor: colors.surfaceSecondary,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  section.icon,
                  size: 17,
                  color: selected ? colors.primary : colors.textSecondary,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  section.label,
                  style: AppTypography.bodySmall.copyWith(
                    color: selected ? colors.primary : colors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Mobile Settings home — a plain navigable list ("Workspace >", "Team
/// >", ...) rather than the desktop sidebar squeezed into a narrow
/// column. Tapping a row opens that section with its own back button.
class SettingsMobileList extends StatelessWidget {
  const SettingsMobileList({super.key, required this.onSelect});

  final ValueChanged<SettingsSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        for (final section in SettingsSection.values)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelect(section),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Icon(section.icon, size: 20, color: colors.textSecondary),
                    const Gap(AppSpacing.md),
                    Expanded(
                      child: Text(
                        section.label,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: colors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Tablet's compact top navigation — a horizontally scrollable pill row
/// replacing the permanent desktop sidebar once there isn't room for it,
/// per the responsive brief (dropdown/compact-nav, not a squeezed
/// sidebar).
class SettingsTabletNavBar extends StatelessWidget {
  const SettingsTabletNavBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final SettingsSection selected;
  final ValueChanged<SettingsSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            for (final section in SettingsSection.values) ...[
              _TabletPill(
                section: section,
                selected: section == selected,
                onTap: () => onSelect(section),
              ),
              const Gap(AppSpacing.xs),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabletPill extends StatelessWidget {
  const _TabletPill({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final SettingsSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected ? colors.primarySoft : Colors.transparent,
      borderRadius: AppRadius.fullAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.fullAll,
        hoverColor: colors.surfaceSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                section.icon,
                size: 15,
                color: selected ? colors.primary : colors.textSecondary,
              ),
              const Gap(AppSpacing.xs),
              Text(
                section.label,
                style: AppTypography.labelMedium.copyWith(
                  color: selected ? colors.primary : colors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
