import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../core/widgets/hover_lift.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/channel_connection.dart';
import '../../domain/channel_connection_status.dart';

/// One channel's connection card. The connect/manage action is always
/// disabled — a real OAuth handshake with Meta needs an Edge Function
/// (connect-channel, AŞAMA 10/11) that doesn't exist yet, so this stays
/// honest about not being wired up rather than pretending to work.
class ChannelCard extends StatelessWidget {
  const ChannelCard({super.key, required this.channel});

  final ChannelConnection channel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (brandColor, icon) = switch (channel.type) {
      ChannelType.instagram => (AppColors.instagram, Icons.camera_alt_outlined),
      ChannelType.facebook => (AppColors.facebookMessenger, Icons.facebook),
      ChannelType.whatsapp => (AppColors.whatsapp, Icons.chat_outlined),
    };
    final isConnected = channel.status == ChannelConnectionStatus.connected;

    return HoverLift(
      child: AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: brandColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    channel.type.label,
                    style: AppTypography.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                StatusBadge(
                  label: channel.status.label,
                  tone: channel.status.tone,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              channel.accountName ?? 'Not connected yet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: channel.accountName != null
                    ? colors.textSecondary
                    : colors.textMuted,
                fontStyle: channel.accountName != null
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              channel.lastSyncAt != null
                  ? 'Last synced ${DateFormat.MMMd().add_jm().format(channel.lastSyncAt!)}'
                  : 'Never synced',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: colors.textMuted),
            ),
            // Fills whatever room is left so the action button always
            // lands on the same baseline across every card in the grid,
            // regardless of how much optional text a given channel has.
            const Spacer(),
            const SizedBox(height: AppSpacing.sm),
            Tooltip(
              message: isConnected
                  ? 'Managing a connection needs the connect-channel Edge Function — coming in a later stage'
                  : 'Connecting needs Meta OAuth via an Edge Function — coming in a later stage',
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: Icon(
                    isConnected ? Icons.settings_outlined : Icons.link,
                    size: 16,
                  ),
                  label: Text(isConnected ? 'Manage' : 'Connect'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
