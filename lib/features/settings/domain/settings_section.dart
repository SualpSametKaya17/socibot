import 'package:flutter/material.dart';

/// One entry in the Settings secondary navigation.
enum SettingsSection {
  workspace(label: 'Workspace', icon: Icons.apartment_outlined),
  team(label: 'Team', icon: Icons.group_outlined),
  notifications(label: 'Notifications', icon: Icons.notifications_outlined),
  inbox(label: 'Inbox', icon: Icons.forum_outlined),
  security(label: 'Security', icon: Icons.lock_outline);

  const SettingsSection({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
