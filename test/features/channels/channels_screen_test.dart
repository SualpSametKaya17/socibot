import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/core/constants/channel_type.dart';
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

  // The mock dataset also seeds Instagram as an errored (not connected)
  // channel, so "Connect" appears on more than one card — scope every
  // interaction to Messenger's own card rather than assuming there's only
  // one match on screen.
  Finder messengerConnectButton() => find.descendant(
    of: find.byWidgetPredicate(
      (widget) =>
          widget is ChannelCard && widget.channel.type == ChannelType.facebook,
    ),
    matching: find.widgetWithText(OutlinedButton, 'Connect'),
  );

  testWidgets('Connecting a disconnected channel updates its card', (
    tester,
  ) async {
    await pumpChannels(tester);

    // Messenger starts disconnected in the mock data.
    expect(find.text('Not connected yet'), findsOneWidget);

    await tester.tap(messengerConnectButton());
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

    await tester.tap(messengerConnectButton());
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

    await tester.tap(find.widgetWithText(OutlinedButton, 'Disconnect').first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Disconnect'));
    await tester.pumpAndSettle();

    expect(find.text('Socibot Support (+1 415 555 0100)'), findsNothing);
  });
}
