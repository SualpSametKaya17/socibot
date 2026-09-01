import 'package:freezed_annotation/freezed_annotation.dart';

import 'organization_role.dart';

part 'organization_member.freezed.dart';
part 'organization_member.g.dart';

/// A user's membership in one organization (the join row between
/// `profiles` and `organizations`).
@freezed
sealed class OrganizationMember with _$OrganizationMember {
  const factory OrganizationMember({
    required String id,
    required String organizationId,
    required String userId,
    required OrganizationRole role,
    required String displayName,
    String? email,
    String? avatarUrl,
    required DateTime joinedAt,
  }) = _OrganizationMember;

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberFromJson(json);
}
