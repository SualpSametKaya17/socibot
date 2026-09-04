import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../conversations/domain/conversation.dart';
import '../../../conversations/domain/conversation_actions.dart';
import '../../../conversations/domain/conversation_status.dart';
import '../../../organization/domain/organization_providers.dart';

/// Region 4's header bar: who this conversation is with, who it's
/// assigned to, a Resolve/Reopen action, and a search-within-conversation
/// toggle. Assign and Resolve are real, immediate local mutations (see
/// conversation_actions.dart) — mock/session-only, same as everywhere
/// else in this app, but genuinely working rather than disabled.
class ConversationWorkspaceHeader extends StatelessWidget {
  const ConversationWorkspaceHeader({
    super.key,
    required this.conversation,
    required this.onClose,
    required this.searching,
    required this.onToggleSearch,
    this.compact = false,
    this.onOpenDetails,
  });

  final Conversation conversation;
  final VoidCallback onClose;
  final bool searching;
  final VoidCallback onToggleSearch;

  /// Drops the assigned-to chip and Resolve button — there isn't room
  /// for them on a narrow (mobile, full-screen-pushed) header.
  final bool compact;

  /// Set only when the customer detail panel isn't permanently visible
  /// at this width (mobile, tablet, small desktop) — renders an info
  /// button that opens it as a drawer instead, so customer details stay
  /// reachable at every breakpoint rather than silently disappearing.
  final VoidCallback? onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    // The assigned-to chip and Resolve button are the widest optional
    // elements. [onOpenDetails] is only set where the customer panel
    // isn't permanently on screen (mobile/tablet/small desktop) — the
    // same narrower layouts that don't have room for them either, so
    // reuse that signal instead of guessing a separate width threshold.
    final roomy = !compact && onOpenDetails == null;

    return Container(
      height: 58,
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
          if (roomy) ...[
            _AssignedToChip(
              conversationId: conversation.id,
              agentName: conversation.assignedAgentName,
            ),
            const SizedBox(width: AppSpacing.sm),
            _ResolveButton(
              conversationId: conversation.id,
              status: conversation.status,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          if (onOpenDetails != null)
            IconButton(
              tooltip: 'View customer details',
              icon: const Icon(Icons.info_outline, size: 18),
              onPressed: onOpenDetails,
            ),
          IconButton(
            tooltip: 'Search this conversation',
            isSelected: searching,
            icon: const Icon(Icons.search, size: 18),
            onPressed: onToggleSearch,
          ),
          if (roomy) _MoreMenu(conversationId: conversation.id),
          IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close, size: 18),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _AssignedToChip extends ConsumerWidget {
  const _AssignedToChip({
    required this.conversationId,
    required this.agentName,
  });

  final String conversationId;
  final String? agentName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final label = agentName ?? 'Unassigned';
    final members =
        ref.watch(organizationMembersProvider).valueOrNull ?? const [];

    return PopupMenuButton<String?>(
      tooltip: 'Assign',
      onSelected: (value) =>
          assignConversation(ref, context, conversationId, value),
      itemBuilder: (context) => [
        const PopupMenuItem<String?>(value: null, child: Text('Unassigned')),
        for (final member in members)
          PopupMenuItem<String?>(
            value: member.displayName,
            child: Text(member.displayName),
          ),
      ],
      child: ConstrainedBox(
        // A long real member name (unlike the short mock names) could
        // otherwise grow this chip unbounded and push the header's Row
        // into overflow — cap it and ellipsize the name instead.
        constraints: const BoxConstraints(maxWidth: 160),
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
                style: AppTypography.caption.copyWith(color: colors.textMuted),
              ),
              const SizedBox(width: AppSpacing.xs),
              if (agentName != null) ...[
                AppAvatar(name: agentName!, radius: 10),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.expand_more, size: 14, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResolveButton extends ConsumerWidget {
  const _ResolveButton({required this.conversationId, required this.status});

  final String conversationId;
  final ConversationStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isResolved = status == ConversationStatus.resolved;
    final label = isResolved ? 'Reopen' : 'Resolve';

    return PopupMenuButton<ConversationStatus>(
      tooltip: '$label (E)',
      onSelected: (value) => value == ConversationStatus.resolved
          ? resolveConversation(ref, context, conversationId)
          : reopenConversation(ref, context, conversationId),
      itemBuilder: (context) => [
        if (isResolved)
          const PopupMenuItem(
            value: ConversationStatus.open,
            child: Text('Reopen'),
          )
        else
          const PopupMenuItem(
            value: ConversationStatus.resolved,
            child: Text('Resolve'),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isResolved ? Icons.replay : Icons.check_circle_outline,
              size: 14,
              color: isResolved ? colors.textSecondary : colors.success,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
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

class _MoreMenu extends ConsumerWidget {
  const _MoreMenu({required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: 'More',
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (value) {
        if (value == 'mark-unread') {
          markConversationUnread(ref, context, conversationId);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'mark-unread', child: Text('Mark as unread')),
      ],
    );
  }
}
