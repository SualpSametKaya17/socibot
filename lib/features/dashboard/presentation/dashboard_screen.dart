import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/route_paths.dart';
import '../../../core/widgets/channel_badge.dart';
import '../../../core/widgets/conversation_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_badge.dart';
import '../../auth/domain/auth_providers.dart';
import '../../conversations/domain/conversation.dart';
import '../../conversations/domain/conversation_providers.dart';
import '../../conversations/domain/conversation_status.dart';
import '../../organization/domain/organization_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authRepositoryProvider).currentUser?.email;
    final organization = ref.watch(currentOrganizationProvider);
    final conversationsAsync = ref.watch(conversationsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back', style: AppTypography.headingMedium),
            const Gap(AppSpacing.xs),
            organization.when(
              data: (org) => Text(
                [?org?.name, ?email].join(' · '),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: context.colors.textSecondary),
              ),
              loading: () => const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, stackTrace) => Text(
                'Could not load organization',
                style: TextStyle(color: context.colors.error),
              ),
            ),
            const Gap(AppSpacing.xl),
            conversationsAsync.when(
              data: (conversations) => _StatsRow(conversations: conversations),
              loading: () => const _StatsRowSkeleton(),
              error: (error, stackTrace) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load stats',
                message: '$error',
              ),
            ),
            const Gap(AppSpacing.xl),
            const _QuickActionsRow(),
            const Gap(AppSpacing.xxl),
            Text('Recent conversations', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            conversationsAsync.when(
              data: (conversations) =>
                  _RecentConversationsCard(conversations: conversations),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load conversations',
                message: '$error',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.conversations});

  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    final open = conversations
        .where((c) => c.status == ConversationStatus.open)
        .length;
    final unread = conversations.where((c) => c.unreadCount > 0).length;
    final resolved = conversations
        .where((c) => c.status == ConversationStatus.resolved)
        .length;

    final stats = [
      (label: 'Open conversations', value: '$open'),
      (label: 'Unread', value: '$unread'),
      (label: 'Resolved', value: '$resolved'),
    ];

    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(
            child: _StatCard(label: stat.label, value: stat.value),
          ),
          if (stat != stats.last) const Gap(AppSpacing.md),
        ],
      ],
    );
  }
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(label: '—', value: '—'),
        ),
        Gap(AppSpacing.md),
        Expanded(
          child: _StatCard(label: '—', value: '—'),
        ),
        Gap(AppSpacing.md),
        Expanded(
          child: _StatCard(label: '—', value: '—'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xs),
            Text(value, style: AppTypography.headingMedium),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        OutlinedButton.icon(
          onPressed: () => context.go(RoutePaths.inbox),
          icon: const Icon(Icons.forum_outlined, size: 18),
          label: const Text('Go to Inbox'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(RoutePaths.channels),
          icon: const Icon(Icons.hub_outlined, size: 18),
          label: const Text('Connect a channel'),
        ),
      ],
    );
  }
}

class _RecentConversationsCard extends ConsumerWidget {
  const _RecentConversationsCard({required this.conversations});

  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (conversations.isEmpty) {
      return const Card(
        child: EmptyState(
          icon: Icons.forum_outlined,
          title: 'No conversations yet',
        ),
      );
    }

    final recent = [...conversations]
      ..sort((a, b) {
        final aTime = a.lastMessageAt;
        final bTime = b.lastMessageAt;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });
    final topFive = recent.take(5).toList();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final conversation in topFive) ...[
            ConversationTile(
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
              onTap: () {
                ref.read(selectedConversationIdProvider.notifier).state =
                    conversation.id;
                context.go(RoutePaths.inbox);
              },
            ),
            if (conversation != topFive.last) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
