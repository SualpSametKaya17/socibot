import 'package:flutter/material.dart';

import '../../app/theme/app_sizes.dart';

class SidebarDestination {
  const SidebarDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
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
  /// mode already shows it as text, so no tooltip needed there).
  Widget _icon(IconData icon, String label) {
    final iconWidget = Icon(icon);
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
            icon: _icon(destination.icon, destination.label),
            selectedIcon: _icon(destination.selectedIcon, destination.label),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
