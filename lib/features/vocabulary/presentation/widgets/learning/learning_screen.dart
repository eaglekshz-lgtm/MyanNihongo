import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return SafeArea(
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
          Expanded(
            child: _buildVocabularyCard(currentItem),
          ),
          const SizedBox(height: 10),
          _buildActionButtons(
            context,
            currentItem,
            vocabulary.length,
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyCard(VocabularyItemModel item) {
    return Consumer(
      builder: (context, ref, _) {
        final bookmarkedIdsAsync = ref.watch(bookmarkedIdsProvider);
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: SwipeableVocabularyCard(
              key: ValueKey('card-$viewingIndex'),
              item: item,
              learningMode: learningMode ?? 'recall',
              flipController: flipController,
              bookmarkedIdsAsync: bookmarkedIdsAsync,
              onFlipTap: onFlipTap,
              onSpeak: onSpeak,
            ),
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
          loading: () => _buildButtons(
            context,
            ref,
            item,
            false,
            totalVocabularyLength,
          ),
          error: (_, __) => _buildButtons(
            context,
            ref,
            item,
            false,
            totalVocabularyLength,
          ),
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
        content: _buildBookmarkSnackBarContent(isBookmarked),
        backgroundColor: isBookmarked
            ? const Color(0xFFFF9800)
            : const Color(0xFF424242),
        duration: const Duration(milliseconds: 2500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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

  Widget _buildBookmarkSnackBarContent(bool isBookmarked) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: Colors.white,
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
                style: const TextStyle(
                  color: Colors.white,
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
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isBookmarked ? Icons.check_circle_rounded : Icons.info_outline_rounded,
          color: Colors.white.withValues(alpha: 0.9),
          size: 22,
        ),
      ],
    );
  }
}