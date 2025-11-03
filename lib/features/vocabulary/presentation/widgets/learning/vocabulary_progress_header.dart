import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class VocabularyProgressHeader extends StatelessWidget {
  final int displayIndex;
  final int completedCount;
  final int totalCount;
  final String level;
  final bool highlightSuccess;
  final bool animate;
  final double? forcedProgress;

  const VocabularyProgressHeader({
    super.key,
    required this.displayIndex,
    required this.completedCount,
    required this.totalCount,
    required this.level,
    this.highlightSuccess = false,
    this.animate = false,
    this.forcedProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Use displayIndex for visual progress (shows current card position)
    // This ensures progress bar updates when going back
    final progress = forcedProgress ?? (displayIndex + 1) / totalCount;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressText(),
              _buildLevel(),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressBar(progress),
        ],
      ),
    );
  }

  Widget _buildProgressText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: '${displayIndex + 1}',
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 16,
            ),
          ),
          const TextSpan(text: ' / '),
          TextSpan(text: totalCount.toString()),
        ],
      ),
    );
  }

  Widget _buildLevel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return TweenAnimationBuilder<double>(
      duration: animate
          ? const Duration(milliseconds: 1500)
          : const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: progress),
      curve: animate ? Curves.easeOutCubic : Curves.easeInOut,
      builder: (context, value, _) {
        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: highlightSuccess
                      ? [
                          const Color(0xFF66BB6A),
                          const Color(0xFF43A047),
                        ]
                      : [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withValues(alpha: 0.8),
                        ],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      },
    );
  }
}