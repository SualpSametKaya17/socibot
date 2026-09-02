import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_semantic_colors.dart';

/// Circular avatar showing a profile image when available, otherwise the
/// initials derived from [name].
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 16,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          // A broken/unreachable image URL falls back to initials rather
          // than a blank or broken-image circle.
          errorWidget: (context, url, error) => _initials(context),
          placeholder: (context, url) => _initials(context),
        ),
      );
    }

    return _initials(context);
  }

  Widget _initials(BuildContext context) {
    final colors = context.colors;
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primarySoft,
      foregroundColor: colors.primary,
      child: Text(
        _initialsOf(name),
        style: TextStyle(fontSize: radius * 0.7, fontWeight: FontWeight.w600),
      ),
    );
  }

  static String _initialsOf(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';

    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
