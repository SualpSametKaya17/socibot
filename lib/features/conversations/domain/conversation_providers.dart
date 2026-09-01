import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/channel_type.dart';
import '../data/conversation_repository.dart';
import 'conversation.dart';
import 'conversation_status.dart';

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return MockConversationRepository();
});

final conversationsProvider = FutureProvider<List<Conversation>>((ref) {
  return ref.watch(conversationRepositoryProvider).fetchConversations();
});

/// Inbox search/filter UI state. Ephemeral and screen-local, so plain
/// [StateProvider]s are enough — no need for a dedicated controller class.
final inboxSearchQueryProvider = StateProvider<String>((ref) => '');
final inboxStatusFilterProvider = StateProvider<ConversationStatus?>((ref) => null);
final inboxChannelFilterProvider = StateProvider<ChannelType?>((ref) => null);
final selectedConversationIdProvider = StateProvider<String?>((ref) => null);

/// [conversationsProvider] narrowed by the current search query and
/// filters, newest first.
final filteredConversationsProvider = Provider<AsyncValue<List<Conversation>>>((ref) {
  final conversationsAsync = ref.watch(conversationsProvider);
  final query = ref.watch(inboxSearchQueryProvider).trim().toLowerCase();
  final statusFilter = ref.watch(inboxStatusFilterProvider);
  final channelFilter = ref.watch(inboxChannelFilterProvider);

  return conversationsAsync.whenData((conversations) {
    final filtered = conversations.where((conversation) {
      if (statusFilter != null && conversation.status != statusFilter) {
        return false;
      }
      if (channelFilter != null && conversation.channel != channelFilter) {
        return false;
      }
      if (query.isNotEmpty) {
        final haystack =
            '${conversation.contactName} ${conversation.lastMessagePreview ?? ''}'
                .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      final aTime = a.lastMessageAt;
      final bTime = b.lastMessageAt;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });

    return filtered;
  });
});
