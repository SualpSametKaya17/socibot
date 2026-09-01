import '../../../core/constants/status_tone.dart';

/// Matches the `status` check constraint on the `channels` table
/// (supabase/migrations) exactly, so the eventual real repository maps
/// 1:1 onto this.
enum ChannelConnectionStatus {
  connected,
  disconnected,
  error;

  String get label => switch (this) {
    ChannelConnectionStatus.connected => 'Connected',
    ChannelConnectionStatus.disconnected => 'Disconnected',
    ChannelConnectionStatus.error => 'Error',
  };

  StatusTone get tone => switch (this) {
    ChannelConnectionStatus.connected => StatusTone.success,
    ChannelConnectionStatus.disconnected => StatusTone.neutral,
    ChannelConnectionStatus.error => StatusTone.danger,
  };
}
