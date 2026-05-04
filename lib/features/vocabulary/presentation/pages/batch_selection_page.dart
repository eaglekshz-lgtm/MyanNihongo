import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../arguments/batch_selection_args.dart';
import '../../../../arguments/vocabulary_learning_args.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../../data/models/block_progress_model.dart';
import '../../../../core/widgets/mesh_background.dart';

class BatchSelectionPage extends ConsumerWidget {
  const BatchSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BatchSelectionArgs?;
    final level = args?.level ?? 'N5';
    final learningMode = args?.learningMode ?? CardStyle.recallMode.code;
    final blockSize = args?.blockSize ?? 50;

    final vocabularyCountAsync = ref.watch(
      vocabularyCountByLevelProvider(level),
    );

    ref.watch(prefetchVocabularyProvider(level));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '${level.toUpperCase()} Vocabulary',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.fixedWhite.withValues(alpha: 0.1)
                    : Theme.of(
                        context,
                      ).colorScheme.fixedBlack.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      body: MeshBackground(
        child: vocabularyCountAsync.when(
          data: (totalWords) {
            if (totalWords == 0) {
              return const Center(child: Text('No vocabulary items available'));
            }

            final totalBlocks = (totalWords / blockSize).ceil();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopBannerCard(
                        totalWords: totalWords,
                        totalBlocks: totalBlocks,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                        child: Text(
                          'YOUR PROGRESS',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  sliver: _BlocksGridWithProgress(
                    level: level,
                    totalBlocks: totalBlocks,
                    blockSize: blockSize,
                    totalWords: totalWords,
                    learningMode: learningMode,
                    onNavigate: (ctx, startIndex, count) => _navigateToLearning(
                      ctx,
                      ref,
                      level,
                      learningMode,
                      startIndex,
                      count,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Error loading vocabulary', style: AppTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: AppTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToLearning(
    BuildContext context,
    WidgetRef ref,
    String level,
    String learningMode,
    int startIndex,
    int count,
  ) async {
    try {
      final repository = ref.read(vocabularyRepositoryProvider);
      final cachedData = await repository.getAllVocabulary();
      final hasLevelData = cachedData
          .where((v) => v.tag.toUpperCase() == level.toUpperCase())
          .isNotEmpty;

      if (!hasLevelData) {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        }

        await repository.getVocabularyByLevelWithRange(
          level,
          startIndex,
          count,
        );

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          RouteNames.vocabularyLearning,
          arguments: VocabularyLearningArgs(
            level: level,
            wordType: null,
            learningMode: learningMode,
            startIndex: startIndex,
            batchSize: count,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load vocabulary: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _BlocksGridWithProgress extends ConsumerWidget {
  final String level;
  final int totalBlocks;
  final int blockSize;
  final int totalWords;
  final String learningMode;
  final void Function(BuildContext, int, int) onNavigate;

  const _BlocksGridWithProgress({
    required this.level,
    required this.totalBlocks,
    required this.blockSize,
    required this.totalWords,
    required this.learningMode,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockProgressAsync = ref.watch(
      blockProgressProvider((level: level, wordType: null)),
    );

    return blockProgressAsync.when(
      data: (progressList) {
        final progressMap = {
          for (var progress in progressList) progress.blockNumber: progress,
        };

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final blockNumber = index + 1;
            final startIndex = index * blockSize;
            final endIndex = (startIndex + blockSize > totalWords)
                ? totalWords
                : startIndex + blockSize;
            final wordsInBlock = endIndex - startIndex;

            final blockProgress = progressMap[blockNumber];

            final prevCompleted = blockNumber == 1
                ? true
                : (progressMap[blockNumber - 1]?.isCompleted ?? false);

            return _BlockCard(
              blockNumber: blockNumber,
              startIndex: startIndex,
              wordCount: wordsInBlock,
              totalWords: totalWords,
              progress: blockProgress,
              isLocked: !prevCompleted,
              onTap: () => onNavigate(context, startIndex, wordsInBlock),
            );
          }, childCount: totalBlocks),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final blockNumber = index + 1;
          final startIndex = index * blockSize;
          final endIndex = (startIndex + blockSize > totalWords)
              ? totalWords
              : startIndex + blockSize;
          final wordsInBlock = endIndex - startIndex;

          return _BlockCard(
            blockNumber: blockNumber,
            startIndex: startIndex,
            wordCount: wordsInBlock,
            totalWords: totalWords,
            progress: null,
            onTap: () => onNavigate(context, startIndex, wordsInBlock),
          );
        }, childCount: totalBlocks),
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final int blockNumber;
  final int startIndex;
  final int wordCount;
  final int totalWords;
  final BlockProgressModel? progress;
  final VoidCallback onTap;
  final bool isLocked;

  const _BlockCard({
    required this.blockNumber,
    required this.startIndex,
    required this.wordCount,
    required this.totalWords,
    this.progress,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress?.isCompleted ?? false;
    final progressValue = progress?.progress ?? 0.0;
    final hasProgress = progress != null && progressValue > 0 && !isCompleted;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color borderColor;
    Color circleBgColor;
    Color circleTextColor;
    Color badgeBgColor;
    Color badgeIconColor;
    Color titleColor;
    Color subtitleColor;

    if (isLocked) {
      bgColor = Theme.of(context).colorScheme.batchLockedSurface;
      borderColor = Theme.of(context).colorScheme.batchLockedContainer;
      circleBgColor = Theme.of(context).colorScheme.batchLockedCircle;
      circleTextColor = Theme.of(context).colorScheme.batchLockedText;
      badgeBgColor = circleBgColor;
      badgeIconColor = circleTextColor;
      titleColor = Theme.of(context).colorScheme.batchLockedTitle;
      subtitleColor = Theme.of(context).colorScheme.batchLockedText;
    } else if (isCompleted) {
      bgColor = Theme.of(context).colorScheme.batchCompletedSurface;
      borderColor = Theme.of(context).colorScheme.batchCompletedOutline;
      circleBgColor = Theme.of(context).colorScheme.batchCompletedContainer;
      circleTextColor = Theme.of(context).colorScheme.batchCompletedForeground;
      badgeBgColor = Theme.of(context).colorScheme.batchCompletedBadge;
      badgeIconColor = Theme.of(context).colorScheme.fixedWhite;
      titleColor = Theme.of(context).colorScheme.onSurface;
      subtitleColor = Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.5);
    } else {
      bgColor = Theme.of(context).colorScheme.batchActiveSurface;
      borderColor = Theme.of(context).colorScheme.batchActiveOutline;
      circleBgColor = Theme.of(context).colorScheme.batchActiveContainer;
      circleTextColor = Theme.of(context).colorScheme.batchActiveForeground;
      badgeBgColor = circleBgColor;
      badgeIconColor = circleTextColor;
      titleColor = Theme.of(context).colorScheme.onSurface;
      subtitleColor = Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.5);
    }

    return Material(
      color: Theme.of(context).colorScheme.transparent,
      child: InkWell(
        onTap: isLocked
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Complete previous block to unlock this one',
                      style: TextStyle(
                        color: isDark
                            ? Theme.of(context).colorScheme.fixedWhite
                            : Theme.of(context).colorScheme.fixedBlack,
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isDark
                        ? Theme.of(context).colorScheme.learningDarkElevated
                        : Theme.of(context).colorScheme.fixedWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                );
              }
            : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: circleBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$blockNumber',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: circleTextColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  if (isLocked || isCompleted)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: bgColor, width: 2),
                        ),
                        child: Icon(
                          isLocked ? Icons.lock_rounded : Icons.check_rounded,
                          color: badgeIconColor,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Block $blockNumber',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$wordCount words',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).colorScheme.batchCompletedContainer
                        : Theme.of(context).colorScheme.batchCompletedContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${progress?.completionCount ?? 1}× done',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? Theme.of(
                              context,
                            ).colorScheme.batchCompletedForeground
                          : Theme.of(
                              context,
                            ).colorScheme.batchCompletedForeground,
                    ),
                  ),
                )
              else if (hasProgress)
                Column(
                  children: [
                    Container(
                      height: 4,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: circleBgColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            circleTextColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(progressValue * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: circleTextColor,
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isLocked
                        ? (isDark
                              ? Theme.of(context).colorScheme.neutral800
                              : Theme.of(
                                  context,
                                ).colorScheme.batchLockedContainer)
                        : circleBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${startIndex + 1}-${startIndex + wordCount}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? (isDark
                                ? Theme.of(context).colorScheme.neutral400
                                : Theme.of(context).colorScheme.batchLockedText)
                          : circleTextColor,
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

class _TopBannerCard extends StatelessWidget {
  final int totalWords;
  final int totalBlocks;

  const _TopBannerCard({required this.totalWords, required this.totalBlocks});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  colorScheme.primary.withValues(alpha: 0.8),
                  colorScheme.primary.withValues(alpha: 0.4),
                ]
              : [
                  colorScheme.bannerGradientStart,
                  colorScheme.bannerGradientEnd,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(
                  context,
                ).colorScheme.fixedWhite.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            right: 80,
            bottom: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(
                  context,
                ).colorScheme.fixedWhite.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.fixedWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        color: Theme.of(context).colorScheme.fixedWhite,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'SELECT BLOCK',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.fixedWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose a Block to Study',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.fixedWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalWords words available · $totalBlocks total blocks',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.fixedWhite.withValues(alpha: 0.8),
                    fontSize: 14,
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
