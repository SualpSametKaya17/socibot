import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_semantic_colors.dart';

/// The app's flat card surface — a bordered container with no shadow,
/// used in place of Material's default [Card] (which carries a soft
/// shadow via the app theme) wherever a screen wants the same crisp,
/// enterprise-flat look already established in the Inbox's detail
/// panels and Dashboard. Centralizing it here keeps that look
/// consistent as more screens adopt it, instead of each one hand-rolling
/// its own `Container` decoration.
class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// Set when [child] contains its own edge-to-edge content (e.g. a list
  /// of rows) that needs corners clipped to the card's radius.
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }
}
