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
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_attachedFileName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: InputChip(
                  avatar: const Icon(Icons.attach_file, size: 14),
                  label: Text(_attachedFileName!),
                  onDeleted: () => setState(() => _attachedFileName = null),
                ),
              ),
            Row(
              children: [
                IconButton(
                  tooltip: 'Attach a file',
                  icon: const Icon(Icons.attach_file_outlined, size: 20),
                  onPressed: _pickAttachment,
                ),
                IconButton(
                  tooltip: 'Emoji',
                  icon: const Icon(Icons.emoji_emotions_outlined, size: 20),
                  onPressed: _pickEmoji,
                ),
                IconButton(
                  tooltip: 'Saved replies (coming soon)',
                  icon: const Icon(Icons.bolt_outlined, size: 20),
                  onPressed: null,
                ),
                const Spacer(),
                Tooltip(
                  message: 'AI Assist — coming in a later phase',
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.auto_awesome_outlined, size: 16),
                    label: const Text('AI Assist'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: _hasText
                        ? colors.primary
                        : colors.textMuted.withValues(alpha: 0.3),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: IconButton(
                    tooltip: 'Send',
                    icon: const Icon(Icons.send_rounded, size: 18),
                    color: Colors.white,
                    onPressed: _hasText ? _send : null,
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
