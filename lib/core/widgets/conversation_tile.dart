import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app_avatar.dart';

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
  final int unreadCount;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = unreadCount > 0;

    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(name: contactName, imageUrl: contactAvatarUrl, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contactName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lastMessageAt != null)
                          Text(
                            timeago.format(lastMessageAt!, locale: 'en_short'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isUnread
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        channelBadge,
                        const SizedBox(width: 6),
                        statusBadge,
                      ],
                    ),
                    if (lastMessagePreview != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessagePreview!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            _UnreadCountPill(count: unreadCount),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadCountPill extends StatelessWidget {
  const _UnreadCountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
