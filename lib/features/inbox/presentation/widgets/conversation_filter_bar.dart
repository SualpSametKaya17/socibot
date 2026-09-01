import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/channel_type.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../../conversations/domain/conversation_status.dart';

/// Search field + status/channel filter chip rows above the conversation
/// list.
class ConversationFilterBar extends ConsumerWidget {
  const ConversationFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    TextStyle chipLabelStyle(bool selected) {
      return Theme.of(context).textTheme.labelMedium!
          .copyWith(color: selected ? colors.primary : colors.textSecondary);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: Icon(Icons.search, size: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              for (final status in [null, ...ConversationStatus.values])
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      status?.label ?? 'All',
                      style: chipLabelStyle(
                        ref.watch(inboxStatusFilterProvider) == status,
                      ),
                    ),
                    selected: ref.watch(inboxStatusFilterProvider) == status,
                    onSelected: (_) =>
                        ref.read(inboxStatusFilterProvider.notifier).state =
                            status,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              for (final channel in [null, ...ChannelType.values])
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      channel?.label ?? 'All channels',
                      style: chipLabelStyle(
                        ref.watch(inboxChannelFilterProvider) == channel,
                      ),
                    ),
                    selected: ref.watch(inboxChannelFilterProvider) == channel,
                    onSelected: (_) =>
                        ref.read(inboxChannelFilterProvider.notifier).state =
                            channel,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
