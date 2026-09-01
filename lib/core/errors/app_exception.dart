/// Common application-level failure model.
///
/// UI code should catch/convert to one of these instead of showing a raw
/// exception to the user. Each variant carries a short [message] safe to
/// display and an optional [cause] for logging.
sealed class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class NetworkFailure extends AppException {
  const NetworkFailure([
    super.message = 'Network connection failed. Please check your connection.',
    super.cause,
  ]);
}

class AuthenticationFailure extends AppException {
  const AuthenticationFailure([
    super.message = 'Authentication failed. Please sign in again.',
    super.cause,
  ]);
}

class PermissionFailure extends AppException {
  const PermissionFailure([
    super.message = 'You do not have permission to perform this action.',
    super.cause,
  ]);
}

class ValidationFailure extends AppException {
  const ValidationFailure([
    super.message = 'The provided data is invalid.',
    super.cause,
  ]);
}

class ProviderFailure extends AppException {
  const ProviderFailure([
    super.message = 'The messaging provider returned an error.',
    super.cause,
  ]);
}

class UnknownFailure extends AppException {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
    super.cause,
  ]);
}
