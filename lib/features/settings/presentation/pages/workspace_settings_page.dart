import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../organization/domain/organization_providers.dart';
import '../../domain/settings_preferences.dart';
import '../widgets/settings_section.dart';

const _timezones = [
  'Europe/Istanbul',
  'UTC',
  'Europe/London',
  'America/New_York',
  'Asia/Dubai',
  'Asia/Tokyo',
];
const _languages = ['English', 'Türkçe'];
const _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
const _timeFormats = ['24 hour', '12 hour'];

/// The default Settings section — workspace identity, appearance, and
/// regional preferences, ending in a clearly separated danger zone.
class WorkspaceSettingsPage extends ConsumerStatefulWidget {
  const WorkspaceSettingsPage({super.key});

  @override
  ConsumerState<WorkspaceSettingsPage> createState() =>
      _WorkspaceSettingsPageState();
}

class _WorkspaceSettingsPageState extends ConsumerState<WorkspaceSettingsPage> {
  bool _saving = false;
  bool _justSaved = false;

  bool _isDirty(WorkspaceDraft draft, WorkspaceDraft saved) {
    return draft.name != saved.name ||
        draft.timezone != saved.timezone ||
        draft.language != saved.language ||
        draft.theme != saved.theme ||
        draft.dateFormat != saved.dateFormat ||
        draft.timeFormat != saved.timeFormat;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    ref.read(savedWorkspaceDraftProvider.notifier).state = ref.read(
      workspaceDraftProvider,
    );
    setState(() {
      _saving = false;
      _justSaved = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _justSaved = false);
    });
  }

  void _cancel() {
    ref.read(workspaceDraftProvider.notifier).state = ref.read(
      savedWorkspaceDraftProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final organizationAsync = ref.watch(currentOrganizationProvider);
    final draft = ref.watch(workspaceDraftProvider);
    final saved = ref.watch(savedWorkspaceDraftProvider);
    final dirty = _isDirty(draft, saved);
    final organizationName = organizationAsync.valueOrNull?.name ?? '';

    void updateDraft(WorkspaceDraft Function(WorkspaceDraft) update) {
      ref.read(workspaceDraftProvider.notifier).state = update(draft);
    }

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
              title: 'Workspace',
              description: 'Manage your workspace information and preferences.',
            ),
            const Gap(AppSpacing.xl),
            Divider(height: 1, color: colors.border),
            const Gap(AppSpacing.xl),
            SettingsSection(
              title: 'Workspace details',
              description:
                  'Update your workspace identity and regional preferences.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WorkspaceLogo(name: organizationName),
                  const Gap(AppSpacing.lg),
                  AppTextField(
                    key: const ValueKey('workspace-name-field'),
                    label: 'Workspace Name',
                    initialValue: draft.name ?? organizationName,
                    onChanged: (value) =>
                        updateDraft((d) => d.copyWith(name: value)),
                  ),
                  const Gap(AppSpacing.md),
                  AppTextField(
                    label: 'Workspace ID',
                    readOnly: true,
                    initialValue: organizationAsync.valueOrNull?.slug ?? '',
                    helperText:
                        "This is your workspace's unique identifier "
                        'and cannot be changed.',
                  ),
                  const Gap(AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Timezone',
                          value: draft.timezone,
                          items: [
                            for (final tz in _timezones)
                              AppDropdownItem(tz, tz),
                          ],
                          onChanged: (value) =>
                              updateDraft((d) => d.copyWith(timezone: value)),
                        ),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Language',
                          value: draft.language,
                          items: [
                            for (final lang in _languages)
                              AppDropdownItem(lang, lang),
                          ],
                          onChanged: (value) =>
                              updateDraft((d) => d.copyWith(language: value)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SettingsSection(
              title: 'Appearance',
              description: 'Customize how Socibot appears for you.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ThemeSegmentedControl(
                    value: draft.theme,
                    onChanged: (value) =>
                        updateDraft((d) => d.copyWith(theme: value)),
                  ),
                  const Gap(AppSpacing.xs + 2),
                  Text(
                    "Theme switching isn't wired up yet — this saves your "
                    'preference for when it is.',
                    style: AppTypography.caption.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SettingsSection(
              title: 'Regional preferences',
              last: true,
              child: Row(
                children: [
                  Expanded(
                    child: AppDropdownField<String>(
                      label: 'Date Format',
                      value: draft.dateFormat,
                      items: [
                        for (final format in _dateFormats)
                          AppDropdownItem(format, format),
                      ],
                      onChanged: (value) =>
                          updateDraft((d) => d.copyWith(dateFormat: value)),
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: AppDropdownField<String>(
                      label: 'Time Format',
                      value: draft.timeFormat,
                      items: [
                        for (final format in _timeFormats)
                          AppDropdownItem(format, format),
                      ],
                      onChanged: (value) =>
                          updateDraft((d) => d.copyWith(timeFormat: value)),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_justSaved) ...[
                  Icon(Icons.check_circle, size: 16, color: colors.success),
                  const Gap(AppSpacing.xs),
                  Text(
                    'Changes saved',
                    style: AppTypography.labelMedium.copyWith(
                      color: colors.success,
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                ],
                TextButton(
                  onPressed: dirty && !_saving ? _cancel : null,
                  child: const Text('Cancel'),
                ),
                const Gap(AppSpacing.sm),
                ElevatedButton(
                  onPressed: dirty && !_saving ? _save : null,
                  child: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ],
            ),
            const Gap(AppSpacing.xxl),
            const _DangerZone(),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceLogo extends StatelessWidget {
  const _WorkspaceLogo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primarySoft,
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: colors.border),
          ),
          child: Text(
            initial,
            style: AppTypography.headingSmall.copyWith(color: colors.primary),
          ),
        ),
        const Gap(AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Uploading a logo needs storage wiring — coming in a later stage',
              child: OutlinedButton(
                onPressed: null,
                child: const Text('Upload / Change'),
              ),
            ),
            const Gap(AppSpacing.xs),
            Text(
              'Recommended square image.',
              style: AppTypography.caption.copyWith(
                color: colors.textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemeSegmentedControl extends StatelessWidget {
  const _ThemeSegmentedControl({required this.value, required this.onChanged});

  final ThemePreference value;
  final ValueChanged<ThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in ThemePreference.values) ...[
            if (option != ThemePreference.values.first)
              Container(width: 1, height: 20, color: colors.border),
            _ThemeSegment(
              option: option,
              selected: option == value,
              onTap: () => onChanged(option),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThemeSegment extends StatelessWidget {
  const _ThemeSegment({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ThemePreference option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: selected ? colors.primarySoft : Colors.transparent,
        child: Text(
          option.label,
          style: AppTypography.labelMedium.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DangerZone extends StatelessWidget {
  const _DangerZone();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: colors.error.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger zone',
            style: AppTypography.labelLarge.copyWith(color: colors.error),
          ),
          const Gap(AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete workspace',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'Permanently delete this workspace and its associated '
                      'data.',
                      style: AppTypography.caption.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.md),
              Tooltip(
                message:
                    'Deleting a workspace needs a backend endpoint — coming '
                    'in a later stage',
                child: OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(
                      color: colors.error.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Text('Delete workspace'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
