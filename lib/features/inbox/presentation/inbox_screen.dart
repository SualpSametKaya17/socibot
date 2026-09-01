import 'package:flutter/material.dart';

import '../../../core/widgets/responsive_layout.dart';
import 'widgets/conversation_detail_placeholder.dart';
import 'widgets/conversation_list_pane.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => const ConversationListPane(),
      desktop: (context) => const Row(
        children: [
          SizedBox(width: 360, child: ConversationListPane()),
          VerticalDivider(width: 1),
          Expanded(child: ConversationDetailPlaceholder()),
        ],
      ),
    );
  }
}
