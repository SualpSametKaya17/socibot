import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_radius.dart';
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
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(AppRadius.md),
      topRight: const Radius.circular(AppRadius.md),
      bottomLeft: Radius.circular(isOutgoing ? AppRadius.md : AppRadius.sm),
      bottomRight: Radius.circular(isOutgoing ? AppRadius.sm : AppRadius.md),
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
                vertical: AppSpacing.sm + 2,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: radius,
              ),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat.Hm().format(time),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
