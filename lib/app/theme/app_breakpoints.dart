/// Width breakpoints shared by every screen that adapts its layout.
/// Priority order per the product brief: Desktop > Web > Tablet > Mobile.
///
/// [mobile] and [tablet] are the two thresholds [ResponsiveLayout] itself
/// switches on and are load-bearing across the app — don't change them.
/// The rest subdivide the `>= tablet` "desktop" band further for screens
/// (like Inbox) that need finer control than mobile/tablet/desktop, e.g.
/// deciding when a secondary panel earns permanent screen space versus
/// living in a drawer.
class AppBreakpoints {
  const AppBreakpoints._();

  static const double smallMobile = 360;
  static const double mobile = 600;
  static const double tablet = 900;
  static const double smallDesktop = 1200;
  static const double largeDesktop = 1600;
}
