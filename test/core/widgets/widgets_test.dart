import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/core/widgets/app_avatar.dart';
import 'package:socibot/core/widgets/responsive_layout.dart';

void main() {
  setUpAll(() {
    // Use the locally-bundled Inter weights instead of hitting the
    // network — same as production (see main.dart).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppAvatar', () {
    testWidgets('shows initials from a two-word name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const AppAvatar(name: 'Ada Lovelace'),
        ),
      );

      expect(find.text('AL'), findsOneWidget);
    });

    testWidgets('shows a single initial for a one-word name/email', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const AppAvatar(name: 'ada@example.com'),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });
  });

  group('ResponsiveLayout', () {
    // Sets the real test viewport (not just the MediaQuery data) so it
    // matches what ResponsiveLayout's own width read sees.
    Future<void> setViewportSize(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('renders the mobile builder below the desktop breakpoint', (
      tester,
    ) async {
      await setViewportSize(tester, const Size(500, 800));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: ResponsiveLayout(
            mobile: (_) => const Text('mobile'),
            desktop: (_) => const Text('desktop'),
          ),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('renders the desktop builder at/above the breakpoint', (
      tester,
    ) async {
      await setViewportSize(tester, const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: ResponsiveLayout(
            mobile: (_) => const Text('mobile'),
            desktop: (_) => const Text('desktop'),
          ),
        ),
      );

      expect(find.text('desktop'), findsOneWidget);
      expect(find.text('mobile'), findsNothing);
    });
  });
}
