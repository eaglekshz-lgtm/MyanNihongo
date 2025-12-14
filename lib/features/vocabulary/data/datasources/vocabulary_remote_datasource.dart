import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/vocabulary_item_model.dart';

/// Remote data source for vocabulary items using Supabase
class VocabularyRemoteDataSource {
  final SupabaseClient _supabase;

  VocabularyRemoteDataSource(this._supabase);

  /// Fetch vocabulary items by JLPT level from Supabase
  /// Uses the 'japanese_words' table and filters by 'tag' column
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async {
    try {
      AppLogger.info(
        'Fetching vocabulary for level: $level from Supabase',
        'VocabularyRemoteDataSource',
      );

      final response = await _supabase
          .from('japanese_words')
          .select()
          .eq('tag', level)
          .order('id', ascending: true);

      AppLogger.data(
        'Retrieved ${response.length} vocabulary items for level $level',
        operation: 'READ',
      );

      return (response as List)
          .map(
            (json) =>
                VocabularyItemModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (e) {
      AppLogger.error(
        'Supabase error fetching vocabulary: ${e.message}',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw ServerException(
        message: 'Failed to load vocabulary: ${e.message}',
        statusCode: int.tryParse(e.code ?? '500'),
      );
    } catch (e) {
      AppLogger.error(
        'Error parsing vocabulary data: $e',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw DataException(message: 'Failed to parse vocabulary data: $e');
    }
  }

  /// Fetch all vocabulary items from Supabase
  Future<List<VocabularyItemModel>> getAllVocabulary() async {
    try {
      AppLogger.info(
        'Fetching all vocabulary from Supabase',
        'VocabularyRemoteDataSource',
      );

      final response = await _supabase
          .from('japanese_words')
          .select()
          .order('id', ascending: true);

      AppLogger.data(
        'Retrieved ${response.length} total vocabulary items',
        operation: 'READ',
      );

      return (response as List)
          .map(
            (json) =>
                VocabularyItemModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (e) {
      AppLogger.error(
        'Supabase error fetching all vocabulary: ${e.message}',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw ServerException(
        message: 'Failed to load vocabulary: ${e.message}',
        statusCode: int.tryParse(e.code ?? '500'),
      );
    } catch (e) {
      AppLogger.error(
        'Error parsing vocabulary data: $e',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw DataException(message: 'Failed to parse vocabulary data: $e');
    }
  }

  /// Get the count of vocabulary items by JLPT level from Supabase
  /// This is more efficient than fetching all data when you only need the count
  Future<int> getVocabularyCountByLevel(String level) async {
    try {
      AppLogger.info(
        'Fetching vocabulary count for level: $level from Supabase',
        'VocabularyRemoteDataSource',
      );

      final response = await _supabase
          .from('japanese_words')
          .select('id')
          .eq('tag', level)
          .count(CountOption.exact);

      final count = response.count;

      AppLogger.data(
        'Vocabulary count for level $level: $count',
        operation: 'READ',
      );

      return count;
    } on PostgrestException catch (e) {
      AppLogger.error(
        'Supabase error fetching vocabulary count: ${e.message}',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw ServerException(
        message: 'Failed to get vocabulary count: ${e.message}',
        statusCode: int.tryParse(e.code ?? '500'),
      );
    } catch (e) {
      AppLogger.error(
        'Error getting vocabulary count: $e',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw DataException(message: 'Failed to get vocabulary count: $e');
    }
  }

  /// Fetch vocabulary items by JLPT level with range (offset and limit)
  /// This allows lazy loading of vocabulary data
  Future<List<VocabularyItemModel>> getVocabularyByLevelWithRange(
    String level,
    int offset,
    int limit,
  ) async {
    try {
      AppLogger.info(
        'Fetching vocabulary for level: $level (offset: $offset, limit: $limit)',
        'VocabularyRemoteDataSource',
      );

      final response = await _supabase
          .from('japanese_words')
          .select()
          .eq('tag', level)
          .order('id', ascending: true)
          .range(offset, offset + limit - 1);

      AppLogger.data(
        'Retrieved ${response.length} vocabulary items for level $level',
        operation: 'READ',
      );

      return (response as List)
          .map(
            (json) =>
                VocabularyItemModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (e) {
      AppLogger.error(
        'Supabase error fetching vocabulary range: ${e.message}',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw ServerException(
        message: 'Failed to load vocabulary: ${e.message}',
        statusCode: int.tryParse(e.code ?? '500'),
      );
    } catch (e) {
      AppLogger.error(
        'Error parsing vocabulary data: $e',
        tag: 'VocabularyRemoteDataSource',
        error: e,
      );
      throw DataException(message: 'Failed to parse vocabulary data: $e');
    }
  }
}
