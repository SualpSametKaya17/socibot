import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/channel_repository.dart';
import 'channel_connection.dart';

final channelRepositoryProvider = Provider<ChannelRepository>((ref) {
  return MockChannelRepository();
});

final channelsProvider = FutureProvider<List<ChannelConnection>>((ref) {
  return ref.watch(channelRepositoryProvider).fetchChannels();
});
