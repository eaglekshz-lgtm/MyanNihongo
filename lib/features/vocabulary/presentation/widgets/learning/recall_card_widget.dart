import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/providers/meaning_language_provider.dart';
import '../../../data/models/vocabulary_item_model.dart';
import 'card_components.dart';

class RecallCardWidget extends ConsumerWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final AnimationController flipController;

  const RecallCardWidget({
    super.key,
    required this.item,
    required this.isBookmarked,
    required this.flipController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meaningLanguage = ref.watch(meaningLanguageProvider);
    
    return AnimatedBuilder(
      animation: flipController,
      builder: (context, _) {
        final angle = flipController.value * 3.1415926535897932;
        final isBackVisible = angle > (3.1415926535897932 / 2);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isBackVisible
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(3.1415926535897932),
                  child: QuizModeCardContent(
                    item: item,
                    isBookmarked: isBookmarked,
                    showBack: true,
                    meaningLanguage: meaningLanguage,
                  ),
                )
              : QuizModeCardContent(
                  item: item,
                  isBookmarked: isBookmarked,
                  showBack: false,
                  meaningLanguage: meaningLanguage,
                ),
        );
      },
    );
  }
}

class QuizModeCardContent extends StatelessWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final bool showBack;
  final MeaningLanguage meaningLanguage;

  const QuizModeCardContent({
    super.key,
    required this.item,
    required this.isBookmarked,
    required this.showBack,
    required this.meaningLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
        minHeight: 380,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.15),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: showBack
                ? AppTheme.primaryColor.withValues(alpha: 0.08)
                : AppTheme.secondaryColor.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CategoryBadge(category: item.partOfSpeech),
          if (!showBack)
            JapaneseSide(japaneseWord: item.word)
          else if (meaningLanguage == MeaningLanguage.burmese)
            BurmeseSide(
              burmeseWord: item.translations.burmese,
              japaneseReading: item.reading,
            )
          else
            EnglishSide(
              englishWord: item.translations.english,
              japaneseReading: item.reading,
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

}