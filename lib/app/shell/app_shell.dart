import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_exception.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_sidebar.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../../features/organization/domain/organization_providers.dart';
import 'nav_destinations.dart';

/// Application chrome: a collapsible sidebar + top bar on desktop/web, a
/// drawer + top bar on mobile. Wraps GoRouter's [StatefulNavigationShell]
/// so each destination keeps its own navigation state when switching tabs.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _sidebarExpanded = true;

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => _MobileShell(
        navigationShell: widget.navigationShell,
        onDestinationSelected: _onDestinationSelected,
      ),
      desktop: (context) => _DesktopShell(
        navigationShell: widget.navigationShell,
        onDestinationSelected: _onDestinationSelected,
        expanded: _sidebarExpanded,
        onToggleExpanded: () =>
            setState(() => _sidebarExpanded = !_sidebarExpanded),
      ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.navigationShell,
    required this.onDestinationSelected,
    required this.expanded,
    required this.onToggleExpanded,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onDestinationSelected;
  final bool expanded;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final destination = shellDestinations[navigationShell.currentIndex];

    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            destinations: [
              for (final d in shellDestinations) d.toSidebarDestination(),
            ],
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: onDestinationSelected,
            extended: expanded,
            leading: _SidebarHeader(
              expanded: expanded,
              onToggleExpanded: onToggleExpanded,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                AppTopBar(
                  title: Text(destination.label),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: _UserMenu(),
                    ),
                  ],
                ),
                const Divider(height: 1),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.navigationShell,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final destination = shellDestinations[navigationShell.currentIndex];

    return Scaffold(
      appBar: AppTopBar(
        title: Text(destination.label),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 8), child: _UserMenu()),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: AppSidebar(
            destinations: [
              for (final d in shellDestinations) d.toSidebarDestination(),
            ],
            selectedIndex: navigationShell.currentIndex,
            extended: true,
            leading: _SidebarHeader(expanded: true, onToggleExpanded: null),
            onDestinationSelected: (index) {
              Navigator.of(context).pop();
              onDestinationSelected(index);
            },
          ),
        ),
      ),
      body: navigationShell,
    );
  }
}

/// Sidebar leading widget: brand mark, current organization name, and the
/// desktop collapse/expand toggle (hidden on mobile, where the toggle is
/// "close the drawer" instead).
class _SidebarHeader extends ConsumerWidget {
  const _SidebarHeader({required this.expanded, required this.onToggleExpanded});

  final bool expanded;
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organization = ref.watch(currentOrganizationProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: expanded
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Icon(Icons.forum_outlined, color: theme.colorScheme.primary),
              if (expanded && onToggleExpanded != null)
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Collapse sidebar',
                  onPressed: onToggleExpanded,
                ),
            ],
          ),
          if (!expanded && onToggleExpanded != null)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Expand sidebar',
              onPressed: onToggleExpanded,
            ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: organization.when(
                data: (org) => Text(
                  org?.name ?? 'Socibot',
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                loading: () => const SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stackTrace) => const Text('Socibot'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserMenu extends ConsumerWidget {
  const _UserMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final label = user?.email ?? 'Account';

    return PopupMenuButton<String>(
      tooltip: 'Account menu',
      onSelected: (value) async {
        if (value != 'sign-out') return;
        final messenger = ScaffoldMessenger.of(context);
        try {
          await ref.read(authRepositoryProvider).signOut();
        } on AppException catch (e) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(e.message)));
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'sign-out',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign out'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      child: AppAvatar(name: label),
    );
  }
}
