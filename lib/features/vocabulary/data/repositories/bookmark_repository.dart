import '../models/bookmark_model.dart';
import '../models/vocabulary_item_model.dart';

/// Repository interface for bookmark data access
/// This interface defines the contract for bookmark operations
abstract class BookmarkRepository {
  /// Get all bookmarks
  Future<List<BookmarkModel>> getAllBookmarks();

  /// Get bookmark by vocabulary ID
  Future<BookmarkModel?> getBookmarkByVocabularyId(int vocabularyId);

  /// Add a bookmark
  Future<void> addBookmark(BookmarkModel bookmark);

  /// Remove a bookmark
  Future<void> removeBookmark(int vocabularyId);

  /// Check if a vocabulary item is bookmarked
  Future<bool> isBookmarked(int vocabularyId);

  /// Get all bookmarked vocabulary items
  Future<List<VocabularyItemModel>> getBookmarkedVocabulary();

  /// Clear all bookmarks
  Future<void> clearAllBookmarks();
}
