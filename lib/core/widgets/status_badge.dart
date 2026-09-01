import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';
import '../constants/status_tone.dart';
import 'app_badge.dart';

/// Small colored pill for any status label (conversation status today;
/// channel/message status later), styled by [StatusTone] rather than a
/// specific feature's enum.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = switch (tone) {
      StatusTone.success => colors.success,
      StatusTone.warning => colors.warning,
      StatusTone.danger => colors.error,
      StatusTone.info => colors.primary,
      StatusTone.neutral => colors.textMuted,
    };

    return AppBadge(label: label, color: color);
  }
}
