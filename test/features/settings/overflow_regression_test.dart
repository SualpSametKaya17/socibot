import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socibot/app/theme/app_theme.dart';
import 'package:socibot/core/constants/channel_type.dart';
import 'package:socibot/features/conversations/domain/conversation.dart';
import 'package:socibot/features/conversations/domain/conversation_status.dart';
import 'package:socibot/features/inbox/presentation/widgets/conversation_workspace_header.dart';
import 'package:socibot/features/organization/domain/organization_member.dart';
import 'package:socibot/features/organization/domain/organization_providers.dart';
import 'package:socibot/features/organization/domain/organization_role.dart';
import 'package:socibot/features/settings/presentation/widgets/team_member_row.dart';

/// Regression tests for two overflow bugs found in a responsive audit:
/// a long email in the mobile Team row, and a long assigned-member name
/// in the Inbox header's Assign chip. Both used to have no
/// overflow/maxLines guard, which throws a RenderFlex overflow error
/// once real (non-mock-short) data is used.
void main() {
  setUpAll(() {
    // Use the locally-bundled Inter weights instead of hitting the
    // network — same as production (see main.dart).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('TeamMemberMobileRow does not overflow with a long email', (
    tester,
  ) async {
    final member = OrganizationMember(
      id: 'm1',
      organizationId: 'org1',
      userId: 'u1',
      role: OrganizationRole.member,
      displayName: 'Alexandra Christodoulopoulos',
      email:
          'alexandra.christodoulopoulos.support@some-long-domain.example.com',
      joinedAt: DateTime(2026),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: TeamMemberMobileRow(member: member),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    final emailText = tester.widget<Text>(
      find.text(member.email!, findRichText: false),
    );
    expect(
      emailText.maxLines,
      1,
      reason: 'a long email must be capped to one line, not wrap freely',
    );
    expect(emailText.overflow, TextOverflow.ellipsis);
  });

  testWidgets(
    'Assign chip does not overflow the header with a long agent name',
    (tester) async {
      final conversation = Conversation(
        id: 'c1',
        contactName: 'Jordan Lee',
        channel: ChannelType.whatsapp,
        status: ConversationStatus.open,
        assignedAgentName: 'Alexandra Christodoulopoulos',
      );
      final longNameMember = OrganizationMember(
        id: 'm1',
        organizationId: 'org1',
        userId: 'u1',
        role: OrganizationRole.member,
        displayName: 'Alexandra Christodoulopoulos',
        joinedAt: DateTime(2026),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            organizationMembersProvider.overrideWith(
              (ref) async => [longNameMember],
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: SizedBox(
                width: 700,
                child: ConversationWorkspaceHeader(
                  conversation: conversation,
                  onClose: () {},
                  searching: false,
                  onToggleSearch: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Alexandra'), findsOneWidget);
    },
  );
}
