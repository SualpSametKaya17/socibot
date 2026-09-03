import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_breakpoints.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/message_bubble.dart';
import '../../../conversations/domain/message.dart';
import '../../../conversations/domain/message_direction.dart';
import 'system_message.dart';
import '../../../../app/theme/app_typography.dart';

/// The scrollable thread, oldest to newest, with a subtle date separator
/// whenever the day changes. Auto-scrolls to the newest message whenever
/// one is added (including on first open).
class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.messages,
    this.assignedAgentName,
  });

  final List<Message> messages;

  /// When set, shows a small "Assigned to X" system-style line above the
  /// thread — real data (the conversation's actual assignee), not a
  /// fabricated activity log.
  final String? assignedAgentName;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  static const _maxContentWidth = 900.0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void didUpdateWidget(covariant MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: AppTypography.bodyMedium.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // A readable central corridor rather than letting bubbles stretch
        // across the whole workspace — capped, not hardcoded, so it still
        // shrinks on a narrower workspace.
        final contentWidth = constraints.maxWidth > _maxContentWidth
            ? _maxContentWidth
            : constraints.maxWidth;
        // Widest on mobile (less room to spare on a narrow screen), tighter
        // on desktop (a full-width bubble reads as excessive once there's
        // hundreds of pixels of workspace to work with) — not one ratio
        // for every screen size.
        final totalWidth = MediaQuery.sizeOf(context).width;
        // Desktop keeps the original, previously-approved 0.72 ratio — an
        // earlier pass narrowed it to 0.65, which read as too cramped in
        // practice. Mobile/tablet stay a bit wider still, since they have
        // less room to spare.
        final bubbleRatio = totalWidth < AppBreakpoints.mobile
            ? 0.82
            : totalWidth < AppBreakpoints.tablet
            ? 0.76
            : 0.72;
        final bubbleMaxWidth = contentWidth * bubbleRatio;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _maxContentWidth),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final previous = index == 0 ? null : messages[index - 1];
                final showDateSeparator =
                    previous == null ||
                    !_isSameDay(previous.createdAt, message.createdAt);
                final sameGroupAsPrevious =
                    !showDateSeparator &&
                    previous.direction == message.direction &&
                    message.createdAt
                            .difference(previous.createdAt)
                            .inMinutes
                            .abs() <
                        5;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (index == 0 && widget.assignedAgentName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: SystemMessage(
                          text: 'Assigned to ${widget.assignedAgentName}',
                        ),
                      ),
                    if (showDateSeparator)
                      _DateSeparator(date: message.createdAt),
                    Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 || showDateSeparator
                            ? 0
                            : sameGroupAsPrevious
                            ? 7
                            : 19,
                      ),
                      child: FadeSlideIn(
                        key: ValueKey(message.id),
                        child: MessageBubble(
                          text: message.text,
                          time: message.createdAt,
                          isOutgoing:
                              message.direction == MessageDirection.outgoing,
                          maxWidth: bubbleMaxWidth,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Divider(color: colors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              DateFormat.yMMMd().format(date),
              style: AppTypography.caption.copyWith(color: colors.textMuted),
            ),
          ),
          Expanded(child: Divider(color: colors.border)),
        ],
      ),
    );
  }
}
