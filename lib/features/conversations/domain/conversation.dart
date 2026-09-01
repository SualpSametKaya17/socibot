import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/channel_type.dart';
import 'conversation_status.dart';
import 'message_direction.dart';

part 'conversation.freezed.dart';

/// One conversation thread as shown in the inbox list.
///
/// No `fromJson` yet — this stage is mock-data only (AŞAMA 5). A real
/// Supabase-backed repository (AŞAMA 7) will map query rows onto this
/// model then.
@freezed
sealed class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String contactName,
    String? contactAvatarUrl,
    required ChannelType channel,
    required ConversationStatus status,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount,
    // Mock-only for now — a real "assigned_to" column/UI lands in the
    // conversation-assignment stage. Null means unassigned.
    String? assignedAgentName,
    // Denormalized from the message thread's last entry — lets the list
    // derive "unreplied" (customer waiting on us) honestly, without a
    // fake status the data model doesn't actually track.
    MessageDirection? lastMessageDirection,
  }) = _Conversation;
}
