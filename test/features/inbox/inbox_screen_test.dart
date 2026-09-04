import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/core/widgets/conversation_tile.dart';
import 'package:socibot/features/conversations/domain/conversation_providers.dart';
import 'package:socibot/features/conversations/domain/conversation_status.dart';
import 'package:socibot/features/inbox/presentation/inbox_screen.dart';
import 'package:socibot/features/inbox/presentation/widgets/channel_rail.dart';

void main() {
  setUpAll(() {
    // Use the locally-bundled Inter weights instead of hitting the
    // network — same as production (see main.dart).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

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
      // Search input is debounced (300ms) — a bigger pump step than the
      // default 100ms reliably clears it in one pass.
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      expect(find.text('Elena Martinez'), findsOneWidget);
      expect(find.text('Marcus Chen'), findsNothing);
    });

    testWidgets('no results shows the empty state', (tester) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nobody matches this');
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      expect(find.text('No conversations found'), findsOneWidget);
    });

    testWidgets('Clear filters on the empty state restores the full list', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(400, 800));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nobody matches this');
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      expect(find.text('No conversations found'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      expect(find.text('No conversations found'), findsNothing);
      expect(find.text('Elena Martinez'), findsOneWidget);
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
      // The header's real Assign chip watches organizationMembersProvider,
      // a sequential Future.delayed chain (currentOrganizationProvider's
      // own fetch, then fetchMembers) — nothing animates while it's
      // pending, so pumpAndSettle can return before it resolves. One more
      // pump past the combined ~800ms delay flushes it.
      await tester.pump(const Duration(milliseconds: 900));

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
      // A newly-laid-out list row can start its own FadeSlideIn entrance
      // timer on pumpAndSettle's very last frame, after which nothing
      // else is scheduled — pumpAndSettle stops without that short timer
      // ever getting to fire. One more pump past its longest possible
      // delay (200ms) flushes it.
      await tester.pump(const Duration(milliseconds: 250));

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
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Marcus Chen'), findsOneWidget);
    });

    testWidgets('Load more reveals the rest of the conversation list', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      // The mock dataset has 10 conversations; the first page shows 6.
      expect(find.byType(ConversationTile), findsNWidgets(6));
      expect(find.text('Load more (4)'), findsOneWidget);

      await tester.tap(find.text('Load more (4)'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 250));

      // The list is virtualized (not every one of the 10 rows is built
      // while off-screen), so assert growth + the button's gone rather
      // than an exact on-screen widget count.
      expect(find.byType(ConversationTile), findsAtLeastNWidgets(7));
      expect(find.text('Load more (4)'), findsNothing);
    });

    testWidgets('composer send button enables once text is entered', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      // See the "shows the channel rail..." test's comment — flushes the
      // header's organizationMembersProvider chain.
      await tester.pump(const Duration(milliseconds: 900));

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

    testWidgets('Enter sends the message (default enter-key behavior)', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      // See the "shows the channel rail..." test's comment — flushes the
      // header's organizationMembersProvider chain.
      await tester.pump(const Duration(milliseconds: 900));

      final composerField = find.widgetWithText(
        TextField,
        'Type a message or type "/" to use template...',
      );
      await tester.tap(composerField);
      await tester.enterText(composerField, 'Sent via Enter');
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Sent via Enter'), findsOneWidget);
      expect(tester.widget<TextField>(composerField).controller!.text, isEmpty);
    });

    testWidgets('Shift+Enter inserts a newline instead of sending', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      // See the "shows the channel rail..." test's comment — flushes the
      // header's organizationMembersProvider chain.
      await tester.pump(const Duration(milliseconds: 900));

      final composerField = find.widgetWithText(
        TextField,
        'Type a message or type "/" to use template...',
      );
      await tester.tap(composerField);
      await tester.enterText(composerField, 'Line one');
      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();

      // Not sent — the text (now with a newline) is still in the field.
      final controllerText = tester
          .widget<TextField>(composerField)
          .controller!
          .text;
      expect(controllerText, contains('Line one'));
      expect(controllerText, contains('\n'));
    });

    testWidgets('customer detail panel shows the selected contact', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      expect(find.text('No conversation selected'), findsOneWidget);

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      // See the "shows the channel rail..." test's comment — flushes the
      // header's organizationMembersProvider chain.
      await tester.pump(const Duration(milliseconds: 900));

      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('elena.martinez@example.com'), findsOneWidget);
      expect(find.text('Conversation room details'), findsOneWidget);
    });

    testWidgets('Resolving a conversation updates its status and toasts', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 900));

      await tester.tap(find.byTooltip('Resolve (E)'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuItem<ConversationStatus> &&
              widget.value == ConversationStatus.resolved,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Conversation resolved'), findsOneWidget);
      // The header now offers "Reopen" instead.
      expect(find.byTooltip('Reopen (E)'), findsOneWidget);
    });

    testWidgets('Assigning a conversation via the header toasts and updates', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 900));

      await tester.tap(find.byTooltip('Assign'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuItem<String?> && widget.value == 'Sofia Reyes',
        ),
      );
      await tester.pumpAndSettle();

      // "Assigned to Sofia Reyes" now shows in more than one honest place
      // at once (the toast, the list tile, the thread's system message) —
      // assert at least the toast + one other surface rather than pinning
      // an exact count that depends on incidental UI elsewhere.
      expect(find.text('Assigned to Sofia Reyes'), findsAtLeastNWidgets(2));
    });

    testWidgets(
      'J/K move the selection through the visible conversation list',
      (tester) async {
        await pumpInbox(tester, size: const Size(1400, 900));
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(InboxScreen)),
        );
        expect(container.read(selectedConversationIdProvider), isNull);

        await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
        await tester.pump();
        final firstId = container.read(selectedConversationIdProvider);
        expect(firstId, isNotNull);
        // Selecting a conversation renders the header's real Assign chip,
        // which watches organizationMembersProvider — see the "shows the
        // channel rail..." test's comment for why this needs an explicit
        // flush before the widget tree is torn down at test end.
        await tester.pump(const Duration(milliseconds: 900));

        await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
        await tester.pumpAndSettle();
        final secondId = container.read(selectedConversationIdProvider);
        expect(secondId, isNotNull);
        expect(secondId, isNot(firstId));

        await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
        await tester.pumpAndSettle();
        expect(container.read(selectedConversationIdProvider), firstId);
      },
    );

    testWidgets('Typing "j" in the search field does not trigger navigation', (
      tester,
    ) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(InboxScreen)),
      );

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
      await tester.pump();

      // The shortcut never fired — the keystroke stayed inside the field.
      expect(container.read(selectedConversationIdProvider), isNull);
    });

    testWidgets('E resolves the open conversation', (tester) async {
      await pumpInbox(tester, size: const Size(1400, 900));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elena Martinez'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 900));

      await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
      await tester.pumpAndSettle();

      expect(find.text('Conversation resolved'), findsOneWidget);
      expect(find.byTooltip('Reopen (E)'), findsOneWidget);
    });
  });
}
