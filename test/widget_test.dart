// Smoke test verifying the app shell (theme + router + Riverpod) boots.
//
// Supabase is not initialized here since the widget tree under test never
// reads the Supabase client provider directly.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:socibot/app/app.dart';

void main() {
  testWidgets('App boots and shows the bootstrap placeholder screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: SocibotApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Socibot'), findsOneWidget);
    expect(find.text('Architecture setup complete.'), findsOneWidget);
  });
}
