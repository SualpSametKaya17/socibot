import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../organization/domain/organization_providers.dart';
import '../../domain/settings_preferences.dart';
import '../widgets/settings_section.dart';

/// Default conversation behavior — assignment, read/preview behavior,
/// composer Enter-key handling, and resolution defaults. Configuration
/// only, no automation is actually implemented here.
class InboxSettingsPage extends ConsumerWidget {
  const InboxSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final prefs = ref.watch(inboxPreferencesProvider);
    final notifier = ref.read(inboxPreferencesProvider.notifier);
    final members =
        ref.watch(organizationMembersProvider).valueOrNull ?? const [];
    final assigneeOptions = [
      'Unassigned',
      for (final member in members) member.displayName,
    ];

    return SettingsPageScaffold(
      title: 'Inbox',
      description: 'Configure default conversation behavior.',
      children: [
        SettingsSection(
          title: 'Conversation assignment',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsToggleRow(
                title: 'Auto assign new conversations',
                value: prefs.autoAssignNewConversations,
                onChanged: (value) => notifier.state = prefs.copyWith(
                  autoAssignNewConversations: value,
                ),
              ),
              const Gap(AppSpacing.md),
              AppDropdownField<String>(
                label: 'Default assignee',
                value: assigneeOptions.contains(prefs.defaultAssignee)
                    ? prefs.defaultAssignee
                    : 'Unassigned',
                items: [
                  for (final name in assigneeOptions)
                    AppDropdownItem(name, name),
                ],
                onChanged: (value) =>
                    notifier.state = prefs.copyWith(defaultAssignee: value),
              ),
            ],
          ),
        ),
        SettingsSection(
          title: 'Conversation behavior',
          child: Column(
            children: [
              SettingsToggleRow(
                title: 'Mark conversations as read when opened',
                value: prefs.markReadWhenOpened,
                onChanged: (value) =>
                    notifier.state = prefs.copyWith(markReadWhenOpened: value),
              ),
              SettingsToggleRow(
                title: 'Show message preview',
                value: prefs.showMessagePreview,
                onChanged: (value) =>
                    notifier.state = prefs.copyWith(showMessagePreview: value),
                last: true,
              ),
              const Gap(AppSpacing.lg),
              Text(
                'Enter key behavior',
                style: AppTypography.labelMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const Gap(AppSpacing.sm),
              _EnterKeyOption(
                label: 'Send message',
                selected: prefs.enterKeyBehavior == EnterKeyBehavior.send,
                onTap: () => notifier.state = prefs.copyWith(
                  enterKeyBehavior: EnterKeyBehavior.send,
                ),
              ),
              _EnterKeyOption(
                label: 'New line',
                selected: prefs.enterKeyBehavior == EnterKeyBehavior.newLine,
                onTap: () => notifier.state = prefs.copyWith(
                  enterKeyBehavior: EnterKeyBehavior.newLine,
                ),
              ),
            ],
          ),
        ),
        SettingsSection(
          title: 'Resolution',
          last: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDropdownField<ConversationResolutionBehavior>(
                label: 'Default resolved behavior',
                value: prefs.resolutionBehavior,
                items: [
                  for (final behavior in ConversationResolutionBehavior.values)
                    AppDropdownItem(behavior, behavior.label),
                ],
                onChanged: (value) =>
                    notifier.state = prefs.copyWith(resolutionBehavior: value),
              ),
              const Gap(AppSpacing.md),
              SettingsToggleRow(
                title: 'Reopen when customer replies',
                value: prefs.reopenWhenCustomerReplies,
                onChanged: (value) => notifier.state = prefs.copyWith(
                  reopenWhenCustomerReplies: value,
                ),
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EnterKeyOption extends StatelessWidget {
  const _EnterKeyOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? colors.primary : colors.textMuted,
            ),
            const Gap(AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
