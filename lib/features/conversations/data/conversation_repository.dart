import '../domain/conversation.dart';
import 'mock/conversation_mock_data.dart';

abstract class ConversationRepository {
  Future<List<Conversation>> fetchConversations();
}

/// Backs the inbox until the `conversations`/`messages` tables are queried
/// for real (AŞAMA 7) — same mock-first pattern used by organizations.
class MockConversationRepository implements ConversationRepository {
  @override
  Future<List<Conversation>> fetchConversations() async {
    return buildMockConversations();
  }
}
