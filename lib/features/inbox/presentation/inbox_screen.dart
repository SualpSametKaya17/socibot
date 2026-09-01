import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.forum_outlined,
      title: 'Inbox is coming soon',
      message:
          'Instagram, Messenger, and WhatsApp conversations will be unified here.',
    );
  }
}
