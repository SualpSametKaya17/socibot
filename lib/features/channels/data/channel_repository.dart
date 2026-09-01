import '../domain/channel_connection.dart';
import 'mock/channel_mock_data.dart';

abstract class ChannelRepository {
  Future<List<ChannelConnection>> fetchChannels();
}

/// Backs the Channels screen until the `channels` table is queried for
/// real (AŞAMA 7) and the OAuth connect flow exists (AŞAMA 10/11) — same
/// mock-first pattern used elsewhere in the app.
class MockChannelRepository implements ChannelRepository {
  @override
  Future<List<ChannelConnection>> fetchChannels() async {
    return buildMockChannels();
  }
}
