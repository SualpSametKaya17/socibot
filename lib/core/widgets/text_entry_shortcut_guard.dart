import 'package:flutter/material.dart';

class _ConsumeKeyIntent extends Intent {
  const _ConsumeKeyIntent();
}

/// Wrap a text-entry widget (a search box, the message composer) with
/// this so single-letter app-wide shortcuts bound on an ancestor
/// [Shortcuts] widget (e.g. Inbox's J/K/E navigation) don't fire while
/// the user is typing here.
///
/// Character insertion into a focused [TextField] flows through the
/// separate text-input/IME channel, not raw key dispatch — unlike the
/// Enter key (which `EditableText` binds as an explicit shortcut for
/// multiline newline-insertion), plain letter keys aren't consumed by
/// the field itself at the raw-[KeyEvent] level, so they'd otherwise
/// keep bubbling up to an ancestor [Shortcuts] mapping even while the
/// field has focus. This widget adds a closer-scoped [Shortcuts] binding
/// for the given [keys] that consumes them first (Flutter's Shortcuts
/// resolution stops at the nearest ancestor with a matching activator)
/// without touching the IME channel, so normal typing is unaffected.
class TextEntryShortcutGuard extends StatelessWidget {
  const TextEntryShortcutGuard({
    super.key,
    required this.keys,
    required this.child,
  });

  final List<SingleActivator> keys;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        for (final activator in keys) activator: const _ConsumeKeyIntent(),
      },
      child: Actions(
        actions: {
          _ConsumeKeyIntent: CallbackAction<_ConsumeKeyIntent>(
            onInvoke: (intent) => null,
          ),
        },
        child: child,
      ),
    );
  }
}
