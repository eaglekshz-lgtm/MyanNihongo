import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../arguments/batch_selection_args.dart';
import '../../../../arguments/vocabulary_learning_args.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../../data/models/block_progress_model.dart';
import '../widgets/page_header_widget.dart';

class BatchSelectionPage extends ConsumerWidget {
  const BatchSelectionPage({super.key});

  String _getAppBarTitle(String level) {
    return level.toUpperCase();
  }

  String _getSubtitle(int totalWords) {
    return '$totalWords words available';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BatchSelectionArgs?;
    final level = args?.level ?? 'N5';
    final learningMode = args?.learningMode ?? CardStyle.recallMode.code;
    final blockSize = args?.blockSize ?? 50;

    // Use count provider instead of fetching all data
    final vocabularyCountAsync = ref.watch(
      vocabularyCountByLevelProvider(level),
    );

    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle(level)), centerTitle: true),
      body: vocabularyCountAsync.when(
        data: (totalWords) {
          if (totalWords == 0) {
            return const Center(child: Text('No vocabulary items available'));
          }

          final totalBlocks = (totalWords / blockSize).ceil();

          return Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: PageHeaderWidget(
                    icon: Icons.apps_rounded,
                    title: 'Select a Block to Study',
                    subtitle: _getSubtitle(totalWords),
                  ),
                ),
              ),

              // Grid Section
              Expanded(
                child: _BlocksGridWithProgress(
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
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Lazy load the vocabulary data for this block
      final repository = ref.read(vocabularyRepositoryProvider);
      await repository.getVocabularyByLevelWithRange(level, startIndex, count);

      // Close loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();

        // Navigate to learning page
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
      // Close loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load vocabulary: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// ============================================================================
// Blocks Grid Widget with Progress - Separated to prevent parent rebuilds
// ============================================================================

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

    return Container(
      color: Colors.grey[50],
      child: blockProgressAsync.when(
        data: (progressList) {
          // Create a map for quick lookup
          final progressMap = {
            for (var progress in progressList) progress.blockNumber: progress,
          };

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio:
                  0.65, // Adjusted to accommodate progress indicator
            ),
            itemCount: totalBlocks,
            itemBuilder: (context, index) {
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
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: totalBlocks,
          itemBuilder: (context, index) {
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
          },
        ),
      ),
    );
  }
}

// ============================================================================
// Block Card Widget
// ============================================================================

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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Complete previous block to unlock this one',
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isLocked ? 0.7 : 1.0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLocked
                  ? Colors.grey.withValues(alpha: 0.3)
                  : isCompleted
                  ? AppTheme.successColor.withValues(alpha: 0.4)
                  : AppTheme.primaryColor.withValues(alpha: 0.15),
              width: isLocked ? 1 : (isCompleted ? 2 : 1),
            ),
            boxShadow: [
              BoxShadow(
                color: isLocked
                    ? Colors.black.withValues(alpha: 0.02)
                    : isCompleted
                    ? AppTheme.successColor.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Section - Block Number Badge with checkmark overlay
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? Colors.grey.withValues(alpha: 0.12)
                            : isCompleted
                            ? AppTheme.successColor.withValues(alpha: 0.12)
                            : AppTheme.primaryColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$blockNumber',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isLocked
                                ? Colors.grey
                                : isCompleted
                                ? AppTheme.successColor
                                : AppTheme.primaryColor,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    if (isLocked)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    // Green checkmark overlay when completed
                    if (isCompleted)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),

                // Middle Section - Text Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Block Title
                    Text(
                      'Block $blockNumber',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF424242),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Word Count
                    Text(
                      '$wordCount words',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Completion count if completed
                    if (isCompleted &&
                        (progress?.completionCount ?? 0) > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.replay_rounded,
                              size: 11,
                              color: AppTheme.successColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${progress!.completionCount}x',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successColor,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                // Bottom Section - Progress indicator or Range Badge
                if (hasProgress)
                  Column(
                    children: [
                      // Progress bar
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isLocked ? Colors.grey[100] : Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isLocked ? Colors.grey : AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Progress text
                      Text(
                        '${(progressValue * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: isLocked ? Colors.grey : AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey.withValues(alpha: 0.06)
                          : isCompleted
                          ? AppTheme.successColor.withValues(alpha: 0.06)
                          : AppTheme.primaryColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${startIndex + 1}-${startIndex + wordCount}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isLocked
                            ? Colors.grey
                            : isCompleted
                            ? AppTheme.successColor
                            : AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
