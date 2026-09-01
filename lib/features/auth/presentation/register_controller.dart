import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_providers.dart';

/// Result of a successful submission: whether the account is signed in
/// immediately or is waiting on email confirmation.
class RegisterResult {
  const RegisterResult({required this.signedIn});

  final bool signedIn;
}

class RegisterController extends AsyncNotifier<RegisterResult?> {
  @override
  FutureOr<RegisterResult?> build() => null;

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final signedIn = await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password);
      return RegisterResult(signedIn: signedIn);
    });
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, RegisterResult?>(
      RegisterController.new,
    );
