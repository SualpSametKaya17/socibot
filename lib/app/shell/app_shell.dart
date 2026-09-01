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
import '../theme/app_radius.dart';
import '../theme/app_semantic_colors.dart';
import '../theme/app_spacing.dart';
import 'nav_destinations.dart';

/// Application chrome: a collapsible sidebar + top bar on desktop/web, a
/// narrower (collapsed) sidebar on tablet, a drawer + top bar on mobile.
/// Wraps GoRouter's [StatefulNavigationShell] so each destination keeps
/// its own navigation state when switching tabs.
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
      tablet: (context) => _DesktopShell(
        navigationShell: widget.navigationShell,
        onDestinationSelected: _onDestinationSelected,
        expanded: false,
        onToggleExpanded: null,
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
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final destination = shellDestinations[navigationShell.currentIndex];

    return Scaffold(
      body: Row(
        children: [
          _SidebarFrame(
            child: AppSidebar(
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
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _SidebarFooter(expanded: expanded),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppTopBar(title: Text(destination.label)),
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
      appBar: AppTopBar(title: Text(destination.label)),
      drawer: Drawer(
        backgroundColor: context.colors.sidebar,
        child: SafeArea(
          child: AppSidebar(
            destinations: [
              for (final d in shellDestinations) d.toSidebarDestination(),
            ],
            selectedIndex: navigationShell.currentIndex,
            extended: true,
            leading: const _SidebarHeader(
              expanded: true,
              onToggleExpanded: null,
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _SidebarFooter(expanded: true),
              ),
            ),
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

/// Paints the sidebar's background + subtle right border around whatever
/// rail content is passed in, so [AppSidebar] itself stays a plain
/// (undecorated) navigation component reusable outside the shell too.
class _SidebarFrame extends StatelessWidget {
  const _SidebarFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.sidebar,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: child,
    );
  }
}

/// Sidebar leading widget: brand mark, current organization name, and the
/// desktop collapse/expand toggle (null on mobile/tablet, where there's
/// no toggle).
class _SidebarHeader extends ConsumerWidget {
  const _SidebarHeader({
    required this.expanded,
    required this.onToggleExpanded,
  });

  final bool expanded;
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organization = ref.watch(currentOrganizationProvider);
    final theme = Theme.of(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: expanded
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Icon(Icons.forum_outlined, color: colors.primary),
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
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: organization.when(
                data: (org) => Text(
                  org?.name ?? 'Socibot',
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                loading: () => SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primary,
                  ),
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

/// The user/profile area pinned to the bottom of the sidebar. Tapping it
/// opens the account menu (sign out) — the one place that action lives,
/// so the top bar can stay minimal.
class _SidebarFooter extends ConsumerWidget {
  const _SidebarFooter({required this.expanded});

  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final user = ref.watch(authRepositoryProvider).currentUser;
    final label = user?.email ?? 'Account';

    Future<void> signOut() async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await ref.read(authRepositoryProvider).signOut();
      } on AppException catch (e) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: PopupMenuButton<String>(
        tooltip: 'Account menu',
        offset: const Offset(0, -8),
        position: PopupMenuPosition.over,
        onSelected: (value) {
          if (value == 'sign-out') signOut();
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
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              AppAvatar(name: label),
              if (expanded) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Icon(Icons.unfold_more, size: 16, color: colors.textMuted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
