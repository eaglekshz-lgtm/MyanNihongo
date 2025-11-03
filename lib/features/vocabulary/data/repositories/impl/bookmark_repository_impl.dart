import '../bookmark_repository.dart';
import '../../models/bookmark_model.dart';
import '../../models/vocabulary_item_model.dart';
import '../../datasources/bookmark_datasource.dart';

/// Implementation of BookmarkRepository
/// Handles bookmark data operations
class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkDataSource _dataSource;

  BookmarkRepositoryImpl({
    required BookmarkDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<List<BookmarkModel>> getAllBookmarks() async {
    return await _dataSource.getAllBookmarks();
  }

  @override
  Future<BookmarkModel?> getBookmarkByVocabularyId(int vocabularyId) async {
    final bookmarks = await _dataSource.getAllBookmarks();
    try {
      return bookmarks.firstWhere(
        (bookmark) => bookmark.vocabularyId == vocabularyId.toString(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addBookmark(BookmarkModel bookmark) async {
    await _dataSource.addBookmark(bookmark.vocabularyId);
  }

  @override
  Future<void> removeBookmark(int vocabularyId) async {
    await _dataSource.removeBookmark(vocabularyId.toString());
  }

  @override
  Future<bool> isBookmarked(int vocabularyId) async {
    return await _dataSource.isBookmarked(vocabularyId.toString());
  }

  @override
  Future<List<VocabularyItemModel>> getBookmarkedVocabulary() async {
    // This would need to be implemented by fetching vocabulary items
    // based on bookmarked IDs. For now, return empty list.
    // TODO: Implement by fetching from vocabulary repository
    return [];
  }

  @override
  Future<void> clearAllBookmarks() async {
    await _dataSource.clearAllBookmarks();
  }
}
