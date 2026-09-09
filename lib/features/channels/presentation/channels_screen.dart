import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/channel_type.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../domain/channel_connection.dart';
import '../domain/channel_connection_status.dart';
import '../domain/channel_providers.dart';
import 'widgets/channel_card.dart';

class ChannelsScreen extends ConsumerWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Channels', style: AppTypography.headingMedium),
            const Gap(AppSpacing.xs),
            Text(
              'Instagram, Messenger, and WhatsApp Business connections for '
              'this organization.',
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xl),
            channelsAsync.when(
              data: (channels) {
                if (channels.isEmpty) {
                  return const EmptyState(
                    icon: Icons.hub_outlined,
                    title: 'No channels yet',
                    message: 'Connect Instagram, Messenger, or WhatsApp to get started.',
                  );
                }
                return _ChannelsGrid(
                  itemCount: channels.length,
                  itemBuilder: (context, index) => FadeSlideIn(
                    delay: Duration(milliseconds: 40 * index),
                    child: ChannelCard(channel: channels[index]),
                  ),
                );
              },
              loading: () => Skeletonizer(
                child: _ChannelsGrid(
                  itemCount: 3,
                  itemBuilder: (context, index) => const ChannelCard(
                    channel: ChannelConnection(
                      type: ChannelType.whatsapp,
                      status: ChannelConnectionStatus.connected,
                      accountName: 'Loading account name',
                    ),
                  ),
                ),
              ),
              error: (error, stackTrace) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load channels',
                message: '$error',
              ),
            ),
            const Gap(AppSpacing.xxl),
            const _ComingSoonSection(),
          ],
        ),
      ),
    );
  }
}

/// A future channel provider — not wired to anything, no `ChannelType`
/// value exists for it yet. Rendered read-only in [_ComingSoonSection]
/// so the roadmap is visible without a control that would pretend to
/// work.
class _UpcomingChannel {
  const _UpcomingChannel({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

const _upcomingChannels = [
  _UpcomingChannel(
    label: 'Telegram',
    icon: Icons.send_outlined,
    color: Color(0xFF29A9EA),
  ),
  _UpcomingChannel(
    label: 'LinkedIn',
    icon: Icons.business_center_outlined,
    color: Color(0xFF0A66C2),
  ),
  _UpcomingChannel(
    label: 'Email',
    icon: Icons.mail_outline,
    color: Color(0xFF64748B),
  ),
];

class _ComingSoonSection extends StatelessWidget {
  const _ComingSoonSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Coming soon', style: AppTypography.labelLarge),
        const Gap(AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final upcoming in _upcomingChannels)
              Container(
                width: 220,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: upcoming.color.withValues(alpha: 0.12),
                        borderRadius: AppRadius.smAll,
                      ),
                      child: Icon(
                        upcoming.icon,
                        color: upcoming.color,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        upcoming.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AppBadge(label: 'Soon', color: colors.textMuted),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// The 2/1-column responsive grid shared by the real channel list and its
/// loading skeleton, so both lay out identically and there's no visible
/// reflow once real data replaces the placeholders. Capped at 2 columns
/// (rather than growing to 3+ on very wide screens) because each card now
/// carries more content — a description line, sync status, and a footer
/// row — and reads better with room to breathe.
class _ChannelsGrid extends StatelessWidget {
  const _ChannelsGrid({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: 226,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
