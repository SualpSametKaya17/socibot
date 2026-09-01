import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_exception.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_sidebar.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../theme/app_radius.dart';
import '../theme/app_semantic_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import 'nav_destinations.dart';

/// Application chrome: a fixed-width, icon-only global nav rail + top bar
/// on desktop/tablet, a drawer + top bar on mobile. Wraps GoRouter's
/// [StatefulNavigationShell] so each destination keeps its own
/// navigation state when switching tabs.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => _MobileShell(
        navigationShell: navigationShell,
        onDestinationSelected: _onDestinationSelected,
      ),
      desktop: (context) => _DesktopShell(
        navigationShell: navigationShell,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

/// Desktop/tablet: a narrow (60px) icon-only rail — brand mark at top,
/// destinations with tooltips, profile/account menu pinned to the
/// bottom.
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.navigationShell,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final destination = shellDestinations[navigationShell.currentIndex];

    return Scaffold(
      body: Row(
        children: [
          _SidebarFrame(
            width: AppSizes.navRailWidth,
            child: AppSidebar(
              destinations: [
                for (final d in shellDestinations) d.toSidebarDestination(),
              ],
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: onDestinationSelected,
              extended: false,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: _BrandMark(),
              ),
              trailing: const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: _SidebarFooter(expanded: false),
                  ),
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
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: _BrandMark(),
            ),
            trailing: const Expanded(
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

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Socibot',
      child: Icon(Icons.forum_outlined, color: context.colors.primary),
    );
  }
}

/// Paints the sidebar's background + subtle right border around whatever
/// rail content is passed in, so [AppSidebar] itself stays a plain
/// (undecorated) navigation component reusable outside the shell too.
class _SidebarFrame extends StatelessWidget {
  const _SidebarFrame({required this.child, this.width});

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.sidebar,
          border: Border(right: BorderSide(color: colors.border)),
        ),
        child: child,
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
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
        child: expanded
            ? Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    AppAvatar(name: label),
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
                ),
              )
            : Tooltip(
                message: label,
                child: AppAvatar(name: label),
              ),
      ),
    );
  }
}
