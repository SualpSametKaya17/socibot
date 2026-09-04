import 'package:flutter/material.dart';

import '../../../app/theme/app_breakpoints.dart';
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
/// desktop (>=900px total app width): [ChannelRail] | [ConversationListPanel] | [ConversationWorkspace] | [CustomerDetailPanel] once there's room (>=[AppBreakpoints.smallDesktop]), otherwise customer detail moves into a drawer
/// tablet: [ConversationListPanel] | [ConversationWorkspace] (customer detail in a drawer)
/// mobile: [ConversationListPanel] only; selecting a conversation pushes
/// [ConversationWorkspace] full-screen (customer detail in a drawer there too).
///
/// [ChannelRail] (a slim 52px icon strip) stays visible across the whole
/// desktop band rather than collapsing at some narrower width — unlike
/// [CustomerDetailPanel], it has no drawer fallback, so hiding it would
/// make channel filtering unreachable, not just less convenient.
///
/// At every width, customer details stay reachable — either permanently
/// on screen or one tap away via [ConversationWorkspaceHeader]'s info
/// button — never silently dropped just because the panel didn't fit.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => ConversationListPanel(
        onSelect: (_) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              endDrawer: const _CustomerDetailDrawer(),
              body: SafeArea(
                child: Builder(
                  builder: (context) => ConversationWorkspace(
                    compact: true,
                    onClose: () => Navigator.of(context).pop(),
                    onOpenDetails: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      tablet: (context) => Scaffold(
        endDrawer: const _CustomerDetailDrawer(),
        body: Builder(
          builder: (context) => Row(
            children: [
              const SizedBox(width: 280, child: ConversationListPanel()),
              const _VerticalBorder(),
              Expanded(
                child: ConversationWorkspace(
                  onOpenDetails: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ],
          ),
        ),
      ),
      desktop: (context) {
        // Total application width, not this screen's local share of it —
        // consistent with how [ResponsiveLayout] itself decides.
        final totalWidth = MediaQuery.sizeOf(context).width;
        final showCustomerPanel = totalWidth >= AppBreakpoints.smallDesktop;

        final listAndWorkspace = <Widget>[
          const SizedBox(width: 52, child: ChannelRail()),
          const _VerticalBorder(),
          const SizedBox(width: 310, child: ConversationListPanel()),
          const _VerticalBorder(),
        ];

        if (showCustomerPanel) {
          return Row(
            children: [
              ...listAndWorkspace,
              const Expanded(child: ConversationWorkspace()),
              const _VerticalBorder(),
              const SizedBox(width: 252, child: CustomerDetailPanel()),
            ],
          );
        }

        // Small desktop (900-1199px total): a permanent 252px customer
        // panel plus the 310px list would leave the conversation column
        // too narrow to be usable, so customer details move into a
        // drawer instead of disappearing outright.
        return Scaffold(
          endDrawer: const _CustomerDetailDrawer(),
          body: Builder(
            builder: (context) => Row(
              children: [
                ...listAndWorkspace,
                Expanded(
                  child: ConversationWorkspace(
                    onOpenDetails: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CustomerDetailDrawer extends StatelessWidget {
  const _CustomerDetailDrawer();

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      width: 320,
      child: SafeArea(child: CustomerDetailPanel()),
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
