import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.hub_outlined,
      title: 'Channels is coming soon',
      message: 'Connect Instagram, Messenger, and WhatsApp Business here.',
    );
  }
}
