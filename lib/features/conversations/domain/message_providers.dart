import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/message_repository.dart';
import 'message.dart';
import 'message_direction.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MockMessageRepository();
});

/// Arguments for [conversationMessagesProvider] — the message thread needs
/// the contact's name (for the mock script) alongside the conversation id.
class ConversationMessagesArgs {
  const ConversationMessagesArgs({
    required this.conversationId,
    required this.contactName,
    this.lastMessagePreview,
  });

  final String conversationId;
  final String contactName;
  final String? lastMessagePreview;

  @override
  bool operator ==(Object other) =>
      other is ConversationMessagesArgs &&
      other.conversationId == conversationId;

  @override
  int get hashCode => conversationId.hashCode;
}

/// One conversation's message thread, with local-only optimistic sending
/// (the composer appends here; nothing is persisted — sending for real is
/// the send-message Edge Function, AŞAMA 13).
class ConversationMessagesController
    extends FamilyAsyncNotifier<List<Message>, ConversationMessagesArgs> {
  @override
  FutureOr<List<Message>> build(ConversationMessagesArgs arg) {
    return ref
        .watch(messageRepositoryProvider)
        .fetchMessages(
          conversationId: arg.conversationId,
          contactName: arg.contactName,
          lastMessagePreview: arg.lastMessagePreview,
        );
  }

  void sendOutgoing(String text) {
    final current = state.valueOrNull ?? const [];
    final message = Message(
      id: const Uuid().v4(),
      conversationId: arg.conversationId,
      direction: MessageDirection.outgoing,
      text: text,
      createdAt: DateTime.now(),
    );
    state = AsyncData([...current, message]);
  }
}

final conversationMessagesProvider =
    AsyncNotifierProvider.family<
      ConversationMessagesController,
      List<Message>,
      ConversationMessagesArgs
    >(ConversationMessagesController.new);
