import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable learning mode card widget
class LearningModeCard extends StatelessWidget {
  final String mode;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> features;
  final VoidCallback onTap;

  const LearningModeCard({
    super.key,
    required this.mode,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ModeCardHeader(icon: icon, title: title, color: color),
              const SizedBox(height: 16),
              _ModeCardDescription(description: description),
              const SizedBox(height: 16),
              _ModeCardFeatures(features: features, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mode card header with icon and title
class _ModeCardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ModeCardHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ModeCardIcon(icon: icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: _ModeCardTitle(title: title, color: color),
        ),
      ],
    );
  }
}

/// Icon container for mode card
class _ModeCardIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ModeCardIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

/// Title section for mode card
class _ModeCardTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _ModeCardTitle({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.arrow_forward,
          color: color,
          size: 20,
        ),
      ],
    );
  }
}

/// Description text for mode card
class _ModeCardDescription extends StatelessWidget {
  final String description;

  const _ModeCardDescription({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: AppTheme.bodyMedium.copyWith(
        color: Colors.grey[700],
        height: 1.5,
      ),
    );
  }
}

/// Features list for mode card
class _ModeCardFeatures extends StatelessWidget {
  final List<String> features;
  final Color color;

  const _ModeCardFeatures({
    required this.features,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features
          .map((feature) => _FeatureItem(feature: feature, color: color))
          .toList(),
    );
  }
}

/// Individual feature item
class _FeatureItem extends StatelessWidget {
  final String feature;
  final Color color;

  const _FeatureItem({
    required this.feature,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: AppTheme.bodySmall.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
