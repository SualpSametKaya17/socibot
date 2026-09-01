import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';

/// One chat bubble. Doesn't know about [Message]/[MessageDirection] —
/// takes plain `isOutgoing`/`text`/`time` so it stays reusable without
/// depending on the conversations feature's domain model.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isOutgoing,
    this.maxWidth = 480,
  });

  final String text;
  final DateTime time;
  final bool isOutgoing;

  /// Caller supplies this from the message area's actual available
  /// width (e.g. via LayoutBuilder) — defaults to a fixed cap so the
  /// widget still behaves sensibly used standalone.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    final bubbleColor = isOutgoing
        ? colors.primarySoft
        : colors.surfaceSecondary;
    final textColor = colors.textPrimary;
    const bubbleRadius = 8.0;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(bubbleRadius),
      topRight: const Radius.circular(bubbleRadius),
      bottomLeft: Radius.circular(isOutgoing ? bubbleRadius : 3),
      bottomRight: Radius.circular(isOutgoing ? 3 : bubbleRadius),
    );

    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: isOutgoing
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: radius,
                border: isOutgoing ? null : Border.all(color: colors.border),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(color: textColor),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat.Hm().format(time),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
