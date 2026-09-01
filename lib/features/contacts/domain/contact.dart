import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/channel_type.dart';

part 'contact.freezed.dart';

/// A customer identity within an organization, independent of any one
/// channel — mirrors the `contacts` table (supabase/migrations).
///
/// No `fromJson` yet — mock-data only, same as [Conversation]/[Message].
@freezed
sealed class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String displayName,
    String? avatarUrl,
    String? email,
    String? phone,
    required ChannelType primaryChannel,
    // Mock-data convenience only — lets "View conversation" jump straight
    // to it. The real schema points the other way (conversations ->
    // contact_id); a real contact can have several conversations.
    required String conversationId,
    DateTime? lastContactedAt,
  }) = _Contact;
}
