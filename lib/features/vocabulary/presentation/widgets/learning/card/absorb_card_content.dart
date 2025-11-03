import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../data/models/vocabulary_item_model.dart';
import 'card_content.dart';

class AbsorbCardContent extends StatelessWidget {
  final VocabularyItemModel item;
  final bool isBookmarked;
  final AnimationController flipController;
  final Future<void> Function(String text)? onSpeak;

  const AbsorbCardContent({
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
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(flipController.value * 3.14),
          alignment: Alignment.center,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isBookmarked ? AppTheme.secondaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: CardContent(
              item: item,
              isBookmarked: isBookmarked,
              isFlipped: flipController.value >= 0.5,
              onSpeak: onSpeak,
            ),
          ),
        );
      },
    );
  }
}