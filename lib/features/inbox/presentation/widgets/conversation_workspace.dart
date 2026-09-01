import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/message_composer.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../../conversations/domain/message_providers.dart';
import 'conversation_workspace_header.dart';
import 'message_list.dart';

/// Region 4: the selected conversation's header, message thread, and
/// composer. Shows an empty state when nothing is selected yet.
class ConversationWorkspace extends ConsumerStatefulWidget {
  const ConversationWorkspace({super.key, this.onClose, this.compact = false});

  /// Overrides the header's close action. Defaults to clearing the
  /// selection in place (desktop split view); mobile's pushed full-screen
  /// route passes `Navigator.pop` instead.
  final VoidCallback? onClose;

  /// Passed through to [ConversationWorkspaceHeader] — true for the
  /// mobile full-screen push, where there isn't room for every header
  /// action.
  final bool compact;

  @override
  ConsumerState<ConversationWorkspace> createState() =>
      _ConversationWorkspaceState();
}

class _ConversationWorkspaceState extends ConsumerState<ConversationWorkspace> {
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedConversationIdProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(selectedId),
        child: _buildBody(selectedId),
      ),
    );
  }

  Widget _buildBody(String? selectedId) {
    if (selectedId == null) {
      return const EmptyState(
        icon: Icons.forum_outlined,
        title: 'Select a conversation',
        message: 'Choose a conversation from the list to see its messages.',
      );
    }

    final conversationsAsync = ref.watch(conversationsProvider);
    return conversationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load conversation',
        message: '$error',
      ),
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

        final args = ConversationMessagesArgs(
          conversationId: conversation.id,
          contactName: conversation.contactName,
          lastMessagePreview: conversation.lastMessagePreview,
        );
        final messagesAsync = ref.watch(conversationMessagesProvider(args));

        return Column(
          children: [
            ConversationWorkspaceHeader(
              conversation: conversation,
              compact: widget.compact,
              searching: _searching,
              onToggleSearch: () => setState(() => _searching = !_searching),
              onClose:
                  widget.onClose ??
                  () =>
                      ref.read(selectedConversationIdProvider.notifier).state =
                          null,
            ),
            if (_searching)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search in this conversation',
                    prefixIcon: Icon(Icons.search, size: 18),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            Expanded(
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Could not load messages',
                  message: '$error',
                ),
                data: (messages) {
                  final query = _searchController.text.trim().toLowerCase();
                  final visible = query.isEmpty
                      ? messages
                      : messages
                            .where((m) => m.text.toLowerCase().contains(query))
                            .toList();
                  return MessageList(
                    messages: visible,
                    assignedAgentName: conversation.assignedAgentName,
                  );
                },
              ),
            ),
            MessageComposer(
              onSend: (text) => ref
                  .read(conversationMessagesProvider(args).notifier)
                  .sendOutgoing(text),
            ),
          ],
        );
      },
    );
  }
}
