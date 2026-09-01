import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../organization/domain/organization_member.dart';
import '../../../organization/domain/organization_providers.dart';
import '../../../organization/domain/organization_role.dart';
import '../widgets/settings_section.dart';
import '../widgets/team_member_row.dart';

/// Placeholder row content for the loading skeleton — shape only, the
/// actual text is replaced by shimmer bones.
final _dummyMember = OrganizationMember(
  id: 'skeleton',
  organizationId: 'skeleton',
  userId: 'skeleton',
  role: OrganizationRole.member,
  displayName: 'Loading member name',
  email: 'loading@example.com',
  joinedAt: DateTime(2026),
  lastActiveAt: DateTime.now(),
);

/// Team management — a flat enterprise table on desktop/tablet, compact
/// structured rows on mobile. No card-per-member layout.
class TeamSettingsPage extends ConsumerStatefulWidget {
  const TeamSettingsPage({super.key});

  @override
  ConsumerState<TeamSettingsPage> createState() => _TeamSettingsPageState();
}

class _TeamSettingsPageState extends ConsumerState<TeamSettingsPage> {
  final _searchController = TextEditingController();
  String _query = '';
  OrganizationRole? _roleFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final membersAsync = ref.watch(organizationMembersProvider);
    final isNarrow = MediaQuery.sizeOf(context).width < 720;

    return SettingsPageScaffold(
      title: 'Team',
      description: 'Manage members who can access this workspace.',
      headerTrailing: Tooltip(
        message:
            'Sending invites needs a backend endpoint — coming in a '
            'later stage',
        child: ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.person_add_alt_1, size: 16),
          label: const Text('Invite member'),
        ),
      ),
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search members',
                  prefixIcon: Icon(Icons.search, size: 18),
                  isDense: true,
                ),
                onChanged: (value) =>
                    setState(() => _query = value.trim().toLowerCase()),
              ),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: DropdownButtonFormField<OrganizationRole?>(
                initialValue: _roleFilter,
                isExpanded: true,
                icon: Icon(
                  Icons.expand_more,
                  size: 18,
                  color: colors.textMuted,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'All roles',
                ),
                onChanged: (value) => setState(() => _roleFilter = value),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All roles')),
                  for (final role in OrganizationRole.values)
                    DropdownMenuItem(value: role, child: Text(role.label)),
                ],
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.lg),
        membersAsync.when(
          data: (members) {
            final filtered = members.where((member) {
              if (_roleFilter != null && member.role != _roleFilter) {
                return false;
              }
              if (_query.isEmpty) return true;
              return member.displayName.toLowerCase().contains(_query) ||
                  (member.email?.toLowerCase().contains(_query) ?? false);
            }).toList();

            if (members.isEmpty) {
              return const EmptyState(
                icon: Icons.group_outlined,
                title: 'No team members found',
                message:
                    'Invite teammates to collaborate on customer '
                    'conversations.',
              );
            }
            if (filtered.isEmpty) {
              return const EmptyState(
                icon: Icons.search_off,
                title: 'No members match your filters',
              );
            }

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  if (!isNarrow) const TeamTableHeader(),
                  for (var i = 0; i < filtered.length; i++) ...[
                    FadeSlideIn(
                      delay: Duration(milliseconds: 25 * i),
                      child: isNarrow
                          ? TeamMemberMobileRow(member: filtered[i])
                          : TeamTableRow(member: filtered[i], onMoreTap: () {}),
                    ),
                    if (i != filtered.length - 1)
                      Divider(height: 1, color: colors.border),
                  ],
                ],
              ),
            );
          },
          loading: () => Skeletonizer(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  if (!isNarrow) const TeamTableHeader(),
                  for (var i = 0; i < 4; i++) ...[
                    isNarrow
                        ? TeamMemberMobileRow(member: _dummyMember)
                        : TeamTableRow(member: _dummyMember, onMoreTap: () {}),
                    if (i != 3) Divider(height: 1, color: colors.border),
                  ],
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => EmptyState(
            icon: Icons.error_outline,
            title: 'Could not load team members',
            message: error is AppException ? error.message : '$error',
          ),
        ),
      ],
    );
  }
}
