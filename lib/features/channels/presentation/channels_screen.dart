import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/fade_slide_in.dart';
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
                      itemCount: channels.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) => FadeSlideIn(
                        delay: Duration(milliseconds: 40 * index),
                        child: ChannelCard(channel: channels[index]),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(),
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
