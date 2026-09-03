import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';
import '../../core/errors/app_exception.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_sidebar.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../../features/auth/domain/mock_auth_session.dart';
import '../../features/conversations/domain/conversation_providers.dart';
import '../theme/app_radius.dart';
import '../theme/app_semantic_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'nav_destinations.dart';

/// Application chrome: a narrow (60px) icon-only nav rail + top bar on
/// desktop/tablet, a full-width labeled drawer + top bar on mobile.
/// Wraps GoRouter's [StatefulNavigationShell] so each destination keeps
/// its own navigation state when switching tabs.
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
      // The 172px labeled sidebar eats too much of a 600-899px tablet
      // width to leave screens like Inbox usable — a narrow icon-only
      // rail (same content, `extended: false`) keeps navigation reachable
      // without the width cost.
      tablet: (context) => _TabletShell(
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

class _TabletShell extends ConsumerWidget {
  const _TabletShell({
    required this.navigationShell,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = shellDestinations[navigationShell.currentIndex];
    final unreadCount = ref.watch(totalUnreadCountProvider);

    return Scaffold(
      body: Row(
        children: [
          _SidebarFrame(
            width: AppSizes.navRailWidth,
            child: _ShellSidebarContent(
              extended: false,
              selectedIndex: navigationShell.currentIndex,
              unreadCount: unreadCount,
              onDestinationSelected: onDestinationSelected,
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

class _DesktopShell extends ConsumerWidget {
  const _DesktopShell({
    required this.navigationShell,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = shellDestinations[navigationShell.currentIndex];
    final unreadCount = ref.watch(totalUnreadCountProvider);

    return Scaffold(
      body: Row(
        children: [
          _SidebarFrame(
            width: AppSizes.mainSidebarWidth,
            child: _DesktopNavList(
              selectedIndex: navigationShell.currentIndex,
              unreadCount: unreadCount,
              onDestinationSelected: onDestinationSelected,
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

/// Desktop's main application sidebar: a compact, grouped, labeled nav
/// list (not [AppSidebar]/[NavigationRail] — those stay for the mobile
/// drawer, unchanged) so row height/icon/label sizing and the GENERAL/
/// SETTINGS grouping can be controlled precisely. Only destinations that
/// actually exist appear — no placeholder Tickets/Campaigns/Reports
/// rows for features this app doesn't have yet.
class _DesktopNavList extends StatelessWidget {
  const _DesktopNavList({
    required this.selectedIndex,
    required this.unreadCount,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final int unreadCount;
  final ValueChanged<int> onDestinationSelected;

  static const _generalIndexes = [0, 1, 2]; // Dashboard, Inbox, Contacts
  static const _settingsIndexes = [3, 4]; // Channels, Settings

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: _WorkspaceSelector(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: _SectionCaption('GENERAL'),
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final i in _generalIndexes) _buildRow(i),
                const SizedBox(height: AppSpacing.md),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: _SectionCaption('SETTINGS'),
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final i in _settingsIndexes) _buildRow(i),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: _SidebarFooter(expanded: true),
        ),
      ],
    );
  }

  Widget _buildRow(int index) {
    final d = shellDestinations[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 1,
      ),
      child: _DesktopNavRow(
        icon: d.icon,
        selectedIcon: d.selectedIcon,
        label: d.label,
        selected: selectedIndex == index,
        badgeCount: d.path == RoutePaths.inbox ? unreadCount : null,
        onTap: () => onDestinationSelected(index),
      ),
    );
  }
}

class _WorkspaceSelector extends StatelessWidget {
  const _WorkspaceSelector();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: 'Switching workspaces is coming in a later stage',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.forum_outlined, size: 16, color: colors.primary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                'Socibot',
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  color: colors.textPrimary,
                  fontSize: 12,
                ),
              ),
            ),
            Icon(Icons.unfold_more, size: 14, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _DesktopNavRow extends StatelessWidget {
  const _DesktopNavRow({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.badgeCount,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final int? badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected ? colors.primarySoft : Colors.transparent,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        hoverColor: colors.surfaceSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 8,
          ),
          child: Row(
            children: [
              Icon(
                selected ? selectedIcon : icon,
                size: 16,
                color: selected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? colors.primary : colors.textSecondary,
                  ),
                ),
              ),
              if (badgeCount != null && badgeCount! > 0) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: AppRadius.fullAll,
                  ),
                  child: Text(
                    badgeCount! > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileShell extends ConsumerWidget {
  const _MobileShell({
    required this.navigationShell,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = shellDestinations[navigationShell.currentIndex];
    final unreadCount = ref.watch(totalUnreadCountProvider);

    return Scaffold(
      appBar: AppTopBar(title: Text(destination.label)),
      drawer: Drawer(
        backgroundColor: context.colors.sidebar,
        child: SafeArea(
          child: _ShellSidebarContent(
            extended: true,
            selectedIndex: navigationShell.currentIndex,
            unreadCount: unreadCount,
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

/// Mobile drawer's nav rail content (via [AppSidebar]/[NavigationRail]):
/// brand header, destinations (Inbox carries a real unread badge), and
/// the account/sign-out footer pinned to the bottom. Desktop uses
/// [_DesktopNavList] instead — a bespoke grouped list, not this.
class _ShellSidebarContent extends StatelessWidget {
  const _ShellSidebarContent({
    required this.extended,
    required this.selectedIndex,
    required this.unreadCount,
    required this.onDestinationSelected,
  });

  final bool extended;
  final int selectedIndex;
  final int unreadCount;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return AppSidebar(
      destinations: [
        for (final d in shellDestinations)
          d.toSidebarDestination(
            badgeCount: d.path == RoutePaths.inbox ? unreadCount : null,
          ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      leading: Padding(
        padding: extended
            ? const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              )
            : const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: extended
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BrandMark(extended: true),
                  SizedBox(height: AppSpacing.lg),
                  _SectionCaption('GENERAL'),
                ],
              )
            : const _BrandMark(extended: false),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: _SidebarFooter(expanded: extended),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(Icons.forum_outlined, color: context.colors.primary);
    if (!extended) return Tooltip(message: 'Socibot', child: icon);

    return Row(
      children: [
        icon,
        const SizedBox(width: AppSpacing.sm),
        Text('Socibot', style: AppTypography.labelLarge),
      ],
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(
        color: context.colors.textMuted,
        letterSpacing: 0.4,
      ),
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
      // Signed in via the temporary demo-credentials shortcut — there's no
      // real Supabase session to tear down, just clear the local flag.
      if (mockAuthActive.value) {
        mockAuthActive.value = false;
        return;
      }
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
          if (value == 'design-preview') context.go(RoutePaths.designPreview);
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            enabled: false,
            child: Text(label, style: AppTypography.bodySmall),
          ),
          const PopupMenuDivider(),
          if (kDebugMode) ...[
            const PopupMenuItem<String>(
              value: 'design-preview',
              child: ListTile(
                leading: Icon(Icons.palette_outlined),
                title: Text('Design language (dev)'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
          ],
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
                        style: AppTypography.bodySmall,
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
