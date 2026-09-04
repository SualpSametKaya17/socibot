import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_semantic_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../conversations/domain/conversation_actions.dart';
import '../../conversations/domain/conversation_providers.dart';
import '../../conversations/domain/conversation_status.dart';

class SelectAdjacentConversationIntent extends Intent {
  const SelectAdjacentConversationIntent({required this.forward});

  final bool forward;
}

class ResolveConversationIntent extends Intent {
  const ResolveConversationIntent();
}

class ShowShortcutsHelpIntent extends Intent {
  const ShowShortcutsHelpIntent();
}

/// Wraps [child] with the Inbox's first slice of keyboard shortcuts: `J`/
/// `K` move the selection through the currently visible (filtered)
/// conversation list, `E` resolves/reopens the open conversation, `?`
/// opens a reference dialog. This is a first slice, not the full
/// command-palette brief — see the plan for what's deferred.
///
/// Typing "j"/"k"/"e" into a focused text field (composer, search boxes)
/// still types normally rather than triggering these — but that isn't
/// automatic. Unlike the Enter key (which `EditableText` binds as an
/// explicit shortcut for multiline newline-insertion), plain letter keys
/// aren't consumed by a text field at the raw-`KeyEvent` level — they
/// reach the field only through the separate text-input/IME channel — so
/// they'd otherwise keep bubbling up to this ancestor `Shortcuts` mapping
/// even while the field has focus. Every text field this screen renders
/// (the search box, the composer) wraps itself in
/// `core/widgets/text_entry_shortcut_guard.dart`'s `TextEntryShortcutGuard`
/// to consume these keys at a closer scope first.
class InboxShortcuts extends ConsumerWidget {
  const InboxShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyJ):
            SelectAdjacentConversationIntent(forward: true),
        SingleActivator(LogicalKeyboardKey.keyK):
            SelectAdjacentConversationIntent(forward: false),
        SingleActivator(LogicalKeyboardKey.keyE): ResolveConversationIntent(),
        SingleActivator(LogicalKeyboardKey.slash, shift: true):
            ShowShortcutsHelpIntent(),
      },
      child: Actions(
        actions: {
          SelectAdjacentConversationIntent:
              CallbackAction<SelectAdjacentConversationIntent>(
                onInvoke: (intent) {
                  _selectAdjacent(ref, forward: intent.forward);
                  return null;
                },
              ),
          ResolveConversationIntent: CallbackAction<ResolveConversationIntent>(
            onInvoke: (intent) {
              _resolveOpenConversation(ref, context);
              return null;
            },
          ),
          ShowShortcutsHelpIntent: CallbackAction<ShowShortcutsHelpIntent>(
            onInvoke: (intent) {
              showKeyboardShortcutsDialog(context);
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }

  void _selectAdjacent(WidgetRef ref, {required bool forward}) {
    final conversations = ref.read(filteredConversationsProvider).valueOrNull;
    if (conversations == null || conversations.isEmpty) return;

    final currentId = ref.read(selectedConversationIdProvider);
    final currentIndex = conversations.indexWhere((c) => c.id == currentId);
    final nextIndex = currentIndex == -1
        ? 0
        : (currentIndex + (forward ? 1 : -1)).clamp(
            0,
            conversations.length - 1,
          );
    ref.read(selectedConversationIdProvider.notifier).state =
        conversations[nextIndex].id;
  }

  void _resolveOpenConversation(WidgetRef ref, BuildContext context) {
    final id = ref.read(selectedConversationIdProvider);
    if (id == null) return;

    final conversations = ref.read(conversationsProvider).valueOrNull ?? [];
    final matches = conversations.where((c) => c.id == id);
    if (matches.isEmpty) return;

    if (matches.first.status == ConversationStatus.resolved) {
      reopenConversation(ref, context, id);
    } else {
      resolveConversation(ref, context, id);
    }
  }
}

void showKeyboardShortcutsDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => const _ShortcutsDialog(),
  );
}

class _ShortcutsDialog extends StatelessWidget {
  const _ShortcutsDialog();

  static const _entries = [
    ('J', 'Next conversation'),
    ('K', 'Previous conversation'),
    ('E', 'Resolve / reopen'),
    ('Enter', 'Send message'),
    ('Shift + Enter', 'New line'),
    ('Esc', 'Close'),
    ('?', 'Show this list'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      title: const Text('Keyboard shortcuts'),
      content: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in _entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.$2,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.border),
                      ),
                      child: Text(
                        entry.$1,
                        style: AppTypography.caption.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
