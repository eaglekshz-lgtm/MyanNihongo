import 'package:hive/hive.dart';
import '../models/bookmark_model.dart';

/// Local data source for bookmarks using Hive
class BookmarkDataSource {
  final Box<BookmarkModel> _bookmarkBox;

  BookmarkDataSource(this._bookmarkBox);

  /// Get all bookmarks
  Future<List<BookmarkModel>> getAllBookmarks() async {
    return _bookmarkBox.values.toList();
  }

  /// Get all bookmarked vocabulary IDs
  Future<List<String>> getBookmarkedIds() async {
    return _bookmarkBox.values.map((bookmark) => bookmark.vocabularyId).toList();
  }

  /// Check if a vocabulary is bookmarked
  Future<bool> isBookmarked(String vocabularyId) async {
    return _bookmarkBox.values.any((bookmark) => bookmark.vocabularyId == vocabularyId);
  }

  /// Add a bookmark
  Future<void> addBookmark(String vocabularyId) async {
    final bookmark = BookmarkModel(
      vocabularyId: vocabularyId,
      bookmarkedAt: DateTime.now(),
    );
    await _bookmarkBox.put(vocabularyId, bookmark);
  }

  /// Remove a bookmark
  Future<void> removeBookmark(String vocabularyId) async {
    await _bookmarkBox.delete(vocabularyId);
  }

  /// Toggle bookmark
  Future<bool> toggleBookmark(String vocabularyId) async {
    if (await isBookmarked(vocabularyId)) {
      await removeBookmark(vocabularyId);
      return false;
    } else {
      await addBookmark(vocabularyId);
      return true;
    }
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }

  /// Get count of bookmarks
  Future<int> getBookmarksCount() async {
    return _bookmarkBox.length;
  }
}
