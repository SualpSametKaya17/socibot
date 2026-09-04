import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/detail_field_row.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../channels/domain/channel_providers.dart';
import '../../../contacts/domain/contact.dart';
import '../../../contacts/domain/contact_providers.dart';
import '../../../conversations/domain/conversation.dart';
import '../../../conversations/domain/conversation_providers.dart';

/// Enterprise software reads as flatter/less-rounded than a consumer
/// mobile card interface — a tighter radius than the shared
/// [AppRadius.lg] used for cards elsewhere, specific to this panel.
const _cardRadius = BorderRadius.all(Radius.circular(8));

/// Region 5: the selected conversation's customer — profile, contact
/// info, who's handling it, tags, and room metadata. Resolves the
/// selected conversation the same way [ConversationWorkspace] does, and
/// looks the [Contact] up by conversation id (mock-convenience
/// relationship, documented on [Contact] itself) rather than fabricating
/// one when no match exists.
class CustomerDetailPanel extends ConsumerStatefulWidget {
  const CustomerDetailPanel({super.key});

  @override
  ConsumerState<CustomerDetailPanel> createState() =>
      _CustomerDetailPanelState();
}

class _CustomerDetailPanelState extends ConsumerState<CustomerDetailPanel> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedId = ref.watch(selectedConversationIdProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(left: BorderSide(color: colors.border)),
      ),
      child: selectedId == null
          ? const EmptyState(
              icon: Icons.person_outline,
              title: 'No conversation selected',
            )
          : ref
                .watch(conversationsProvider)
                .when(
                  loading: () => const _CustomerDetailSkeleton(),
                  error: (error, stackTrace) => EmptyState(
                    icon: Icons.error_outline,
                    title: 'Could not load customer',
                    message: '$error',
                  ),
                  data: (conversations) {
                    final matches = conversations.where(
                      (c) => c.id == selectedId,
                    );
                    if (matches.isEmpty) {
                      return const EmptyState(
                        icon: Icons.person_outline,
                        title: 'No conversation selected',
                      );
                    }
                    return _CustomerDetailContent(
                      conversation: matches.first,
                      tabIndex: _tabIndex,
                      onTabSelected: (index) =>
                          setState(() => _tabIndex = index),
                    );
                  },
                ),
    );
  }
}

/// Shimmer placeholder shaped like [_ProfileCard] + [_DetailCard], shown
/// while [conversationsProvider] is still resolving (rare in practice —
/// reaching this panel already required the list to load — but honest
/// for the brief window it's actually possible).
class _CustomerDetailSkeleton extends StatelessWidget {
  const _CustomerDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Skeletonizer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: _cardRadius,
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  const AppAvatar(name: 'Loading name', radius: 28),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Loading contact name', style: AppTypography.labelLarge),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: _cardRadius,
                border: Border.all(color: colors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailFieldRow(
                    icon: Icons.phone_outlined,
                    label: 'Loading phone number',
                  ),
                  SizedBox(height: AppSpacing.sm),
                  DetailFieldRow(
                    icon: Icons.email_outlined,
                    label: 'Loading email address',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerDetailContent extends ConsumerWidget {
  const _CustomerDetailContent({
    required this.conversation,
    required this.tabIndex,
    required this.onTabSelected,
  });

  final Conversation conversation;
  final int tabIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactByConversationIdProvider(conversation.id));
    final channels = ref.watch(channelsProvider).valueOrNull ?? const [];
    String? channelAccount;
    for (final connection in channels) {
      if (connection.type == conversation.channel) {
        channelAccount = connection.accountName;
        break;
      }
    }

    return Column(
      children: [
        _DetailTabs(selected: tabIndex, onSelected: onTabSelected),
        const Divider(height: 1),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 140),
            child: tabIndex != 0
                ? const _ComingSoonTab(key: ValueKey('coming-soon'))
                : SingleChildScrollView(
                    key: const ValueKey('detail'),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileCard(
                          contact: contact,
                          fallbackName: conversation.contactName,
                          fallbackAvatarUrl: conversation.contactAvatarUrl,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _DetailCard(
                          sections: [
                            _Section(
                              title: 'Contact Information',
                              child: _ContactInformation(contact: contact),
                            ),
                            _Section(
                              title: 'Agent Handled',
                              child: _AgentHandled(
                                agentName: conversation.assignedAgentName,
                                since: conversation.createdAt,
                              ),
                            ),
                            const _Section(
                              title: 'Tags',
                              trailing: _DisabledAddIcon(
                                tooltip: 'Tagging is coming in a later stage',
                              ),
                              child: _EmptySectionNote(text: 'No tags yet'),
                            ),
                            _Section(
                              title: 'Conversation room details',
                              child: _RoomDetails(
                                conversation: conversation,
                                channelAccount: channelAccount,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  static const _tabs = [
    (icon: Icons.info_outline, label: 'Detail'),
    (icon: Icons.people_outline, label: 'Contacts (coming soon)'),
    (icon: Icons.history, label: 'Activity (coming soon)'),
    (icon: Icons.sticky_note_2_outlined, label: 'Notes (coming soon)'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Tooltip(
              message: _tabs[i].label,
              child: InkWell(
                borderRadius: AppRadius.mdAll,
                onTap: () => onSelected(i),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: selected == i ? colors.primarySoft : null,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(
                    _tabs[i].icon,
                    size: 18,
                    color: selected == i ? colors.primary : colors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Coming in a later stage',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.contact,
    required this.fallbackName,
    required this.fallbackAvatarUrl,
  });

  final Contact? contact;
  final String fallbackName;
  final String? fallbackAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = contact?.displayName ?? fallbackName;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: _cardRadius,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Tooltip(
              message: 'More actions — coming in a later stage',
              child: Icon(Icons.more_horiz, size: 18, color: colors.textMuted),
            ),
          ),
          AppAvatar(
            name: name,
            imageUrl: contact?.avatarUrl ?? fallbackAvatarUrl,
            radius: 28,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            name,
            style: AppTypography.labelLarge,
            textAlign: TextAlign.center,
          ),
          if (contact?.company != null) ...[
            const SizedBox(height: 2),
            Text(
              contact!.company!,
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (contact?.location != null) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.place_outlined, size: 12, color: colors.textMuted),
                const SizedBox(width: 2),
                Text(
                  contact!.location!,
                  style: AppTypography.caption.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Plain data for one subsection of [_DetailCard] — kept separate from
/// the widget that renders it so [_DetailCard] can insert its own
/// dividers between sections without each section drawing its own box.
class _Section {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;
}

/// One continuous bordered panel holding every subsection, divided by
/// hairlines instead of each subsection getting its own bordered box —
/// reads as a single coherent detail panel (Linear/Intercom-style)
/// rather than a stack of repeated cards.
class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.sections});

  final List<_Section> sections;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        borderRadius: _cardRadius,
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final section in sections) ...[
            if (section != sections.first)
              Divider(height: 1, color: colors.border),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          section.title,
                          style: AppTypography.caption.copyWith(
                            color: colors.textMuted,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ?section.trailing,
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  section.child,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DisabledAddIcon extends StatelessWidget {
  const _DisabledAddIcon({required this.tooltip});

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Icon(Icons.add, size: 16, color: context.colors.textMuted),
    );
  }
}

class _EmptySectionNote extends StatelessWidget {
  const _EmptySectionNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodySmall.copyWith(color: context.colors.textMuted),
    );
  }
}

class _ContactInformation extends StatelessWidget {
  const _ContactInformation({required this.contact});

  final Contact? contact;

  @override
  Widget build(BuildContext context) {
    if (contact == null || (contact!.email == null && contact!.phone == null)) {
      return const _EmptySectionNote(text: 'No contact info on file');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contact!.phone != null)
          DetailFieldRow(icon: Icons.phone_outlined, label: contact!.phone!),
        if (contact!.phone != null && contact!.email != null)
          const SizedBox(height: AppSpacing.sm),
        if (contact!.email != null)
          DetailFieldRow(icon: Icons.email_outlined, label: contact!.email!),
      ],
    );
  }
}

class _AgentHandled extends StatelessWidget {
  const _AgentHandled({required this.agentName, required this.since});

  final String? agentName;
  final DateTime? since;

  @override
  Widget build(BuildContext context) {
    if (agentName == null) {
      return const _EmptySectionNote(text: 'Unassigned');
    }

    final colors = context.colors;
    return Row(
      children: [
        AppAvatar(name: agentName!, radius: 14),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agentName!,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (since != null)
                Text(
                  '${DateFormat.MMMd().add_jm().format(since!)} – Now',
                  style: AppTypography.caption.copyWith(
                    color: colors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomDetails extends StatelessWidget {
  const _RoomDetails({
    required this.conversation,
    required this.channelAccount,
  });

  final Conversation conversation;
  final String? channelAccount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rows = <(String, String?)>[
      (
        'Channel',
        channelAccount == null
            ? conversation.channel.label
            : '${conversation.channel.label} ($channelAccount)',
      ),
      if (conversation.createdAt != null)
        (
          'Create Conversation',
          DateFormat.yMMMd().add_jm().format(conversation.createdAt!),
        ),
      if (conversation.lastMessageAt != null)
        (
          'Last Activity',
          DateFormat.yMMMd().add_jm().format(conversation.lastMessageAt!),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          Text(
            row.$1,
            style: AppTypography.caption.copyWith(color: colors.textMuted),
          ),
          Text(row.$2!, style: AppTypography.bodySmall),
          if (row != rows.last) const SizedBox(height: AppSpacing.xs + 2),
        ],
      ],
    );
  }
}
