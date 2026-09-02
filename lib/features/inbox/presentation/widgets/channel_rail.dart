import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../channels/domain/channel_providers.dart';
import '../../../conversations/domain/conversation_providers.dart';

/// The narrow vertical strip between the app's main sidebar and the
/// conversation list — real, connected channels (from the Channels
/// feature) as compact icon buttons, plus an "All" entry. Selecting one
/// filters the conversation list for real via
/// [inboxChannelFilterProvider], the same provider the old CHANNELS
/// sidebar section drove.
class ChannelRail extends ConsumerWidget {
  const ChannelRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final channels = ref.watch(channelsProvider).valueOrNull ?? const [];
    final selectedChannel = ref.watch(inboxChannelFilterProvider);

    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        _RailButton(
          tooltip: 'All channels',
          selected: selectedChannel == null,
          onTap: () =>
              ref.read(inboxChannelFilterProvider.notifier).state = null,
          child: Icon(
            Icons.forum_outlined,
            size: 18,
            color: colors.textSecondary,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(
            height: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
        ),
        for (final connection in channels)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _RailButton(
              tooltip: connection.type.label,
              selected: selectedChannel == connection.type,
              onTap: () => ref.read(inboxChannelFilterProvider.notifier).state =
                  selectedChannel == connection.type ? null : connection.type,
              child: _ChannelIcon(channel: connection.type),
            ),
          ),
        const Spacer(),
        _RailButton(
          tooltip: 'Add a channel',
          selected: false,
          onTap: () => context.go(RoutePaths.channels),
          child: Icon(Icons.add, size: 18, color: colors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _ChannelIcon extends StatelessWidget {
  const _ChannelIcon({required this.channel});

  final ChannelType channel;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (channel) {
      ChannelType.instagram => (AppColors.instagram, Icons.camera_alt_outlined),
      ChannelType.facebook => (AppColors.facebookMessenger, Icons.facebook),
      ChannelType.whatsapp => (AppColors.whatsapp, Icons.chat_outlined),
    };
    return Icon(icon, size: 18, color: color);
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.tooltip,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final String tooltip;
  final bool selected;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? colors.primarySoft : Colors.transparent,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          hoverColor: colors.surfaceSecondary,
          child: SizedBox(width: 36, height: 36, child: Center(child: child)),
        ),
      ),
    );
  }
}
