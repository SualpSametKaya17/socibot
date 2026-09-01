import '../../../../core/constants/channel_type.dart';
import '../../domain/conversation.dart';
import '../../domain/conversation_status.dart';

/// The name used for "assigned to me" in the mock data / dev-bypass
/// session — there's no real current-agent concept yet (that needs a
/// signed-in user with a profile row), so this stands in for it.
const String mockCurrentAgentName = 'You';

/// Isolated from [MockConversationRepository] on purpose: sample content
/// living in its own file is easy to extend/replace without touching
/// repository logic, and never gets mixed into a real implementation.
List<Conversation> buildMockConversations() {
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
      assignedAgentName: mockCurrentAgentName,
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
      assignedAgentName: mockCurrentAgentName,
    ),
    Conversation(
      id: '4',
      contactName: 'Diego Fernandez',
      channel: ChannelType.whatsapp,
      status: ConversationStatus.resolved,
      lastMessagePreview: 'Perfect, see you then.',
      lastMessageAt: now.subtract(const Duration(hours: 5)),
      assignedAgentName: 'Sofia Reyes',
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
      assignedAgentName: mockCurrentAgentName,
    ),
    Conversation(
      id: '7',
      contactName: "James O'Brien",
      channel: ChannelType.whatsapp,
      status: ConversationStatus.resolved,
      lastMessagePreview: 'Appreciate the quick help, thanks!',
      lastMessageAt: now.subtract(const Duration(days: 1, hours: 3)),
      assignedAgentName: 'Sofia Reyes',
    ),
    Conversation(
      id: '8',
      contactName: 'Fatima Al-Sayed',
      channel: ChannelType.instagram,
      status: ConversationStatus.open,
      lastMessagePreview: 'What colors does this come in?',
      lastMessageAt: now.subtract(const Duration(days: 2)),
    ),
    Conversation(
      id: '9',
      contactName: 'Lucas Weber',
      channel: ChannelType.whatsapp,
      status: ConversationStatus.open,
      lastMessagePreview: 'Can I change my delivery address?',
      lastMessageAt: now.subtract(const Duration(days: 2, hours: 6)),
      unreadCount: 1,
    ),
    Conversation(
      id: '10',
      contactName: 'Hannah Kim',
      channel: ChannelType.facebook,
      status: ConversationStatus.pending,
      lastMessagePreview: 'Still waiting on a reply about my invoice.',
      lastMessageAt: now.subtract(const Duration(days: 3)),
      assignedAgentName: mockCurrentAgentName,
    ),
  ];
}
