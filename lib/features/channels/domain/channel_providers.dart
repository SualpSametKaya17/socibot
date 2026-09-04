import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/channel_type.dart';
import '../data/channel_repository.dart';
import 'channel_connection.dart';
import 'channel_connection_status.dart';

final channelRepositoryProvider = Provider<ChannelRepository>((ref) {
  return MockChannelRepository();
});

/// Loads the mock connections, then lets the Channels screen mutate them
/// locally — connect/disconnect are real, immediate state changes (no
/// backend round-trip needed to flip local UI state), but they don't call
/// any actual Meta API: there's no OAuth handshake here, matching every
/// other "coming in a later stage" integration in this app. See
/// [ChannelsNotifier.connect]'s doc comment.
class ChannelsNotifier extends AsyncNotifier<List<ChannelConnection>> {
  @override
  Future<List<ChannelConnection>> build() {
    return ref.watch(channelRepositoryProvider).fetchChannels();
  }

  /// Marks [type] connected under [accountName] — a local mock stand-in
  /// for the real Meta OAuth handshake (connect-channel Edge Function,
  /// AŞAMA 10/11), which doesn't exist yet. Nothing is actually
  /// authenticated with Instagram/Messenger/WhatsApp.
  void connect(ChannelType type, {required String accountName}) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData([
      for (final connection in current)
        if (connection.type == type)
          connection.copyWith(
            status: ChannelConnectionStatus.connected,
            accountName: accountName,
            lastSyncAt: DateTime.now(),
          )
        else
          connection,
    ]);
  }

  /// Revokes the local connection for [type]. Unlike [connect], this one
  /// has a real-world equivalent that needs no third-party call — "forget
  /// this connection" is a purely local action even in a real backend.
  void disconnect(ChannelType type) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData([
      for (final connection in current)
        if (connection.type == type)
          connection.copyWith(
            status: ChannelConnectionStatus.disconnected,
            accountName: null,
            lastSyncAt: null,
          )
        else
          connection,
    ]);
  }
}

final channelsProvider =
    AsyncNotifierProvider<ChannelsNotifier, List<ChannelConnection>>(
      ChannelsNotifier.new,
    );
