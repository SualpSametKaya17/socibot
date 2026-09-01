import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

/// Wraps [child] with a subtle "lift" on hover — a small scale-up plus a
/// soft shadow — the kind of micro-interaction modern SaaS dashboards use
/// on clickable cards. No-ops on touch input: [MouseRegion] only ever
/// reports hover on mouse/trackpad, so this is a desktop/web-only touch.
class HoverLift extends StatefulWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.lgAll,
    this.scale = 1.015,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double scale;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.scale : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
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
