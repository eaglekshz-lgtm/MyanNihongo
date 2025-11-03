import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../../data/providers/bookmark_providers.dart';
import '../widgets/home_feature_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularyAsync = ref.watch(allVocabularyProvider);
    final progressAsync = ref.watch(allUserProgressProvider);
    final bookmarkCountAsync = ref.watch(bookmarkCountProvider);

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
                          _StatsSection(
                            vocabularyAsync: vocabularyAsync,
                            progressAsync: progressAsync,
                            bookmarkCountAsync: bookmarkCountAsync,
                          ),
                          const SizedBox(height: 36),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.secondaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      AppTheme.secondaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: AppTheme.secondaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Start Learning',
                                style: AppTheme.headlineMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
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
        _HeaderGradientContainer(
          statusBarHeight: statusBarHeight,
          hour: hour,
        ),
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
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.85),
            AppTheme.secondaryColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, statusBarHeight + 16, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _WavingHandIcon(),
                _TimeBasedGreetingBadge(hour: hour),
              ],
            ),
            const SizedBox(height: 24),
            const _WelcomeTitle(),
            const SizedBox(height: 12),
            const _WelcomeSubtitle(),
          ],
        ),
      ),
    );
  }
}

/// Waving hand icon - const for no rebuilds
class _WavingHandIcon extends StatelessWidget {
  const _WavingHandIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.waving_hand,
        color: Colors.white,
        size: 32,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
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

/// Welcome title - const for no rebuilds
class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome Back!',
      style: AppTheme.headlineLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 36,
        letterSpacing: -0.5,
      ),
    );
  }
}

/// Welcome subtitle - const for no rebuilds
class _WelcomeSubtitle extends StatelessWidget {
  const _WelcomeSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ready to continue your Japanese learning journey?',
      style: AppTheme.bodyLarge.copyWith(
        color: Colors.white.withValues(alpha: 0.95),
        height: 1.6,
        fontSize: 16,
      ),
    );
  }
}

/// Stats section with async data handling
class _StatsSection extends StatelessWidget {
  final AsyncValue vocabularyAsync;
  final AsyncValue progressAsync;
  final AsyncValue<int> bookmarkCountAsync;

  const _StatsSection({
    required this.vocabularyAsync,
    required this.progressAsync,
    required this.bookmarkCountAsync,
  });

  @override
  Widget build(BuildContext context) {
    return vocabularyAsync.when(
      data: (vocabulary) => progressAsync.when(
        data: (progress) => bookmarkCountAsync.when(
          data: (bookmarkCount) => _StatsGrid(
            totalWords: vocabulary.length,
            learnedWords: progress.length,
            bookmarkedWords: bookmarkCount,
          ),
          loading: () => _StatsGrid(
            totalWords: vocabulary.length,
            learnedWords: progress.length,
            bookmarkedWords: 0,
          ),
          error: (_, __) => _StatsGrid(
            totalWords: vocabulary.length,
            learnedWords: progress.length,
            bookmarkedWords: 0,
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _StatsGrid(
          totalWords: 0,
          learnedWords: 0,
          bookmarkedWords: 0,
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          const _StatsGrid(totalWords: 0, learnedWords: 0, bookmarkedWords: 0),
    );
  }
}

/// Modern stats grid with better visual design
class _StatsGrid extends StatelessWidget {
  final int totalWords;
  final int learnedWords;
  final int bookmarkedWords;

  const _StatsGrid({
    required this.totalWords,
    required this.learnedWords,
    required this.bookmarkedWords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.2),
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.trending_up,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Your Progress',
              style: AppTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ModernStatCard(
                icon: Icons.book_rounded,
                label: 'Total',
                value: totalWords.toString(),
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModernStatCard(
                icon: Icons.check_circle_rounded,
                label: 'Learned',
                value: learnedWords.toString(),
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModernStatCard(
                icon: Icons.bookmark_rounded,
                label: 'Saved',
                value: bookmarkedWords.toString(),
                color: const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Modern compact stat card with enhanced visuals
class _ModernStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ModernStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w700,
              fontSize: 12,
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
          onTap: () => Navigator.pushNamed(context, RouteNames.bookmarkedVocabulary),
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
