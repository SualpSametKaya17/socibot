import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../conversations/domain/conversation_providers.dart';

/// Desktop's right-hand pane. Message bubbles and the composer are
/// AŞAMA 6's job — for now this only proves selection state works.
class ConversationDetailPlaceholder extends ConsumerWidget {
  const ConversationDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedConversationIdProvider);
    if (selectedId == null) {
      return const EmptyState(
        icon: Icons.forum_outlined,
        title: 'Select a conversation',
        message: 'Choose a conversation from the list to see its messages.',
      );
    }

    final conversationsAsync = ref.watch(conversationsProvider);
    return conversationsAsync.when(
      data: (conversations) {
        final matches = conversations.where((c) => c.id == selectedId);
        final conversation = matches.isEmpty ? null : matches.first;
        if (conversation == null) {
          return const EmptyState(
            icon: Icons.forum_outlined,
            title: 'Select a conversation',
            message: 'Choose a conversation from the list to see its messages.',
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppAvatar(
                name: conversation.contactName,
                imageUrl: conversation.contactAvatarUrl,
                radius: 28,
              ),
              const SizedBox(height: 16),
              Text(
                conversation.contactName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Message bubbles and the composer arrive in a later stage.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load conversation',
        message: '$error',
      ),
    );
  }
}
