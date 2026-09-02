import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../organization/domain/organization_member.dart';

/// Column header row for the desktop/tablet Team table.
class TeamTableHeader extends StatelessWidget {
  const TeamTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = AppTypography.caption.copyWith(
      color: colors.textMuted,
      fontWeight: FontWeight.w600,
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surfaceSecondary),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Expanded(flex: 4, child: Text('MEMBER', style: style)),
            Expanded(flex: 2, child: Text('ROLE', style: style)),
            Expanded(flex: 2, child: Text('STATUS', style: style)),
            Expanded(flex: 2, child: Text('LAST ACTIVE', style: style)),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}

/// One desktop/tablet Team table row — compact (52-58px), flat, hairline
/// separators handled by the caller.
///
/// Not wrapped in a tappable [InkWell] — there's no member detail view to
/// open yet, and a hover/press cue that leads nowhere on click reads as
/// broken rather than informative.
class TeamTableRow extends StatelessWidget {
  const TeamTableRow({super.key, required this.member});

  final OrganizationMember member;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                AppAvatar(name: member.displayName, radius: 15),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        member.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (member.email != null)
                        Text(
                          member.email!,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: colors.textMuted,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              member.role.label,
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(flex: 2, child: _MemberStatusBadge(member: member)),
          Expanded(
            flex: 2,
            child: Text(
              member.lastActiveAt == null
                  ? '—'
                  : timeago.format(member.lastActiveAt!, locale: 'en_short'),
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          SizedBox(
            width: 32,
            child: IconButton(
              tooltip: 'More actions (coming in a later stage)',
              icon: const Icon(Icons.more_horiz, size: 18),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}

/// A member as a compact structured row for mobile — same information
/// as the table, stacked instead of columned.
class TeamMemberMobileRow extends StatelessWidget {
  const TeamMemberMobileRow({super.key, required this.member});

  final OrganizationMember member;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(name: member.displayName, radius: 17),
          const Gap(AppSpacing.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (member.email != null)
                  Text(
                    member.email!,
                    style: AppTypography.caption.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                const Gap(AppSpacing.xs + 2),
                Row(
                  children: [
                    Text(
                      member.role.label,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    _MemberStatusBadge(member: member),
                  ],
                ),
                if (member.lastActiveAt != null) ...[
                  const Gap(2),
                  Text(
                    'Last active ${timeago.format(member.lastActiveAt!, locale: 'en_short')}',
                    style: AppTypography.caption.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const IconButton(
            tooltip: 'More actions (coming in a later stage)',
            icon: Icon(Icons.more_horiz, size: 18),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class _MemberStatusBadge extends StatelessWidget {
  const _MemberStatusBadge({required this.member});

  final OrganizationMember member;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = member.status == OrganizationMemberStatus.active;

    return AppBadge(
      label: member.status.label,
      color: active ? colors.success : colors.textMuted,
    );
  }
}
