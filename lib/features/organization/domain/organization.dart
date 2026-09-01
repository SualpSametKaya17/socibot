import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// A B2B customer account (tenant). All conversations, contacts, channels,
/// and members are scoped to exactly one organization; a user can belong to
/// more than one.
@freezed
sealed class Organization with _$Organization {
  const factory Organization({
    required String id,
    required String name,
    required String slug,
    required DateTime createdAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
