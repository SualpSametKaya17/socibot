import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/channel_type.dart';
import 'channel_connection_status.dart';

part 'channel_connection.freezed.dart';

/// A connected (or connectable) messaging channel for the organization —
/// mirrors the `channels` table (supabase/migrations). No provider
/// access token ever lives here, mock or real — see the migration's
/// comment on why (integration_credentials, AŞAMA 10).
///
/// No `fromJson` yet — mock-data only, same as [Conversation]/[Contact].
@freezed
sealed class ChannelConnection with _$ChannelConnection {
  const factory ChannelConnection({
    required ChannelType type,
    required ChannelConnectionStatus status,
    String? accountName,
    DateTime? lastSyncAt,
  }) = _ChannelConnection;
}
