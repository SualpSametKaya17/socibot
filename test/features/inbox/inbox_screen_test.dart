import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/features/inbox/presentation/inbox_screen.dart';
import 'package:socibot/features/inbox/presentation/widgets/inbox_filter_sidebar.dart';

void main() {
  // Sets the *real* test viewport (not just the MediaQuery data a widget
  // reads) so ResponsiveLayout's branch and the actual render constraints
  // agree — a bare `MediaQuery(data: ...)` override only fakes the
  // former, which silently breaks any layout with real fixed-width
  // content (icon rows, badges) once the two disagree.
  Future<void> pumpInbox(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: InboxScreen()),
        ),
      ),
    );
  }

  group('InboxScreen (mobile)', () {
    testWidgets('lists all mock conversations by default', (tester) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsOneWidget);
      expect(find.text('Priya Nair'), findsOneWidget);
    });

    testWidgets('search narrows the list to matching contacts', (tester) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Elena');
      await tester.pumpAndSettle();

      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing);
    });

    testWidgets('no results shows the empty state', (tester) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nobody matches this');
      await tester.pumpAndSettle();

      expect(find.text('No conversations found'), findsOneWidget);
    });

    testWidgets('selecting a conversation pushes the workspace full-screen', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      // Pushed full-screen: header shows the contact name again, plus a
      // close button to get back.
      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Is my order #4521 still on the way?'), findsOneWidget);
    });
  });

  group('InboxScreen (desktop)', () {
    testWidgets('shows the filter sidebar, list, and workspace side by side', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      expect(find.text('Select a conversation'), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget); // filter sidebar header
      expect(find.text('Mine'), findsOneWidget);
      expect(find.text('Unassigned'), findsOneWidget);

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      expect(find.text('Select a conversation'), findsNothing);
      // Contact name now appears twice: once in the list tile, once in
      // the workspace header.
      expect(find.text('Elena Martinez'), findsNWidgets(2));
    });

    testWidgets('status filter in the sidebar narrows the list', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(InboxFilterSidebar),
          matching: find.text('Resolved'),
        ),
      );
      await tester.pumpAndSettle();

      // Only Diego and James are resolved in the mock data.
      expect(find.text('Diego Fernandez'), findsOneWidget);
      expect(find.text('Elena Martinez'), findsNothing);
    });

    testWidgets('Mine quick filter narrows the list to the current agent', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mine'));
      await tester.pumpAndSettle();

      // Elena Martinez is assigned to the mock current agent ("You").
      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing); // unassigned
    });

    testWidgets('composer send button enables once text is entered', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      final sendButtonFinder = find.widgetWithIcon(
        IconButton,
        Icons.send_rounded,
      );
      expect(tester.widget<IconButton>(sendButtonFinder).onPressed, isNull);

      await tester.enterText(
        find.widgetWithText(TextField, 'Type a message...'),
        'Thanks for reaching out!',
      );
      await tester.pump();

      expect(tester.widget<IconButton>(sendButtonFinder).onPressed, isNotNull);

      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Thanks for reaching out!'), findsOneWidget);
    });
  });
}
