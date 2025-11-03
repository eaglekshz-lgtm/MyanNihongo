import '../vocabulary_repository.dart';
import '../../models/vocabulary_item_model.dart';
import '../../models/vocabulary_filter.dart';
import '../../models/user_progress_model.dart';
import '../../models/block_progress_model.dart';
import '../../datasources/vocabulary_local_datasource.dart';
import '../../datasources/vocabulary_remote_datasource.dart';
import '../../datasources/vocabulary_file_datasource.dart';
import '../../../../../core/utils/logger.dart';

/// Implementation of VocabularyRepository
/// Handles data fetching with API fallback to local files and caching
class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyLocalDataSource _localDataSource;
  final VocabularyRemoteDataSource _remoteDataSource;
  final VocabularyFileDataSource _fileDataSource;

  VocabularyRepositoryImpl({
    required VocabularyLocalDataSource localDataSource,
    required VocabularyRemoteDataSource remoteDataSource,
    required VocabularyFileDataSource fileDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _fileDataSource = fileDataSource;

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevelAndType(
    VocabularyFilter filter,
  ) async {
    List<VocabularyItemModel> vocabulary = [];

    try {
      // First, try to get from API
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
    } catch (apiError) {
      try {
        // If API fails, try to load from local file
        AppLogger.info('API failed, loading from local file', 'VocabRepository');
        final vocabularyFromFile = await _fileDataSource.loadVocabularyFromFile(
          filter.level,
        );

        // Save to cache
        try {
          AppLogger.data(
            'Saving ${vocabularyFromFile.length} items from file to cache',
            operation: 'SAVE',
          );
          await _localDataSource.saveVocabulary(vocabularyFromFile);

          // Verify what was actually saved
          final savedCount = await _localDataSource.getVocabularyByLevel(
            filter.level.toUpperCase(),
          );
          AppLogger.info(
            'File: ${vocabularyFromFile.length} items, Cached: ${savedCount.length} items',
            'VocabRepository',
          );
        } catch (saveError) {
          AppLogger.warning(
            'Error saving to cache: $saveError',
            'VocabRepository',
          );
          // Continue anyway with the loaded data
        }

        vocabulary = vocabularyFromFile;
      } catch (fileError) {
        // If both fail, check cache using JLPT level (N5, N4, etc.)
        AppLogger.warning(
          'File loading failed, checking cache',
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
          // If everything fails, return empty list instead of throwing
          AppLogger.warning(
            'No vocabulary found for level: ${filter.level}',
            'VocabRepository',
          );
          return [];
        }
      }
    }

    // Final safety: if still empty, attempt direct file load without saving
    if (vocabulary.isEmpty) {
      try {
        AppLogger.warning(
          'Repository empty, attempting direct file load for ${filter.level}',
          'VocabRepository',
        );
        final fromFile = await _fileDataSource.loadVocabularyFromFile(
          filter.level,
        );
        if (fromFile.isNotEmpty) {
          vocabulary = fromFile;
          AppLogger.info(
            'Direct file load recovered ${fromFile.length} items',
            'VocabRepository',
          );
        }
      } catch (_) {}
    }

    return vocabulary;
  }

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async {
    final filter = VocabularyFilter(level: level, wordType: 'all');
    return getVocabularyByLevelAndType(filter);
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
