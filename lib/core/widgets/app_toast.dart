import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum ToastVariant { success, error, warning, info }

/// A flat, compact, stacked toast notification — the app's replacement
/// for ad hoc [ScaffoldMessenger]/[SnackBar] calls. Rendered in the root
/// [Overlay] (above dialogs/drawers), stacks up to [_maxVisible] at once
/// (oldest drops early past that), auto-dismisses per-toast, and pauses
/// its own timer while the pointer hovers it.
class AppToast {
  const AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    ToastVariant variant = ToastVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    _ToastOverlay.instance(context).show(
      _ToastEntry(
        message: message,
        variant: variant,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      ),
    );
  }
}

class _ToastEntry {
  _ToastEntry({
    required this.message,
    required this.variant,
    required this.duration,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final ToastVariant variant;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Stable per-entry identity for [AnimatedList]-free key-based removal.
  final Object key = Object();
}

/// One controller per root [Overlay] (effectively a singleton for the
/// whole app, since there's only one). Owns the single [OverlayEntry] that
/// renders every currently-visible toast, so adding/removing a toast is
/// just a list mutation + [OverlayEntry.markNeedsBuild] rather than
/// juggling one overlay entry per toast.
class _ToastOverlay {
  _ToastOverlay._();

  static _ToastOverlay? _instance;

  static _ToastOverlay instance(BuildContext context) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final controller = _instance ??= _ToastOverlay._();
    controller._ensureMounted(overlay);
    return controller;
  }

  static const _maxVisible = 3;

  final List<_ToastEntry> _entries = [];
  OverlayEntry? _overlayEntry;
  OverlayState? _mountedOverlay;

  void _ensureMounted(OverlayState overlay) {
    if (_overlayEntry != null && _mountedOverlay == overlay) return;
    // The overlay changed (e.g. a fresh widget tree between tests) — the
    // old entry belongs to a tree that's being torn down by the framework
    // already, so just drop the reference rather than removing it
    // ourselves, and mount a new one on the current overlay.
    _entries.clear();
    _mountedOverlay = overlay;
    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastStack(
        entries: List.unmodifiable(_entries),
        onDismiss: _dismiss,
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void show(_ToastEntry entry) {
    _entries.add(entry);
    while (_entries.length > _maxVisible) {
      _entries.removeAt(0);
    }
    _overlayEntry?.markNeedsBuild();
  }

  void _dismiss(_ToastEntry entry) {
    _entries.remove(entry);
    _overlayEntry?.markNeedsBuild();
  }
}

class _ToastStack extends StatelessWidget {
  const _ToastStack({required this.entries, required this.onDismiss});

  final List<_ToastEntry> entries;
  final ValueChanged<_ToastEntry> onDismiss;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: AppSpacing.lg,
      right: AppSpacing.lg,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ToastCard(
                  key: ValueKey(entry.key),
                  entry: entry,
                  onDismiss: () => onDismiss(entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({super.key, required this.entry, required this.onDismiss});

  final _ToastEntry entry;
  final VoidCallback onDismiss;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(widget.entry.duration, widget.onDismiss);
  }

  void _pauseTimer() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, tint) = switch (widget.entry.variant) {
      ToastVariant.success => (Icons.check_circle_outline, colors.success),
      ToastVariant.error => (Icons.error_outline, colors.error),
      ToastVariant.warning => (Icons.warning_amber_outlined, colors.warning),
      ToastVariant.info => (Icons.info_outline, colors.primary),
    };

    // Fixed 260-360px regardless of screen size would overflow off the
    // left edge on a narrow phone (the stack is only right/top-anchored)
    // — cap against the actual available width instead.
    final maxAvailable = MediaQuery.sizeOf(context).width - AppSpacing.lg * 2;
    final maxWidth = maxAvailable.clamp(200.0, 360.0);
    final minWidth = maxAvailable < 260 ? 0.0 : 260.0;

    return MouseRegion(
      onEnter: (_) => _pauseTimer(),
      onExit: (_) => _startTimer(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
        child: Material(
          color: colors.surface,
          borderRadius: AppRadius.mdAll,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 16, color: tint),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    widget.entry.message,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (widget.entry.actionLabel != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  InkWell(
                    borderRadius: AppRadius.smAll,
                    onTap: () {
                      widget.entry.onAction?.call();
                      widget.onDismiss();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        widget.entry.actionLabel!,
                        style: AppTypography.labelMedium.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: AppSpacing.xs),
                InkWell(
                  borderRadius: AppRadius.smAll,
                  onTap: widget.onDismiss,
                  child: Icon(Icons.close, size: 14, color: colors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
