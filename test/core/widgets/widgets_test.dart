import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socibot/core/widgets/app_avatar.dart';
import 'package:socibot/core/widgets/responsive_layout.dart';

void main() {
  group('AppAvatar', () {
    testWidgets('shows initials from a two-word name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AppAvatar(name: 'Ada Lovelace')),
      );

      expect(find.text('AL'), findsOneWidget);
    });

    testWidgets('shows a single initial for a one-word name/email', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: AppAvatar(name: 'ada@example.com')),
      );

      expect(find.text('A'), findsOneWidget);
    });
  });

  group('ResponsiveLayout', () {
    testWidgets('renders the mobile builder below the desktop breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 800)),
          child: MaterialApp(
            home: ResponsiveLayout(
              mobile: (_) => const Text('mobile'),
              desktop: (_) => const Text('desktop'),
            ),
          ),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('renders the desktop builder at/above the breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: MaterialApp(
            home: ResponsiveLayout(
              mobile: (_) => const Text('mobile'),
              desktop: (_) => const Text('desktop'),
            ),
          ),
        ),
      );

      expect(find.text('desktop'), findsOneWidget);
      expect(find.text('mobile'), findsNothing);
    });
  });
}
