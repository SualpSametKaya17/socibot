/// Centralized route path constants for GoRouter.
///
/// Kept as plain strings (not an enum) so GoRouter's path-based matching
/// stays straightforward. Extend this as each feature's routes land.
class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Application shell destinations (AŞAMA 3+).
  static const String dashboard = '/dashboard';
  static const String inbox = '/inbox';
  static const String contacts = '/contacts';
  static const String channels = '/channels';
  static const String settings = '/settings';
}
