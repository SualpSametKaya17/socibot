import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../../core/constants/status_tone.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/conversation_tile.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../../conversations/domain/conversation_status.dart';
import '../../domain/inbox_quick_filter.dart';

/// Region 3 of the Inbox layout: the conversation list — header (channel
/// name + search), status tabs, an ownership dropdown, the rows
/// themselves, and a small real-count summary footer.
class ConversationListPanel extends ConsumerStatefulWidget {
  const ConversationListPanel({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  ConsumerState<ConversationListPanel> createState() =>
      _ConversationListPanelState();
}

class _ConversationListPanelState extends ConsumerState<ConversationListPanel> {
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = ref.watch(filteredConversationsProvider);
    final selectedId = ref.watch(selectedConversationIdProvider);
    final selectedChannel = ref.watch(inboxChannelFilterProvider);
    final channelLabel = selectedChannel?.label ?? 'All Channel';
    final quickCounts =
        ref.watch(inboxQuickFilterCountsProvider).valueOrNull ?? const {};

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  channelLabel,
                  style: AppTypography.headingSmall.copyWith(fontSize: 14),
                ),
              ),
              IconButton(
                tooltip: 'Search conversations',
                isSelected: _searching,
                icon: const Icon(Icons.search, size: 20),
                onPressed: () => setState(() => _searching = !_searching),
              ),
            ],
          ),
        ),
        if (_searching)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search conversations',
                prefixIcon: Icon(Icons.search, size: 18),
                isDense: true,
              ),
              onChanged: (value) =>
                  ref.read(inboxSearchQueryProvider.notifier).state = value,
            ),
          ),
        const _StatusTabsRow(key: Key('inbox-status-tabs')),
        const SizedBox(height: AppSpacing.xs),
        const _AssignRow(),
        const Divider(height: 1),
        Expanded(
          child: conversationsAsync.when(
            data: (conversations) {
              if (conversations.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off,
                  title: 'No conversations found',
                  message: 'Try a different search term or filter.',
                );
              }
              return ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return FadeSlideIn(
                    delay: Duration(milliseconds: 20 * index.clamp(0, 10)),
                    child: ConversationTile(
                      contactName: conversation.contactName,
                      contactAvatarUrl: conversation.contactAvatarUrl,
                      channelBadge: ChannelBadge(channel: conversation.channel),
                      statusBadge: StatusBadge(
                        label: conversation.status.label,
                        tone: conversation.status.tone,
                      ),
                      lastMessagePreview: conversation.lastMessagePreview,
                      lastMessageAt: conversation.lastMessageAt,
                      assignedAgentName: conversation.assignedAgentName,
                      unreadCount: conversation.unreadCount,
                      selected: conversation.id == selectedId,
                      onTap: () {
                        ref
                                .read(selectedConversationIdProvider.notifier)
                                .state =
                            conversation.id;
                        widget.onSelect?.call(conversation.id);
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const _ConversationListSkeleton(),
            error: (error, stackTrace) => EmptyState(
              icon: Icons.error_outline,
              title: 'Could not load conversations',
              message: '$error',
            ),
          ),
        ),
        _AssignmentSummaryFooter(
          assignedCount:
              (quickCounts[InboxQuickFilter.all] ?? 0) -
              (quickCounts[InboxQuickFilter.unassigned] ?? 0),
          unassignedCount: quickCounts[InboxQuickFilter.unassigned] ?? 0,
        ),
      ],
    );
  }
}

/// All/Open/Pending/Resolved as compact pill tabs, driving the real
/// [inboxStatusFilterProvider] — the reference's "All/Open/Resolved/
/// Expired" tabs, mapped onto the statuses this app actually tracks
/// (there's no "expired" concept in [ConversationStatus]).
class _StatusTabsRow extends ConsumerWidget {
  const _StatusTabsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(inboxStatusFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          _StatusPill(
            label: 'All',
            selected: selectedStatus == null,
            onTap: () =>
                ref.read(inboxStatusFilterProvider.notifier).state = null,
          ),
          for (final status in ConversationStatus.values)
            _StatusPill(
              label: status.label,
              selected: selectedStatus == status,
              onTap: () => ref.read(inboxStatusFilterProvider.notifier).state =
                  selectedStatus == status ? null : status,
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
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
            horizontal: AppSpacing.sm + 2,
            vertical: 5,
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: selected ? colors.primary : colors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// The ownership dropdown ("Assign to me ▾  5") plus a compact
/// unreplied-only toggle — both real, driving
/// [inboxQuickFilterProvider]/[inboxUnrepliedOnlyProvider] exactly like
/// the old filter sidebar did.
class _AssignRow extends ConsumerWidget {
  const _AssignRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final quickFilter = ref.watch(inboxQuickFilterProvider);
    final quickCounts =
        ref.watch(inboxQuickFilterCountsProvider).valueOrNull ?? const {};
    final unrepliedOnly = ref.watch(inboxUnrepliedOnlyProvider);
    final newestFirst = ref.watch(inboxSortNewestFirstProvider);
    final count = quickCounts[quickFilter] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton<InboxQuickFilter>(
              key: const Key('inbox-assign-dropdown'),
              tooltip: 'Filter by ownership',
              onSelected: (value) =>
                  ref.read(inboxQuickFilterProvider.notifier).state = value,
              itemBuilder: (context) => [
                for (final filter in InboxQuickFilter.values)
                  PopupMenuItem(
                    value: filter,
                    child: Text(
                      filter == InboxQuickFilter.mine
                          ? 'Assign to me'
                          : filter.label,
                    ),
                  ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.expand_more, size: 16, color: colors.textMuted),
                  const SizedBox(width: 2),
                  Text(
                    quickFilter == InboxQuickFilter.mine
                        ? 'Assign to me'
                        : quickFilter.label,
                    style: AppTypography.labelMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '$count',
                    style: AppTypography.labelMedium.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Tooltip(
            message: unrepliedOnly
                ? 'Showing unreplied only'
                : 'Show unreplied only',
            child: InkWell(
              borderRadius: AppRadius.smAll,
              onTap: () => ref.read(inboxUnrepliedOnlyProvider.notifier).state =
                  !unrepliedOnly,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  unrepliedOnly
                      ? Icons.mark_chat_unread
                      : Icons.mark_chat_unread_outlined,
                  size: 18,
                  color: unrepliedOnly ? colors.primary : colors.textMuted,
                ),
              ),
            ),
          ),
          Tooltip(
            message: newestFirst ? 'Newest first' : 'Oldest first',
            child: InkWell(
              borderRadius: AppRadius.smAll,
              onTap: () =>
                  ref.read(inboxSortNewestFirstProvider.notifier).state =
                      !newestFirst,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  newestFirst ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 16,
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Static (no filtering behavior — matches the reference's "no business
/// logic yet" collapsible rows) but honest: both counts come from real
/// conversation data via [inboxQuickFilterCountsProvider].
class _AssignmentSummaryFooter extends StatelessWidget {
  const _AssignmentSummaryFooter({
    required this.assignedCount,
    required this.unassignedCount,
  });

  final int assignedCount;
  final int unassignedCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rowStyle = AppTypography.labelMedium.copyWith(
      color: colors.textSecondary,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.expand_more, size: 16, color: colors.textMuted),
                const SizedBox(width: 4),
                Text('Assigned', style: rowStyle),
                const Spacer(),
                Text('$assignedCount', style: rowStyle),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.chevron_right, size: 16, color: colors.textMuted),
                const SizedBox(width: 4),
                Text('Unassigned', style: rowStyle),
                const Spacer(),
                Text('$unassignedCount', style: rowStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder rows shaped exactly like real [ConversationTile]s
/// (built from the same widget with dummy data, not a bespoke skeleton
/// layout) so there's no layout jump once real data arrives.
class _ConversationListSkeleton extends StatelessWidget {
  const _ConversationListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        itemCount: 7,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => ConversationTile(
          contactName: 'Loading contact name',
          channelBadge: const ChannelBadge(channel: ChannelType.whatsapp),
          statusBadge: const StatusBadge(label: 'Open', tone: StatusTone.info),
          lastMessagePreview: 'Loading the latest message preview…',
          lastMessageAt: DateTime.now(),
        ),
      ),
    );
  }
}
