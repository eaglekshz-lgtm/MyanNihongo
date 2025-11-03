import 'package:hive/hive.dart';
import '../models/vocabulary_item_model.dart';
import '../models/user_progress_model.dart';
import '../models/block_progress_model.dart';
import '../../../../core/utils/logger.dart';

/// Local data source for vocabulary items using Hive
class VocabularyLocalDataSource {
  final Box<VocabularyItemModel> _vocabularyBox;
  final Box<UserProgressModel> _progressBox;
  final Box<BlockProgressModel> _blockProgressBox;

  VocabularyLocalDataSource(
    this._vocabularyBox,
    this._progressBox,
    this._blockProgressBox,
  );

  /// Get all vocabulary items
  Future<List<VocabularyItemModel>> getAllVocabulary() async {
    return _vocabularyBox.values.toList();
  }

  /// Get vocabulary items by level
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async {
    return _vocabularyBox.values
        .toList();
  }

  /// Get a single vocabulary item by ID
  Future<VocabularyItemModel?> getVocabularyById(String id) async {
    return _vocabularyBox.get(id);
  }

  /// Save vocabulary items
  /// Clears existing items before saving to prevent duplicates
  Future<void> saveVocabulary(List<VocabularyItemModel> items) async {
    if (items.isEmpty) return;
    
    // Clear existing items to prevent ID conflicts
    AppLogger.data('Clearing existing vocabulary', operation: 'DELETE');
    await _vocabularyBox.clear();
    
    // Now save the new items
    AppLogger.data('Saving ${items.length} new items', operation: 'SAVE');
    final map = {for (var item in items) item.id: item};
    await _vocabularyBox.putAll(map);
    
    // Verify what was saved
    final savedCount = _vocabularyBox.values.length;
    AppLogger.info('Saved and verified: $savedCount items in Hive', 'LocalDataSource');
  }

  /// Get user progress for a vocabulary item
  Future<UserProgressModel?> getUserProgress(String vocabularyId) async {
    return _progressBox.get(vocabularyId);
  }

  /// Save user progress
  Future<void> saveUserProgress(UserProgressModel progress) async {
    await _progressBox.put(progress.vocabularyId, progress);
  }

  /// Get all user progress
  Future<List<UserProgressModel>> getAllProgress() async {
    return _progressBox.values.toList();
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _vocabularyBox.clear();
    await _progressBox.clear();
    await _blockProgressBox.clear();
  }

  /// Get block progress
  Future<BlockProgressModel?> getBlockProgress(String blockId) async {
    return _blockProgressBox.get(blockId);
  }

  /// Save block progress
  Future<void> saveBlockProgress(BlockProgressModel progress) async {
    await _blockProgressBox.put(progress.blockId, progress);
  }

  /// Get all block progress
  Future<List<BlockProgressModel>> getAllBlockProgress() async {
    return _blockProgressBox.values.toList();
  }

  /// Get block progress for a specific level and word type
  Future<List<BlockProgressModel>> getBlockProgressByLevelAndType(
    String level,
    String? wordType,
  ) async {
    final type = wordType ?? 'all';
    return _blockProgressBox.values
        .where((block) => block.level == level && (block.wordType ?? 'all') == type)
        .toList();
  }
}
