import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/vocabulary_item_model.dart';
import '../../../data/providers/srs_provider.dart';

class SRSReviewCard extends ConsumerStatefulWidget {
  final VocabularyItemModel vocabulary;
  final VoidCallback onReviewComplete;

  const SRSReviewCard({
    super.key,
    required this.vocabulary,
    required this.onReviewComplete,
  });

  @override
  ConsumerState<SRSReviewCard> createState() => _SRSReviewCardState();
}

class _SRSReviewCardState extends ConsumerState<SRSReviewCard>
    with SingleTickerProviderStateMixin {
  bool _showAnswer = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.status == AnimationStatus.completed) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _onQualitySelected(int quality) async {
    // Record the review
    await ref
        .read(allSRSCardsProvider.notifier)
        .reviewCard(widget.vocabulary.id.toString(), quality);

    // Call completion callback
    widget.onReviewComplete();
  }

  Color _getQualityColor(int quality) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (quality) {
      case 2:
        return isDark
            ? Theme.of(context).colorScheme.srsAgain
            : Theme.of(context).colorScheme.error;
      case 3:
        return isDark
            ? Theme.of(context).colorScheme.jlptN3
            : Theme.of(context).colorScheme.warning;
      case 4:
        return isDark
            ? Theme.of(context).colorScheme.jlptN4
            : Theme.of(context).colorScheme.info;
      case 5:
        return isDark
            ? Theme.of(context).colorScheme.jlptN5
            : Theme.of(context).colorScheme.success;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }

  String _getQualityLabel(int quality) {
    switch (quality) {
      case 2:
        return 'Again';
      case 3:
        return 'Hard';
      case 4:
        return 'Good';
      case 5:
        return 'Easy';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card
          GestureDetector(
            onTap: _flipCard,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final isFlipped = _flipAnimation.value > 0.5;
                final angle = _flipAnimation.value * 3.14159;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(isFlipped ? 3.14159 : 0),
                    child: isFlipped
                        ? _buildAnswerSide()
                        : _buildQuestionSide(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          // Instructions
          if (!_showAnswer)
            Text(
              'Tap card to reveal answer',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),

          if (_showAnswer) ...[
            Text(
              'How well did you know this?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Quality buttons
            Row(
              children: [2, 3, 4, 5].map((quality) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildQualityButton(quality),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionSide() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Japanese word
          Text(
            widget.vocabulary.word,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.fixedWhite,
            ),
          ),
          const SizedBox(height: 16),

          // Reading
          if (widget.vocabulary.reading != widget.vocabulary.word)
            Text(
              widget.vocabulary.reading,
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(
                  context,
                ).colorScheme.fixedWhite.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 24),

          // Part of speech
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.fixedWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.vocabulary.partOfSpeech,
              style: TextStyle(
                color: Theme.of(context).colorScheme.fixedWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSide() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Translations
          Text(
            widget.vocabulary.translations.english,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.fixedWhite,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            widget.vocabulary.translations.burmese,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(
                context,
              ).colorScheme.fixedWhite.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),

          // Example sentence (if available)
          if (widget.vocabulary.exampleSentences.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.fixedWhite.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    widget.vocabulary.exampleSentences.first.japanese,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.fixedWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.vocabulary.exampleSentences.first.english,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.fixedWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQualityButton(int quality) {
    return GestureDetector(
      onTap: () => _onQualitySelected(quality),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: _getQualityColor(quality),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _getQualityColor(quality).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getQualityLabel(quality),
              style: TextStyle(
                color: Theme.of(context).colorScheme.fixedWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              quality.toString(),
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.fixedWhite.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
