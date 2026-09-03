import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_avatar.dart';
import '../../app/theme/app_typography.dart';

/// One row in the inbox conversation list. Takes prebuilt badge widgets
/// (rather than a domain [Conversation]) so it stays reusable without
/// depending on any one feature's data model.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.contactName,
    this.contactAvatarUrl,
    required this.channelBadge,
    required this.statusBadge,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.assignedAgentName,
    this.unreadCount = 0,
    this.selected = false,
    this.onTap,
  });

  final String contactName;
  final String? contactAvatarUrl;
  final Widget channelBadge;
  final Widget statusBadge;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;

  /// Shown as a small "Assigned to X" line when set — null renders
  /// nothing rather than an "Unassigned" placeholder.
  final String? assignedAgentName;
  final int unreadCount;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isUnread = unreadCount > 0;

    // Selected state reads as a slim colored edge + soft tint across a
    // flat rectangle — not a rounded, boxed card. Rows in a list don't
    // get corners; only the hover ripple stays (subtly) rounded.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? colors.primarySoft : Colors.transparent,
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              hoverColor: colors.surfaceSecondary,
              splashColor: colors.primarySoft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md + 2,
                  right: AppSpacing.sm + 2,
                  top: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAvatar(
                      name: contactName,
                      imageUrl: contactAvatarUrl,
                      radius: 18,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  contactName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13,
                                    fontWeight: isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (lastMessageAt != null)
                                Text(
                                  timeago.format(
                                    lastMessageAt!,
                                    locale: 'en_short',
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isUnread
                                        ? colors.primary
                                        : colors.textMuted,
                                    fontWeight: isUnread
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs + 2),
                          Row(
                            children: [
                              channelBadge,
                              const SizedBox(width: AppSpacing.xs),
                              statusBadge,
                            ],
                          ),
                          if (lastMessagePreview != null) ...[
                            const SizedBox(height: AppSpacing.xs + 2),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lastMessagePreview!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                      color: colors.textSecondary,
                                      fontWeight: isUnread
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (isUnread) ...[
                                  const SizedBox(width: AppSpacing.sm),
                                  _UnreadCountPill(count: unreadCount),
                                ],
                              ],
                            ),
                          ],
                          if (assignedAgentName != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Assigned to $assignedAgentName',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selected)
            Positioned(
              left: 0,
              top: 8,
              bottom: 8,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UnreadCountPill extends StatelessWidget {
  const _UnreadCountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
        '$count',
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
