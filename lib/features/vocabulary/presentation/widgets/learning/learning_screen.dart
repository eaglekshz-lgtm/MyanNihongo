import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';
import '../../../../../core/widgets/mesh_background.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/vocabulary_item_model.dart';
import '../../../data/providers/bookmark_providers.dart';
import 'swipeable_vocabulary_card.dart';
import 'vocabulary_progress_header.dart';

class LearningScreen extends ConsumerStatefulWidget {
  final List<VocabularyItemModel> vocabulary;
  final int viewingIndex;
  final int lastCompletedCount;
  final bool isFinishing;
  final String? level;
  final String? learningMode;
  final AnimationController flipController;
  final Future<void> Function(String text)? onSpeak;
  final VoidCallback onFlipTap;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const LearningScreen({
    super.key,
    required this.vocabulary,
    required this.viewingIndex,
    required this.lastCompletedCount,
    required this.isFinishing,
    this.level,
    this.learningMode,
    required this.flipController,
    this.onSpeak,
    required this.onFlipTap,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  double _swipeProgress = 0.0;
  bool _isSwipingRight = false;
  bool _isSwiping = false;

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.vocabulary[widget.viewingIndex];
    final cs = Theme.of(context).colorScheme;
    final isBookmarkedAsync = ref.watch(
      isVocabularyBookmarkedProvider(currentItem.id.toString()),
    );
    final isBookmarked = isBookmarkedAsync.valueOrNull ?? false;
    final effectiveLearningMode =
        widget.learningMode ?? CardStyle.recallMode.code;
    final isRecallMode = effectiveLearningMode == CardStyle.recallMode.code;

    final content = SafeArea(
      child: Column(
        children: [
          VocabularyProgressHeader(
            displayIndex: widget.viewingIndex,
            completedCount: widget.lastCompletedCount,
            totalCount: widget.vocabulary.length,
            level: widget.level ?? 'N5',
            highlightSuccess: widget.isFinishing,
            animate: widget.isFinishing,
            forcedProgress: widget.isFinishing ? 1.0 : null,
            swipeProgress: _swipeProgress,
            isSwipingRight: _isSwipingRight,
            isSwiping: _isSwiping,
          ),
          Expanded(child: _buildVocabularyCard(currentItem, isBookmarked)),
          const SizedBox(height: 14),
          _buildRecallChoiceBar(context, cs),
          const SizedBox(height: 18),
        ],
      ),
    );

    return !isRecallMode && cs.usesLearningMesh
        ? MeshBackground(child: content)
        : content;
  }

  Widget _buildRecallChoiceBar(BuildContext context, ColorScheme cs) {
    final hardColor = cs.learningRecallHard;
    final easyColor = cs.learningRecallEasy;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // Hard side
          Expanded(
            child: Material(
              color: cs.transparent,
              child: InkWell(
                onTap: widget.onSwipeLeft,
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _OutlinedCircle(
                        icon: Icons.close_rounded,
                        color: hardColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hard',
                        style: AppTheme.bodyLarge.copyWith(
                          color: hardColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_left_rounded,
                        color: hardColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Center dot
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              shape: BoxShape.circle,
            ),
          ),
          // Easy side
          Expanded(
            child: Material(
              color: cs.transparent,
              child: InkWell(
                onTap: widget.onSwipeRight,
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: easyColor,
                        size: 20,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Easy',
                        style: AppTheme.bodyLarge.copyWith(
                          color: easyColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _OutlinedCircle(
                        icon: Icons.check_rounded,
                        color: easyColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyCard(VocabularyItemModel item, bool isBookmarked) {
    final nextItem = (widget.viewingIndex + 1 < widget.vocabulary.length)
        ? widget.vocabulary[widget.viewingIndex + 1]
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SwipeableVocabularyCard(
        key: ValueKey('card-${widget.viewingIndex}'),
        item: item,
        nextItem: nextItem,
        learningMode: widget.learningMode ?? CardStyle.recallMode.code,
        flipController: widget.flipController,
        isBookmarked: isBookmarked,
        onFlipTap: widget.onFlipTap,
        onSpeak: widget.onSpeak,
        onBookmarkToggle: () {
          final notifier = ref.read(bookmarkNotifierProvider.notifier);
          notifier.toggleBookmark(item.id.toString());
        },
        onSwipeLeft: () {
          setState(() {
            _isSwiping = false;
            _swipeProgress = 0.0;
          });
          widget.onSwipeLeft();
        },
        onSwipeRight: () {
          setState(() {
            _isSwiping = false;
            _swipeProgress = 0.0;
          });
          widget.onSwipeRight();
        },
        onSwipeUpdate: (progress, isRight) {
          setState(() {
            _isSwiping = true;
            _swipeProgress = progress;
            _isSwipingRight = isRight;
          });
        },
        onSwipeCancel: () {
          setState(() {
            _isSwiping = false;
            _swipeProgress = 0.0;
          });
        },
      ),
    );
  }
}

class _OutlinedCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _OutlinedCircle({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(child: Icon(icon, color: color, size: 20)),
    );
  }
}
