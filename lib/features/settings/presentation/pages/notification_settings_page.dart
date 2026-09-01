import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/settings_preferences.dart';
import '../widgets/settings_section.dart';

/// Grouped notification toggles — real, session-scoped preference state
/// (see [notificationPreferencesProvider]), not a mock.
class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final prefs = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsPageHeader(
              title: 'Notifications',
              description: 'Choose which events you want to be notified about.',
            ),
            const Gap(AppSpacing.xl),
            Divider(height: 1, color: colors.border),
            const Gap(AppSpacing.xl),
            SettingsSection(
              title: 'Conversations',
              child: Column(
                children: [
                  SettingsToggleRow(
                    title: 'New conversation',
                    value: prefs.newConversation,
                    onChanged: (value) =>
                        notifier.state = prefs.copyWith(newConversation: value),
                  ),
                  SettingsToggleRow(
                    title: 'New message',
                    value: prefs.newMessage,
                    onChanged: (value) =>
                        notifier.state = prefs.copyWith(newMessage: value),
                  ),
                  SettingsToggleRow(
                    title: 'Conversation assigned to me',
                    value: prefs.assignedToMe,
                    onChanged: (value) =>
                        notifier.state = prefs.copyWith(assignedToMe: value),
                  ),
                  SettingsToggleRow(
                    title: 'Mention',
                    value: prefs.mention,
                    onChanged: (value) =>
                        notifier.state = prefs.copyWith(mention: value),
                    last: true,
                  ),
                ],
              ),
            ),
            SettingsSection(
              title: 'Team',
              child: Column(
                children: [
                  SettingsToggleRow(
                    title: 'New team member',
                    value: prefs.newTeamMember,
                    onChanged: (value) =>
                        notifier.state = prefs.copyWith(newTeamMember: value),
                  ),
                  SettingsToggleRow(
                    title: 'Assignment changes',
                    value: prefs.assignmentChanges,
                    onChanged: (value) => notifier.state = prefs.copyWith(
                      assignmentChanges: value,
                    ),
                    last: true,
                  ),
                ],
              ),
            ),
            SettingsSection(
              title: 'System',
              last: true,
              child: Column(
                children: [
                  SettingsToggleRow(
                    title: 'Channel disconnected',
                    value: prefs.channelDisconnected,
                    onChanged: (value) => notifier.state = prefs.copyWith(
                      channelDisconnected: value,
                    ),
                  ),
                  SettingsToggleRow(
                    title: 'Integration error',
                    value: prefs.integrationError,
                    onChanged: (value) => notifier.state = prefs.copyWith(
                      integrationError: value,
                    ),
                    last: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
