import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';
import '../../../data/models/vocabulary_item_model.dart';
import 'recall_card_widget.dart';
import 'absorb_card_widget.dart';

class SwipeableVocabularyCard extends StatelessWidget {
  final VocabularyItemModel item;
  final String learningMode;
  final AnimationController flipController;
  final AsyncValue bookmarkedIdsAsync;
  final VoidCallback onFlipTap;
  final Future<void> Function(String text)? onSpeak;

  const SwipeableVocabularyCard({
    super.key,
    required this.item,
    required this.learningMode,
    required this.flipController,
    required this.bookmarkedIdsAsync,
    required this.onFlipTap,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlipTap,
      child: bookmarkedIdsAsync.when(
        data: (bookmarkedIds) {
          final isBookmarked = bookmarkedIds.contains(item.id);
          return _buildCard(isBookmarked);
        },
        loading: () => _buildCard(false),
        error: (_, __) => _buildCard(false),
      ),
    );
  }

  Widget _buildCard(bool isBookmarked) {
    return learningMode == CardStyle.recallMode.code
        ? RecallCardWidget(
            item: item,
            isBookmarked: isBookmarked,
            flipController: flipController,
          )
        : AbsorbCardWidget(
            item: item,
            isBookmarked: isBookmarked,
            flipController: flipController,
            onSpeak: onSpeak,
          );
  }
}