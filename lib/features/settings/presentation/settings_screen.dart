import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../auth/domain/auth_providers.dart';
import '../../organization/domain/organization_member.dart';
import '../../organization/domain/organization_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationAsync = ref.watch(currentOrganizationProvider);
    final membersAsync = ref.watch(organizationMembersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppTypography.headingMedium),
            const Gap(AppSpacing.xl),
            Text('Organization', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            organizationAsync.when(
              data: (organization) => organization == null
                  ? const AppSurfaceCard(
                      child: EmptyState(
                        icon: Icons.apartment_outlined,
                        title: 'No organization yet',
                      ),
                    )
                  : _OrganizationCard(
                      name: organization.name,
                      slug: organization.slug,
                      createdAt: organization.createdAt,
                    ),
              loading: () => const AppSurfaceCard(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load organization',
                message: '$error',
              ),
            ),
            const Gap(AppSpacing.xxl),
            Text('Team', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            membersAsync.when(
              data: (members) => _TeamCard(members: members),
              loading: () => const AppSurfaceCard(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load team members',
                message: '$error',
              ),
            ),
            const Gap(AppSpacing.xxl),
            Text('Account', style: AppTypography.headingSmall),
            const Gap(AppSpacing.md),
            const _AccountCard(),
          ],
        ),
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  const _OrganizationCard({
    required this.name,
    required this.slug,
    required this.createdAt,
  });

  final String name;
  final String slug;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTypography.labelLarge),
          const Gap(AppSpacing.xs),
          Text(
            '$slug · created ${DateFormat.yMMMd().format(createdAt)}',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.members});

  final List<OrganizationMember> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const AppSurfaceCard(
        child: EmptyState(icon: Icons.group_outlined, title: 'No members yet'),
      );
    }

    return AppSurfaceCard(
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < members.length; i++) ...[
            FadeSlideIn(
              delay: Duration(milliseconds: 30 * i),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    AppAvatar(
                      name: members[i].displayName,
                      imageUrl: members[i].avatarUrl,
                    ),
                    const Gap(AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            members[i].displayName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (members[i].email != null)
                            Text(
                              members[i].email!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    AppBadge(
                      label: members[i].role.label,
                      color: context.colors.primary,
                    ),
                  ],
                ),
              ),
            ),
            if (i != members.length - 1)
              Divider(height: 1, color: context.colors.border),
          ],
        ],
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final email =
        ref.watch(authRepositoryProvider).currentUser?.email ?? 'Unknown';

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

    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          AppAvatar(name: email),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Signed in as',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.textSecondary),
                ),
                Text(email, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: signOut,
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
