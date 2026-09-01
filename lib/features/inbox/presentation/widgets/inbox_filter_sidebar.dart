import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
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
    final selectedQuickFilter = ref.watch(inboxQuickFilterProvider);
    final selectedStatus = ref.watch(inboxStatusFilterProvider);

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
      child: Material(
        color: selected ? colors.primarySoft : Colors.transparent,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
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
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
    );
  }
}
