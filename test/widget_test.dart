// Smoke test verifying the app shell (theme + router + Riverpod + Supabase
// auth guard) boots and lands on the login screen when signed out.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:socibot/app/app.dart';

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
}
