/// A member's permission level within an organization.
///
/// `owner` — full control, including billing and deleting the organization.
/// `admin` — manage members, channels, and settings, but not billing/deletion.
/// `member` — day-to-day work: handle conversations and contacts.
enum OrganizationRole {
  owner,
  admin,
  member;

  bool get canManageMembers => this == owner || this == admin;

  bool get canManageChannels => this == owner || this == admin;

  String get label => switch (this) {
    OrganizationRole.owner => 'Owner',
    OrganizationRole.admin => 'Admin',
    OrganizationRole.member => 'Member',
  };
}
