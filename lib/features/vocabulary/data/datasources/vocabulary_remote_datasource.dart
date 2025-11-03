import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/vocabulary_item_model.dart';

/// Remote data source for vocabulary items using API
class VocabularyRemoteDataSource {
  final Dio _dio;

  VocabularyRemoteDataSource(this._dio);

  /// Fetch vocabulary items by JLPT level from API
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/api/vocabulary/level/$level',
        options: Options(
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data
            .map((json) => VocabularyItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to load vocabulary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else if (e.response?.statusCode != null) {
        throw ServerException(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw const NetworkException(message: 'Network error occurred');
      }
    } catch (e) {
      throw DataException(message: 'Failed to parse vocabulary data: $e');
    }
  }

  /// Fetch all vocabulary items from API
  Future<List<VocabularyItemModel>> getAllVocabulary() async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/api/vocabulary',
        options: Options(
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data
            .map((json) => VocabularyItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to load vocabulary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else if (e.response?.statusCode != null) {
        throw ServerException(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw const NetworkException(message: 'Network error occurred');
      }
    } catch (e) {
      throw DataException(message: 'Failed to parse vocabulary data: $e');
    }
  }
}
