import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_spacing.dart';

/// Thin wrapper over [AppBar] so every screen's top bar shares the same
/// height, subtle bottom border, and optional subtitle instead of
/// configuring [AppBar] ad hoc. Kept minimal per the shell's design
/// language — no oversized headers.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  final Widget title;
  final Widget? subtitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize =>
      Size.fromHeight(AppSizes.topBarHeight + (subtitle != null ? 18 : 0));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PreferredSize(
      preferredSize: preferredSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: subtitle == null
              ? title
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                      ),
                      child: subtitle!,
                    ),
                  ],
                ),
          centerTitle: false,
          actions: actions == null
              ? null
              : [...actions!, const SizedBox(width: AppSpacing.sm)],
          toolbarHeight: preferredSize.height,
        ),
      ),
    );
  }
}
