import '../../../core/constants/channel_type.dart';
import '../domain/conversation.dart';
import '../domain/conversation_status.dart';

abstract class ConversationRepository {
  Future<List<Conversation>> fetchConversations();
}

/// Backs the inbox until the `conversations`/`messages` tables are queried
/// for real (AŞAMA 7) — same mock-first pattern used by organizations.
class MockConversationRepository implements ConversationRepository {
  @override
  Future<List<Conversation>> fetchConversations() async {
    final now = DateTime.now();
    return [
      Conversation(
        id: '1',
        contactName: 'Elena Martinez',
        channel: ChannelType.whatsapp,
        status: ConversationStatus.open,
        lastMessagePreview: 'Is my order #4521 still on the way?',
        lastMessageAt: now.subtract(const Duration(minutes: 4)),
        unreadCount: 2,
      ),
      Conversation(
        id: '2',
        contactName: 'Marcus Chen',
        channel: ChannelType.instagram,
        status: ConversationStatus.pending,
        lastMessagePreview: 'Can you send me a size chart?',
        lastMessageAt: now.subtract(const Duration(minutes: 32)),
        unreadCount: 1,
      ),
      Conversation(
        id: '3',
        contactName: 'Priya Nair',
        channel: ChannelType.facebook,
        status: ConversationStatus.open,
        lastMessagePreview: 'Thank you, that solved it!',
        lastMessageAt: now.subtract(const Duration(hours: 2)),
      ),
      Conversation(
        id: '4',
        contactName: 'Diego Fernandez',
        channel: ChannelType.whatsapp,
        status: ConversationStatus.resolved,
        lastMessagePreview: 'Perfect, see you then.',
        lastMessageAt: now.subtract(const Duration(hours: 5)),
      ),
      Conversation(
        id: '5',
        contactName: 'Aiko Tanaka',
        channel: ChannelType.instagram,
        status: ConversationStatus.open,
        lastMessagePreview: 'Do you ship internationally?',
        lastMessageAt: now.subtract(const Duration(hours: 9)),
        unreadCount: 3,
      ),
      Conversation(
        id: '6',
        contactName: 'Sofia Rossi',
        channel: ChannelType.facebook,
        status: ConversationStatus.pending,
        lastMessagePreview: 'Following up on my refund request.',
        lastMessageAt: now.subtract(const Duration(hours: 14)),
        unreadCount: 1,
      ),
      Conversation(
        id: '7',
        contactName: 'James O\'Brien',
        channel: ChannelType.whatsapp,
        status: ConversationStatus.resolved,
        lastMessagePreview: 'Appreciate the quick help, thanks!',
        lastMessageAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      Conversation(
        id: '8',
        contactName: 'Fatima Al-Sayed',
        channel: ChannelType.instagram,
        status: ConversationStatus.open,
        lastMessagePreview: 'What colors does this come in?',
        lastMessageAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
