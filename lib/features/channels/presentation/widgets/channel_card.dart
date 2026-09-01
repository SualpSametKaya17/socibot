import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/channel_type.dart';
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: brandColor, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      channel.type.label,
                      style: AppTypography.labelLarge,
                    ),
                  ),
                  StatusBadge(
                    label: channel.status.label,
                    tone: channel.status.tone,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                channel.accountName ?? 'Not connected',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.textSecondary),
              ),
              if (channel.lastSyncAt != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Last synced ${DateFormat.MMMd().add_jm().format(channel.lastSyncAt!)}',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: colors.textMuted),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Tooltip(
                message: isConnected
                    ? 'Managing a connection needs the connect-channel Edge Function — coming in a later stage'
                    : 'Connecting needs Meta OAuth via an Edge Function — coming in a later stage',
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: null,
                    child: Text(isConnected ? 'Manage' : 'Connect'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
