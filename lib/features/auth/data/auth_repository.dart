import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/app_exception.dart';

/// Wraps Supabase Auth so the rest of the app never touches
/// `supabase_flutter` directly and always deals with [AppException].
class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthenticationFailure(e.message, e);
    } catch (e) {
      throw NetworkFailure(
        'Could not sign in. Please check your connection.',
        e,
      );
    }
  }

  /// Returns `true` when the new account is signed in immediately, and
  /// `false` when Supabase requires email confirmation first.
  Future<bool> signUp({required String email, required String password}) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response.session != null;
    } on AuthException catch (e) {
      throw AuthenticationFailure(e.message, e);
    } catch (e) {
      throw NetworkFailure(
        'Could not create account. Please check your connection.',
        e,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthenticationFailure(e.message, e);
    } catch (e) {
      throw NetworkFailure(
        'Could not sign out. Please check your connection.',
        e,
      );
    }
  }
}
