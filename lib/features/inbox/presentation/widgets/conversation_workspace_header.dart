import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../conversations/domain/conversation.dart';

/// Region 4's header bar: who this conversation is with, who it's
/// assigned to, a Resolve action, and a search-within-conversation
/// toggle. Assign/Resolve are intentionally rendered disabled —
/// conversation assignment/status mutation is a later stage (AŞAMA 14),
/// not faked here.
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

  /// Drops the assigned-to chip and Resolve button — there isn't room
  /// for them on a narrow (mobile, full-screen-pushed) header.
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
          if (!compact) ...[
            _AssignedToChip(agentName: conversation.assignedAgentName),
            const SizedBox(width: AppSpacing.sm),
            const _ResolveButton(),
            const SizedBox(width: AppSpacing.xs),
          ],
          IconButton(
            tooltip: 'Search this conversation',
            isSelected: searching,
            icon: const Icon(Icons.search, size: 20),
            onPressed: onToggleSearch,
          ),
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

class _AssignedToChip extends StatelessWidget {
  const _AssignedToChip({required this.agentName});

  final String? agentName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = agentName ?? 'Unassigned';

    return Tooltip(
      message: 'Reassigning is coming in a later stage',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Assigned to',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(width: AppSpacing.xs),
            if (agentName != null) ...[
              AppAvatar(name: agentName!, radius: 10),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.expand_more, size: 14, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _ResolveButton extends StatelessWidget {
  const _ResolveButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: 'Changing status here is coming in a later stage',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.textMuted.withValues(alpha: 0.3),
          borderRadius: AppRadius.mdAll,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 2,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Resolve',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 2),
              Icon(Icons.expand_more, size: 16, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
