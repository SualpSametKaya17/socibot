import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_toggle.dart';

/// A settings page's compact header — title + one-line description,
/// deliberately not a hero heading (this is a dense B2B tool, not a
/// marketing page).
class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    super.key,
    required this.title,
    required this.description,
    this.trailing,
  });

  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.headingSmall.copyWith(fontSize: 19),
              ),
              const Gap(4),
              Text(
                description,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// One labeled block of settings content — "SECTION TITLE / description
/// / controls" — the app's preferred structure over stacking everything
/// in cards. A [Divider] follows automatically unless [last] is set, so
/// call sites just list sections in order.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    this.description,
    required this.child,
    this.trailing,
    this.last = false,
  });

  final String title;
  final String? description;
  final Widget child;
  final Widget? trailing;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.labelLarge),
                    if (description != null) ...[
                      const Gap(2),
                      Text(
                        description!,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const Gap(AppSpacing.lg),
          child,
          if (!last) ...[
            const Gap(AppSpacing.xl),
            Divider(height: 1, color: colors.border),
          ],
        ],
      ),
    );
  }
}

/// One title(+description) / trailing-control row inside a
/// [SettingsSection] — the building block for toggle lists and simple
/// action rows, separated by hairline dividers rather than each living
/// in its own card.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.description,
    required this.trailing,
    this.last = false,
  });

  final String title;
  final String? description;
  final Widget trailing;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (description != null) ...[
                      const Gap(2),
                      Text(
                        description!,
                        style: AppTypography.caption.copyWith(
                          color: colors.textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(AppSpacing.lg),
              trailing,
            ],
          ),
        ),
        if (!last) Divider(height: 1, color: colors.border),
      ],
    );
  }
}

/// A [SettingsRow] whose trailing control is always an [AppToggle] —
/// covers the very common "title / description / switch" shape used
/// throughout Notifications and Inbox settings.
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
    this.last = false,
  });

  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      title: title,
      description: description,
      last: last,
      trailing: AppToggle(value: value, onChanged: onChanged),
    );
  }
}
