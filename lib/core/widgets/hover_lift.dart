import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

/// Wraps [child] with a "lift" on hover — a scale-up plus a soft shadow
/// (optionally tinted, e.g. with the card's own brand color for a subtle
/// glow) — the kind of micro-interaction modern SaaS dashboards use on
/// clickable cards. No-ops on touch input: [MouseRegion] only ever
/// reports hover on mouse/trackpad, so this is a desktop/web-only touch.
class HoverLift extends StatefulWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.lgAll,
    this.scale = 1.02,
    this.glowColor,
    this.cursor = SystemMouseCursors.click,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double scale;

  /// Shadow color while hovered — defaults to a plain soft black shadow;
  /// pass a card's own brand/accent color for a tinted glow instead.
  final Color? glowColor;
  final MouseCursor cursor;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final shadowColor = widget.glowColor ?? Colors.black;

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.scale : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: shadowColor.withValues(
                        alpha: widget.glowColor != null ? 0.22 : 0.12,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
