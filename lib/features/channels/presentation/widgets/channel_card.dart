import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../domain/channel_providers.dart';

/// One channel's connection card. Connect/Disconnect are real, immediate
/// local actions — see [ChannelsNotifier]'s doc comment for why that's
/// honest (no real Meta OAuth happens; nothing here talks to Instagram,
/// Messenger, or WhatsApp).
class ChannelCard extends ConsumerWidget {
  const ChannelCard({super.key, required this.channel});

  final ChannelConnection channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final (brandColor, icon) = switch (channel.type) {
      ChannelType.instagram => (AppColors.instagram, Icons.camera_alt_outlined),
      ChannelType.facebook => (AppColors.facebookMessenger, Icons.facebook),
      ChannelType.whatsapp => (AppColors.whatsapp, Icons.chat_outlined),
    };
    final isConnected = channel.status == ChannelConnectionStatus.connected;

    return HoverLift(
      glowColor: brandColor,
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
              style: AppTypography.bodySmall.copyWith(
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
              style: AppTypography.caption.copyWith(color: colors.textMuted),
            ),
            // Fills whatever room is left so the action button always
            // lands on the same baseline across every card in the grid,
            // regardless of how much optional text a given channel has.
            const Spacer(),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => isConnected
                    ? _confirmDisconnect(context, ref, channel.type)
                    : _showConnectDialog(context, ref, channel.type),
                icon: Icon(isConnected ? Icons.link_off : Icons.link, size: 16),
                label: Text(isConnected ? 'Disconnect' : 'Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A short hint for what account identifier each channel expects — just
/// copy, no format validation (this never leaves the device).
String _accountHint(ChannelType type) => switch (type) {
  ChannelType.whatsapp => 'e.g. Socibot Support (+1 415 555 0100)',
  ChannelType.instagram => 'e.g. @socibot.support',
  ChannelType.facebook => 'e.g. Socibot Page',
};

Future<void> _showConnectDialog(
  BuildContext context,
  WidgetRef ref,
  ChannelType type,
) async {
  final accountName = await showDialog<String>(
    context: context,
    builder: (dialogContext) => _ConnectChannelDialog(type: type),
  );

  if (accountName != null && accountName.isNotEmpty) {
    ref.read(channelsProvider.notifier).connect(type, accountName: accountName);
  }
}

/// Its own [StatefulWidget] (rather than a bare [TextEditingController]
/// owned by the calling function) so the controller's lifecycle is tied
/// to this widget's actual mount/unmount — disposing it manually right
/// after `showDialog`'s Future resolves races the dialog's exit
/// animation, which can still be rebuilding this field a frame later.
class _ConnectChannelDialog extends StatefulWidget {
  const _ConnectChannelDialog({required this.type});

  final ChannelType type;

  @override
  State<_ConnectChannelDialog> createState() => _ConnectChannelDialogState();
}

class _ConnectChannelDialogState extends State<_ConnectChannelDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Connect ${widget.type.label}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demo mode — this saves an account name locally for review. '
              "It does not perform a real ${widget.type.label} sign-in.",
              style: AppTypography.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Account name',
                hintText: _accountHint(widget.type),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter an account name'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('Connect'),
        ),
      ],
    );
  }
}

Future<void> _confirmDisconnect(
  BuildContext context,
  WidgetRef ref,
  ChannelType type,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Disconnect ${type.label}?'),
        content: const Text(
          'Conversations already in the inbox stay, but no new messages '
          'will come in from this channel until it\'s reconnected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Disconnect'),
          ),
        ],
      );
    },
  );

  if (confirmed ?? false) {
    ref.read(channelsProvider.notifier).disconnect(type);
  }
}
