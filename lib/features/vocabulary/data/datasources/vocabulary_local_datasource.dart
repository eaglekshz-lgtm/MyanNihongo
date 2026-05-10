import 'package:hive/hive.dart';
import '../models/vocabulary_item_model.dart';
import '../models/user_progress_model.dart';
import '../models/block_progress_model.dart';
import '../../../../core/utils/logger.dart';

/// Local data source for vocabulary items using Hive
class VocabularyLocalDataSource {
  final LazyBox<VocabularyItemModel> _vocabularyBox;
  final Box<UserProgressModel> _progressBox;
  final Box<BlockProgressModel> _blockProgressBox;
  final Box<dynamic> _appPreferencesBox;

  static const String _levelIndexPrefix = 'vocabulary_level_index_';

  VocabularyLocalDataSource(
    this._vocabularyBox,
    this._progressBox,
    this._blockProgressBox,
    this._appPreferencesBox,
  );

  /// Get all vocabulary items
  Future<List<VocabularyItemModel>> getAllVocabulary() async {
    final items = <VocabularyItemModel>[];
    for (final key in _vocabularyBox.keys) {
      final item = await _vocabularyBox.get(key);
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }

  /// Get vocabulary items by level
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async {
    final normalizedLevel = level.toUpperCase();
    final ids = await _getOrBuildLevelIndex(normalizedLevel);
    return _itemsForIds(ids);
  }

  /// Get only a range of vocabulary items for a level.
  ///
  /// The range is resolved through a Hive-backed level index so callers do not
  /// need to materialize the whole level just to show one learning batch.
  Future<List<VocabularyItemModel>> getVocabularyByLevelRange(
    String level,
    int offset,
    int limit,
  ) async {
    if (limit <= 0) return [];

    final normalizedLevel = level.toUpperCase();
    final ids = await _getOrBuildLevelIndex(normalizedLevel);
    if (ids.isEmpty || offset >= ids.length) return [];

    final safeOffset = offset < 0 ? 0 : offset;
    final rangeIds = ids.skip(safeOffset).take(limit).toList();
    var items = await _itemsForIds(rangeIds);

    if (items.length == rangeIds.length) {
      return items;
    }

    // Repair stale index entries caused by old cache data or manual Hive edits.
    final rebuiltIds = await _rebuildLevelIndex(normalizedLevel);
    if (rebuiltIds.isEmpty || safeOffset >= rebuiltIds.length) return [];
    items = await _itemsForIds(rebuiltIds.skip(safeOffset).take(limit));
    return items;
  }

  /// Get locally cached count for a level without reading each object twice.
  Future<int> getCachedVocabularyCountByLevel(String level) async {
    final ids = await _getOrBuildLevelIndex(level.toUpperCase());
    return ids.length;
  }

  /// Get a single vocabulary item by ID
  Future<VocabularyItemModel?> getVocabularyById(String id) async {
    return _vocabularyBox.get(int.tryParse(id) ?? id);
  }

  /// Save vocabulary items.
  /// Full-level refreshes replace the level; range fetches merge into cache.
  Future<void> saveVocabulary(
    List<VocabularyItemModel> items, {
    bool replaceLevel = true,
  }) async {
    if (items.isEmpty) return;

    // Get the tag from the first item (all items should have the same tag)
    final tag = items.first.tag.toUpperCase();
    final existingIds = replaceLevel
        ? await _rebuildLevelIndex(tag)
        : await _getOrBuildLevelIndex(tag);

    // Clear only existing items with the same tag to prevent duplicates
    if (replaceLevel && existingIds.isNotEmpty) {
      AppLogger.data(
        'Clearing ${existingIds.length} existing items with tag $tag',
        operation: 'DELETE',
      );
      await _vocabularyBox.deleteAll(existingIds);
    }

    // Now save the new items
    AppLogger.data(
      'Saving ${items.length} new items with tag $tag',
      operation: 'SAVE',
    );
    final map = {for (var item in items) item.id: item};
    await _vocabularyBox.putAll(map);
    await _writeLevelIndex(
      tag,
      replaceLevel
          ? items.map((item) => item.id)
          : {...existingIds, ...items.map((item) => item.id)},
    );

    // Verify what was saved
    final savedCount = await getCachedVocabularyCountByLevel(tag);
    AppLogger.info(
      'Saved and verified: $savedCount items with tag $tag in Hive',
      'LocalDataSource',
    );
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
    final indexKeys = _appPreferencesBox.keys
        .where((key) => key is String && key.startsWith(_levelIndexPrefix))
        .toList();
    await _appPreferencesBox.deleteAll(indexKeys);
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
        .where(
          (block) => block.level == level && (block.wordType ?? 'all') == type,
        )
        .toList();
  }

  String _levelIndexKey(String level) {
    return '$_levelIndexPrefix${level.toUpperCase()}';
  }

  List<int>? _readLevelIndex(String level) {
    final rawIndex = _appPreferencesBox.get(_levelIndexKey(level));
    if (rawIndex is! List) return null;

    final ids = <int>[];
    for (final value in rawIndex) {
      if (value is int) {
        ids.add(value);
      } else {
        final parsed = int.tryParse(value.toString());
        if (parsed != null) ids.add(parsed);
      }
    }
    ids.sort();
    return ids;
  }

  Future<void> _writeLevelIndex(String level, Iterable<int> ids) async {
    final sortedIds = ids.toSet().toList()..sort();
    await _appPreferencesBox.put(_levelIndexKey(level), sortedIds);
  }

  Future<List<int>> _getOrBuildLevelIndex(String level) async {
    return _readLevelIndex(level) ?? await _rebuildLevelIndex(level);
  }

  Future<List<int>> _rebuildLevelIndex(String level) async {
    final normalizedLevel = level.toUpperCase();
    final ids = <int>[];
    for (final key in _vocabularyBox.keys) {
      final item = await _vocabularyBox.get(key);
      if (item != null && item.tag.toUpperCase() == normalizedLevel) {
        ids.add(item.id);
      }
    }
    ids.sort();

    await _writeLevelIndex(normalizedLevel, ids);
    return ids;
  }

  Future<List<VocabularyItemModel>> _itemsForIds(Iterable<int> ids) async {
    final items = <VocabularyItemModel>[];
    for (final id in ids) {
      final item = await _vocabularyBox.get(id);
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }
}
