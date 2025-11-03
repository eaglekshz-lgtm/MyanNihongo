import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../data/models/vocabulary_item_model.dart';

class CardContent extends StatelessWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final bool isFlipped;
  final bool showMeaning;
  final Future<void> Function(String text)? onSpeak;

  const CardContent({
    super.key,
    required this.item,
    required this.isBookmarked,
    required this.isFlipped,
    this.showMeaning = true,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.85;
    final cardHeight = cardWidth * 0.7;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      child: !isFlipped ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onSpeak != null)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => onSpeak!(item.word),
            ),
          ),
        Flexible(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.word,
                  style: AppTheme.japaneseText.copyWith(
                    fontSize: 32,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.reading,
                  style: AppTheme.japaneseText.copyWith(
                    color: Colors.grey,
                    fontSize: 20,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isBookmarked)
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.bookmark, color: Colors.orange),
          ),
      ],
    );
  }

  Widget _buildBack() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showMeaning) ...[
          Text(
            item.translations.burmese,
            style: AppTheme.burmeseText.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            item.translations.english,
            style: AppTheme.bodyLarge.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
        if (isBookmarked)
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.bookmark, color: Colors.orange),
          ),
      ],
    );
  }
}