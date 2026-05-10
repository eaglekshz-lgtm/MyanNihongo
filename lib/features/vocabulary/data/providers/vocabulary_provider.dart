import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../repositories/vocabulary_repository.dart';
import '../repositories/impl/vocabulary_repository_impl.dart';
import '../models/vocabulary_item_model.dart';
import '../models/user_progress_model.dart';
import '../models/block_progress_model.dart';
import '../models/vocabulary_filter.dart';
import '../models/system_update_model.dart';
import '../datasources/vocabulary_local_datasource.dart';
import '../datasources/vocabulary_remote_datasource.dart';
import '../datasources/system_update_datasource.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provider for vocabulary box
final vocabularyBoxProvider = Provider<LazyBox<VocabularyItemModel>>((ref) {
  return Hive.lazyBox<VocabularyItemModel>(AppConstants.vocabularyBoxName);
});

/// Provider for user progress box
final userProgressBoxProvider = Provider<Box<UserProgressModel>>((ref) {
  return Hive.box<UserProgressModel>(AppConstants.userProgressBoxName);
});

/// Provider for block progress box
final blockProgressBoxProvider = Provider<Box<BlockProgressModel>>((ref) {
  return Hive.box<BlockProgressModel>(AppConstants.blockProgressBoxName);
});

/// Provider for app preferences box
final appPreferencesBoxProvider = Provider<Box<dynamic>>((ref) {
  return Hive.box<dynamic>(AppConstants.appPreferencesBoxName);
});

/// Provider for vocabulary local data source
/// Note: Using ref.read for box providers since they don't change after initialization
final vocabularyLocalDataSourceProvider = Provider<VocabularyLocalDataSource>((
  ref,
) {
  final vocabularyBox = ref.read(vocabularyBoxProvider);
  final progressBox = ref.read(userProgressBoxProvider);
  final blockProgressBox = ref.read(blockProgressBoxProvider);
  final appPreferencesBox = ref.read(appPreferencesBoxProvider);
  return VocabularyLocalDataSource(
    vocabularyBox,
    progressBox,
    blockProgressBox,
    appPreferencesBox,
  );
});

/// Provider for vocabulary remote data source
final vocabularyRemoteDataSourceProvider = Provider<VocabularyRemoteDataSource>(
  (ref) {
    final supabase = SupabaseConfig.isConfigured
        ? Supabase.instance.client
        : null;
    return VocabularyRemoteDataSource(supabase);
  },
);

/// Provider for system update box
final systemUpdateBoxProvider = Provider<Box<SystemUpdateModel>>((ref) {
  return Hive.box<SystemUpdateModel>(AppConstants.systemUpdateBoxName);
});

/// Provider for system update data source
final systemUpdateDataSourceProvider = Provider<SystemUpdateDataSource?>((ref) {
  if (!SupabaseConfig.isConfigured) {
    return null;
  }

  final supabase = Supabase.instance.client;
  final box = ref.read(systemUpdateBoxProvider);
  return SystemUpdateDataSource(supabase, box);
});

// ============================================================================
// Repository Provider
// ============================================================================

/// Provider for vocabulary repository
/// This is the main provider that should be used by the presentation layer
final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  final localDataSource = ref.read(vocabularyLocalDataSourceProvider);
  final remoteDataSource = ref.read(vocabularyRemoteDataSourceProvider);
  final systemUpdateDataSource = ref.read(systemUpdateDataSourceProvider);

  return VocabularyRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    systemUpdateDataSource: systemUpdateDataSource,
  );
});

// ============================================================================
// Vocabulary Data Providers
// ============================================================================

typedef VocabularyRangeRequest = ({String level, int offset, int limit});

/// Provider for getting vocabulary by level with API fallback to local file
/// Uses autoDispose to prevent memory leaks when navigating away
final vocabularyByLevelProvider = FutureProvider.family
    .autoDispose<List<VocabularyItemModel>, String>((ref, level) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return repository.getVocabularyByLevel(level);
    });

/// Provider for getting only one vocabulary range.
/// This is the preferred provider for learning batches because it avoids
/// loading an entire JLPT level into widget state.
final vocabularyRangeProvider = FutureProvider.family
    .autoDispose<List<VocabularyItemModel>, VocabularyRangeRequest>((
      ref,
      request,
    ) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return repository.getVocabularyByLevelWithRange(
        request.level,
        request.offset,
        request.limit,
      );
    });

/// Provider for prefetching one vocabulary range in the background.
final prefetchVocabularyRangeProvider = FutureProvider.family
    .autoDispose<bool, VocabularyRangeRequest>((ref, request) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      await repository.getVocabularyByLevelWithRange(
        request.level,
        request.offset,
        request.limit,
      );
      return true;
    });

/// Provider for prefetching vocabulary by level
/// Use this to preload vocabulary data in background before user needs it
/// Returns true when prefetch is complete, false if already cached
final prefetchVocabularyProvider = FutureProvider.family.autoDispose<bool, String>((
  ref,
  level,
) async {
  final repository = ref.read(vocabularyRepositoryProvider);

  // Prefetch the vocabulary
  AppLogger.info(
    'Prefetch: Loading first vocabulary batch for $level...',
    'PrefetchProvider',
  );
  final stopwatch = Stopwatch()..start();

  await repository.getVocabularyByLevelWithRange(
    level,
    0,
    AppConstants.defaultVocabularyBatchSize,
  );

  stopwatch.stop();
  AppLogger.info(
    'Prefetch: First vocabulary batch for $level loaded in ${stopwatch.elapsedMilliseconds}ms',
    'PrefetchProvider',
  );
  return true;
});

/// Provider for getting vocabulary by level and word type
/// Uses autoDispose to clean up when widget is disposed
final vocabularyByLevelAndTypeProvider = FutureProvider.family
    .autoDispose<List<VocabularyItemModel>, VocabularyFilter>((
      ref,
      filter,
    ) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return repository.getVocabularyByLevelAndType(filter);
    });

/// Provider for getting vocabulary count by level
/// More efficient than fetching all data when you only need the count
/// Uses autoDispose to clean up when widget is disposed
final vocabularyCountByLevelProvider = FutureProvider.family
    .autoDispose<int, String>((ref, level) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return repository.getVocabularyCountByLevel(level);
    });

/// Provider for getting all vocabulary items
/// Returns all cached vocabulary items without filtering by level
/// Does not automatically load any data - returns empty list if cache is empty
final allVocabularyProvider =
    FutureProvider.autoDispose<List<VocabularyItemModel>>((ref) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getAllVocabulary();
    });

// ============================================================================
// User Progress Providers
// ============================================================================

/// Provider for user progress
/// Uses autoDispose since progress data can change frequently
final userProgressProvider = FutureProvider.family
    .autoDispose<UserProgressModel?, String>((ref, vocabularyId) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getUserProgress(vocabularyId);
    });

/// Provider for all user progress
/// ✅ FIXED: Added autoDispose for memory efficiency
final allUserProgressProvider =
    FutureProvider.autoDispose<List<UserProgressModel>>((ref) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getAllUserProgress();
    });

// ============================================================================
// Block Progress Providers
// ============================================================================

/// Provider for block progress by level and type
/// Uses autoDispose to clean up when navigating away from block selection
final blockProgressProvider = FutureProvider.family
    .autoDispose<List<BlockProgressModel>, ({String level, String? wordType})>((
      ref,
      params,
    ) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getBlockProgressByLevelAndType(
        params.level,
        params.wordType,
      );
    });

/// Provider for single block progress
/// Uses autoDispose for memory efficiency
final singleBlockProgressProvider = FutureProvider.family
    .autoDispose<BlockProgressModel?, String>((ref, blockId) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return await repository.getBlockProgress(blockId);
    });
