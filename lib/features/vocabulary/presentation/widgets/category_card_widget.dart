import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable category card widget with icon, title and description
class CategoryCardWidget extends StatelessWidget {
  final String type;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCardWidget({
    super.key,
    required this.type,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  String get _title {
    switch (type) {
      case 'all':
        return 'All Words';
      case 'verb':
        return 'Verbs';
      case 'adjective':
        return 'Adjectives';
      case 'noun':
        return 'Nouns & Adverbs';
      case 'number':
        return 'Numbers';
      case 'day':
        return 'Days & Time';
      case 'counter':
        return 'Counters';
      default:
        return type;
    }
  }

  String get _description {
    switch (type) {
      case 'all':
        return 'Learn all vocabulary';
      case 'verb':
        return 'Action words';
      case 'adjective':
        return 'Descriptive words';
      case 'noun':
        return 'People, places, things, and manner words';
      case 'number':
        return 'Numbers and counting';
      case 'day':
        return 'Days, months, time';
      case 'counter':
        return 'Counting objects';
      default:
        return '';
    }
  }

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
              Container(
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
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: AppTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _description,
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: color,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
