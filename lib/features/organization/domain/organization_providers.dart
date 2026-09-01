import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/organization_repository.dart';
import 'organization.dart';

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return MockOrganizationRepository();
});

/// The organization the signed-in user is currently working in.
///
/// Picks the user's first organization for now — an organization switcher
/// (for users in more than one) is a later-stage UI concern, not a data
/// layer one.
class CurrentOrganizationController extends AsyncNotifier<Organization?> {
  @override
  FutureOr<Organization?> build() async {
    final organizations =
        await ref.watch(organizationRepositoryProvider).fetchMyOrganizations();
    return organizations.isEmpty ? null : organizations.first;
  }
}

final currentOrganizationProvider =
    AsyncNotifierProvider<CurrentOrganizationController, Organization?>(
  CurrentOrganizationController.new,
);
