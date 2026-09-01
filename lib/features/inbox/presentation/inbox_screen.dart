import 'package:flutter/material.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../core/widgets/responsive_layout.dart';
import 'widgets/conversation_list_panel.dart';
import 'widgets/conversation_workspace.dart';
import 'widgets/inbox_filter_sidebar.dart';

/// The Inbox screen. Composes three of the layout's four regions (the
/// fourth, the app's own navigation rail, is [AppShell] — outside this
/// feature's scope):
///
/// desktop: [InboxFilterSidebar] | [ConversationListPanel] | [ConversationWorkspace]
/// large tablet: [ConversationListPanel] | [ConversationWorkspace] (filter sidebar folds away)
/// mobile: [ConversationListPanel] only; selecting a conversation pushes
/// [ConversationWorkspace] full-screen.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

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
      desktop: (context) => const Row(
        children: [
          SizedBox(width: 172, child: InboxFilterSidebar()),
          _VerticalBorder(),
          SizedBox(width: 320, child: ConversationListPanel()),
          _VerticalBorder(),
          Expanded(child: ConversationWorkspace()),
        ],
      ),
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
