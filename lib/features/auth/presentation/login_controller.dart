import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_providers.dart';
import '../domain/mock_auth_session.dart';

class LoginController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();

    // Temporary debug-only shortcut: the demo credentials sign in without
    // a real Supabase project — see [mockAuthActive]'s doc comment.
    if (kDebugMode && email == mockDemoEmail && password == mockDemoPassword) {
      mockAuthActive.value = true;
      state = const AsyncData(null);
      return;
    }

    state = await AsyncValue.guard(() {
      return ref
          .read(authRepositoryProvider)
          .signInWithPassword(email: email, password: password);
    });
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);
