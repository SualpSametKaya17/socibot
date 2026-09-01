import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/channel_type.dart';
import '../../inbox/domain/inbox_quick_filter.dart';
import '../data/conversation_repository.dart';
import '../data/mock/conversation_mock_data.dart';
import 'conversation.dart';
import 'conversation_status.dart';
import 'message_direction.dart';

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return MockConversationRepository();
});

final conversationsProvider = FutureProvider<List<Conversation>>((ref) {
  return ref.watch(conversationRepositoryProvider).fetchConversations();
});

/// Inbox search/filter UI state. Ephemeral and screen-local, so plain
/// [StateProvider]s are enough — no need for a dedicated controller class.
final inboxSearchQueryProvider = StateProvider<String>((ref) => '');
final inboxQuickFilterProvider = StateProvider<InboxQuickFilter>(
  (ref) => InboxQuickFilter.all,
);
final inboxStatusFilterProvider = StateProvider<ConversationStatus?>(
  (ref) => null,
);

/// Filters the list to one channel (WhatsApp/Instagram/Messenger) when
/// set — driven by the sidebar's real CHANNELS section, backed by the
/// same [ChannelType] every conversation already carries.
final inboxChannelFilterProvider = StateProvider<ChannelType?>((ref) => null);

final selectedConversationIdProvider = StateProvider<String?>((ref) => null);

/// `true` = newest first (default), `false` = oldest first.
final inboxSortNewestFirstProvider = StateProvider<bool>((ref) => true);

/// When on, only shows conversations whose last message is incoming —
/// i.e. the customer is waiting on a reply. Derived from the real
/// [Conversation.lastMessageDirection] field rather than a status the
/// data model doesn't actually track.
final inboxUnrepliedOnlyProvider = StateProvider<bool>((ref) => false);

/// [conversationsProvider] narrowed by the quick filter, status filter, and
/// search query — in that order — newest first. Note this does *not*
/// depend on [inboxSearchQueryProvider], so the sidebar's counts stay
/// stable while the user types a search.
final _quickAndStatusFilteredProvider =
    Provider<AsyncValue<List<Conversation>>>((ref) {
      final conversationsAsync = ref.watch(conversationsProvider);
      final quickFilter = ref.watch(inboxQuickFilterProvider);
      final statusFilter = ref.watch(inboxStatusFilterProvider);

      return conversationsAsync.whenData((conversations) {
        return conversations.where((conversation) {
          switch (quickFilter) {
            case InboxQuickFilter.all:
              break;
            case InboxQuickFilter.mine:
              if (conversation.assignedAgentName != mockCurrentAgentName) {
                return false;
              }
            case InboxQuickFilter.unassigned:
              if (conversation.assignedAgentName != null) return false;
          }
          if (statusFilter != null && conversation.status != statusFilter) {
            return false;
          }
          return true;
        }).toList();
      });
    });

/// [_quickAndStatusFilteredProvider] further narrowed to one channel, when
/// [inboxChannelFilterProvider] is set. Kept separate from the quick/status
/// step so [inboxChannelCountsProvider] can scope its counts to quick+status
/// while ignoring the channel filter itself — same pattern as
/// [inboxStatusCountsProvider] ignoring the status filter.
final _quickStatusAndChannelFilteredProvider =
    Provider<AsyncValue<List<Conversation>>>((ref) {
      final scoped = ref.watch(_quickAndStatusFilteredProvider);
      final channelFilter = ref.watch(inboxChannelFilterProvider);

      return scoped.whenData((conversations) {
        if (channelFilter == null) return conversations;
        return conversations.where((c) => c.channel == channelFilter).toList();
      });
    });

/// The list the conversation panel actually renders:
/// [_quickStatusAndChannelFilteredProvider] further narrowed by the search
/// box, newest first.
final filteredConversationsProvider = Provider<AsyncValue<List<Conversation>>>((
  ref,
) {
  final scoped = ref.watch(_quickStatusAndChannelFilteredProvider);
  final query = ref.watch(inboxSearchQueryProvider).trim().toLowerCase();
  final newestFirst = ref.watch(inboxSortNewestFirstProvider);
  final unrepliedOnly = ref.watch(inboxUnrepliedOnlyProvider);

  return scoped.whenData((conversations) {
    var filtered = query.isEmpty
        ? conversations
        : conversations.where((conversation) {
            final haystack =
                '${conversation.contactName} ${conversation.lastMessagePreview ?? ''}'
                    .toLowerCase();
            return haystack.contains(query);
          }).toList();

    if (unrepliedOnly) {
      filtered = filtered
          .where((c) => c.lastMessageDirection == MessageDirection.incoming)
          .toList();
    }

    filtered.sort((a, b) {
      final aTime = a.lastMessageAt;
      final bTime = b.lastMessageAt;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return newestFirst ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
    });

    return filtered;
  });
});

/// Counts for the Inbox filter sidebar's All/Mine/Unassigned rows, over
/// every conversation regardless of the current status filter or search.
final inboxQuickFilterCountsProvider =
    Provider<AsyncValue<Map<InboxQuickFilter, int>>>((ref) {
      return ref.watch(conversationsProvider).whenData((conversations) {
        return {
          InboxQuickFilter.all: conversations.length,
          InboxQuickFilter.mine: conversations
              .where((c) => c.assignedAgentName == mockCurrentAgentName)
              .length,
          InboxQuickFilter.unassigned: conversations
              .where((c) => c.assignedAgentName == null)
              .length,
        };
      });
    });

/// Counts for the sidebar's STATUS section, scoped to the current quick
/// filter (so "Mine" shows how many of *your* conversations are open,
/// not the whole inbox's).
final inboxStatusCountsProvider =
    Provider<AsyncValue<Map<ConversationStatus, int>>>((ref) {
      return ref.watch(_quickAndStatusFilteredProviderIgnoringStatus).whenData((
        conversations,
      ) {
        return {
          for (final status in ConversationStatus.values)
            status: conversations.where((c) => c.status == status).length,
        };
      });
    });

/// Counts for the sidebar's CHANNELS section, scoped to the current quick
/// and status filters (so counts stay honest when either is active),
/// ignoring the channel filter itself — same reasoning as
/// [inboxStatusCountsProvider].
final inboxChannelCountsProvider = Provider<AsyncValue<Map<ChannelType, int>>>((
  ref,
) {
  return ref.watch(_quickAndStatusFilteredProvider).whenData((conversations) {
    return {
      for (final channel in ChannelType.values)
        channel: conversations.where((c) => c.channel == channel).length,
    };
  });
});

/// Same as [_quickAndStatusFilteredProvider] but ignoring the status
/// filter itself, so status counts reflect "how many would match each
/// status" rather than collapsing to the currently-selected one.
final _quickAndStatusFilteredProviderIgnoringStatus =
    Provider<AsyncValue<List<Conversation>>>((ref) {
      final conversationsAsync = ref.watch(conversationsProvider);
      final quickFilter = ref.watch(inboxQuickFilterProvider);

      return conversationsAsync.whenData((conversations) {
        return conversations.where((conversation) {
          switch (quickFilter) {
            case InboxQuickFilter.all:
              return true;
            case InboxQuickFilter.mine:
              return conversation.assignedAgentName == mockCurrentAgentName;
            case InboxQuickFilter.unassigned:
              return conversation.assignedAgentName == null;
          }
        }).toList();
      });
    });
