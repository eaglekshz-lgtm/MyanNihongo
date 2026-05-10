import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';

class QuizResultScoreCircle extends StatelessWidget {
  const QuizResultScoreCircle({
    super.key,
    required this.animation,
    required this.scorePercentage,
    required this.isPassed,
  });

  final Animation<double> animation;
  final int scorePercentage;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scoreColor = isPassed ? cs.success : cs.warning;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withValues(
                        alpha: isPassed ? 0.2 : 0.15,
                      ),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      cs.surface,
                      cs.surfaceContainerHighest.withValues(alpha: 0.5),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.fixedBlack.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: scoreColor.withValues(alpha: 0.1),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: animation.value * (scorePercentage / 100),
                    color: scoreColor,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(animation.value * scorePercentage).round()}%',
                    style: AppTheme.headlineLarge.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                  Text(
                    'Your Score',
                    style: AppTheme.bodySmall.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              if (isPassed) _CelebrationBadge(color: cs.success),
            ],
          ),
        );
      },
    );
  }
}

class QuizResultMessageCard extends StatelessWidget {
  const QuizResultMessageCard({
    super.key,
    required this.isPassed,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.animation,
  });

  final bool isPassed;
  final int correctAnswers;
  final int totalQuestions;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = isPassed ? cs.success : cs.warning;

    return FadeTransition(
      opacity: animation,
      child: GlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        tintColor: statusColor,
        tintOpacity: 0.10,
        borderColor: statusColor.withValues(alpha: 0.40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPassed ? Icons.emoji_events : Icons.fitness_center,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    isPassed ? 'Excellent Work!' : 'Keep Going!',
                    style: AppTheme.titleLarge.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isPassed
                  ? 'You\'ve mastered this quiz!'
                  : 'Practice makes perfect!',
              style: AppTheme.bodyMedium.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _CorrectAnswersBadge(
              color: statusColor,
              correctAnswers: correctAnswers,
              totalQuestions: totalQuestions,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResultInsightsHeader extends StatelessWidget {
  const QuizResultInsightsHeader({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return FadeTransition(
      opacity: animation,
      child: Row(
        children: [
          const Expanded(
            child: _DividerGradient(alignment: _GradientEdge.left),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Performance Insights',
                  style: AppTheme.titleMedium.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: _DividerGradient(alignment: _GradientEdge.right),
          ),
        ],
      ),
    );
  }
}

class QuizResultStatistics extends StatelessWidget {
  const QuizResultStatistics({
    super.key,
    required this.animation,
    required this.scorePercentage,
    required this.isPassed,
    this.level,
  });

  final Animation<double> animation;
  final int scorePercentage;
  final bool isPassed;
  final String? level;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = isPassed ? cs.success : cs.warning;

    return FadeTransition(
      opacity: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (level != null) ...[
            QuizResultStatisticCard(
              icon: Icons.school_rounded,
              label: 'Difficulty Level',
              value: level!.toUpperCase(),
              color: cs.primary,
            ),
            const SizedBox(height: 12),
          ],
          QuizResultStatisticCard(
            icon: Icons.trending_up_rounded,
            label: 'Accuracy Rate',
            value: '$scorePercentage%',
            color: statusColor,
          ),
        ],
      ),
    );
  }
}

class QuizResultActionBar extends StatelessWidget {
  const QuizResultActionBar({
    super.key,
    required this.animation,
    required this.onRetakeQuiz,
    required this.onBackHome,
  });

  final Animation<double> animation;
  final VoidCallback onRetakeQuiz;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      borderRadius: BorderRadius.zero,
      tintOpacity: cs.quizResultBottomTintOpacity,
      borderColor: cs.fixedWhite.withValues(alpha: 0.15),
      borderWidth: 1,
      shadow: false,
      child: SafeArea(
        top: false,
        child: FadeTransition(
          opacity: animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ResultActionButton(
                icon: Icons.refresh_rounded,
                label: 'Take Another Quiz',
                onPressed: onRetakeQuiz,
                isPrimary: true,
              ),
              const SizedBox(height: 10),
              _ResultActionButton(
                icon: Icons.home_rounded,
                label: 'Back to Home',
                onPressed: onBackHome,
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizResultStatisticCard extends StatelessWidget {
  const QuizResultStatisticCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: cs.fixedBlack.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.bodySmall.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTheme.titleLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CelebrationBadge extends StatelessWidget {
  const _CelebrationBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -5,
      right: -5,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events,
                color: Theme.of(context).colorScheme.fixedWhite,
                size: 22,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CorrectAnswersBadge extends StatelessWidget {
  const _CorrectAnswersBadge({
    required this.color,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  final Color color;
  final int correctAnswers;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            '$correctAnswers/$totalQuestions',
            style: AppTheme.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'correct',
            style: AppTheme.bodySmall.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultActionButton extends StatelessWidget {
  const _ResultActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final foreground = isPrimary ? cs.fixedWhite : cs.primary;

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: isPrimary ? null : cs.surface,
        gradient: isPrimary
            ? LinearGradient(
                colors: [cs.primary, cs.primary.withValues(alpha: 0.85)],
              )
            : null,
        borderRadius: BorderRadius.circular(14),
        border: isPrimary
            ? null
            : Border.all(color: cs.primary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? cs.primary.withValues(alpha: 0.25)
                : cs.fixedBlack.withValues(alpha: 0.04),
            blurRadius: isPrimary ? 10 : 6,
            offset: Offset(0, isPrimary ? 4 : 2),
          ),
        ],
      ),
      child: Material(
        color: cs.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foreground, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTheme.titleMedium.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _GradientEdge { left, right }

class _DividerGradient extends StatelessWidget {
  const _DividerGradient({required this.alignment});

  final _GradientEdge alignment;

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.transparent,
      Theme.of(context).dividerColor.withValues(alpha: 0.2),
    ];

    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: alignment == _GradientEdge.left
              ? colors
              : colors.reversed.toList(),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
