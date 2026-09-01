import '../domain/message.dart';
import 'mock/message_mock_data.dart';

abstract class MessageRepository {
  Future<List<Message>> fetchMessages({
    required String conversationId,
    required String contactName,
    String? lastMessagePreview,
  });
}

/// Backs the conversation workspace until `messages` is queried for real
/// (AŞAMA 7) — same mock-first pattern used elsewhere in the app.
class MockMessageRepository implements MessageRepository {
  @override
  Future<List<Message>> fetchMessages({
    required String conversationId,
    required String contactName,
    String? lastMessagePreview,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return buildMockMessages(
      conversationId: conversationId,
      contactName: contactName,
      lastMessagePreview: lastMessagePreview,
    );
  }
}
