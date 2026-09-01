import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/contact_providers.dart';
import 'contact_tile.dart';

/// The searchable contact list — left pane on desktop, whole screen on
/// mobile (same paradigm as [ConversationListPanel]).
class ContactListPanel extends ConsumerWidget {
  const ContactListPanel({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(filteredContactsProvider);
    final selectedId = ref.watch(selectedContactIdProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contacts', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search contacts',
                  prefixIcon: Icon(Icons.search, size: 20),
                  isDense: true,
                ),
                onChanged: (value) =>
                    ref.read(contactSearchQueryProvider.notifier).state = value,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: contactsAsync.when(
            data: (contacts) {
              if (contacts.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off,
                  title: 'No contacts found',
                  message: 'Try a different search term.',
                );
              }
              return ListView.separated(
                itemCount: contacts.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return FadeSlideIn(
                    delay: Duration(milliseconds: 20 * index.clamp(0, 10)),
                    child: ContactTile(
                      name: contact.displayName,
                      avatarUrl: contact.avatarUrl,
                      channel: contact.primaryChannel,
                      subtitle: contact.email ?? contact.phone,
                      lastContactedAt: contact.lastContactedAt,
                      selected: contact.id == selectedId,
                      onTap: () {
                        ref.read(selectedContactIdProvider.notifier).state =
                            contact.id;
                        onSelect?.call(contact.id);
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const _ContactListSkeleton(),
            error: (error, stackTrace) => EmptyState(
              icon: Icons.error_outline,
              title: 'Could not load contacts',
              message: '$error',
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer placeholder rows built from real [ContactTile]s with dummy
/// data — same reasoning as the Inbox conversation list's skeleton.
class _ContactListSkeleton extends StatelessWidget {
  const _ContactListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        itemCount: 7,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => ContactTile(
          name: 'Loading contact name',
          channel: ChannelType.whatsapp,
          subtitle: 'loading@example.com',
          lastContactedAt: DateTime.now(),
        ),
      ),
    );
  }
}
