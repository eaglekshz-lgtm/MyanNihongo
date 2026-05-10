import 'dart:async';

import '../vocabulary_repository.dart';
import '../../models/vocabulary_item_model.dart';
import '../../models/vocabulary_filter.dart';
import '../../models/user_progress_model.dart';
import '../../models/block_progress_model.dart';
import '../../datasources/vocabulary_local_datasource.dart';
import '../../datasources/vocabulary_remote_datasource.dart';
import '../../datasources/system_update_datasource.dart';
import '../../../../../core/constants/app_constants.dart';
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

  Future<bool> _hasCompleteCache(String level, int cachedCount) async {
    if (cachedCount == 0) return false;

    try {
      final remoteCount = await _remoteDataSource.getVocabularyCountByLevel(
        level,
      );
      final isComplete = cachedCount >= remoteCount;

      if (!isComplete) {
        AppLogger.info(
          'Cache for $level is incomplete: cached $cachedCount of $remoteCount',
          'VocabRepository',
        );
      }

      return isComplete;
    } catch (e) {
      AppLogger.warning(
        'Unable to verify vocabulary cache completeness for $level: $e',
        'VocabRepository',
      );
      return true;
    }
  }

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
          final hasCompleteCache = await _hasCompleteCache(
            filter.level,
            cachedVocabulary.length,
          );
          if (hasCompleteCache) {
            return cachedVocabulary;
          }
          // If cache is empty or incomplete, fetch from server anyway
          shouldFetchFromServer = true;
          AppLogger.warning(
            'Cache is empty or incomplete despite update check, fetching from server',
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
      return _localDataSource.getCachedVocabularyCountByLevel(
        level.toUpperCase(),
      );
    }
  }

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevelWithRange(
    String level,
    int offset,
    int limit,
  ) async {
    if (limit <= 0) return [];

    final normalizedLevel = level.toUpperCase();
    final safeOffset = offset < 0 ? 0 : offset;
    var cachedVocabulary = <VocabularyItemModel>[];

    // First, return a complete cached range immediately when available.
    try {
      cachedVocabulary = await _localDataSource.getVocabularyByLevelRange(
        normalizedLevel,
        safeOffset,
        limit,
      );

      if (cachedVocabulary.length == limit) {
        AppLogger.info(
          'Using cached range for $normalizedLevel (offset: $safeOffset, limit: $limit)',
          'VocabRepository',
        );
        _refreshVocabularyRangeInBackground(normalizedLevel, safeOffset, limit);
        return cachedVocabulary;
      }

      if (cachedVocabulary.isNotEmpty) {
        AppLogger.info(
          'Partial cached range for $normalizedLevel: ${cachedVocabulary.length}/$limit items',
          'VocabRepository',
        );
      }
    } catch (e) {
      AppLogger.warning('Error checking cache: $e', 'VocabRepository');
    }

    // Fetch only the requested range when cache is missing or incomplete.
    try {
      final vocabulary = await _fetchVocabularyRangeFromRemote(
        normalizedLevel,
        safeOffset,
        limit,
      );
      if (vocabulary.isNotEmpty) {
        return vocabulary;
      }

      return cachedVocabulary;
    } catch (e) {
      AppLogger.error(
        'Failed to fetch vocabulary with range: $e',
        tag: 'VocabRepository',
        error: e,
      );

      return cachedVocabulary;
    }
  }

  void _refreshVocabularyRangeInBackground(
    String level,
    int offset,
    int limit,
  ) {
    unawaited(() async {
      try {
        await _fetchVocabularyRangeFromRemote(level, offset, limit);
      } catch (e) {
        AppLogger.warning(
          'Background vocabulary refresh failed for $level '
              '(offset: $offset, limit: $limit): $e',
          'VocabRepository',
        );
      }
    }());
  }

  Future<List<VocabularyItemModel>> _fetchVocabularyRangeFromRemote(
    String level,
    int offset,
    int limit,
  ) async {
    final vocabulary = await _remoteDataSource.getVocabularyByLevelWithRange(
      level,
      offset,
      limit,
    );

    AppLogger.data(
      'Retrieved ${vocabulary.length} items from remote (offset: $offset, limit: $limit)',
      operation: 'READ',
    );

    if (vocabulary.isEmpty) {
      return vocabulary;
    }

    try {
      await _localDataSource.saveVocabulary(vocabulary, replaceLevel: false);
      AppLogger.info(
        'Saved ${vocabulary.length} range items to cache',
        'VocabRepository',
      );
    } catch (saveError) {
      AppLogger.warning(
        'Failed to save range to cache: $saveError',
        'VocabRepository',
      );
    }

    return vocabulary;
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
      final correctAnswers =
          progress.timesAnsweredCorrectly + (isCorrect ? 1 : 0);
      final incorrectAnswers =
          progress.timesAnsweredIncorrectly + (isCorrect ? 0 : 1);
      final totalAnswers = correctAnswers + incorrectAnswers;
      final accuracy = totalAnswers == 0 ? 0.0 : correctAnswers / totalAnswers;

      progress = progress.copyWith(
        timesViewed: progress.timesViewed + 1,
        timesAnsweredCorrectly: correctAnswers,
        timesAnsweredIncorrectly: incorrectAnswers,
        lastReviewed: DateTime.now(),
        isMastered: accuracy >= AppConstants.masteryThreshold,
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
