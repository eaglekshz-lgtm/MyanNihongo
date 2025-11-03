import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

class LevelCard extends StatelessWidget {
  final String level;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? AppTheme.primaryColor
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                level,
                style: AppTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'JLPT Level',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}