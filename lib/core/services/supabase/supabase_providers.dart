import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Exposes the initialized [SupabaseClient] to the rest of the app.
///
/// Features should depend on this provider (or a repository built on top of
/// it) rather than importing `supabase_flutter` directly, so the Supabase
/// dependency stays confined to the data layer.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});

/// Streams auth state changes (sign in / sign out / token refresh).
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});
