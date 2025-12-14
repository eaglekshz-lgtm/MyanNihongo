import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/system_update_model.dart';

/// Data source for system update tracking
/// Handles both remote (Supabase) and local (Hive) operations
class SystemUpdateDataSource {
  final SupabaseClient _supabase;
  final Box<SystemUpdateModel> _localBox;

  SystemUpdateDataSource(this._supabase, this._localBox);

  /// Fetch system update info from Supabase by tag
  /// Tag examples: 'N5', 'N4', 'N3', 'N2', 'N1'
  Future<SystemUpdateModel?> getSystemUpdateByTag(String tag) async {
    try {
      AppLogger.info(
        'Fetching system update for tag: $tag from Supabase',
        'SystemUpdateDataSource',
      );

      final response = await _supabase
          .from('system_update')
          .select()
          .eq('tag', tag)
          .maybeSingle();

      if (response == null) {
        AppLogger.info(
          'No system update found for tag: $tag',
          'SystemUpdateDataSource',
        );
        return null;
      }

      final systemUpdate = SystemUpdateModel.fromJson(
        response,
      );

      AppLogger.data(
        'Retrieved system update for $tag: last updated at ${systemUpdate.lastUpdatedAt}',
        operation: 'READ',
      );

      return systemUpdate;
    } on PostgrestException catch (e) {
      AppLogger.error(
        'Supabase error fetching system update: ${e.message}',
        tag: 'SystemUpdateDataSource',
        error: e,
      );
      throw ServerException(
        message: 'Failed to load system update: ${e.message}',
        statusCode: int.tryParse(e.code ?? '500'),
      );
    } catch (e) {
      AppLogger.error(
        'Error parsing system update data: $e',
        tag: 'SystemUpdateDataSource',
        error: e,
      );
      throw DataException(message: 'Failed to parse system update data: $e');
    }
  }

  /// Get locally cached system update by tag
  Future<SystemUpdateModel?> getLocalSystemUpdate(String tag) async {
    try {
      final update = _localBox.get(tag);
      if (update != null) {
        AppLogger.info(
          'Found local system update for $tag: ${update.lastUpdatedAt}',
          'SystemUpdateDataSource',
        );
      }
      return update;
    } catch (e) {
      AppLogger.error(
        'Error reading local system update: $e',
        tag: 'SystemUpdateDataSource',
        error: e,
      );
      return null;
    }
  }

  /// Save system update to local cache
  Future<void> saveLocalSystemUpdate(SystemUpdateModel update) async {
    try {
      // Update with current check time
      final updatedModel = update.copyWith(lastCheckedAt: DateTime.now());
      await _localBox.put(update.tag, updatedModel);
      
      AppLogger.data(
        'Saved system update for ${update.tag} to local cache',
        operation: 'SAVE',
      );
    } catch (e) {
      AppLogger.error(
        'Error saving system update to local cache: $e',
        tag: 'SystemUpdateDataSource',
        error: e,
      );
      throw CacheException(message: 'Failed to save system update: $e');
    }
  }

  /// Check if vocabulary needs update by comparing server and local timestamps
  /// Returns true if server data is newer or if no local cache exists
  Future<bool> needsVocabularyUpdate(String tag) async {
    try {
      // Get server update info
      final serverUpdate = await getSystemUpdateByTag(tag);
      if (serverUpdate == null) {
        // If no server record, assume no update needed
        AppLogger.info(
          'No server update record for $tag, skipping update check',
          'SystemUpdateDataSource',
        );
        return false;
      }

      // Get local update info
      final localUpdate = await getLocalSystemUpdate(tag);
      
      if (localUpdate == null) {
        // No local cache, need to fetch
        AppLogger.info(
          'No local cache for $tag, needs update',
          'SystemUpdateDataSource',
        );
        return true;
      }

      // Compare timestamps
      final needsUpdate = serverUpdate.needsUpdate(localUpdate.lastUpdatedAt);
      
      AppLogger.info(
        'Update check for $tag: Server=${serverUpdate.lastUpdatedAt}, Local=${localUpdate.lastUpdatedAt}, NeedsUpdate=$needsUpdate',
        'SystemUpdateDataSource',
      );

      return needsUpdate;
    } catch (e) {
      AppLogger.warning(
        'Error checking for updates, defaulting to fetch: $e',
        'SystemUpdateDataSource',
      );
      // On error, default to fetching to be safe
      return true;
    }
  }

  /// Clear all local system update cache
  Future<void> clearLocalCache() async {
    try {
      await _localBox.clear();
      AppLogger.info(
        'Cleared all system update cache',
        'SystemUpdateDataSource',
      );
    } catch (e) {
      AppLogger.error(
        'Error clearing system update cache: $e',
        tag: 'SystemUpdateDataSource',
        error: e,
      );
    }
  }
}
