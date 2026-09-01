import 'package:flutter/material.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/responsive_layout.dart';
import 'widgets/contact_detail_pane.dart';
import 'widgets/contact_list_panel.dart';

/// The Contacts screen — same list+detail paradigm as Inbox.
class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => ContactListPanel(
        onSelect: (_) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              appBar: AppTopBar(title: const Text('Contact')),
              body: const ContactDetailPane(),
            ),
          ),
        ),
      ),
      desktop: (context) => Row(
        children: [
          const SizedBox(width: 340, child: ContactListPanel()),
          VerticalDivider(width: 1, color: context.colors.border),
          const Expanded(child: ContactDetailPane()),
        ],
      ),
    );
  }
}
