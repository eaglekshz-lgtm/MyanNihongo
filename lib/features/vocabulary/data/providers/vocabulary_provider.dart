import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/mock_data.dart';
import '../repositories/vocabulary_repository.dart';
import '../repositories/impl/vocabulary_repository_impl.dart';
import '../models/vocabulary_item_model.dart';
import '../models/user_progress_model.dart';
import '../models/block_progress_model.dart';
import '../models/vocabulary_filter.dart';
import '../datasources/vocabulary_local_datasource.dart';
import '../datasources/vocabulary_remote_datasource.dart';
import '../datasources/vocabulary_file_datasource.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
    ),
  );
});

/// Provider for vocabulary box
final vocabularyBoxProvider = Provider<Box<VocabularyItemModel>>((ref) {
  return Hive.box<VocabularyItemModel>(AppConstants.vocabularyBoxName);
});

/// Provider for user progress box
final userProgressBoxProvider = Provider<Box<UserProgressModel>>((ref) {
  return Hive.box<UserProgressModel>(AppConstants.userProgressBoxName);
});

/// Provider for block progress box
final blockProgressBoxProvider = Provider<Box<BlockProgressModel>>((ref) {
  return Hive.box<BlockProgressModel>(AppConstants.blockProgressBoxName);
});

/// Provider for vocabulary local data source
/// Note: Using ref.read for box providers since they don't change after initialization
final vocabularyLocalDataSourceProvider = Provider<VocabularyLocalDataSource>((
  ref,
) {
  final vocabularyBox = ref.read(vocabularyBoxProvider);
  final progressBox = ref.read(userProgressBoxProvider);
  final blockProgressBox = ref.read(blockProgressBoxProvider);
  return VocabularyLocalDataSource(
    vocabularyBox,
    progressBox,
    blockProgressBox,
  );
});

/// Provider for vocabulary remote data source
final vocabularyRemoteDataSourceProvider = Provider<VocabularyRemoteDataSource>(
  (ref) {
    final dio = ref.read(dioProvider);
    return VocabularyRemoteDataSource(dio);
  },
);

/// Provider for vocabulary file data source
final vocabularyFileDataSourceProvider = Provider<VocabularyFileDataSource>((
  ref,
) {
  return VocabularyFileDataSource();
});

// ============================================================================
// Repository Provider
// ============================================================================

/// Provider for vocabulary repository
/// This is the main provider that should be used by the presentation layer
final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  final localDataSource = ref.read(vocabularyLocalDataSourceProvider);
  final remoteDataSource = ref.read(vocabularyRemoteDataSourceProvider);
  final fileDataSource = ref.read(vocabularyFileDataSourceProvider);

  return VocabularyRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    fileDataSource: fileDataSource,
  );
});

// ============================================================================
// Vocabulary Data Providers
// ============================================================================

/// Provider for getting vocabulary by level with API fallback to local file
/// Uses autoDispose to prevent memory leaks when navigating away
final vocabularyByLevelProvider =
    FutureProvider.family.autoDispose<List<VocabularyItemModel>, String>((
      ref,
      level,
    ) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return repository.getVocabularyByLevel(level);
    });

/// Provider for getting vocabulary by level and word type
/// Uses autoDispose to clean up when widget is disposed
final vocabularyByLevelAndTypeProvider = FutureProvider.family.autoDispose<
    List<VocabularyItemModel>, VocabularyFilter>((
  ref,
  filter,
) async {
  final repository = ref.read(vocabularyRepositoryProvider);
  return repository.getVocabularyByLevelAndType(filter);
});

/// Provider for getting all vocabulary items
/// ✅ FIXED: Added autoDispose to prevent memory leaks
/// Note: If you need global caching across the app, remove autoDispose
/// and consider using ref.keepAlive() in specific screens
final allVocabularyProvider = FutureProvider.autoDispose<List<VocabularyItemModel>>((
  ref,
) async {
  final repository = ref.read(vocabularyRepositoryProvider);
  var items = await repository.getAllVocabulary();

  // If no items in cache, load mock data
  if (items.isEmpty) {
    items = MockVocabularyData.getSampleVocabulary();
    await repository.saveVocabulary(items);
  }

  return items;
});

// ============================================================================
// User Progress Providers
// ============================================================================

/// Provider for user progress
/// Uses autoDispose since progress data can change frequently
final userProgressProvider = FutureProvider.family.autoDispose<UserProgressModel?, String>((
  ref,
  vocabularyId,
) async {
  final repository = ref.read(vocabularyRepositoryProvider);
  return await repository.getUserProgress(vocabularyId);
});

/// Provider for all user progress
/// ✅ FIXED: Added autoDispose for memory efficiency
final allUserProgressProvider = FutureProvider.autoDispose<List<UserProgressModel>>((
  ref,
) async {
  final repository = ref.read(vocabularyRepositoryProvider);
  return await repository.getAllUserProgress();
});

// ============================================================================
// Block Progress Providers
// ============================================================================

/// Provider for block progress by level and type
/// Uses autoDispose to clean up when navigating away from block selection
final blockProgressProvider =
    FutureProvider.family.autoDispose<
      List<BlockProgressModel>,
      ({String level, String? wordType})
    >((ref, params) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getBlockProgressByLevelAndType(
        params.level,
        params.wordType,
      );
    });

/// Provider for single block progress
/// Uses autoDispose for memory efficiency
final singleBlockProgressProvider =
    FutureProvider.family.autoDispose<BlockProgressModel?, String>((ref, blockId) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getBlockProgress(blockId);
    });
