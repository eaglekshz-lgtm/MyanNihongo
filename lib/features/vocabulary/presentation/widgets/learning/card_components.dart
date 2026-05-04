import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

class CategoryBadge extends StatelessWidget {
  final String category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
            : Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
              : Theme.of(context).colorScheme.outlineVariant,
          width: 1.2,
        ),
      ),
      child: Text(
        category.toUpperCase(),
        style: AppTheme.bodySmall.copyWith(
          color: isDark
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 13,
        ),
      ),
    );
  }
}

class BurmeseSide extends StatelessWidget {
  final String burmeseWord;
  final String japaneseReading;

  const BurmeseSide({
    super.key,
    required this.burmeseWord,
    required this.japaneseReading,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    // Replace "၊ " with newline for proper line breaks
    final formattedText = burmeseWord.replaceAll('၊ ', '၊\n');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formattedText,
            style: AppTheme.burmeseText.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.6,
              letterSpacing: 0.3,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Text(
              japaneseReading,
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
        ],
      ),
    );
  }
}

class EnglishSide extends StatelessWidget {
  final String englishWord;
  final String japaneseReading;

  const EnglishSide({
    super.key,
    required this.englishWord,
    required this.japaneseReading,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            englishWord,
            style: AppTheme.bodyLarge.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.4,
              letterSpacing: 0.3,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Text(
              japaneseReading,
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
        ],
      ),
    );
  }
}

class JapaneseSide extends StatelessWidget {
  static const double kCardBorderRadius = 28.0;
  static const double kJapaneseFontSize = 62.0;

  final String japaneseWord;

  const JapaneseSide({super.key, required this.japaneseWord});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Center(
      child: Text(
        japaneseWord,
        style: AppTheme.japaneseText.copyWith(
          fontSize: 60,
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
    );
  }
}
