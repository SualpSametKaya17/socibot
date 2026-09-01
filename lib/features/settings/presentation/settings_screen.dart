import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_breakpoints.dart';
import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../domain/settings_section.dart';
import 'pages/inbox_settings_page.dart';
import 'pages/notification_settings_page.dart';
import 'pages/security_settings_page.dart';
import 'pages/team_settings_page.dart';
import 'pages/workspace_settings_page.dart';
import 'widgets/settings_navigation.dart';

/// The Settings experience: a secondary navigation panel (desktop), a
/// compact top pill bar (tablet), or a plain navigable list with
/// master-detail push (mobile) — all sharing the same five section
/// pages. Stays on the single `/settings` GoRouter route; section
/// selection is local UI state, not a nested route.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  SettingsSection _selected = SettingsSection.workspace;
  bool _mobileSectionOpen = false;

  Widget _pageFor(SettingsSection section) {
    return switch (section) {
      SettingsSection.workspace => const WorkspaceSettingsPage(),
      SettingsSection.team => const TeamSettingsPage(),
      SettingsSection.notifications => const NotificationSettingsPage(),
      SettingsSection.inbox => const InboxSettingsPage(),
      SettingsSection.security => const SecuritySettingsPage(),
    };
  }

  void _select(SettingsSection section) {
    setState(() {
      _selected = section;
      _mobileSectionOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < AppBreakpoints.mobile) {
      if (!_mobileSectionOpen) {
        return SettingsMobileList(onSelect: _select);
      }
      return Column(
        children: [
          _MobileSectionHeader(
            title: _selected.label,
            onBack: () => setState(() => _mobileSectionOpen = false),
          ),
          Expanded(child: _pageFor(_selected)),
        ],
      );
    }

    if (width < AppBreakpoints.tablet) {
      return Column(
        children: [
          SettingsTabletNavBar(selected: _selected, onSelect: _select),
          Expanded(child: _pageFor(_selected)),
        ],
      );
    }

    return Row(
      children: [
        SettingsNavigationPanel(selected: _selected, onSelect: _select),
        Expanded(child: _pageFor(_selected)),
      ],
    );
  }
}

class _MobileSectionHeader extends StatelessWidget {
  const _MobileSectionHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Back to Settings',
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: onBack,
            ),
            Text(
              title,
              style: AppTypography.headingSmall.copyWith(fontSize: 16),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
