import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
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
    final color = switch (tone) {
      StatusTone.success => AppColors.success,
      StatusTone.warning => AppColors.warning,
      StatusTone.danger => AppColors.danger,
      StatusTone.info => AppColors.info,
      StatusTone.neutral => Theme.of(context).colorScheme.outline,
    };

    return AppBadge(label: label, color: color);
  }
}
