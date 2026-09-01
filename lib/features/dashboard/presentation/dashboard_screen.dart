import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import '../../auth/domain/auth_providers.dart';
import '../../organization/domain/organization_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final email = ref.watch(authRepositoryProvider).currentUser?.email;
    final organization = ref.watch(currentOrganizationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          organization.when(
            data: (org) => Text(
              [?org?.name, ?email].join(' · '),
              style: theme.textTheme.bodyMedium,
            ),
            loading: () => const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (error, stackTrace) => Text(
              'Could not load organization',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          const SizedBox(height: 48),
          const EmptyState(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard is coming soon',
            message: 'Conversation and channel metrics will appear here.',
          ),
        ],
      ),
    );
  }
}
