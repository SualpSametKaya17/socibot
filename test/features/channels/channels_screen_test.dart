import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/core/constants/channel_type.dart';
import 'package:socibot/core/widgets/app_toggle.dart';
import 'package:socibot/features/channels/presentation/channels_screen.dart';
import 'package:socibot/features/channels/presentation/widgets/channel_card.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpChannels(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ChannelsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Each channel's on/off state lives in a single AppToggle now — scope
  // every interaction to one channel's own card rather than assuming
  // there's only one toggle on screen.
  Finder channelToggle(ChannelType type) => find.descendant(
    of: find.byWidgetPredicate(
      (widget) => widget is ChannelCard && widget.channel.type == type,
    ),
    matching: find.byType(AppToggle),
  );

  testWidgets('Connecting a disconnected channel updates its card', (
    tester,
  ) async {
    await pumpChannels(tester);

    // Messenger starts disconnected in the mock data.
    expect(find.text('Not connected yet'), findsOneWidget);

    await tester.tap(channelToggle(ChannelType.facebook));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Socibot Page');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Connect'));
    await tester.pumpAndSettle();

    expect(find.text('Socibot Page'), findsOneWidget);
    expect(find.text('Not connected yet'), findsNothing);
  });

  testWidgets('Connect dialog requires a non-empty account name', (
    tester,
  ) async {
    await pumpChannels(tester);

    await tester.tap(channelToggle(ChannelType.facebook));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Connect'));
    await tester.pumpAndSettle();

    // Dialog stays open with a validation error instead of closing.
    expect(find.text('Enter an account name'), findsOneWidget);
  });

  testWidgets('Disconnecting a connected channel clears its account', (
    tester,
  ) async {
    await pumpChannels(tester);

    // WhatsApp starts connected in the mock data.
    expect(find.text('Socibot Support (+1 415 555 0100)'), findsOneWidget);

    await tester.tap(channelToggle(ChannelType.whatsapp));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Disconnect'));
    await tester.pumpAndSettle();

    expect(find.text('Socibot Support (+1 415 555 0100)'), findsNothing);
  });

  testWidgets('Details dialog shows the connected channel\'s info', (
    tester,
  ) async {
    await pumpChannels(tester);

    await tester.tap(
      find.descendant(
        of: find.byWidgetPredicate(
          (widget) =>
              widget is ChannelCard &&
              widget.channel.type == ChannelType.whatsapp,
        ),
        matching: find.widgetWithText(OutlinedButton, 'Details'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('WhatsApp details'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Socibot Support (+1 415 555 0100)'),
      ),
      findsOneWidget,
    );
  });
}
