import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Simple feature card for home page navigation
class HomeFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const HomeFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
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
          child: Row(
            children: [
              _FeatureIcon(icon: icon, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: _FeatureInfo(
                  title: title,
                  description: description,
                  color: color,
                ),
              ),
              _FeatureArrow(color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature icon container with shadow
class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _FeatureIcon({
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

/// Feature title and description with color
class _FeatureInfo extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _FeatureInfo({
    required this.title,
    required this.description,
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
        Text(
          description,
          style: AppTheme.bodyMedium.copyWith(
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Arrow indicator with color
class _FeatureArrow extends StatelessWidget {
  final Color color;

  const _FeatureArrow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward,
      color: color,
      size: 20,
    );
  }
}
