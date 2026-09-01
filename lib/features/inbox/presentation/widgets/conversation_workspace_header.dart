import 'package:flutter/material.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../conversations/domain/conversation.dart';

/// Region 4's header bar: who this conversation is with, its channel and
/// status, and a search-within-conversation toggle. Assign/more-menu are
/// intentionally rendered disabled — conversation assignment is a later
/// stage (AŞAMA 14), not faked here.
class ConversationWorkspaceHeader extends StatelessWidget {
  const ConversationWorkspaceHeader({
    super.key,
    required this.conversation,
    required this.onClose,
    required this.searching,
    required this.onToggleSearch,
    this.compact = false,
  });

  final Conversation conversation;
  final VoidCallback onClose;
  final bool searching;
  final VoidCallback onToggleSearch;

  /// Drops the disabled assign/more placeholders — there isn't room for
  /// them on a narrow (mobile, full-screen-pushed) header.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          AppAvatar(
            name: conversation.contactName,
            imageUrl: conversation.contactAvatarUrl,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.contactName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Wrap (not Row) so a long channel/status label pair
                // never overflows on a narrow header.
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: 2,
                  children: [
                    ChannelBadge(channel: conversation.channel),
                    StatusBadge(
                      label: conversation.status.label,
                      tone: conversation.status.tone,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Search this conversation',
            isSelected: searching,
            icon: const Icon(Icons.search, size: 20),
            onPressed: onToggleSearch,
          ),
          if (!compact) ...[
            const IconButton(
              tooltip: 'Assign agent (coming in a later stage)',
              icon: Icon(Icons.person_add_alt_outlined, size: 20),
              onPressed: null,
            ),
            const IconButton(
              tooltip: 'More (coming in a later stage)',
              icon: Icon(Icons.more_vert, size: 20),
              onPressed: null,
            ),
          ],
          IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
