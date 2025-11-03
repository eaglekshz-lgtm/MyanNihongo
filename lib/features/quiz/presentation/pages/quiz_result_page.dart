import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../domain/models/quiz_result_args.dart';

class QuizResultPage extends ConsumerStatefulWidget {
  const QuizResultPage({super.key});

  @override
  ConsumerState<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends ConsumerState<QuizResultPage>
    with SingleTickerProviderStateMixin {
  int? _totalQuestions;
  int? _correctAnswers;
  String? _level;
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_totalQuestions == null) {
      final args = ModalRoute.of(context)!.settings.arguments as QuizResultArgs?;
      _totalQuestions = args?.totalQuestions ?? 10;
      _correctAnswers = args?.correctAnswers ?? 0;
      _level = args?.level;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scorePercentage =
        ((_correctAnswers ?? 0) / (_totalQuestions ?? 10) * 100).round();
    final isPassed = scorePercentage >= 70;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Quiz Results',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isPassed
                ? [
                    AppTheme.successColor.withValues(alpha: 0.15),
                    const Color(0xFFFAFAFA),
                    const Color(0xFFFAFAFA),
                  ]
                : [
                    AppTheme.warningColor.withValues(alpha: 0.12),
                    const Color(0xFFFAFAFA),
                    const Color(0xFFFAFAFA),
                  ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              // Animated Score Circle with enhanced design
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow effect
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isPassed
                                    ? AppTheme.successColor.withValues(alpha: 0.2)
                                    : AppTheme.warningColor.withValues(alpha: 0.15),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        // Background circle with gradient
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.grey.shade50,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: isPassed
                                    ? AppTheme.successColor.withValues(alpha: 0.1)
                                    : AppTheme.warningColor.withValues(alpha: 0.1),
                                blurRadius: 15,
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: CustomPaint(
                            painter: _CircularProgressPainter(
                              progress: _scoreAnimation.value *
                                  (scorePercentage / 100),
                              color: isPassed
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor,
                            ),
                          ),
                        ),
                        // Score text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(_scoreAnimation.value * scorePercentage).round()}%',
                              style: AppTheme.headlineLarge.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: isPassed
                                    ? AppTheme.successColor
                                    : AppTheme.warningColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Your Score',
                              style: AppTheme.bodySmall.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        // Celebration badge
                        if (isPassed)
                          Positioned(
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
                                        colors: [
                                          AppTheme.successColor,
                                          AppTheme.successColor.withValues(alpha: 0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.successColor
                                              .withValues(alpha: 0.4),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Result message - Enhanced design with container
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Main message with icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? AppTheme.successColor.withValues(alpha: 0.15)
                                  : AppTheme.warningColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPassed ? Icons.emoji_events : Icons.fitness_center,
                              color: isPassed
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              isPassed ? 'Excellent Work!' : 'Keep Going!',
                              style: AppTheme.titleLarge.copyWith(
                                color: isPassed
                                    ? AppTheme.successColor
                                    : AppTheme.warningColor,
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
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Stats badge with enhanced design
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isPassed
                                ? [
                                    AppTheme.successColor.withValues(alpha: 0.15),
                                    AppTheme.successColor.withValues(alpha: 0.08),
                                  ]
                                : [
                                    AppTheme.warningColor.withValues(alpha: 0.15),
                                    AppTheme.warningColor.withValues(alpha: 0.08),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isPassed
                                ? AppTheme.successColor.withValues(alpha: 0.3)
                                : AppTheme.warningColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: isPassed
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$_correctAnswers/$_totalQuestions',
                              style: AppTheme.titleMedium.copyWith(
                                color: isPassed
                                    ? AppTheme.successColor
                                    : AppTheme.warningColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'correct',
                              style: AppTheme.bodySmall.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section Title with decorative line
              FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.grey.shade300,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Performance Insights',
                            style: AppTheme.titleMedium.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Modern Statistics Cards
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_level != null) ...[
                      // Level Card - Full width
                      _StatisticCard(
                        icon: Icons.school_rounded,
                        label: 'Difficulty Level',
                        value: _level!.toUpperCase(),
                        color: AppTheme.primaryColor,
                        gradient: [
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                          AppTheme.primaryColor.withValues(alpha: 0.05),
                        ],
                        isFullWidth: true,
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Accuracy Card - Full width
                    _StatisticCard(
                      icon: Icons.trending_up_rounded,
                      label: 'Accuracy Rate',
                      value: '$scorePercentage%',
                      color: isPassed
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                      gradient: isPassed
                          ? [
                              AppTheme.successColor.withValues(alpha: 0.1),
                              AppTheme.successColor.withValues(alpha: 0.05),
                            ]
                          : [
                              AppTheme.warningColor.withValues(alpha: 0.1),
                              AppTheme.warningColor.withValues(alpha: 0.05),
                            ],
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
                  ],
                ),
              ),
            ),

            // Fixed bottom buttons
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Primary button - Take Another Quiz
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withValues(alpha: 0.85),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppTheme.primaryColor.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Take Another Quiz',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Secondary button - Back to Home
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.home,
                              (route) => false,
                            );
                          },
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.home_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Back to Home',
                                  style: AppTheme.titleMedium.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

// Private Widget Classes

/// Modern statistic card widget with gradient background
class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.gradient,
    this.isFullWidth = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final List<Color> gradient;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: isFullWidth
          ? Row(
              children: [
                // Icon with enhanced circular background
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
                // Label and value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: AppTheme.titleLarge.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with enhanced circular background
                Container(
                  width: 44,
                  height: 44,
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
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 12),
                // Label
                Text(
                  label,
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Value
                Text(
                  value,
                  style: AppTheme.titleLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );
  }
}

/// Custom painter for circular progress indicator
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background circle
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
