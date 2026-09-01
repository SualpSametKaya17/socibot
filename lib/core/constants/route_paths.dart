/// Centralized route path constants for GoRouter.
///
/// Kept as plain strings (not an enum) so GoRouter's path-based matching
/// stays straightforward. Extend this as each feature's routes land.
class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}
