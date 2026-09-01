import '../domain/organization.dart';
import '../domain/organization_member.dart';
import '../domain/organization_role.dart';

/// Data access for organizations and their members.
///
/// Backed by [MockOrganizationRepository] until the `organizations` /
/// `organization_members` tables exist (AŞAMA 4) and a real Supabase-backed
/// implementation replaces it (AŞAMA 7) — the same mock-first pattern used
/// for the inbox.
///
/// RLS plan for AŞAMA 4 (documented here so the contract is decided before
/// the tables are modeled): every organization-scoped table carries an
/// `organization_id` column, and each policy checks membership via a
/// `SECURITY DEFINER` helper such as `is_org_member(organization_id uuid)`
/// backed by `organization_members` — so a user only ever sees rows for
/// organizations they belong to, and no organization can read another's
/// data.
abstract class OrganizationRepository {
  /// Organizations the current user belongs to.
  Future<List<Organization>> fetchMyOrganizations();

  Future<List<OrganizationMember>> fetchMembers(String organizationId);
}

class MockOrganizationRepository implements OrganizationRepository {
  static final _mockOrganization = Organization(
    id: 'mock-org-1',
    name: 'Acme Inc.',
    slug: 'acme',
    createdAt: DateTime(2026, 1, 1),
  );

  @override
  Future<List<Organization>> fetchMyOrganizations() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return [_mockOrganization];
  }

  @override
  Future<List<OrganizationMember>> fetchMembers(String organizationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return [
      OrganizationMember(
        id: 'mock-member-1',
        organizationId: organizationId,
        userId: 'mock-user-1',
        role: OrganizationRole.owner,
        displayName: 'Sofia Reyes',
        email: 'sofia@acme.com',
        joinedAt: DateTime(2026, 1, 1),
        lastActiveAt: now,
      ),
      OrganizationMember(
        id: 'mock-member-2',
        organizationId: organizationId,
        userId: 'mock-user-2',
        role: OrganizationRole.admin,
        displayName: 'Alex Kim',
        email: 'alex@acme.com',
        joinedAt: DateTime(2026, 1, 8),
        lastActiveAt: now.subtract(const Duration(minutes: 12)),
      ),
      OrganizationMember(
        id: 'mock-member-3',
        organizationId: organizationId,
        userId: 'mock-user-3',
        role: OrganizationRole.member,
        displayName: 'John Miller',
        email: 'john@acme.com',
        joinedAt: DateTime(2026, 1, 15),
        lastActiveAt: now.subtract(const Duration(hours: 2)),
      ),
      OrganizationMember(
        id: 'mock-member-4',
        organizationId: organizationId,
        userId: 'mock-user-4',
        role: OrganizationRole.member,
        displayName: 'Emma Moore',
        email: 'emma@acme.com',
        joinedAt: DateTime(2026, 2, 3),
        status: OrganizationMemberStatus.invited,
      ),
    ];
  }
}
