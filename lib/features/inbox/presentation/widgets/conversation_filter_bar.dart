import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/channel_type.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../../conversations/domain/conversation_status.dart';

/// Search field + status/channel filter chip rows above the conversation
/// list.
class ConversationFilterBar extends ConsumerWidget {
  const ConversationFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (value) =>
                ref.read(inboxSearchQueryProvider.notifier).state = value,
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final status in [null, ...ConversationStatus.values])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(status?.label ?? 'All'),
                    selected: ref.watch(inboxStatusFilterProvider) == status,
                    onSelected: (_) =>
                        ref.read(inboxStatusFilterProvider.notifier).state = status,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final channel in [null, ...ChannelType.values])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(channel?.label ?? 'All channels'),
                    selected: ref.watch(inboxChannelFilterProvider) == channel,
                    onSelected: (_) =>
                        ref.read(inboxChannelFilterProvider.notifier).state = channel,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
