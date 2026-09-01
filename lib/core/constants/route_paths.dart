/// Centralized route path constants for GoRouter.
///
/// Kept as plain strings (not an enum) so GoRouter's path-based matching
/// stays straightforward. Extend this as each feature's routes land.
class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';

  // Reserved for upcoming stages (AŞAMA 1+). Not wired into the router yet.
  static const String login = '/login';
  static const String home = '/home';
}
