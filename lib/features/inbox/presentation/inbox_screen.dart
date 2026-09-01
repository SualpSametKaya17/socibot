import 'package:flutter/material.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../core/widgets/responsive_layout.dart';
import 'widgets/channel_rail.dart';
import 'widgets/conversation_list_panel.dart';
import 'widgets/conversation_workspace.dart';
import 'widgets/customer_detail_panel.dart';

/// The Inbox screen. Composes four of the layout's five regions (the
/// fifth, the app's own main application sidebar, is [AppShell] —
/// outside this feature's scope):
///
/// wide desktop (>=1350px total app width): [ChannelRail] | [ConversationListPanel] | [ConversationWorkspace] | [CustomerDetailPanel]
/// medium desktop: [ConversationListPanel] | [ConversationWorkspace] | [CustomerDetailPanel] (channel rail collapses)
/// tablet: [ConversationListPanel] | [ConversationWorkspace] (customer detail hidden too)
/// mobile: [ConversationListPanel] only; selecting a conversation pushes
/// [ConversationWorkspace] full-screen.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  static const _wideDesktopWidth = 1350.0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => ConversationListPanel(
        onSelect: (_) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: SafeArea(
                child: ConversationWorkspace(
                  compact: true,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ),
      ),
      tablet: (context) => const Row(
        children: [
          SizedBox(width: 320, child: ConversationListPanel()),
          _VerticalBorder(),
          Expanded(child: ConversationWorkspace()),
        ],
      ),
      desktop: (context) {
        // Total application width, not this screen's local share of it —
        // consistent with how [ResponsiveLayout] itself decides.
        final isWide = MediaQuery.sizeOf(context).width >= _wideDesktopWidth;
        return Row(
          children: [
            if (isWide) ...[
              const SizedBox(width: 52, child: ChannelRail()),
              const _VerticalBorder(),
            ],
            const SizedBox(width: 310, child: ConversationListPanel()),
            const _VerticalBorder(),
            const Expanded(child: ConversationWorkspace()),
            const _VerticalBorder(),
            const SizedBox(width: 252, child: CustomerDetailPanel()),
          ],
        );
      },
    );
  }
}

class _VerticalBorder extends StatelessWidget {
  const _VerticalBorder();

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(width: 1, color: context.colors.border);
  }
}
