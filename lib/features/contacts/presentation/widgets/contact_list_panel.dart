import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/load_more_row.dart';
import '../../domain/contact_providers.dart';
import 'contact_tile.dart';

/// The searchable contact list — left pane on desktop, whole screen on
/// mobile (same paradigm as [ConversationListPanel]).
class ContactListPanel extends ConsumerStatefulWidget {
  const ContactListPanel({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  ConsumerState<ContactListPanel> createState() => _ContactListPanelState();
}

class _ContactListPanelState extends ConsumerState<ContactListPanel> {
  // Deliberately small: the mock dataset only has 10 contacts, and a page
  // size bigger than that would make "Load more" never actually appear.
  static const _pageSize = 6;

  int _visibleCount = _pageSize;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(contactSearchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(filteredContactsProvider);
    final selectedId = ref.watch(selectedContactIdProvider);

    ref.listen(contactSearchQueryProvider, (previous, next) {
      if (previous != next) setState(() => _visibleCount = _pageSize);
    });

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
                // Debounced so re-filtering doesn't run on every keystroke.
                onChanged: _onSearchChanged,
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
              final visible = contacts.take(_visibleCount).toList();
              final hasMore = contacts.length > visible.length;

              return ListView.separated(
                itemCount: visible.length + (hasMore ? 1 : 0),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index == visible.length) {
                    return LoadMoreRow(
                      remaining: contacts.length - visible.length,
                      onTap: () => setState(() => _visibleCount += _pageSize),
                    );
                  }
                  final contact = visible[index];
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
                        widget.onSelect?.call(contact.id);
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
