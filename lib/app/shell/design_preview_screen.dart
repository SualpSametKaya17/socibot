import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/channel_type.dart';
import '../../core/constants/status_tone.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_sidebar.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/channel_badge.dart';
import '../../core/widgets/conversation_tile.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/status_badge.dart';
import '../theme/app_radius.dart';
import '../theme/app_semantic_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'nav_destinations.dart';

/// UI-language reference page — NOT a real feature. Exists only to show
/// every token/component together on one screen for design QA: page
/// title, stat tiles, a card with a small list, badges, buttons, an
/// input, and the sidebar. Reachable at [RoutePaths.designPreview]; not
/// linked from the app's nav.
class DesignPreviewScreen extends StatelessWidget {
  const DesignPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => Scaffold(
        appBar: AppTopBar(title: const Text('Design language')),
        body: const _DesignPreviewBody(),
      ),
      desktop: (context) => Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: AppSizes.navRailWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.sidebar,
                  border: Border(
                    right: BorderSide(color: context.colors.border),
                  ),
                ),
                child: AppSidebar(
                  destinations: [
                    for (final d in shellDestinations) d.toSidebarDestination(),
                  ],
                  selectedIndex: -1,
                  extended: false,
                  onDestinationSelected: (index) =>
                      context.go(shellDestinations[index].path),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    child: Icon(
                      Icons.forum_outlined,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Column(
                children: [
                  AppTopBar(
                    title: Text('Design language'),
                    subtitle: Text('Reference page — components & tokens only'),
                  ),
                  Expanded(child: _DesignPreviewBody()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignPreviewBody extends StatelessWidget {
  const _DesignPreviewBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            const _StatsRow(),
            const Gap(AppSpacing.xxl),

            Text('Recent conversations', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            const _ConversationListCard(),
            const Gap(AppSpacing.xxl),

            Text('Badges', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            const _BadgesRow(),
            const Gap(AppSpacing.xxl),

            Text('Buttons', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            const _ButtonsRow(),
            const Gap(AppSpacing.xxl),

            Text('Input', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            const SizedBox(
              width: 360,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Organization name',
                  hintText: 'Acme Inc.',
                ),
              ),
            ),
            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    const stats = [
      (label: 'Open conversations', value: '24'),
      (label: 'Avg. first response', value: '3m 40s'),
      (label: 'Resolved today', value: '18'),
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

class _ConversationListCard extends StatelessWidget {
  const _ConversationListCard();

  @override
  Widget build(BuildContext context) {
    const rows = [
      (
        name: 'Elena Martinez',
        channel: ChannelType.whatsapp,
        preview: 'Is my order #4521 still on the way?',
        unread: 2,
      ),
      (
        name: 'Marcus Chen',
        channel: ChannelType.instagram,
        preview: 'Can you send me a size chart?',
        unread: 0,
      ),
      (
        name: 'Priya Nair',
        channel: ChannelType.facebook,
        preview: 'Thank you, that solved it!',
        unread: 0,
      ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final row in rows) ...[
            ConversationTile(
              contactName: row.name,
              channelBadge: ChannelBadge(channel: row.channel),
              statusBadge: const StatusBadge(
                label: 'Open',
                tone: StatusTone.info,
              ),
              lastMessagePreview: row.preview,
              lastMessageAt: DateTime.now().subtract(
                const Duration(minutes: 12),
              ),
              unreadCount: row.unread,
            ),
            if (row != rows.last) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: const [
        StatusBadge(label: 'Open', tone: StatusTone.info),
        StatusBadge(label: 'Pending', tone: StatusTone.warning),
        StatusBadge(label: 'Resolved', tone: StatusTone.success),
        StatusBadge(label: 'Failed', tone: StatusTone.danger),
        ChannelBadge(channel: ChannelType.instagram),
        ChannelBadge(channel: ChannelType.facebook),
        ChannelBadge(channel: ChannelType.whatsapp),
        AppBadge(label: 'New', color: Color(0xFF2563EB)),
      ],
    );
  }
}

class _ButtonsRow extends StatelessWidget {
  const _ButtonsRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Primary')),
        OutlinedButton(onPressed: () {}, child: const Text('Secondary')),
        TextButton(onPressed: () {}, child: const Text('Ghost')),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
          style: IconButton.styleFrom(
            side: BorderSide(color: context.colors.border),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
        ),
      ],
    );
  }
}
