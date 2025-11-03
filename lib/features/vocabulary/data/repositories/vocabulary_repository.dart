import '../models/vocabulary_item_model.dart';
import '../models/vocabulary_filter.dart';
import '../models/user_progress_model.dart';
import '../models/block_progress_model.dart';

/// Repository interface for vocabulary data access
/// This interface defines the contract for vocabulary data operations
abstract class VocabularyRepository {
  /// Get vocabulary items by level and optional word type
  Future<List<VocabularyItemModel>> getVocabularyByLevelAndType(
    VocabularyFilter filter,
  );

  /// Get vocabulary items by level only
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level);

  /// Get all vocabulary items
  Future<List<VocabularyItemModel>> getAllVocabulary();

  /// Save vocabulary items to cache
  Future<void> saveVocabulary(List<VocabularyItemModel> vocabulary);

  /// Get user progress for a specific vocabulary item
  Future<UserProgressModel?> getUserProgress(String vocabularyId);

  /// Get all user progress
  Future<List<UserProgressModel>> getAllUserProgress();

  /// Save user progress
  Future<void> saveUserProgress(UserProgressModel progress);

  /// Update user progress based on quiz/learning result
  /// This method creates or updates progress and handles mastery calculation
  Future<UserProgressModel> updateUserProgress(
    String vocabularyId,
    bool isCorrect,
  );

  /// Get block progress by level and type
  Future<List<BlockProgressModel>> getBlockProgressByLevelAndType(
    String level,
    String? wordType,
  );

  /// Get single block progress
  Future<BlockProgressModel?> getBlockProgress(String blockId);

  /// Save block progress
  Future<void> saveBlockProgress(BlockProgressModel progress);

  /// Update block progress with completion tracking
  /// Returns the updated block progress model
  Future<BlockProgressModel> updateBlockProgress(
    String blockId,
    String level,
    int blockNumber,
    int startIndex,
    int completedWords,
    int totalWords, {
    String? wordType,
    bool isCompleted = false,
  });

  /// Reset block progress to start over
  Future<void> resetBlockProgress(String blockId);
}
