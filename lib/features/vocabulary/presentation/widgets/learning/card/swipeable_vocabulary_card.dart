import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';

import '../../../../data/models/vocabulary_item_model.dart';
import 'recall_card_content.dart';
import 'absorb_card_content.dart';

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
          return learningMode == CardStyle.recallMode.code
              ? RecallCardContent(
                  item: item,
                  isBookmarked: isBookmarked,
                  flipController: flipController,
                )
              : AbsorbCardContent(
                  item: item,
                  isBookmarked: isBookmarked,
                  flipController: flipController,
                  onSpeak: onSpeak,
                );
        },
        loading: () => learningMode == CardStyle.recallMode.code
            ? RecallCardContent(
                item: item,
                isBookmarked: false,
                flipController: flipController,
              )
            : AbsorbCardContent(
                item: item,
                isBookmarked: false,
                flipController: flipController,
                onSpeak: onSpeak,
              ),
        error: (_, __) => learningMode == CardStyle.recallMode.code
            ? RecallCardContent(
                item: item,
                isBookmarked: false,
                flipController: flipController,
              )
            : AbsorbCardContent(
                item: item,
                isBookmarked: false,
                flipController: flipController,
                onSpeak: onSpeak,
              ),
      ),
    );
  }
}