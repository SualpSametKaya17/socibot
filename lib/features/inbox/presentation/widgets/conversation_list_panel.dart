import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/conversation_tile.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../conversations/domain/conversation_providers.dart';

/// Region 3 of the Inbox layout: the "Chats" list — header, search, a
/// sort control, and the conversation rows.
class ConversationListPanel extends ConsumerWidget {
  const ConversationListPanel({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(filteredConversationsProvider);
    final selectedId = ref.watch(selectedConversationIdProvider);

    return Column(
      children: [
        const _ConversationListHeader(),
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
                  return FadeSlideIn(
                    delay: Duration(milliseconds: 20 * index.clamp(0, 10)),
                    child: ConversationTile(
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
                        ref
                                .read(selectedConversationIdProvider.notifier)
                                .state =
                            conversation.id;
                        onSelect?.call(conversation.id);
                      },
                    ),
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

class _ConversationListHeader extends ConsumerWidget {
  const _ConversationListHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final newestFirst = ref.watch(inboxSortNewestFirstProvider);
    final unrepliedOnly = ref.watch(inboxUnrepliedOnlyProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chats', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () =>
                    ref.read(inboxUnrepliedOnlyProvider.notifier).state =
                        !unrepliedOnly,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        unrepliedOnly
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 16,
                        color: unrepliedOnly
                            ? colors.primary
                            : colors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Unreplied',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: unrepliedOnly
                              ? colors.primary
                              : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () =>
                    ref.read(inboxSortNewestFirstProvider.notifier).state =
                        !newestFirst,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        newestFirst ? 'Newest' : 'Oldest',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 16,
                        color: colors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: Icon(Icons.search, size: 20),
              isDense: true,
            ),
            onChanged: (value) =>
                ref.read(inboxSearchQueryProvider.notifier).state = value,
          ),
        ],
      ),
    );
  }
}
