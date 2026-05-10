import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/meaning_language_provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/vocabulary_item_model.dart';
import 'learning_card_components.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RecallCardWidget
// ─────────────────────────────────────────────────────────────────────────────
// Layout:
//
//  ┌──────────────────────────────────────────┐
//  │  blue backing card top                   │
//  │  ┌────────────────────────────────────┐  │
//  │  │  white foreground card             │  │
//  │  │  …content…                         │  │
//  │  └────────────────────────────────────┘  │
//  └──────────────────────────────────────────┘
// ─────────────────────────────────────────────────────────────────────────────

class RecallCardWidget extends ConsumerWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final AnimationController flipController;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback? onBookmarkToggle;
  final Color? stackedTopColor;

  const RecallCardWidget({
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
          final revealValue = Curves.easeOutCubic.transform(
            flipController.value.clamp(0.0, 1.0),
          );

          return RecallRevealCardContent(
            item: item,
            isBookmarked: isBookmarked,
            revealValue: revealValue,
            meaningLanguage: meaningLanguage,
            onSpeak: onSpeak,
            onBookmarkToggle: onBookmarkToggle,
            stackedTopColor: stackedTopColor,
          );
        },
      ),
    );
  }
}

class RecallRevealCardContent extends StatelessWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final double revealValue;
  final MeaningLanguage meaningLanguage;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback? onBookmarkToggle;
  final Color? stackedTopColor;

  const RecallRevealCardContent({
    super.key,
    required this.item,
    required this.isBookmarked,
    required this.revealValue,
    required this.meaningLanguage,
    this.onSpeak,
    this.onBookmarkToggle,
    this.stackedTopColor,
  });

  @override
  Widget build(BuildContext context) {
    final isRevealed = revealValue > 0.5;
    final cs = Theme.of(context).colorScheme;

    final card = LearningCardShell(
      isBookmarked: isBookmarked,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
      child: Column(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.word,
                            style: AppTheme.japaneseText.copyWith(
                              color: cs.learningWordForeground,
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 34),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: isRevealed
                              ? _RevealedContent(
                                  key: const ValueKey('revealed'),
                                  reading: item.reading,
                                  meaning: _meaning,
                                  language: meaningLanguage,
                                )
                              : const _RevealPrompt(key: ValueKey('prompt')),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.64)),
          const SizedBox(height: 10),
          _RecallActionRow(onSpeak: onSpeak, word: item.word),
        ],
      ),
    );

    return CustomPaint(
      painter: OuterTopBorderPainter(
        color: stackedTopColor ?? cs.primary,
        borderRadius: 28,
        backgroundColor: cs.surface,
      ),
      child: Padding(padding: const EdgeInsets.only(top: 3.5), child: card),
    );
  }

  String get _meaning {
    return meaningLanguage == MeaningLanguage.burmese
        ? item.translations.burmese
        : item.translations.english;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal widgets
// ─────────────────────────────────────────────────────────────────────────────

class _RevealedContent extends StatelessWidget {
  final String reading;
  final String meaning;
  final MeaningLanguage language;

  const _RevealedContent({
    super.key,
    required this.reading,
    required this.meaning,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ReadingText(reading: reading),
        const SizedBox(height: 24),
        _MeaningText(meaning: meaning, language: language),
      ],
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
        color: cs.onSurface,
        fontSize: isBurmese ? 24 : 22,
        fontWeight: FontWeight.w800,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _RevealPrompt extends StatelessWidget {
  const _RevealPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final promptColor = cs.primary.withValues(alpha: 0.42);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.keyboard_arrow_down_rounded, color: promptColor, size: 22),
        const SizedBox(width: 6),
        Text(
          'Tap to reveal meaning',
          style: AppTheme.bodyLarge.copyWith(
            color: promptColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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

class _RecallActionRow extends StatelessWidget {
  final Future<void> Function(String text)? onSpeak;
  final String word;
  const _RecallActionRow({required this.onSpeak, required this.word});

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
            _RecallUtilityButton(
              icon: Icons.volume_up_rounded,
              label: 'Listen',
              width: buttonWidth,
              onTap: onSpeak == null ? null : () => onSpeak!(word),
            ),
            SizedBox(width: gap),
            _RecallUtilityButton(
              icon: Icons.edit_rounded,
              label: 'Write',
              width: buttonWidth,
              onTap: null,
            ),
          ],
        );
      },
    );
  }
}

class _RecallUtilityButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  final VoidCallback? onTap;
  const _RecallUtilityButton({
    required this.icon,
    required this.label,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.70),
                    width: 1.2,
                  ),
                ),
                child: Icon(icon, color: cs.primary, size: 22),
              ),
            ),
          ),
          const SizedBox(height: 4),
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
