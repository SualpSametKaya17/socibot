// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationMember _$OrganizationMemberFromJson(Map<String, dynamic> json) =>
    _OrganizationMember(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String,
      role: $enumDecode(_$OrganizationRoleEnumMap, json['role']),
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      status:
          $enumDecodeNullable(
            _$OrganizationMemberStatusEnumMap,
            json['status'],
          ) ??
          OrganizationMemberStatus.active,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
    );

Map<String, dynamic> _$OrganizationMemberToJson(_OrganizationMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'userId': instance.userId,
      'role': _$OrganizationRoleEnumMap[instance.role]!,
      'displayName': instance.displayName,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'status': _$OrganizationMemberStatusEnumMap[instance.status]!,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
    };

const _$OrganizationRoleEnumMap = {
  OrganizationRole.owner: 'owner',
  OrganizationRole.admin: 'admin',
  OrganizationRole.member: 'member',
};

const _$OrganizationMemberStatusEnumMap = {
  OrganizationMemberStatus.active: 'active',
  OrganizationMemberStatus.invited: 'invited',
};
