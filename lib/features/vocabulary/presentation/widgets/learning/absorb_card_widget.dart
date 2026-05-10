import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/providers/meaning_language_provider.dart';
import '../../../data/models/vocabulary_item_model.dart';
import 'learning_card_components.dart';

class AbsorbCardWidget extends ConsumerWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final AnimationController flipController;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback? onBookmarkToggle;
  final Color? stackedTopColor;

  const AbsorbCardWidget({
    super.key,
    required this.item,
    required this.isBookmarked,
    required this.flipController,
    this.onSpeak,
    this.onBookmarkToggle,
    this.stackedTopColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meaningLanguage = ref.watch(meaningLanguageProvider);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: flipController,
        builder: (context, _) {
          final isFlipped = flipController.value >= 0.5;
          final angle = flipController.value * 3.14;

          final card = LearningCardShell(
            isBookmarked: isBookmarked,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Transform(
              transform: Matrix4.rotationY(isFlipped ? 3.14 : 0),
              alignment: Alignment.center,
              child: StudyModeCardContent(
                item: item,
                isFlipped: isFlipped,
                isBookmarked: isBookmarked,
                onSpeak: onSpeak,
                onBookmarkToggle: onBookmarkToggle,
                meaningLanguage: meaningLanguage,
              ),
            ),
          );

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: CustomPaint(
              painter: OuterTopBorderPainter(
                color: stackedTopColor ?? Theme.of(context).colorScheme.primary,
                borderRadius: 28,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: card,
              ),
            ),
          );
        },
      ),
    );
  }
}

class StudyModeCardContent extends StatelessWidget {
  final VocabularyItemModel item;
  final bool isFlipped;
  final bool isBookmarked;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback? onBookmarkToggle;
  final MeaningLanguage meaningLanguage;

  const StudyModeCardContent({
    super.key,
    required this.item,
    required this.isFlipped,
    required this.isBookmarked,
    this.onSpeak,
    this.onBookmarkToggle,
    required this.meaningLanguage,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFlipped) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryBadge(category: item.partOfSpeech),
              const Spacer(),
              _BookmarkButton(
                isBookmarked: isBookmarked,
                onPressed: onBookmarkToggle,
              ),
            ],
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(child: _buildFrontContent(context)),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.64),
          ),
          const SizedBox(height: 10),
          _AbsorbActionRow(onSpeak: onSpeak, word: item.word, elevated: false),
        ],
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedHeight = constraints.maxHeight.isFinite;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: hasBoundedHeight ? constraints.maxHeight : 0,
              ),
              child: Center(child: _buildBack(context)),
            ),
          );
        },
      );
    }
  }

  Widget _buildFrontContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            item.word,
            style: AppTheme.japaneseText.copyWith(
              color: cs.learningWordForeground,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        _ReadingText(reading: item.reading),
        const SizedBox(height: 24),
        _MeaningText(
          meaning: meaningLanguage == MeaningLanguage.burmese
              ? item.translations.burmese
              : item.translations.english,
          language: meaningLanguage,
        ),
      ],
    );
  }

  Widget _buildBack(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                color: cs.exampleTitleForeground,
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
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cs.exampleCardSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.exampleCardBorder, width: 1.5),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: cs.exampleBadgeSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Example ${index + 1}',
        style: AppTheme.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: cs.exampleBadgeForeground,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildJapaneseSentence(BuildContext context, dynamic sentence) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      sentence.japanese,
      style: AppTheme.japaneseText.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: cs.exampleJapaneseForeground,
        height: 1.4,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic sentence) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (onSpeak != null)
          _buildIconButton(
            Icons.volume_up_rounded,
            () => onSpeak!(sentence.japanese),
            cs.exampleSpeakerSurface,
            cs.exampleSpeakerBorder,
            cs.exampleSpeakerForeground,
          ),
        const SizedBox(width: 8),
        _buildIconButton(
          Icons.copy_rounded,
          () => _copyToClipboard(context, sentence.japanese),
          cs.exampleCopySurface,
          cs.exampleCopyBorder,
          cs.exampleCopyForeground,
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
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.exampleTranslationSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.exampleTranslationBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.language, size: 22, color: cs.exampleTranslationIcon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  translationText,
                  style: meaningLanguage == MeaningLanguage.burmese
                      ? AppTheme.burmeseText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.exampleTranslationBody,
                          height: 1.6,
                        )
                      : AppTheme.bodyMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: cs.exampleTranslationBody,
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

class _ReadingText extends StatelessWidget {
  final String reading;
  const _ReadingText({required this.reading});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: cs.readingPillSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.readingPillBorder, width: 1.2),
      ),
      child: Text(
        reading,
        style: AppTheme.japaneseText.copyWith(
          color: cs.primary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MeaningText extends StatelessWidget {
  final String meaning;
  final MeaningLanguage language;

  const _MeaningText({required this.meaning, required this.language});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isBurmese = language == MeaningLanguage.burmese;

    return Text(
      meaning,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: (isBurmese ? AppTheme.burmeseText : AppTheme.bodyLarge).copyWith(
        color: cs.primary,
        fontSize: isBurmese ? 22 : 24,
        fontWeight: FontWeight.w800,
        height: isBurmese ? 1.5 : 1.24,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback? onPressed;

  const _BookmarkButton({required this.isBookmarked, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.74),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: cs.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _AbsorbActionRow extends StatelessWidget {
  final Future<void> Function(String text)? onSpeak;
  final String word;
  final bool elevated;

  const _AbsorbActionRow({
    required this.onSpeak,
    required this.word,
    required this.elevated,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = (constraints.maxWidth * 0.12).clamp(20.0, 48.0).toDouble();
        final buttonWidth = ((constraints.maxWidth - gap) / 2)
            .clamp(80.0, 110.0)
            .toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AbsorbUtilityButton(
              icon: Icons.volume_up_rounded,
              label: 'Listen',
              elevated: elevated,
              width: buttonWidth,
              onTap: onSpeak == null ? null : () => onSpeak!(word),
            ),
            SizedBox(width: gap),
            _AbsorbUtilityButton(
              icon: Icons.edit_rounded,
              label: 'Write',
              elevated: elevated,
              width: buttonWidth,
              onTap: null,
            ),
          ],
        );
      },
    );
  }
}

class _AbsorbUtilityButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool elevated;
  final double width;
  final VoidCallback? onTap;

  const _AbsorbUtilityButton({
    required this.icon,
    required this.label,
    required this.elevated,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const iconBoxSize = 50.0;
    const iconSize = 22.0;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: elevated ? cs.surface : cs.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: cs.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.70),
                    width: 1.2,
                  ),
                ),
                child: Icon(icon, color: cs.primary, size: iconSize),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: cs.onSurface.withValues(alpha: 0.58),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
