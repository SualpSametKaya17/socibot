import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';

/// Root GoRouter configuration.
///
/// Only a single bootstrap route exists at this stage (AŞAMA 0) so the
/// router/theme/Supabase wiring can be verified end-to-end. Auth, guards,
/// and feature routes (login, inbox, ...) are added starting AŞAMA 1.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const _BootstrapPlaceholderScreen(),
      ),
    ],
  );
});

/// Temporary placeholder confirming the app shell (theme + router +
/// Supabase client) initialized correctly. Replaced by the real auth-aware
/// landing screen in a later stage.
class _BootstrapPlaceholderScreen extends StatelessWidget {
  const _BootstrapPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Socibot',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Architecture setup complete.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
