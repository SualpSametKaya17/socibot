import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.people_outline,
      title: 'Contacts is coming soon',
      message:
          'Everyone who has messaged you across channels will show up here.',
    );
  }
}
