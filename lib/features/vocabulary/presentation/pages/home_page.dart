import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../data/providers/streak_provider.dart';
import '../widgets/home_feature_card.dart';
import '../widgets/streak_card_widget.dart';

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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.homeScaffold,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Scrollable gradient background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 450, // Height of the gradient area
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: cs.homeGradientColors,
                    stops: cs.homeGradientStops,
                  ),
                ),
              ),
            ),
            // The actual content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _WelcomeHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Streak Card
                      const StreakCardWidget(),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cs.homeSectionIconSurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '🎒',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Start Learning',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 20,
                                  letterSpacing: -0.3,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _FeaturesSection(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final hour = DateTime.now().hour;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.fixedWhite.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.fixedWhite.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Text('👋', style: TextStyle(fontSize: 20)),
              ),
              _TimeBasedGreetingBadge(hour: hour),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Welcome\nBack! 🎌',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.fixedWhite,
              fontWeight: FontWeight.w800,
              fontSize: 36,
              letterSpacing: -1.0,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ready to continue your Japanese journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.fixedWhite.withValues(alpha: 0.85),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBasedGreetingBadge extends StatelessWidget {
  final int hour;

  const _TimeBasedGreetingBadge({required this.hour});

  String get _greeting {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.fixedWhite.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.fixedWhite.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.amberAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _greeting,
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.fixedWhite,
              fontWeight: FontWeight.w700,
              fontSize: 13,
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
          color: Theme.of(context).colorScheme.primary,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pushNamed(context, RouteNames.levelSelection);
          },
        ),
        const SizedBox(height: 12),
        HomeFeatureCard(
          icon: Icons.quiz,
          title: 'Take a Quiz',
          description: 'Test your knowledge',
          color: Theme.of(context).colorScheme.secondary,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pushNamed(context, RouteNames.quizSetup);
          },
        ),
        const SizedBox(height: 12),
        HomeFeatureCard(
          icon: Icons.bookmark,
          title: 'Bookmarks',
          description: 'Review your saved vocabulary',
          color: Theme.of(context).colorScheme.error,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pushNamed(context, RouteNames.bookmarkedVocabulary);
          },
        ),
        const SizedBox(height: 12),
        HomeFeatureCard(
          icon: Icons.insights,
          title: 'Progress Tracking',
          description: 'View your learning statistics',
          color: Theme.of(context).colorScheme.success,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Coming soon!'))),
        ),
      ],
    );
  }
}
