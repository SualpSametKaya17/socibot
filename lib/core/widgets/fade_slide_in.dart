import 'package:flutter/material.dart';

/// A small entrance animation — fades and slides [child] up slightly the
/// first time it's built. Used for list rows and chat bubbles so content
/// eases in instead of just popping into place.
///
/// Runs once per widget lifetime (not on every rebuild), since it's
/// driven from [initState] — exactly what's wanted for list items that
/// are built lazily as they scroll into view or as new messages arrive.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 240),
    this.verticalOffset = 10,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double verticalOffset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _animation.value) * widget.verticalOffset),
          child: child,
        ),
      ),
    );
  }
}
