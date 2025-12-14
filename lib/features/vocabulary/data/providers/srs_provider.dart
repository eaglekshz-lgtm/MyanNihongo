import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../models/srs_card_model.dart';
import '../../domain/entities/srs_card.dart';

/// Provider for SRS cards box
final srsBoxProvider = Provider<Box<SRSCardModel>>((ref) {
  return Hive.box<SRSCardModel>(AppConstants.srsCardsBoxName);
});

/// Provider for all SRS cards
final allSRSCardsProvider =
    StateNotifierProvider<SRSCardsNotifier, AsyncValue<List<SRSCard>>>((ref) {
      final box = ref.watch(srsBoxProvider);
      return SRSCardsNotifier(box);
    });

/// Notifier for managing SRS cards
class SRSCardsNotifier extends StateNotifier<AsyncValue<List<SRSCard>>> {
  final Box<SRSCardModel> _box;

  SRSCardsNotifier(this._box) : super(const AsyncValue.loading()) {
    _loadCards();
  }

  /// Load all SRS cards from storage
  Future<void> _loadCards() async {
    try {
      final models = _box.values.toList();
      final cards = models.map((model) => model.toEntity()).toList();
      state = AsyncValue.data(cards);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Get or create SRS card for a vocabulary item
  Future<SRSCard> getOrCreateCard(String vocabularyId) async {
    try {
      final model = _box.get(vocabularyId);
      if (model != null) {
        return model.toEntity();
      }

      // Create new card
      final newCard = SRSCard.newCard(vocabularyId);
      await _saveCard(newCard);
      return newCard;
    } catch (e) {
      AppLogger.error('Error getting/creating SRS card', tag: 'SRS', error: e);
      return SRSCard.newCard(vocabularyId);
    }
  }

  /// Save SRS card to storage
  Future<void> _saveCard(SRSCard card) async {
    try {
      final model = SRSCardModel.fromEntity(card);
      await _box.put(card.vocabularyId, model);
      await _loadCards(); // Refresh state
    } catch (e) {
      AppLogger.error('Error saving SRS card', tag: 'SRS', error: e);
    }
  }

  /// Review a card with quality rating (0-5)
  Future<void> reviewCard(String vocabularyId, int quality) async {
    try {
      final card = await getOrCreateCard(vocabularyId);
      final updatedCard = card.review(quality);
      await _saveCard(updatedCard);
    } catch (e) {
      AppLogger.error('Error reviewing card', tag: 'SRS', error: e);
    }
  }

  /// Get all cards due for review
  List<SRSCard> getDueCards() {
    final currentState = state;
    if (!currentState.hasValue) return [];

    final cards = currentState.value!;
    return cards.where((card) => card.isDue).toList()
      ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));
  }

  /// Get cards by level
  List<SRSCard> getCardsByLevel(SRSLevel level) {
    final currentState = state;
    if (!currentState.hasValue) return [];

    final cards = currentState.value!;
    return cards.where((card) => card.level == level).toList();
  }

  /// Get new cards (not yet reviewed)
  List<SRSCard> getNewCards({int limit = 20}) {
    final currentState = state;
    if (!currentState.hasValue) return [];

    final cards = currentState.value!;
    return cards
        .where((card) => card.level == SRSLevel.newCard)
        .take(limit)
        .toList();
  }

  /// Reset a card (for testing or user request)
  Future<void> resetCard(String vocabularyId) async {
    try {
      final newCard = SRSCard.newCard(vocabularyId);
      await _saveCard(newCard);
    } catch (e) {
      AppLogger.error('Error resetting card', tag: 'SRS', error: e);
    }
  }

  /// Delete a card
  Future<void> deleteCard(String vocabularyId) async {
    try {
      await _box.delete(vocabularyId);
      await _loadCards();
    } catch (e) {
      AppLogger.error('Error deleting card', tag: 'SRS', error: e);
    }
  }
}

/// Provider for SRS statistics
final srsStatsProvider = Provider<SRSStats>((ref) {
  final cardsAsync = ref.watch(allSRSCardsProvider);

  return cardsAsync.when(
    data: (cards) {
      final dueCards = cards.where((c) => c.isDue).length;
      final newCards = cards.where((c) => c.level == SRSLevel.newCard).length;
      final learningCards = cards
          .where((c) => c.level == SRSLevel.learning)
          .length;
      final youngCards = cards.where((c) => c.level == SRSLevel.young).length;
      final matureCards = cards.where((c) => c.level == SRSLevel.mature).length;
      final masteredCards = cards
          .where((c) => c.level == SRSLevel.mastered)
          .length;

      // Calculate average retention
      final cardsWithReviews = cards.where((c) => c.repetitions > 0);
      final avgRetention = cardsWithReviews.isEmpty
          ? 0.0
          : cardsWithReviews
                    .map((c) => c.retentionRate)
                    .reduce((a, b) => a + b) /
                cardsWithReviews.length;

      return SRSStats(
        totalCards: cards.length,
        dueCards: dueCards,
        newCards: newCards,
        learningCards: learningCards,
        youngCards: youngCards,
        matureCards: matureCards,
        masteredCards: masteredCards,
        averageRetention: avgRetention,
      );
    },
    loading: () => SRSStats.empty(),
    error: (_, __) => SRSStats.empty(),
  );
});

/// SRS statistics data class
class SRSStats {
  final int totalCards;
  final int dueCards;
  final int newCards;
  final int learningCards;
  final int youngCards;
  final int matureCards;
  final int masteredCards;
  final double averageRetention;

  const SRSStats({
    required this.totalCards,
    required this.dueCards,
    required this.newCards,
    required this.learningCards,
    required this.youngCards,
    required this.matureCards,
    required this.masteredCards,
    required this.averageRetention,
  });

  factory SRSStats.empty() {
    return const SRSStats(
      totalCards: 0,
      dueCards: 0,
      newCards: 0,
      learningCards: 0,
      youngCards: 0,
      matureCards: 0,
      masteredCards: 0,
      averageRetention: 0.0,
    );
  }

  /// Get total cards in review (not new)
  int get reviewCards =>
      learningCards + youngCards + matureCards + masteredCards;
}
