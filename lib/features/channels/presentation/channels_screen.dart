import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/channel_type.dart';
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
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: context.colors.textSecondary),
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
          ],
        ),
      ),
    );
  }
}

/// The 3/2/1-column responsive grid shared by the real channel list and
/// its loading skeleton, so both lay out identically and there's no
/// visible reflow once real data replaces the placeholders.
class _ChannelsGrid extends StatelessWidget {
  const _ChannelsGrid({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          >= 720 => 3,
          >= 480 => 2,
          _ => 1,
        };
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: 200,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
