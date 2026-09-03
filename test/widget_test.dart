// Smoke test verifying the app shell (theme + router + Riverpod + Supabase
// auth guard) boots and lands on the login screen when signed out.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:socibot/app/app.dart';
import 'package:socibot/features/auth/domain/mock_auth_session.dart';
import 'package:socibot/features/settings/domain/settings_preferences.dart';

void main() {
  setUpAll(() async {
    // Use the locally-bundled Inter weights instead of hitting the
    // network — same as production (see main.dart).
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-anon-key',
    );
  });

  testWidgets('Signed-out user is redirected to the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SocibotApp()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in to your Socibot workspace'), findsOneWidget);
  });

  testWidgets('Demo credentials sign in without a real Supabase session', (
    WidgetTester tester,
  ) async {
    addTearDown(() => mockAuthActive.value = false);

    await tester.pumpWidget(const ProviderScope(child: SocibotApp()));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), mockDemoEmail);
    await tester.enterText(fields.at(1), mockDemoPassword);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(mockAuthActive.value, isTrue);
    expect(find.text('Recent conversations'), findsOneWidget);
    expect(find.text('Sign in to your Socibot workspace'), findsNothing);
  });

  testWidgets(
    'Workspace theme preference (Dark) switches the app to dark mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            savedWorkspaceDraftProvider.overrideWith(
              (ref) => const WorkspaceDraft(theme: ThemePreference.dark),
            ),
          ],
          child: const SocibotApp(),
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Scaffold).first);
      expect(Theme.of(context).brightness, Brightness.dark);
    },
  );
}
