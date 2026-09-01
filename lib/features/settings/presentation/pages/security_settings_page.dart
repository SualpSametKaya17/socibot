import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../auth/domain/auth_providers.dart';
import '../widgets/settings_section.dart';

/// Account and workspace security. Every action here needs a backend
/// endpoint that doesn't exist yet, so each control stays visibly
/// disabled with a tooltip rather than pretending to work — same
/// convention as the Channels screen's Connect/Manage buttons.
class SecuritySettingsPage extends ConsumerWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final email =
        ref.watch(authRepositoryProvider).currentUser?.email ?? 'Unknown';

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
              title: 'Security',
              description: 'Manage account and workspace security.',
            ),
            const Gap(AppSpacing.xl),
            Divider(height: 1, color: colors.border),
            const Gap(AppSpacing.xl),
            SettingsSection(
              title: 'Password',
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '••••••••••••',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textPrimary,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tooltip(
                    message:
                        'Changing your password needs a backend endpoint — '
                        'coming in a later stage',
                    child: OutlinedButton(
                      onPressed: null,
                      child: const Text('Change password'),
                    ),
                  ),
                ],
              ),
            ),
            SettingsSection(
              title: 'Sessions',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        borderRadius: AppRadius.smAll,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.devices_outlined,
                            size: 18,
                            color: colors.textSecondary,
                          ),
                          const Gap(AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'This device',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  'Current session',
                                  style: AppTypography.caption.copyWith(
                                    color: colors.textMuted,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const AppBadge(
                            label: 'Active now',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  Tooltip(
                    message:
                        'Listing and revoking sessions needs a backend '
                        'endpoint — coming in a later stage',
                    child: OutlinedButton(
                      onPressed: null,
                      child: const Text('Manage sessions'),
                    ),
                  ),
                ],
              ),
            ),
            SettingsSection(
              title: 'Two-factor authentication',
              description: 'Add an extra layer of security to your account.',
              last: true,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Status: ',
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        AppBadge(label: 'Not enabled', color: colors.textMuted),
                      ],
                    ),
                  ),
                  Tooltip(
                    message:
                        'Enabling 2FA needs a backend endpoint — coming in a '
                        'later stage',
                    child: ElevatedButton(
                      onPressed: null,
                      child: const Text('Enable 2FA'),
                    ),
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
