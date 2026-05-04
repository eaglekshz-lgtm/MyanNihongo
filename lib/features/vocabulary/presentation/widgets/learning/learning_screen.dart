import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/mesh_background.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/vocabulary_item_model.dart';
import '../../../data/providers/bookmark_providers.dart';
import 'action_buttons.dart';
import 'swipeable_vocabulary_card.dart';
import 'vocabulary_progress_header.dart';

class LearningScreen extends StatelessWidget {
  final List<VocabularyItemModel> vocabulary;
  final int viewingIndex;
  final int lastCompletedCount;
  final bool isFinishing;
  final String? level;
  final String? learningMode;
  final AnimationController flipController;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback onFlipTap;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const LearningScreen({
    super.key,
    required this.vocabulary,
    required this.viewingIndex,
    required this.lastCompletedCount,
    required this.isFinishing,
    required this.level,
    required this.learningMode,
    required this.flipController,
    required this.onSpeak,
    required this.onFlipTap,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final currentItem = vocabulary[viewingIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = SafeArea(
      child: Column(
        children: [
          VocabularyProgressHeader(
            displayIndex: viewingIndex,
            completedCount: lastCompletedCount,
            totalCount: vocabulary.length,
            level: level ?? 'N5',
            highlightSuccess: isFinishing,
            animate: isFinishing,
            forcedProgress: isFinishing ? 1.0 : null,
          ),
          Expanded(child: _buildVocabularyCard(currentItem)),
          const SizedBox(height: 10),
          _buildActionButtons(context, currentItem, vocabulary.length),
        ],
      ),
    );

    return isDark ? content : MeshBackground(child: content);
  }

  Widget _buildVocabularyCard(VocabularyItemModel item) {
    return Consumer(
      builder: (context, ref, _) {
        final bookmarkedIdsAsync = ref.watch(bookmarkedIdsProvider);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SwipeableVocabularyCard(
            key: ValueKey('card-$viewingIndex'),
            item: item,
            learningMode: learningMode ?? 'recall',
            flipController: flipController,
            bookmarkedIdsAsync: bookmarkedIdsAsync,
            onFlipTap: onFlipTap,
            onSpeak: onSpeak,
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    VocabularyItemModel item,
    int totalVocabularyLength,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        final bookmarkedIdsAsync = ref.watch(bookmarkedIdsProvider);

        return bookmarkedIdsAsync.when(
          data: (bookmarkedIds) => _buildButtons(
            context,
            ref,
            item,
            bookmarkedIds.contains(item.id.toString()),
            totalVocabularyLength,
          ),
          loading: () =>
              _buildButtons(context, ref, item, false, totalVocabularyLength),
          error: (_, __) =>
              _buildButtons(context, ref, item, false, totalVocabularyLength),
        );
      },
    );
  }

  Widget _buildButtons(
    BuildContext context,
    WidgetRef ref,
    VocabularyItemModel item,
    bool isBookmarked,
    int totalVocabularyLength,
  ) {
    final bookmarkNotifier = ref.read(bookmarkNotifierProvider.notifier);

    return LearningActionButtons(
      canGoBack: viewingIndex > 0,
      isBookmarked: isBookmarked,
      onBack: onBack,
      onBookmark: () async {
        await bookmarkNotifier.toggleBookmark(item.id.toString());
        if (context.mounted) {
          _showBookmarkFeedback(context, !isBookmarked);
        }
      },
      onNext: onNext,
    );
  }

  void _showBookmarkFeedback(BuildContext context, bool isBookmarked) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildBookmarkSnackBarContent(context, isBookmarked),
        backgroundColor: isBookmarked
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        duration: const Duration(milliseconds: 2500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
        ),
        elevation: 8,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildBookmarkSnackBarContent(
    BuildContext context,
    bool isBookmarked,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.fixedWhite.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: Theme.of(context).colorScheme.fixedWhite,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBookmarked ? 'Saved!' : 'Removed',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fixedWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                isBookmarked
                    ? 'Word added to your bookmarks'
                    : 'Word removed from bookmarks',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.fixedWhite.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isBookmarked
              ? Icons.check_circle_rounded
              : Icons.info_outline_rounded,
          color: Theme.of(
            context,
          ).colorScheme.fixedWhite.withValues(alpha: 0.9),
          size: 22,
        ),
      ],
    );
  }
}
