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
import '../../features/conversations/domain/conversation_providers.dart';
import '../theme/app_radius.dart';
import '../theme/app_semantic_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'nav_destinations.dart';

/// Application chrome: a full-width labeled nav sidebar + top bar on
/// desktop/tablet, a drawer + top bar on mobile — the same extended
/// sidebar content in both, just framed differently. Wraps GoRouter's
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
            width: AppSizes.sidebarWidth,
            child: _ShellSidebarContent(
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

/// The extended (labeled) nav rail content shared by desktop's fixed
/// sidebar and mobile's drawer: brand header, a "GENERAL" section label,
/// destinations (Inbox carries a real unread badge), and the
/// account/sign-out footer pinned to the bottom.
class _ShellSidebarContent extends StatelessWidget {
  const _ShellSidebarContent({
    required this.selectedIndex,
    required this.unreadCount,
    required this.onDestinationSelected,
  });

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
      extended: true,
      leading: const Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BrandMark(),
            SizedBox(height: AppSpacing.lg),
            _SectionCaption('GENERAL'),
          ],
        ),
      ),
      trailing: const Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: _SidebarFooter(),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.forum_outlined, color: context.colors.primary),
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
  const _SidebarFooter();

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
        child: Container(
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
        ),
      ),
    );
  }
}
