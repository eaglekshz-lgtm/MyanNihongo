import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import '../../../../../core/widgets/glass_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      constraints: const BoxConstraints(maxWidth: 400, minHeight: 380),
      blur: isDark ? 20.0 : 0.0,
      tintColor: Theme.of(context).colorScheme.primaryContainer,
      tintOpacity: isDark ? 0.18 : 1.0,
      borderRadius: BorderRadius.circular(28),
      borderColor: isDark
          ? Theme.of(context).colorScheme.fixedWhite.withValues(alpha: 0.22)
          : Theme.of(context).colorScheme.outlineVariant,
      borderWidth: 1.5,
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
