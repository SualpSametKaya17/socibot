import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_direction.dart';

part 'message.freezed.dart';

/// One message in a conversation thread.
///
/// No `fromJson` yet — mock-data only, same as [Conversation]. A real
/// Supabase-backed repository (AŞAMA 7) will map query rows onto this
/// model then.
@freezed
sealed class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required MessageDirection direction,
    required String text,
    required DateTime createdAt,
  }) = _Message;
}
