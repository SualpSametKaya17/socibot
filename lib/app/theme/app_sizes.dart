/// Fixed sizes reused across the shell and form controls, pulled out of
/// individual widgets so there's one place to retune the shell's density.
class AppSizes {
  const AppSizes._();

  /// Extended-mode width (mobile drawer, which has room for labels).
  static const double sidebarWidth = 232;

  /// The global nav rail's fixed icon-only width on desktop/tablet.
  static const double navRailWidth = 60;

  static const double topBarHeight = 60;

  static const double controlHeight = 44;
  static const double borderWidth = 1;
  static const double borderWidthFocused = 1.5;

  static const double avatarSm = 14;
  static const double avatarMd = 16;
  static const double avatarLg = 28;

  static const double iconSm = 16;
  static const double iconMd = 20;
}
