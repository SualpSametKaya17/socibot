import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';

/// A CRM-style composer anchored at the bottom of the conversation
/// workspace: a utility row (attachment/emoji/saved-reply/AI-assist),
/// the text input, and a send button gated on non-empty text.
///
/// Attachment/emoji are wired for real (pick a file, insert an emoji);
/// nothing is uploaded or persisted — that's the send-message Edge
/// Function's job (AŞAMA 13). "Saved reply" and "AI Assist" are
/// presentation-only placeholders — no such feature exists yet.
class MessageComposer extends StatefulWidget {
  const MessageComposer({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  String? _attachedFileName;
  bool _hasText = false;

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
  }

  @override
  void dispose() {
    _controller.dispose();
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
            _controller.text += emoji.emoji;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
            Row(
              children: [
                Expanded(
                  child: _ComposerTabs(
                    internalNote: _internalNote,
                    onChanged: (value) => setState(() => _internalNote = value),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Tooltip(
                    message: 'Tickets are coming in a later stage',
                    child: TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        minimumSize: const Size(0, 28),
                      ),
                      child: const Text(
                        'Create Ticket',
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (_attachedFileName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: InputChip(
                  avatar: const Icon(Icons.attach_file, size: 14),
                  label: Text(_attachedFileName!),
                  onDeleted: () => setState(() => _attachedFileName = null),
                ),
              ),
            TextField(
              controller: _controller,
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
                const Spacer(),
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
