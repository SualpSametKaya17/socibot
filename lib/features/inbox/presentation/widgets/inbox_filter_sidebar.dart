import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/status_tone.dart';
import '../../../channels/domain/channel_connection.dart';
import '../../../channels/domain/channel_providers.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../../conversations/domain/conversation_status.dart';
import '../../domain/inbox_quick_filter.dart';

/// Region 2 of the Inbox layout: ownership quick filters (All/Mine/
/// Unassigned) with counts, a conversation-status filter, and a
/// presentation-only "Team Inbox" grouping (no such feature exists yet,
/// so it isn't wired to anything — see the class doc below).
class InboxFilterSidebar extends ConsumerWidget {
  const InboxFilterSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final quickCounts =
        ref.watch(inboxQuickFilterCountsProvider).valueOrNull ?? const {};
    final statusCounts =
        ref.watch(inboxStatusCountsProvider).valueOrNull ?? const {};
    final channelCounts =
        ref.watch(inboxChannelCountsProvider).valueOrNull ?? const {};
    final channels = ref.watch(channelsProvider).valueOrNull ?? const [];
    final selectedQuickFilter = ref.watch(inboxQuickFilterProvider);
    final selectedStatus = ref.watch(inboxStatusFilterProvider);
    final selectedChannel = ref.watch(inboxChannelFilterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text('Inbox', style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final filter in InboxQuickFilter.values)
            _SidebarRow(
              label: filter.label,
              count: quickCounts[filter],
              selected: selectedQuickFilter == filter,
              onTap: () =>
                  ref.read(inboxQuickFilterProvider.notifier).state = filter,
            ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel('STATUS'),
          for (final status in ConversationStatus.values)
            _SidebarRow(
              label: status.label,
              count: statusCounts[status],
              selected: selectedStatus == status,
              onTap: () => ref.read(inboxStatusFilterProvider.notifier).state =
                  selectedStatus == status ? null : status,
            ),
          if (channels.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionLabel('CHANNELS'),
            // Real data end to end: connection status comes from the
            // Channels feature (channelsProvider), the count from actual
            // conversations of that channel type — tapping filters the
            // list for real, unlike the static "Team Inbox" rows below.
            for (final connection in channels)
              _ChannelSidebarRow(
                connection: connection,
                count: channelCounts[connection.type],
                selected: selectedChannel == connection.type,
                onTap: () =>
                    ref
                        .read(inboxChannelFilterProvider.notifier)
                        .state = selectedChannel == connection.type
                    ? null
                    : connection.type,
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel('TEAM INBOX'),
          // Presentation-only: no team/inbox-grouping data model exists
          // yet, so these rows are static and intentionally not
          // interactive rather than faking a filter that does nothing.
          for (final team in const ['Sales', 'Support', 'Marketing'])
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              child: Text(
                team,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: context.colors.textMuted, letterSpacing: 0.4),
      ),
    );
  }
}

class _SidebarRow extends StatelessWidget {
  const _SidebarRow({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? colors.primarySoft : Colors.transparent,
          borderRadius: AppRadius.mdAll,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.mdAll,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.mdAll,
            hoverColor: colors.surfaceSecondary,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: selected ? colors.primary : colors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (count != null)
                    Text(
                      '$count',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: selected ? colors.primary : colors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One row in the sidebar's CHANNELS section — a real, connected channel
/// (from the Channels feature) rather than a static label. The leading
/// dot shows its live connection status; tapping filters the
/// conversation list to that channel.
class _ChannelSidebarRow extends StatelessWidget {
  const _ChannelSidebarRow({
    required this.connection,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final ChannelConnection connection;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final statusColor = switch (connection.status.tone) {
      StatusTone.success => colors.success,
      StatusTone.warning => colors.warning,
      StatusTone.danger => colors.error,
      StatusTone.info => colors.primary,
      StatusTone.neutral => colors.textMuted,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? colors.primarySoft : Colors.transparent,
          borderRadius: AppRadius.mdAll,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.mdAll,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.mdAll,
            hoverColor: colors.surfaceSecondary,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Tooltip(
                    message: connection.status.label,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      connection.type.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: selected ? colors.primary : colors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (count != null)
                    Text(
                      '$count',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: selected ? colors.primary : colors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
