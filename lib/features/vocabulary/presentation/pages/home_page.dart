import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../data/providers/streak_provider.dart';
import '../../data/providers/srs_provider.dart';
import '../widgets/home_feature_card.dart';
import '../widgets/streak_card_widget.dart';
import '../widgets/srs_stats_widget.dart';
import 'srs_review_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Check streak status when home page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userStreakProvider.notifier).checkStreakStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Welcome Header - extends to top of screen
          const _WelcomeHeader(),
          // Main content with SafeArea
          Expanded(
            child: SafeArea(
              top:
                  false, // Don't add safe area padding at top since header handles it
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Streak Card
                          const StreakCardWidget(),
                          const SizedBox(height: 20),

                          // SRS Stats Widget
                          const SRSStatsWidget(),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.secondaryColor,
                                      AppTheme.secondaryColor.withValues(
                                        alpha: 0.85,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.secondaryColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Start Learning',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                      fontSize: 20,
                                      letterSpacing: -0.3,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Consumer(
                            builder: (context, ref, child) {
                              final stats = ref.watch(srsStatsProvider);

                              if (stats.dueCards > 0) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 24),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SRSReviewPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.red.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.fact_check, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Review ${stats.dueCards} Cards Now',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                          const _FeaturesSection(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern welcome header with gradient background and decorative elements
/// Separated into smaller widgets to prevent unnecessary rebuilds
class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    // Get the status bar height for proper padding
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final hour = DateTime.now().hour;

    return Stack(
      children: [
        // Main gradient container
        _HeaderGradientContainer(statusBarHeight: statusBarHeight, hour: hour),
        // Decorative circles for visual interest (const for no rebuilds)
        const _DecorativeCircle(size: 100, right: -20, top: 40, alpha: 0.1),
        const _DecorativeCircle(size: 60, right: 40, top: -10, alpha: 0.08),
      ],
    );
  }
}

/// Decorative circle widget - const for optimization
class _DecorativeCircle extends StatelessWidget {
  final double size;
  final double right;
  final double top;
  final double alpha;

  const _DecorativeCircle({
    required this.size,
    required this.right,
    required this.top,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}

/// Header gradient container separated for better organization
class _HeaderGradientContainer extends StatelessWidget {
  final double statusBarHeight;
  final int hour;

  const _HeaderGradientContainer({
    required this.statusBarHeight,
    required this.hour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, statusBarHeight + 20, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.waving_hand,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                _TimeBasedGreetingBadge(hour: hour),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 32,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ready to continue your Japanese learning journey?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// Time-based greeting badge - only rebuilds when hour changes
class _TimeBasedGreetingBadge extends StatelessWidget {
  final int hour;

  const _TimeBasedGreetingBadge({required this.hour});

  String get _greeting {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  IconData get _timeIcon {
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 17) return Icons.wb_sunny_outlined;
    return Icons.nightlight_round;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(_timeIcon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            _greeting,
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}



/// Features section (const, never rebuilds)
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeFeatureCard(
          icon: Icons.style,
          title: 'Vocabulary Cards',
          description: 'Learn with swipeable flashcards',
          color: AppTheme.primaryColor,
          onTap: () => Navigator.pushNamed(context, RouteNames.levelSelection),
        ),
        const SizedBox(height: 12),
        HomeFeatureCard(
          icon: Icons.quiz,
          title: 'Take a Quiz',
          description: 'Test your knowledge',
          color: AppTheme.secondaryColor,
          onTap: () => Navigator.pushNamed(context, RouteNames.quizSetup),
        ),
        const SizedBox(height: 12),
        HomeFeatureCard(
          icon: Icons.bookmark,
          title: 'Bookmarked Words',
          description: 'Review your saved vocabulary',
          color: const Color(0xFFE53935),
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.bookmarkedVocabulary),
        ),
        const SizedBox(height: 12),
        HomeFeatureCard(
          icon: Icons.insights,
          title: 'Progress Tracking',
          description: 'View your learning statistics',
          color: AppTheme.successColor,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Coming soon!'))),
        ),
      ],
    );
  }
}
