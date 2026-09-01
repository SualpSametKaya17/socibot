import 'package:flutter/material.dart';

import '../../app/theme/app_sizes.dart';

class SidebarDestination {
  const SidebarDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Real count shown as a small badge on the icon (e.g. unread inbox
  /// count) — null or zero renders no badge at all rather than a "0".
  final int? badgeCount;
}

/// The app's primary navigation, shared by the desktop rail and the mobile
/// drawer so both present the same destinations consistently.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = true,
    this.leading,
    this.trailing,
  });

  final List<SidebarDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;
  final Widget? leading;
  final Widget? trailing;

  /// Icon-only mode relies on a tooltip to convey the label (extended
  /// mode already shows it as text, so no tooltip needed there). A
  /// positive [badgeCount] overlays a small count badge either way.
  Widget _icon(IconData icon, String label, int? badgeCount) {
    Widget iconWidget = Icon(icon);
    if (badgeCount != null && badgeCount > 0) {
      iconWidget = Badge(
        label: Text(badgeCount > 99 ? '99+' : '$badgeCount'),
        child: iconWidget,
      );
    }
    return extended ? iconWidget : Tooltip(message: label, child: iconWidget);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: extended,
      minExtendedWidth: AppSizes.sidebarWidth,
      groupAlignment: -1,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      leading: leading,
      trailing: trailing,
      destinations: [
        for (final destination in destinations)
          NavigationRailDestination(
            icon: _icon(
              destination.icon,
              destination.label,
              destination.badgeCount,
            ),
            selectedIcon: _icon(
              destination.selectedIcon,
              destination.label,
              destination.badgeCount,
            ),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
