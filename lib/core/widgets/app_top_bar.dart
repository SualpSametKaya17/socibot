import 'package:flutter/material.dart';

/// Thin wrapper over [AppBar] so every screen's top bar shares the same
/// height and styling instead of configuring [AppBar] ad hoc.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.title, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: false,
      actions: actions,
      toolbarHeight: preferredSize.height,
    );
  }
}
