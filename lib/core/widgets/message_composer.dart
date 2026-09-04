import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../features/settings/domain/settings_preferences.dart';
import 'text_entry_shortcut_guard.dart';

/// A CRM-style composer anchored at the bottom of the conversation
/// workspace: a utility row (attachment/emoji/saved-reply/AI-assist),
/// the text input, and a send button gated on non-empty text.
///
/// Attachment/emoji are wired for real (pick a file, insert an emoji);
/// nothing is uploaded or persisted — that's the send-message Edge
/// Function's job (AŞAMA 13). "Saved reply" and "AI Assist" are
/// presentation-only placeholders — no such feature exists yet.
class MessageComposer extends ConsumerStatefulWidget {
  const MessageComposer({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _attachedFileName;
  bool _hasText = false;
  bool _hasFocus = false;

  /// Local-only UI toggle — there's no separate internal-note persistence
  /// layer yet, so switching tabs just changes the composer's own
  /// placeholder/tint; sending still goes through [MessageComposer.onSend]
  /// either way.
  bool _internalNote = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    _focusNode.addListener(() {
      // The focus manager can notify listeners while this element is
      // mid-teardown (e.g. the route it's in is being popped) — guard
      // against calling setState on a widget that's no longer mounted.
      if (!mounted) return;
      if (_focusNode.hasFocus != _hasFocus) {
        setState(() => _hasFocus = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _attachedFileName = null);
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      final files = result?.files ?? const [];
      if (files.isNotEmpty) {
        setState(() => _attachedFileName = files.first.name);
      }
    } catch (_) {
      // Picker unsupported/cancelled on this platform — not fatal for a
      // UI-review build.
    }
  }

  void _pickEmoji() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SizedBox(
        height: 280,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            // Appending via `.text +=` resets the selection to the start
            // of the field (a well-known TextEditingController gotcha),
            // so the next keystroke would land before the emoji instead
            // of after it — set the selection explicitly to keep typing
            // where the user expects.
            final text = _controller.text + emoji.emoji;
            _controller.value = _controller.value.copyWith(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          },
        ),
      ),
    );
  }

  /// Enter-to-send, gated on the real Inbox settings preference
  /// (`InboxPreferences.enterKeyBehavior`) — Shift+Enter always inserts a
  /// newline regardless, matching every other chat composer's convention.
  ///
  /// Flutter's own default multiline newline-on-Enter shortcut only
  /// matches a bare Enter (no modifiers), so it never fires while Shift is
  /// held — the Shift+Enter case has to insert the newline itself rather
  /// than falling through to that default.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter) return KeyEventResult.ignored;

    if (HardwareKeyboard.instance.isShiftPressed) {
      _insertNewline();
      return KeyEventResult.handled;
    }

    final behavior = ref.read(inboxPreferencesProvider).enterKeyBehavior;
    if (behavior != EnterKeyBehavior.send) return KeyEventResult.ignored;
    _send();
    return KeyEventResult.handled;
  }

  void _insertNewline() {
    final selection = _controller.selection;
    final text = _controller.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final newText = text.replaceRange(start, end, '\n');
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enterKeyBehavior = ref.watch(
      inboxPreferencesProvider.select((p) => p.enterKeyBehavior),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _internalNote
            ? colors.warning.withValues(alpha: 0.06)
            : colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ComposerTabs(
              internalNote: _internalNote,
              onChanged: (value) => setState(() => _internalNote = value),
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                // Muted, not the same white/surface tone message bubbles
                // use — reads as an input field, not another bubble
                // floating inside the thread ("chat within a chat").
                color: colors.surfaceSecondary,
                borderRadius: AppRadius.smAll,
                border: _hasFocus
                    ? Border.all(color: colors.primary, width: 1.5)
                    : null,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_attachedFileName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: InputChip(
                        avatar: const Icon(Icons.attach_file, size: 14),
                        label: Text(_attachedFileName!),
                        onDeleted: () =>
                            setState(() => _attachedFileName = null),
                      ),
                    ),
                  TextEntryShortcutGuard(
                    keys: const [
                      SingleActivator(LogicalKeyboardKey.keyJ),
                      SingleActivator(LogicalKeyboardKey.keyK),
                      SingleActivator(LogicalKeyboardKey.keyE),
                      SingleActivator(LogicalKeyboardKey.slash, shift: true),
                    ],
                    child: Focus(
                      onKeyEvent: _handleKeyEvent,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        minLines: 2,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: false,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: const TextStyle(fontSize: 13),
                          hintText: _internalNote
                              ? 'Add an internal note — only your team can see this...'
                              : 'Type a message or type "/" to use template...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                IconButton(
                  tooltip: 'Attach a file',
                  icon: const Icon(Icons.attach_file_outlined, size: 18),
                  onPressed: _pickAttachment,
                ),
                IconButton(
                  tooltip: 'Emoji',
                  icon: const Icon(Icons.emoji_emotions_outlined, size: 18),
                  onPressed: _pickEmoji,
                ),
                IconButton(
                  tooltip: 'Saved replies (coming soon)',
                  icon: const Icon(Icons.bolt_outlined, size: 18),
                  onPressed: null,
                ),
                Expanded(
                  child: enterKeyBehavior == EnterKeyBehavior.send
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.sm,
                            ),
                            child: Text(
                              'Enter to send • Shift+Enter for new line',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                color: colors.textMuted,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                // Icon-only: a subtle secondary action that doesn't visually
                // compete with Send for width or attention.
                const IconButton(
                  tooltip: 'AI Assist — coming in a later phase',
                  icon: Icon(Icons.auto_awesome_outlined, size: 16),
                  onPressed: null,
                ),
                const SizedBox(width: AppSpacing.xs),
                Tooltip(
                  message: _internalNote
                      ? 'Internal notes are coming in a later stage'
                      : 'Send',
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _hasText && !_internalNote
                            ? colors.primary
                            : colors.textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.send_rounded, size: 17),
                        color: Colors.white,
                        onPressed: _hasText && !_internalNote ? _send : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reply / Internal Note tabs — purely local UI state (see
/// [_MessageComposerState._internalNote]'s doc comment for why Internal
/// Note disables Send instead of quietly sending a real message under a
/// misleading label).
class _ComposerTabs extends StatelessWidget {
  const _ComposerTabs({required this.internalNote, required this.onChanged});

  final bool internalNote;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ComposerTab(
          label: 'Reply',
          selected: !internalNote,
          onTap: () => onChanged(false),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: _ComposerTab(
            label: 'Internal Note',
            selected: internalNote,
            onTap: () => onChanged(true),
          ),
        ),
      ],
    );
  }
}

class _ComposerTab extends StatelessWidget {
  const _ComposerTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? colors.primary : colors.textMuted,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 2,
              width: 20,
              color: selected ? colors.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
