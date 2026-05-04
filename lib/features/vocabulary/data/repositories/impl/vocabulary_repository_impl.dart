import '../vocabulary_repository.dart';
import '../../models/vocabulary_item_model.dart';
import '../../models/vocabulary_filter.dart';
import '../../models/user_progress_model.dart';
import '../../models/block_progress_model.dart';
import '../../datasources/vocabulary_local_datasource.dart';
import '../../datasources/vocabulary_remote_datasource.dart';
import '../../datasources/system_update_datasource.dart';
import '../../../../../core/utils/logger.dart';

/// Implementation of VocabularyRepository
/// Handles data fetching with remote/cache fallback behavior
/// Now includes system update checking to avoid unnecessary fetches
class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyLocalDataSource _localDataSource;
  final VocabularyRemoteDataSource _remoteDataSource;
  final SystemUpdateDataSource? _systemUpdateDataSource;

  VocabularyRepositoryImpl({
    required VocabularyLocalDataSource localDataSource,
    required VocabularyRemoteDataSource remoteDataSource,
    SystemUpdateDataSource? systemUpdateDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _systemUpdateDataSource = systemUpdateDataSource;

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevelAndType(
    VocabularyFilter filter,
  ) async {
    List<VocabularyItemModel> vocabulary = [];

    // Check if we need to update vocabulary from server
    bool shouldFetchFromServer = true;
    if (_systemUpdateDataSource != null) {
      try {
        final tag = filter.level
            .toUpperCase(); // Use N5, N4, N3, N2, N1 directly
        shouldFetchFromServer = await _systemUpdateDataSource
            .needsVocabularyUpdate(tag);

        if (!shouldFetchFromServer) {
          AppLogger.info(
            'Vocabulary for ${filter.level} is up to date, using cache',
            'VocabRepository',
          );
          // Try to get from cache first
          final cachedVocabulary = await _localDataSource.getVocabularyByLevel(
            filter.level.toUpperCase(),
          );
          if (cachedVocabulary.isNotEmpty) {
            return cachedVocabulary;
          }
          // If cache is empty, fetch from server anyway
          shouldFetchFromServer = true;
          AppLogger.warning(
            'Cache is empty despite update check, fetching from server',
            'VocabRepository',
          );
        }
      } catch (e) {
        AppLogger.warning(
          'Error checking for updates, will fetch from server: $e',
          'VocabRepository',
        );
        shouldFetchFromServer = true;
      }
    }

    try {
      // Fetch from API if needed
      if (shouldFetchFromServer) {
        final vocabularyFromApi = await _remoteDataSource.getVocabularyByLevel(
          filter.level,
        );

        if (vocabularyFromApi.isNotEmpty) {
          // Save to cache
          AppLogger.data(
            'Saving ${vocabularyFromApi.length} items from API to cache',
            operation: 'SAVE',
          );
          await _localDataSource.saveVocabulary(vocabularyFromApi);

          // Update system update timestamp
          if (_systemUpdateDataSource != null) {
            try {
              final tag = filter.level
                  .toUpperCase(); // Use N5, N4, N3, N2, N1 directly
              final serverUpdate = await _systemUpdateDataSource
                  .getSystemUpdateByTag(tag);
              if (serverUpdate != null) {
                await _systemUpdateDataSource.saveLocalSystemUpdate(
                  serverUpdate,
                );
              }
            } catch (e) {
              AppLogger.warning(
                'Error saving system update timestamp: $e',
                'VocabRepository',
              );
            }
          }

          // Verify what was actually saved
          final savedCount = await _localDataSource.getVocabularyByLevel(
            filter.level.toUpperCase(),
          );
          AppLogger.info(
            'API: ${vocabularyFromApi.length} items, Cached: ${savedCount.length} items',
            'VocabRepository',
          );
          vocabulary = vocabularyFromApi;
        } else {
          // Treat empty API as failure to trigger fallback
          throw Exception('API returned empty list');
        }
      }
    } catch (apiError) {
      AppLogger.warning(
        'Remote vocabulary load failed, checking cache: $apiError',
        'VocabRepository',
      );
      final cachedVocabulary = await _localDataSource.getVocabularyByLevel(
        filter.level.toUpperCase(),
      );

      if (cachedVocabulary.isNotEmpty) {
        AppLogger.data(
          'Using ${cachedVocabulary.length} items from cache',
          operation: 'READ',
        );
        vocabulary = cachedVocabulary;
      } else {
        AppLogger.warning(
          'No vocabulary found for level: ${filter.level}',
          'VocabRepository',
        );
        return [];
      }
    }

    return vocabulary;
  }

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async {
    final filter = VocabularyFilter(level: level, wordType: 'all');
    return getVocabularyByLevelAndType(filter);
  }

  @override
  Future<int> getVocabularyCountByLevel(String level) async {
    try {
      // Try to get count from remote datasource first
      final count = await _remoteDataSource.getVocabularyCountByLevel(level);
      AppLogger.data(
        'Retrieved count from remote: $count for level $level',
        operation: 'READ',
      );
      return count;
    } catch (e) {
      // If remote fails, fall back to counting local cache
      AppLogger.warning(
        'Failed to get count from remote, using local cache: $e',
        'VocabRepository',
      );
      final cachedVocabulary = await _localDataSource.getVocabularyByLevel(
        level.toUpperCase(),
      );
      return cachedVocabulary.length;
    }
  }

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevelWithRange(
    String level,
    int offset,
    int limit,
  ) async {
    // First, check if we have this data in cache
    try {
      final cachedVocabulary = await _localDataSource.getVocabularyByLevel(
        level.toUpperCase(),
      );

      if (cachedVocabulary.isNotEmpty) {
        // Check if cache has the requested range
        final endIndex = offset + limit;
        if (cachedVocabulary.length >= endIndex) {
          AppLogger.info(
            'Using cached data for range (offset: $offset, limit: $limit)',
            'VocabRepository',
          );
          return cachedVocabulary.sublist(offset, endIndex);
        } else if (offset < cachedVocabulary.length) {
          // Partial cache hit - we have some data but need more
          AppLogger.info(
            'Partial cache hit: have ${cachedVocabulary.length}, need up to $endIndex',
            'VocabRepository',
          );
        }
      }
    } catch (e) {
      AppLogger.warning('Error checking cache: $e', 'VocabRepository');
    }

    // Fetch from remote if not in cache
    try {
      final vocabulary = await _remoteDataSource.getVocabularyByLevelWithRange(
        level,
        offset,
        limit,
      );

      AppLogger.data(
        'Retrieved ${vocabulary.length} items from remote (offset: $offset, limit: $limit)',
        operation: 'READ',
      );

      // Save fetched data to cache
      if (vocabulary.isNotEmpty) {
        try {
          await _localDataSource.saveVocabulary(vocabulary);
          AppLogger.info(
            'Saved ${vocabulary.length} items to cache',
            'VocabRepository',
          );
        } catch (saveError) {
          AppLogger.warning(
            'Failed to save to cache: $saveError',
            'VocabRepository',
          );
          // Continue anyway with the fetched data
        }
      }

      return vocabulary;
    } catch (e) {
      AppLogger.error(
        'Failed to fetch vocabulary with range: $e',
        tag: 'VocabRepository',
        error: e,
      );

      // Final fallback: try to get from local cache within the range
      final cachedVocabulary = await _localDataSource.getVocabularyByLevel(
        level.toUpperCase(),
      );
      if (cachedVocabulary.isEmpty) {
        return [];
      }
      // Return the range from cached data if available
      final endIndex = (offset + limit > cachedVocabulary.length)
          ? cachedVocabulary.length
          : offset + limit;
      if (offset >= cachedVocabulary.length) {
        return [];
      }
      return cachedVocabulary.sublist(offset, endIndex);
    }
  }

  @override
  Future<List<VocabularyItemModel>> getAllVocabulary() async {
    return await _localDataSource.getAllVocabulary();
  }

  @override
  Future<void> saveVocabulary(List<VocabularyItemModel> vocabulary) async {
    await _localDataSource.saveVocabulary(vocabulary);
  }

  @override
  Future<UserProgressModel?> getUserProgress(String vocabularyId) async {
    return await _localDataSource.getUserProgress(vocabularyId);
  }

  @override
  Future<List<UserProgressModel>> getAllUserProgress() async {
    return await _localDataSource.getAllProgress();
  }

  @override
  Future<void> saveUserProgress(UserProgressModel progress) async {
    await _localDataSource.saveUserProgress(progress);
  }

  @override
  Future<List<BlockProgressModel>> getBlockProgressByLevelAndType(
    String level,
    String? wordType,
  ) async {
    return await _localDataSource.getBlockProgressByLevelAndType(
      level,
      wordType,
    );
  }

  @override
  Future<BlockProgressModel?> getBlockProgress(String blockId) async {
    return await _localDataSource.getBlockProgress(blockId);
  }

  @override
  Future<void> saveBlockProgress(BlockProgressModel progress) async {
    await _localDataSource.saveBlockProgress(progress);
  }

  @override
  Future<UserProgressModel> updateUserProgress(
    String vocabularyId,
    bool isCorrect,
  ) async {
    // Get existing progress or create new one
    var progress = await _localDataSource.getUserProgress(vocabularyId);

    if (progress == null) {
      // Create new progress entry
      progress = UserProgressModel(
        vocabularyId: vocabularyId,
        timesViewed: 1,
        timesAnsweredCorrectly: isCorrect ? 1 : 0,
        timesAnsweredIncorrectly: isCorrect ? 0 : 1,
        lastReviewed: DateTime.now(),
        isMastered: false,
      );
    } else {
      // Update existing progress
      progress = progress.copyWith(
        timesViewed: progress.timesViewed + 1,
        timesAnsweredCorrectly:
            progress.timesAnsweredCorrectly + (isCorrect ? 1 : 0),
        timesAnsweredIncorrectly:
            progress.timesAnsweredIncorrectly + (isCorrect ? 0 : 1),
        lastReviewed: DateTime.now(),
        // Mark as mastered if accuracy >= 80%
        isMastered: progress.accuracy >= 0.8,
      );
    }

    // Save updated progress
    await _localDataSource.saveUserProgress(progress);

    AppLogger.info(
      'Updated progress for vocabulary $vocabularyId: '
          'viewed=${progress.timesViewed}, '
          'correct=${progress.timesAnsweredCorrectly}, '
          'incorrect=${progress.timesAnsweredIncorrectly}, '
          'mastered=${progress.isMastered}',
      'VocabRepository',
    );

    return progress;
  }

  @override
  Future<BlockProgressModel> updateBlockProgress(
    String blockId,
    String level,
    int blockNumber,
    int startIndex,
    int completedWords,
    int totalWords, {
    String? wordType,
    bool isCompleted = false,
  }) async {
    // Get existing progress or create new one
    var progress = await _localDataSource.getBlockProgress(blockId);

    if (progress == null) {
      // Create new progress entry
      progress = BlockProgressModel(
        blockId: blockId,
        blockNumber: blockNumber,
        level: level,
        wordType: wordType,
        startIndex: startIndex,
        completedWords: completedWords,
        totalWords: totalWords,
        lastStudied: DateTime.now(),
        isCompleted: isCompleted,
        completionCount: isCompleted ? 1 : 0,
      );
    } else {
      // Update existing progress
      final wasCompleted = progress.isCompleted;
      final nowCompleted = isCompleted || completedWords >= totalWords;

      progress = progress.copyWith(
        completedWords: completedWords,
        totalWords: totalWords,
        lastStudied: DateTime.now(),
        isCompleted: nowCompleted,
        // Increment completion count if transitioning from incomplete to complete
        completionCount: (!wasCompleted && nowCompleted)
            ? progress.completionCount + 1
            : progress.completionCount,
      );
    }

    // Save updated progress
    await _localDataSource.saveBlockProgress(progress);

    AppLogger.info(
      'Updated block progress $blockId: '
          '${progress.completedWords}/$totalWords, '
          'completed=${progress.isCompleted}, '
          'count=${progress.completionCount}',
      'VocabRepository',
    );

    return progress;
  }

  @override
  Future<void> resetBlockProgress(String blockId) async {
    // Get existing progress
    final progress = await _localDataSource.getBlockProgress(blockId);

    if (progress != null) {
      // Reset progress while keeping completion history
      final resetProgress = progress.copyWith(
        completedWords: 0,
        lastStudied: DateTime.now(),
        isCompleted: false,
        // Keep completion count to track how many times user has completed this block
      );

      await _localDataSource.saveBlockProgress(resetProgress);

      AppLogger.info(
        'Reset block progress for $blockId (completion count preserved: ${resetProgress.completionCount})',
        'VocabRepository',
      );
    }
  }
}
