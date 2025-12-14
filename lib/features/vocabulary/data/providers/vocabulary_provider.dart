import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../repositories/vocabulary_repository.dart';
import '../repositories/impl/vocabulary_repository_impl.dart';
import '../models/vocabulary_item_model.dart';
import '../models/user_progress_model.dart';
import '../models/block_progress_model.dart';
import '../models/vocabulary_filter.dart';
import '../models/system_update_model.dart';
import '../datasources/vocabulary_local_datasource.dart';
import '../datasources/vocabulary_remote_datasource.dart';
import '../datasources/vocabulary_file_datasource.dart';
import '../datasources/system_update_datasource.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

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
    final supabase = Supabase.instance.client;
    return VocabularyRemoteDataSource(supabase);
  },
);

/// Provider for vocabulary file data source
final vocabularyFileDataSourceProvider = Provider<VocabularyFileDataSource>((
  ref,
) {
  return VocabularyFileDataSource();
});

/// Provider for system update box
final systemUpdateBoxProvider = Provider<Box<SystemUpdateModel>>((ref) {
  return Hive.box<SystemUpdateModel>(AppConstants.systemUpdateBoxName);
});

/// Provider for system update data source
final systemUpdateDataSourceProvider = Provider<SystemUpdateDataSource>((ref) {
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
  final fileDataSource = ref.read(vocabularyFileDataSourceProvider);
  final systemUpdateDataSource = ref.read(systemUpdateDataSourceProvider);

  return VocabularyRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    fileDataSource: fileDataSource,
    systemUpdateDataSource: systemUpdateDataSource,
  );
});

// ============================================================================
// Vocabulary Data Providers
// ============================================================================

/// Provider for getting vocabulary by level with API fallback to local file
/// Uses autoDispose to prevent memory leaks when navigating away
final vocabularyByLevelProvider = FutureProvider.family
    .autoDispose<List<VocabularyItemModel>, String>((ref, level) async {
      final repository = ref.read(vocabularyRepositoryProvider);
      return repository.getVocabularyByLevel(level);
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
