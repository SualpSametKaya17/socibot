import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/conversation_tile.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../conversations/domain/conversation_providers.dart';
import 'conversation_filter_bar.dart';

/// The searchable, filterable conversation list — the left pane on
/// desktop, the whole screen on mobile.
class ConversationListPane extends ConsumerWidget {
  const ConversationListPane({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(filteredConversationsProvider);
    final selectedId = ref.watch(selectedConversationIdProvider);

    return Column(
      children: [
        const ConversationFilterBar(),
        const Divider(height: 1),
        Expanded(
          child: conversationsAsync.when(
            data: (conversations) {
              if (conversations.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off,
                  title: 'No conversations found',
                  message: 'Try a different search term or filter.',
                );
              }
              return ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ConversationTile(
                    contactName: conversation.contactName,
                    contactAvatarUrl: conversation.contactAvatarUrl,
                    channelBadge: ChannelBadge(channel: conversation.channel),
                    statusBadge: StatusBadge(
                      label: conversation.status.label,
                      tone: conversation.status.tone,
                    ),
                    lastMessagePreview: conversation.lastMessagePreview,
                    lastMessageAt: conversation.lastMessageAt,
                    unreadCount: conversation.unreadCount,
                    selected: conversation.id == selectedId,
                    onTap: () {
                      ref.read(selectedConversationIdProvider.notifier).state =
                          conversation.id;
                      onSelect?.call(conversation.id);
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => EmptyState(
              icon: Icons.error_outline,
              title: 'Could not load conversations',
              message: '$error',
            ),
          ),
        ),
      ],
    );
  }
}
