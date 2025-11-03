import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/vocabulary_item_model.dart';

class AbsorbCardWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flipController,
      builder: (context, _) {
        final isFlipped = flipController.value >= 0.5;
        final angle = flipController.value * 3.14;
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
              minHeight: 380,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isBookmarked 
                    ? AppTheme.secondaryColor.withValues(alpha: 0.3)
                    : AppTheme.primaryColor.withValues(alpha: 0.15),
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
                  color: isBookmarked
                      ? AppTheme.secondaryColor.withValues(alpha: 0.08)
                      : AppTheme.primaryColor.withValues(alpha: 0.06),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                  spreadRadius: -4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Transform(
              transform: Matrix4.rotationY(isFlipped ? 3.14 : 0),
              alignment: Alignment.center,
              child: StudyModeCardContent(
                item: item,
                isFlipped: isFlipped,
                onSpeak: onSpeak,
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

  const StudyModeCardContent({
    super.key,
    required this.item,
    required this.isFlipped,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: !isFlipped ? _buildFront() : _buildBack(context),
    );
  }

  Widget _buildFront() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Part of Speech Badge - centered
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Text(
              item.partOfSpeech.toUpperCase(),
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.primaryColor,
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
        //         color: AppTheme.primaryColor.withValues(alpha: 0.1),
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: IconButton(
        //         icon: const Icon(Icons.volume_up_rounded, color: AppTheme.primaryColor),
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
              color: const Color(0xFF1A1A1A),
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withValues(alpha: 0.12),
                AppTheme.primaryColor.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            item.reading,
            style: AppTheme.japaneseText.copyWith(
              color: AppTheme.primaryColor,
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
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.primaryColor.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
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
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'MEANING',
                    style: AppTheme.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppTheme.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 1,
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Burmese translation
            Text(
              item.translations.burmese,
              style: AppTheme.burmeseText.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
                height: 1.6,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            // English translation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                    AppTheme.primaryColor.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                item.translations.english,
                style: AppTheme.bodyLarge.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF424242),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBack(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        if (item.exampleSentences.isEmpty) ...[
          const SizedBox(height: 40),
          Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No example sentences available',
            style: AppTheme.bodyLarge.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Text(
            'Example Sentences',
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ...item.exampleSentences.asMap().entries.map((entry) {
            final index = entry.key;
            final sentence = entry.value;
            return _buildExampleSentence(context, index, sentence);
          }),
        ],
      ],
    );
  }

  Widget _buildExampleSentence(BuildContext context, int index, dynamic sentence) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF5F9FF),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExampleBadge(index),
            const SizedBox(height: 12),
            _buildJapaneseSentence(context, sentence),
            const SizedBox(height: 12),
            _buildTranslations(sentence),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleBadge(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryVariant,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Example ${index + 1}',
        style: AppTheme.bodySmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildJapaneseSentence(BuildContext context, dynamic sentence) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            sentence.japanese,
            style: AppTheme.japaneseText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildActionButtons(context, sentence),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic sentence) {
    return Row(
      children: [
        if (onSpeak != null)
          _buildIconButton(
            Icons.volume_up_rounded,
            () => onSpeak!(sentence.japanese),
            AppTheme.primaryColor,
          ),
        const SizedBox(width: 6),
        _buildIconButton(
          Icons.copy_rounded,
          () => _copyToClipboard(context, sentence.japanese),
          AppTheme.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildTranslations(dynamic sentence) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Burmese translation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.language, size: 14, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sentence.burmese,
                  style: AppTheme.burmeseText.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // English translation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.translate, size: 14, color: AppTheme.secondaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sentence.english,
                  style: AppTheme.bodySmall.copyWith(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    height: 1.4,
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