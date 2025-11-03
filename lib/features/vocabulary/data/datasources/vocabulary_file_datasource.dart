import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/exceptions.dart';
import '../models/vocabulary_item_model.dart';
import '../../../../core/utils/logger.dart';

/// Local file data source for vocabulary items
class VocabularyFileDataSource {
  /// Load vocabulary from JSON file
  Future<List<VocabularyItemModel>> loadVocabularyFromFile(String level) async {
    try {
      // Load the JSON file based on selected level
      final jsonFileName = '${level.toUpperCase()}_DataSet.json';
      final jsonFilePath = 'assets/vocabulary/$jsonFileName';

      AppLogger.data('Loading vocabulary from: $jsonFilePath', operation: 'READ');
      final jsonContent = await rootBundle.loadString(jsonFilePath);
      return await _loadFromJson(jsonContent, level);
    } catch (e) {
      if (e is CacheException || e is DataException) {
        rethrow;
      }
      AppLogger.error(
        'Failed to load vocabulary from file',
        tag: 'FileDataSource',
        error: e,
      );
      throw DataException(message: 'Failed to load vocabulary from file: $e');
    }
  }

  /// Load vocabulary from JSON format
  Future<List<VocabularyItemModel>> _loadFromJson(
    String jsonContent,
    String level,
  ) async {
    try {
      final List<dynamic> jsonList = json.decode(jsonContent);
      final List<VocabularyItemModel> vocabulary = [];

      int successCount = 0;
      int failCount = 0;

      for (var item in jsonList) {
        if (item is! Map<String, dynamic>) continue;

        try {
          // Use the model's fromJson method to parse the entire item
          final vocabItem = VocabularyItemModel.fromJson(item);
          vocabulary.add(vocabItem);
          successCount++;

          if (successCount <= 5) {
            // Only log first 5 items to reduce noise
            AppLogger.debug(
              'Loaded item: ${vocabItem.word}, ID: ${vocabItem.id}',
              'FileDataSource',
            );
          }
        } catch (e, stackTrace) {
          failCount++;
          if (failCount <= 10) {
            // Only log first 10 errors
            final itemData = item.toString().length > 200
                ? '${item.toString().substring(0, 200)}...'
                : item.toString();
            AppLogger.error(
              'Error parsing vocabulary item',
              tag: 'FileDataSource',
              error: e,
              stackTrace: stackTrace,
            );
            AppLogger.debug('Item data: $itemData', 'FileDataSource');
          }
          continue;
        }
      }

      AppLogger.info(
        'Parsing: Success=$successCount, Failed=$failCount, Total=${jsonList.length}',
        'FileDataSource',
      );

      if (vocabulary.isEmpty) {
        throw const DataException(
          message: 'No valid vocabulary found in JSON file',
        );
      }

      AppLogger.info(
        'Loaded ${vocabulary.length} items for level ${level.toUpperCase()}',
        'FileDataSource',
      );
      AppLogger.debug(
        'Sample IDs: ${vocabulary.take(3).map((v) => v.id).join(', ')}',
        'FileDataSource',
      );

      return vocabulary;
    } catch (e) {
      AppLogger.error('Failed to parse JSON', tag: 'FileDataSource', error: e);
      throw DataException(message: 'Failed to parse JSON: $e');
    }
  }
}
