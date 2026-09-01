import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../constants/channel_type.dart';
import 'app_badge.dart';

/// Color-coded badge identifying which messaging channel a conversation
/// or contact belongs to.
class ChannelBadge extends StatelessWidget {
  const ChannelBadge({super.key, required this.channel});

  final ChannelType channel;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (channel) {
      ChannelType.instagram => (AppColors.instagram, Icons.camera_alt_outlined),
      ChannelType.facebook => (AppColors.facebookMessenger, Icons.facebook),
      ChannelType.whatsapp => (AppColors.whatsapp, Icons.chat_outlined),
    };

    return AppBadge(label: channel.label, color: color, icon: icon);
  }
}
