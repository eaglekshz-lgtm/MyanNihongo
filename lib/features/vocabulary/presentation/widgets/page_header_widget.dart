import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable page header widget with icon, title and subtitle
class PageHeaderWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const PageHeaderWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 64,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTheme.headlineMedium.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTheme.bodyMedium.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
