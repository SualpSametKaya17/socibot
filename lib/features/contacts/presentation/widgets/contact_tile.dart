import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/channel_badge.dart';

/// One row in the contacts list — simpler than [ConversationTile]
/// (no unread/status), so it's its own small widget rather than forcing
/// that shape.
class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.channel,
    this.subtitle,
    this.lastContactedAt,
    this.selected = false,
    this.onTap,
  });

  final String name;
  final String? avatarUrl;
  final ChannelType channel;
  final String? subtitle;
  final DateTime? lastContactedAt;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    // Flat rectangle + left accent bar on selection, matching
    // ConversationTile — Contacts is meant to read as the same list
    // paradigm as Inbox, not a differently-styled one.
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    AppAvatar(name: name, imageUrl: avatarUrl, radius: 18),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ChannelBadge(channel: channel),
                        if (lastContactedAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            timeago.format(
                              lastContactedAt!,
                              locale: 'en_short',
                            ),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ],
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
