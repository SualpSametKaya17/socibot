import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socibot/features/inbox/presentation/inbox_screen.dart';

void main() {
  Widget wrap(Widget child, {required Size size}) {
    return ProviderScope(
      child: MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
  }

  group('InboxScreen (mobile)', () {
    testWidgets('lists all mock conversations by default', (tester) async {
      await tester.pumpWidget(wrap(const InboxScreen(), size: const Size(400, 800)));
      await tester.pumpAndSettle();

      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsOneWidget);
      expect(find.text('Priya Nair'), findsOneWidget);
    });

    testWidgets('search narrows the list to matching contacts', (tester) async {
      await tester.pumpWidget(wrap(const InboxScreen(), size: const Size(400, 800)));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Elena');
      await tester.pumpAndSettle();

      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing);
    });

    testWidgets('status filter chip narrows the list', (tester) async {
      await tester.pumpWidget(wrap(const InboxScreen(), size: const Size(400, 800)));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Resolved'));
      await tester.pumpAndSettle();

      // Only Diego and James are resolved in the mock data.
      expect(find.text('Diego Fernandez'), findsOneWidget);
      expect(find.text('Elena Martinez'), findsNothing);
    });

    testWidgets('no results shows the empty state', (tester) async {
      await tester.pumpWidget(wrap(const InboxScreen(), size: const Size(400, 800)));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nobody matches this');
      await tester.pumpAndSettle();

      expect(find.text('No conversations found'), findsOneWidget);
    });
  });

  group('InboxScreen (desktop)', () {
    testWidgets('shows list and detail panes side by side', (tester) async {
      await tester.pumpWidget(wrap(const InboxScreen(), size: const Size(1280, 800)));
      await tester.pumpAndSettle();

      expect(find.text('Select a conversation'), findsOneWidget);

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      expect(find.text('Select a conversation'), findsNothing);
      // Contact name now appears twice: once in the list tile, once in
      // the detail pane header.
      expect(find.text('Elena Martinez'), findsNWidgets(2));
    });
  });
}
