import '../bookmark_repository.dart';
import '../../models/bookmark_model.dart';
import '../../models/vocabulary_item_model.dart';
import '../../datasources/bookmark_datasource.dart';
import '../../datasources/vocabulary_local_datasource.dart';

/// Implementation of BookmarkRepository
/// Handles bookmark data operations
class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkDataSource _dataSource;
  final VocabularyLocalDataSource _vocabularyDataSource;

  BookmarkRepositoryImpl({
    required BookmarkDataSource dataSource,
    required VocabularyLocalDataSource vocabularyDataSource,
  }) : _dataSource = dataSource,
       _vocabularyDataSource = vocabularyDataSource;

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
    final bookmarks = await _dataSource.getAllBookmarks();
    bookmarks.sort((a, b) => b.bookmarkedAt.compareTo(a.bookmarkedAt));
    final vocabulary = <VocabularyItemModel>[];

    for (final bookmark in bookmarks) {
      final item = await _vocabularyDataSource.getVocabularyById(
        bookmark.vocabularyId,
      );
      if (item != null) {
        vocabulary.add(item);
      }
    }

    return vocabulary;
  }

  @override
  Future<void> clearAllBookmarks() async {
    await _dataSource.clearAllBookmarks();
  }
}
