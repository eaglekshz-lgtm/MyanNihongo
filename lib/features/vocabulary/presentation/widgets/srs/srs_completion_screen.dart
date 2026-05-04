import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class SRSCompletionScreen extends StatelessWidget {
  final int totalReviewed;
  final VoidCallback onBack;

  const SRSCompletionScreen({
    super.key,
    required this.totalReviewed,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final successColor = Theme.of(context).colorScheme.success;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review Complete',
          style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: onBack,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [successColor, successColor.withValues(alpha: 0.8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: successColor.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Theme.of(context).colorScheme.fixedWhite,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Great job!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'You reviewed $totalReviewed cards',
                style: TextStyle(
                  fontSize: 20,
                  color: cs.onSurface.withValues(alpha: 0.75),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your progress has been saved',
                style: TextStyle(
                  fontSize: 16,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),

              const SizedBox(height: 48),

              if (totalReviewed >= 10)
                _buildAchievementBadge(context, '🔥', '10+ Cards'),
              if (totalReviewed >= 25)
                _buildAchievementBadge(context, '⭐', '25+ Cards'),
              if (totalReviewed >= 50)
                _buildAchievementBadge(context, '🏆', '50+ Cards'),

              const SizedBox(height: 48),

              _buildActionButton(
                context,
                'Review More',
                Icons.refresh,
                cs.primary,
                onBack,
              ),

              const SizedBox(height: 16),

              _buildActionButton(
                context,
                'Back to Home',
                Icons.home,
                cs.surfaceContainerHigh,
                () => Navigator.of(context).popUntil((route) => route.isFirst),
                foreground: cs.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    String emoji,
    String text,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    Color? foreground,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor:
              foreground ?? Theme.of(context).colorScheme.fixedWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
