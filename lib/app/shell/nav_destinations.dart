import 'package:flutter/material.dart';

import '../../core/constants/route_paths.dart';
import '../../core/widgets/app_sidebar.dart';

class ShellDestination {
  const ShellDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  SidebarDestination toSidebarDestination({int? badgeCount}) {
    return SidebarDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      label: label,
      badgeCount: badgeCount,
    );
  }
}

/// One entry per [StatefulShellBranch] in [appRouterProvider], in the same
/// order — index N here must be branch N in the router.
const List<ShellDestination> shellDestinations = [
  ShellDestination(
    path: RoutePaths.dashboard,
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  ShellDestination(
    path: RoutePaths.inbox,
    label: 'Inbox',
    icon: Icons.forum_outlined,
    selectedIcon: Icons.forum,
  ),
  ShellDestination(
    path: RoutePaths.contacts,
    label: 'Contacts',
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
  ),
  ShellDestination(
    path: RoutePaths.channels,
    label: 'Channels',
    icon: Icons.hub_outlined,
    selectedIcon: Icons.hub,
  ),
  ShellDestination(
    path: RoutePaths.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];
