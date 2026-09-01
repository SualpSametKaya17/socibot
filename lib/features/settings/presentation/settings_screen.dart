import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.settings_outlined,
      title: 'Settings is coming soon',
      message: 'Organization, team, and channel settings will live here.',
    );
  }
}
