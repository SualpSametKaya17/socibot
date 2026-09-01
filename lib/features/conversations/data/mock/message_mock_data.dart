import '../../domain/message.dart';
import '../../domain/message_direction.dart';

/// Builds a realistic-looking 9-message thread for one conversation.
/// Isolated from the repository/widgets on purpose, same reasoning as
/// [buildMockConversations].
List<Message> buildMockMessages({
  required String conversationId,
  required String contactName,
  String? lastMessagePreview,
}) {
  final firstName = contactName.split(' ').first;
  final now = DateTime.now();
  DateTime at(int minutesAgo) => now.subtract(Duration(minutes: minutesAgo));

  final script = <(MessageDirection, String, int)>[
    (
      MessageDirection.incoming,
      'Hi, I had a question about my recent order.',
      180,
    ),
    (
      MessageDirection.outgoing,
      'Hi $firstName, happy to help — what\'s going on?',
      176,
    ),
    (
      MessageDirection.incoming,
      'I placed it three days ago but haven\'t seen a shipping update.',
      174,
    ),
    (MessageDirection.outgoing, 'Let me check that for you, one moment.', 170),
    (
      MessageDirection.outgoing,
      'Looks like it left the warehouse yesterday — you should get a tracking link shortly.',
      168,
    ),
    (MessageDirection.incoming, 'Oh perfect, thank you for checking!', 140),
    (
      MessageDirection.outgoing,
      'Of course — anything else I can help with?',
      100,
    ),
    (MessageDirection.incoming, 'Actually yes, one more thing —', 12),
    (
      MessageDirection.incoming,
      lastMessagePreview ?? 'Thanks again for the help!',
      4,
    ),
  ];

  return [
    for (var i = 0; i < script.length; i++)
      Message(
        id: '$conversationId-msg-$i',
        conversationId: conversationId,
        direction: script[i].$1,
        text: script[i].$2,
        createdAt: at(script[i].$3),
      ),
  ];
}
