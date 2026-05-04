import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/widgets/glass_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/providers/meaning_language_provider.dart';
import '../../../data/models/vocabulary_item_model.dart';

class AbsorbCardWidget extends ConsumerWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final AnimationController flipController;
  final Future<void> Function(String text)? onSpeak;

  const AbsorbCardWidget({
    super.key,
    required this.item,
    required this.isBookmarked,
    required this.flipController,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meaningLanguage = ref.watch(meaningLanguageProvider);

    return AnimatedBuilder(
      animation: flipController,
      builder: (context, _) {
        final isFlipped = flipController.value >= 0.5;
        final angle = flipController.value * 3.14;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: GlassContainer(
            constraints: const BoxConstraints(maxWidth: 400, minHeight: 380),
            blur: 0.0,
            tintColor: isDark
                ? Theme.of(context).colorScheme.learningDarkSurface
                : Theme.of(context).colorScheme.primaryContainer,
            tintOpacity: 1.0,
            borderRadius: BorderRadius.circular(32),
            borderColor: isBookmarked
                ? Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.60)
                : (isDark
                      ? Theme.of(context).colorScheme.learningDarkOutline
                      : Theme.of(context).colorScheme.outlineVariant),
            borderWidth: isBookmarked ? 2.0 : 1.5,
            padding: const EdgeInsets.all(28),
            child: Transform(
              transform: Matrix4.rotationY(isFlipped ? 3.14 : 0),
              alignment: Alignment.center,
              child: StudyModeCardContent(
                item: item,
                isFlipped: isFlipped,
                onSpeak: onSpeak,
                meaningLanguage: meaningLanguage,
              ),
            ),
          ),
        );
      },
    );
  }
}

class StudyModeCardContent extends StatelessWidget {
  final VocabularyItemModel item;
  final bool isFlipped;
  final Future<void> Function(String text)? onSpeak;
  final MeaningLanguage meaningLanguage;

  const StudyModeCardContent({
    super.key,
    required this.item,
    required this.isFlipped,
    this.onSpeak,
    required this.meaningLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: !isFlipped ? _buildFront(context) : _buildBack(context),
    );
  }

  Widget _buildFront(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Part of Speech Badge - centered
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.25)
                    : Theme.of(context).colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            child: Text(
              item.partOfSpeech.toUpperCase(),
              style: AppTheme.bodySmall.copyWith(
                color: isDark
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Speaker button
        // if (onSpeak != null)
        //   Align(
        //     alignment: Alignment.centerRight,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: IconButton(
        //         icon: Icon(Icons.volume_up_rounded, color: Theme.of(context).colorScheme.primary),
        //         iconSize: 26,
        //         padding: const EdgeInsets.all(8),
        //         onPressed: () => onSpeak!(item.word),
        //       ),
        //     ),
        //   ),
        // if (onSpeak != null) const SizedBox(height: 24),
        // Japanese word (Kanji) - centered
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            item.word,
            style: AppTheme.japaneseText.copyWith(
              fontSize: 50,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.onSurface,
              shadows: [
                Shadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.fixedBlack.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 18),
        // Reading (Hiragana/Katakana)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? null
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            gradient: isDark
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Text(
            item.reading,
            style: AppTheme.japaneseText.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 28),
        // Divider
        Container(
          height: 2,
          width: 80,
          decoration: BoxDecoration(
            color: isDark ? null : Theme.of(context).colorScheme.outlineVariant,
            gradient: isDark
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.transparent,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      Theme.of(context).colorScheme.transparent,
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 32),
        // Translations section with modern design
        Column(
          children: [
            // Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 1,
                  color: isDark
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3)
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'MEANING',
                    style: AppTheme.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 1,
                  color: isDark
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3)
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Translation based on language preference
            Text(
              meaningLanguage == MeaningLanguage.burmese
                  ? item.translations.burmese
                  : item.translations.english,
              style: meaningLanguage == MeaningLanguage.burmese
                  ? AppTheme.burmeseText.copyWith(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.6,
                      letterSpacing: 0.3,
                    )
                  : AppTheme.bodyLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.4,
                    ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBack(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        if (item.exampleSentences.isEmpty) ...[
          const SizedBox(height: 40),
          Icon(
            Icons.info_outline,
            size: 48,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No example sentences available',
            style: AppTheme.bodyLarge.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Center(
            child: Text(
              'Example Sentences',
              style: AppTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...item.exampleSentences.asMap().entries.map((entry) {
            final index = entry.key;
            final sentence = entry.value;
            return _buildExampleSentence(context, index, sentence);
          }),
        ],
      ],
    );
  }

  Widget _buildExampleSentence(
    BuildContext context,
    int index,
    dynamic sentence,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark
              ? Theme.of(context).colorScheme.learningDarkElevated
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Theme.of(context).colorScheme.learningDarkOutlineAlt
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildExampleBadge(context, index),
                _buildActionButtons(context, sentence),
              ],
            ),
            const SizedBox(height: 12),
            _buildJapaneseSentence(context, sentence),
            const SizedBox(height: 12),
            _buildTranslations(context, sentence),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleBadge(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.learningDarkPrimaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Example ${index + 1}',
        style: AppTheme.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark
              ? Theme.of(context).colorScheme.learningDarkBadgeForeground
              : Theme.of(context).colorScheme.onPrimaryContainer,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildJapaneseSentence(BuildContext context, dynamic sentence) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      sentence.japanese,
      style: AppTheme.japaneseText.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark
            ? Theme.of(context).colorScheme.fixedWhite
            : Theme.of(context).colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic sentence) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        if (onSpeak != null)
          _buildIconButton(
            Icons.volume_up_rounded,
            () => onSpeak!(sentence.japanese),
            isDark
                ? Theme.of(context).colorScheme.learningDarkIconFill
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            isDark
                ? Theme.of(context).colorScheme.learningDarkIconBorder
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            isDark
                ? Theme.of(context).colorScheme.learningDarkIconAccent
                : Theme.of(context).colorScheme.primary,
          ),
        const SizedBox(width: 8),
        _buildIconButton(
          Icons.copy_rounded,
          () => _copyToClipboard(context, sentence.japanese),
          Theme.of(context).colorScheme.transparent,
          isDark
              ? Theme.of(context).colorScheme.learningDarkSecondaryIconBorder
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          isDark
              ? Theme.of(context).colorScheme.learningDarkMutedForeground
              : Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback onTap,
    Color bgColor,
    Color borderColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Japanese sentence copied!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildTranslations(BuildContext context, dynamic sentence) {
    final translationText = meaningLanguage == MeaningLanguage.burmese
        ? sentence.burmese
        : sentence.english;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.learningDarkSurfaceAlt
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Theme.of(context).colorScheme.learningDarkTranslationOutline
              : Theme.of(context).colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.language,
                size: 22,
                color: isDark
                    ? Theme.of(context).colorScheme.learningCardGradientStart
                    : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  translationText,
                  style: meaningLanguage == MeaningLanguage.burmese
                      ? AppTheme.burmeseText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Theme.of(
                                  context,
                                ).colorScheme.learningDarkBodyForeground
                              : Theme.of(context).colorScheme.onSurface,
                          height: 1.6,
                        )
                      : AppTheme.bodyMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Theme.of(
                                  context,
                                ).colorScheme.learningDarkBodyForeground
                              : Theme.of(context).colorScheme.onSurface,
                          height: 1.5,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
