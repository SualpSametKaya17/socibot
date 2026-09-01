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
    return [_mockOrganization];
  }

  @override
  Future<List<OrganizationMember>> fetchMembers(String organizationId) async {
    return [
      OrganizationMember(
        id: 'mock-member-1',
        organizationId: organizationId,
        userId: 'mock-user-1',
        role: OrganizationRole.owner,
        displayName: 'You',
        joinedAt: DateTime(2026, 1, 1),
      ),
    ];
  }
}
