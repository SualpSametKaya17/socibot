import '../../../../core/constants/channel_type.dart';
import '../../domain/channel_connection.dart';
import '../../domain/channel_connection_status.dart';

/// Isolated from [MockChannelRepository] on purpose, same reasoning as
/// the conversations/contacts mock data. Deliberately shows one of each
/// status so the UI language (StatusBadge tones, empty vs. connected
/// card) is visible without needing a real Meta OAuth connection.
List<ChannelConnection> buildMockChannels() {
  final now = DateTime.now();
  return [
    ChannelConnection(
      type: ChannelType.whatsapp,
      status: ChannelConnectionStatus.connected,
      accountName: 'Socibot Support (+1 415 555 0100)',
      lastSyncAt: now.subtract(const Duration(minutes: 3)),
    ),
    ChannelConnection(
      type: ChannelType.instagram,
      status: ChannelConnectionStatus.error,
      accountName: '@socibot.support',
      lastSyncAt: now.subtract(const Duration(hours: 6)),
    ),
    const ChannelConnection(
      type: ChannelType.facebook,
      status: ChannelConnectionStatus.disconnected,
    ),
  ];
}
