import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/channel_type.dart';
import '../../../core/constants/route_paths.dart';
import '../../../core/constants/status_tone.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/channel_badge.dart';
import '../../../core/widgets/conversation_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/fade_slide_in.dart';
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
                style: AppTypography.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              loading: () => Skeletonizer(
                child: Text(
                  'Loading organization name',
                  style: AppTypography.bodyMedium,
                ),
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
              loading: () => const _RecentConversationsSkeleton(),
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

    final colors = context.colors;
    final stats = [
      _StatCard(
        label: 'Open conversations',
        value: '$open',
        icon: Icons.forum_outlined,
        color: colors.primary,
      ),
      _StatCard(
        label: 'Unread',
        value: '$unread',
        icon: Icons.mark_email_unread_outlined,
        color: colors.warning,
      ),
      _StatCard(
        label: 'Resolved',
        value: '$resolved',
        icon: Icons.task_alt_outlined,
        color: colors.success,
      ),
      _StatCard(
        label: 'Total conversations',
        value: '${conversations.length}',
        icon: Icons.dashboard_outlined,
        color: colors.textSecondary,
      ),
    ];

    return _StatsGrid(
      cards: [
        for (var i = 0; i < stats.length; i++)
          FadeSlideIn(
            delay: Duration(milliseconds: 40 * i),
            child: stats[i],
          ),
      ],
    );
  }
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _StatsGrid(
      cards: [
        for (final icon in const [
          Icons.forum_outlined,
          Icons.mark_email_unread_outlined,
          Icons.task_alt_outlined,
          Icons.dashboard_outlined,
        ])
          _StatCard(
            label: '—',
            value: '—',
            icon: icon,
            color: colors.textMuted,
          ),
      ],
    );
  }
}

/// 4 columns on desktop, 2x2 on tablet/mobile down to a minimum readable
/// card width, then a single column — not a fixed [Row] that would
/// squeeze four cards into an unreadable sliver on a narrow screen.
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.cards});

  final List<Widget> cards;

  // Icon row (32) + gap + label + gap + value text needs ~105px inside
  // the card's own padding — 92 was too tight and overflowed.
  static const double _cardHeight = 112;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          >= 800 => 4,
          >= 420 => 2,
          _ => 1,
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: _cardHeight,
          ),
          itemBuilder: (context, index) => cards[index],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          Text(value, style: AppTypography.headingMedium),
        ],
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

/// Shimmer placeholder rows built from real [ConversationTile]s, matching
/// [_RecentConversationsCard]'s own layout so there's no reflow once
/// real data arrives.
class _RecentConversationsSkeleton extends StatelessWidget {
  const _RecentConversationsSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Skeletonizer(
      child: AppSurfaceCard(
        clip: true,
        child: Column(
          children: [
            for (var i = 0; i < 5; i++) ...[
              ConversationTile(
                contactName: 'Loading contact name',
                channelBadge: const ChannelBadge(channel: ChannelType.whatsapp),
                statusBadge: const StatusBadge(
                  label: 'Open',
                  tone: StatusTone.info,
                ),
                lastMessagePreview: 'Loading the latest message preview…',
                lastMessageAt: DateTime.now(),
              ),
              if (i != 4) Divider(height: 1, color: colors.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecentConversationsCard extends ConsumerWidget {
  const _RecentConversationsCard({required this.conversations});

  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    if (conversations.isEmpty) {
      return AppSurfaceCard(
        child: EmptyState(
          icon: Icons.forum_outlined,
          title: 'No conversations yet',
          action: OutlinedButton.icon(
            onPressed: () => context.go(RoutePaths.inbox),
            icon: const Icon(Icons.forum_outlined, size: 16),
            label: const Text('Go to Inbox'),
          ),
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

    return AppSurfaceCard(
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < topFive.length; i++) ...[
            FadeSlideIn(
              delay: Duration(milliseconds: 25 * i),
              child: ConversationTile(
                contactName: topFive[i].contactName,
                contactAvatarUrl: topFive[i].contactAvatarUrl,
                channelBadge: ChannelBadge(channel: topFive[i].channel),
                statusBadge: StatusBadge(
                  label: topFive[i].status.label,
                  tone: topFive[i].status.tone,
                ),
                lastMessagePreview: topFive[i].lastMessagePreview,
                lastMessageAt: topFive[i].lastMessageAt,
                assignedAgentName: topFive[i].assignedAgentName,
                unreadCount: topFive[i].unreadCount,
                onTap: () {
                  ref.read(selectedConversationIdProvider.notifier).state =
                      topFive[i].id;
                  context.go(RoutePaths.inbox);
                },
              ),
            ),
            if (i != topFive.length - 1)
              Divider(height: 1, color: colors.border),
          ],
        ],
      ),
    );
  }
}
