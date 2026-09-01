import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a [Stream] to GoRouter's `refreshListenable`, so the router
/// re-evaluates its `redirect` callback whenever Supabase's auth state
/// changes (sign in, sign out, token refresh) without recreating the
/// [GoRouter] instance itself.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
