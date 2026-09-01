import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/features/inbox/presentation/inbox_screen.dart';
import 'package:socibot/features/inbox/presentation/widgets/channel_rail.dart';

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

      // Search starts collapsed behind the search icon.
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Elena');
      await tester.pumpAndSettle();

      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing);
    });

    testWidgets('no results shows the empty state', (tester) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
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
    testWidgets('shows the channel rail, list, workspace and customer panel', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      expect(find.text('Select a conversation'), findsOneWidget);
      expect(find.byType(ChannelRail), findsOneWidget);
      expect(find.text('All Channel'), findsOneWidget);

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      expect(find.text('Select a conversation'), findsNothing);
      // Contact name now appears three times: the list tile, the
      // workspace header, and the customer detail panel's profile card.
      expect(find.text('Elena Martinez'), findsNWidgets(3));
    });

    testWidgets('status tab narrows the list', (tester) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('inbox-status-tabs')),
          matching: find.text('Resolved'),
        ),
      );
      await tester.pumpAndSettle();

      // Only Diego and James are resolved in the mock data.
      expect(find.text('Diego Fernandez'), findsOneWidget);
      expect(find.text('Elena Martinez'), findsNothing);
    });

    testWidgets('assignment dropdown narrows the list to the current agent', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('inbox-assign-dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Assign to me'));
      await tester.pumpAndSettle();

      // Elena Martinez is assigned to the mock current agent ("You").
      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing); // unassigned
    });

    testWidgets(
      'unreplied-only toggle keeps only conversations awaiting a reply',
      (tester) async {
        await pumpInbox(tester, size: const Size(1400, 900));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Show unreplied only'));
        await tester.pumpAndSettle();

        // Elena's last message is incoming (unreplied); Diego's last
        // message is the agent's outgoing closing reply.
        expect(find.text('Elena Martinez'), findsOneWidget);
        expect(find.text('Diego Fernandez'), findsNothing);
      },
    );

    testWidgets('small desktop widths move the customer panel into a drawer', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1000, 800));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      // No permanently-visible customer detail panel at this width —
      // the contact name appears only in the list tile and header.
      expect(find.text('Elena Martinez'), findsNWidgets(2));
      expect(find.text('Contact Information'), findsNothing);

      await tester.tap(find.byTooltip('View customer details'));
      // A larger step than the default 100ms so this reliably clears the
      // repositories' simulated network latency in one pass — pumpAndSettle
      // stops as soon as a step produces no new scheduled frame, which a
      // still-pending `Future.delayed` timer wouldn't necessarily cause.
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Contact Information'), findsOneWidget);
    });

    testWidgets('channel rail narrows the list by channel', (tester) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(ChannelRail),
          matching: find.byTooltip('WhatsApp'),
        ),
      );
      await tester.pumpAndSettle();

      // Elena Martinez is WhatsApp; Marcus Chen is Instagram.
      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing);

      // Tapping the same channel again clears the filter.
      await tester.tap(
        find.descendant(
          of: find.byType(ChannelRail),
          matching: find.byTooltip('WhatsApp'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Marcus Chen'), findsOneWidget);
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
        find.widgetWithText(
          TextField,
          'Type a message or type "/" to use template...',
        ),
        'Thanks for reaching out!',
      );
      await tester.pump();

      expect(tester.widget<IconButton>(sendButtonFinder).onPressed, isNotNull);

      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Thanks for reaching out!'), findsOneWidget);
    });

    testWidgets('customer detail panel shows the selected contact', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      expect(find.text('No conversation selected'), findsOneWidget);

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();

      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('elena.martinez@example.com'), findsOneWidget);
      expect(find.text('Conversation room details'), findsOneWidget);
    });
  });
}
