import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';

/// A compact on/off switch, deliberately smaller than Material's default
/// [Switch] (which reserves a large mobile-scale touch target) so a
/// column of settings toggles reads as dense desktop SaaS chrome rather
/// than a mobile preferences screen.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canInteract = enabled && onChanged != null;

    return GestureDetector(
      onTap: canInteract ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: 34,
        height: 20,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: !enabled
              ? colors.textMuted.withValues(alpha: 0.15)
              : (value ? colors.primary : colors.borderStrong),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 16, height: 16),
        ),
      ),
    );
  }
}
