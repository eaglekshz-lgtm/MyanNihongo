import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../data/models/vocabulary_item_model.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../../data/providers/srs_provider.dart';
import '../widgets/srs/srs_review_card.dart';
import '../widgets/srs/srs_completion_screen.dart';
import '../../../../core/widgets/mesh_background.dart';

class SRSReviewPage extends ConsumerStatefulWidget {
  const SRSReviewPage({super.key});

  @override
  ConsumerState<SRSReviewPage> createState() => _SRSReviewPageState();
}

class _SRSReviewPageState extends ConsumerState<SRSReviewPage> {
  List<VocabularyItemModel> _dueCards = [];
  int _currentIndex = 0;
  bool _isCompleted = false;
  int _reviewsCompleted = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDueCards();
  }

  Future<void> _loadDueCards() async {
    try {
      // Get all vocabulary items
      final vocabularyAsync = ref.read(allVocabularyProvider);

      if (vocabularyAsync.hasValue) {
        final allVocabulary = vocabularyAsync.value!;
        final dueSrsCards = ref
            .read(allSRSCardsProvider.notifier)
            .getDueCards();

        // Get vocabulary items for due SRS cards
        final dueCards = allVocabulary
            .where(
              (vocab) => dueSrsCards.any(
                (srs) => srs.vocabularyId == vocab.id.toString(),
              ),
            )
            .toList();

        setState(() {
          _dueCards = dueCards;
          _isLoading = false;
          if (_dueCards.isEmpty) {
            _isCompleted = true;
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _isCompleted = true;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading due cards', tag: 'SRSReview', error: e);
      setState(() {
        _isLoading = false;
        _isCompleted = true;
      });
    }
  }

  void _onReviewComplete() {
    setState(() {
      _reviewsCompleted++;
      _currentIndex++;

      if (_currentIndex >= _dueCards.length) {
        _isCompleted = true;
      }
    });
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while loading cards
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_isCompleted) {
      return SRSCompletionScreen(
        totalReviewed: _reviewsCompleted,
        onBack: _goBack,
      );
    }

    if (_dueCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: Theme.of(context).colorScheme.success,
              ),
              const SizedBox(height: 16),
              Text(
                'All caught up!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No cards due for review right now.\nCome back later!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.neutralGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = _dueCards[_currentIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(
          'Review (${_currentIndex + 1}/${_dueCards.length})',
          style: TextStyle(
            color: Theme.of(context).colorScheme.fixedWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.fixedWhite,
          ),
          onPressed: _goBack,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.fixedWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).colorScheme.fixedWhite,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_dueCards.length - _currentIndex}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.fixedWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: MeshBackground(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _dueCards.length,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.fixedWhite.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.fixedWhite,
              ),
            ),

            // Review card
            Expanded(
              child: SRSReviewCard(
                vocabulary: currentCard,
                onReviewComplete: _onReviewComplete,
              ),
            ),
          ],
        ),
      ), // MeshBackground
    );
  }
}
