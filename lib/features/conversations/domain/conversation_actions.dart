import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_toast.dart';
import 'conversation_providers.dart';
import 'conversation_status.dart';

/// The single place every Resolve/Reopen/Assign/Mark-unread trigger calls
/// through — the header's buttons today, keyboard shortcuts, and (in a
/// later phase) the command palette/context menu — so the mutation +
/// user-feedback logic lives in exactly one spot instead of being
/// duplicated per entry point.
void resolveConversation(
  WidgetRef ref,
  BuildContext context,
  String conversationId,
) {
  ref
      .read(conversationsProvider.notifier)
      .setStatus(conversationId, ConversationStatus.resolved);
  AppToast.show(
    context,
    message: 'Conversation resolved',
    variant: ToastVariant.success,
  );
}

void reopenConversation(
  WidgetRef ref,
  BuildContext context,
  String conversationId,
) {
  ref
      .read(conversationsProvider.notifier)
      .setStatus(conversationId, ConversationStatus.open);
  AppToast.show(
    context,
    message: 'Conversation reopened',
    variant: ToastVariant.info,
  );
}

/// Pass `null` for [agentName] to unassign.
void assignConversation(
  WidgetRef ref,
  BuildContext context,
  String conversationId,
  String? agentName,
) {
  ref
      .read(conversationsProvider.notifier)
      .setAssignee(conversationId, agentName);
  AppToast.show(
    context,
    message: agentName == null
        ? 'Conversation unassigned'
        : 'Assigned to $agentName',
    variant: ToastVariant.success,
  );
}

void markConversationUnread(
  WidgetRef ref,
  BuildContext context,
  String conversationId,
) {
  ref.read(conversationsProvider.notifier).markUnread(conversationId);
  AppToast.show(
    context,
    message: 'Marked as unread',
    variant: ToastVariant.info,
  );
}
