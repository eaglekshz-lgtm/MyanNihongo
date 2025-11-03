import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/bookmark_model.dart';
import '../models/vocabulary_item_model.dart';
import '../datasources/bookmark_datasource.dart';
import '../datasources/vocabulary_local_datasource.dart';
import '../repositories/bookmark_repository.dart';
import '../repositories/impl/bookmark_repository_impl.dart';
import 'vocabulary_provider.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provider for bookmark box
final bookmarkBoxProvider = Provider<Box<BookmarkModel>>((ref) {
  return Hive.box<BookmarkModel>('bookmarks_box');
});

/// Provider for bookmark data source
final bookmarkDataSourceProvider = Provider<BookmarkDataSource>((ref) {
  // ✅ FIXED: Use ref.read instead of ref.watch for one-time dependency
  final bookmarkBox = ref.read(bookmarkBoxProvider);
  return BookmarkDataSource(bookmarkBox);
});

// ============================================================================
// Repository Provider
// ============================================================================

/// Provider for bookmark repository
/// This is the main provider that should be used by the presentation layer
final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  final dataSource = ref.read(bookmarkDataSourceProvider);
  return BookmarkRepositoryImpl(dataSource: dataSource);
});

// ============================================================================
// Helper Functions
// ============================================================================

/// ✅ NEW: Extract duplicate sorting logic into helper function
List<VocabularyItemModel> _sortVocabularyByBookmarkDate(
  List<VocabularyItemModel> vocabulary,
  List<BookmarkModel> bookmarks,
) {
  if (vocabulary.isEmpty || bookmarks.isEmpty) return vocabulary;
  
  return vocabulary..sort((a, b) {
    final bookmarkA = bookmarks.firstWhere(
      (bm) => bm.vocabularyId == a.id.toString(),
      orElse: () => BookmarkModel(
        vocabularyId: a.id.toString(),
        bookmarkedAt: DateTime.now(),
      ),
    );
    final bookmarkB = bookmarks.firstWhere(
      (bm) => bm.vocabularyId == b.id.toString(),
      orElse: () => BookmarkModel(
        vocabularyId: b.id.toString(),
        bookmarkedAt: DateTime.now(),
      ),
    );
    return bookmarkB.bookmarkedAt.compareTo(bookmarkA.bookmarkedAt);
  });
}

/// ✅ NEW: Helper to fetch vocabulary items for bookmark IDs
Future<List<VocabularyItemModel>> _fetchVocabularyForBookmarks(
  List<String> bookmarkIds,
  VocabularyLocalDataSource vocabularyDataSource,
) async {
  final vocabulary = <VocabularyItemModel>[];
  
  for (final id in bookmarkIds) {
    final vocab = await vocabularyDataSource.getVocabularyById(id);
    if (vocab != null) {
      vocabulary.add(vocab);
    }
  }
  
  return vocabulary;
}

// ============================================================================
// Bookmark Data Providers
// ============================================================================

/// Provider for all bookmarks
/// ✅ FIXED: Optimized to use synchronous Hive access and removed await in initial yield
final allBookmarksProvider = StreamProvider<List<BookmarkModel>>((ref) async* {
  final box = ref.read(bookmarkBoxProvider);
  
  // ✅ Synchronous initial yield (Hive is sync-capable)
  yield box.values.toList();
  
  // Listen to changes in the bookmark box
  await for (final _ in box.watch()) {
    yield box.values.toList();
  }
});

/// Provider for bookmarked vocabulary IDs
/// ✅ FIXED: Simplified to use direct box access
final bookmarkedIdsProvider = StreamProvider<Set<String>>((ref) async* {
  final box = ref.read(bookmarkBoxProvider);
  
  // Synchronous initial yield
  yield box.values.map((bm) => bm.vocabularyId).toSet();
  
  // Listen to changes
  await for (final _ in box.watch()) {
    yield box.values.map((bm) => bm.vocabularyId).toSet();
  }
});

/// Provider for bookmarked vocabulary items
/// ✅ FIXED: Refactored to use helper functions and reduce duplication
final bookmarkedVocabularyProvider = StreamProvider<List<VocabularyItemModel>>((
  ref,
) async* {
  final box = ref.read(bookmarkBoxProvider);
  final vocabularyDataSource = ref.read(vocabularyLocalDataSourceProvider);
  
  // Helper function to get current bookmarked vocabulary
  Future<List<VocabularyItemModel>> getCurrentBookmarkedVocab() async {
    final bookmarks = box.values.toList();
    final bookmarkIds = bookmarks.map((bm) => bm.vocabularyId).toList();
    
    final vocabulary = await _fetchVocabularyForBookmarks(
      bookmarkIds,
      vocabularyDataSource,
    );
    
    return _sortVocabularyByBookmarkDate(vocabulary, bookmarks);
  }
  
  // Initial fetch
  yield await getCurrentBookmarkedVocab();
  
  // Listen to changes in the bookmark box
  await for (final _ in box.watch()) {
    yield await getCurrentBookmarkedVocab();
  }
});

/// Provider for bookmark count
/// ✅ FIXED: Simplified to use direct box access
final bookmarkCountProvider = StreamProvider<int>((ref) async* {
  final box = ref.read(bookmarkBoxProvider);
  
  // Synchronous initial count
  yield box.length;
  
  // Listen to changes
  await for (final _ in box.watch()) {
    yield box.length;
  }
});

// ============================================================================
// State Notifier for Managing Bookmarks
// ============================================================================

/// State notifier for managing bookmarks
/// ✅ FIXED: Added proper loading and error states for async operations
class BookmarkNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  final BookmarkDataSource _dataSource;

  BookmarkNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    state = const AsyncValue.loading();
    try {
      final ids = await _dataSource.getBookmarkedIds();
      state = AsyncValue.data(ids.toSet());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// ✅ FIXED: Added loading state during toggle operation
  Future<bool> toggleBookmark(String vocabularyId) async {
    // Store current state to restore on error
    final previousState = state;
    
    // Set loading state
    state = const AsyncValue.loading();
    
    try {
      final isBookmarked = await _dataSource.toggleBookmark(vocabularyId);
      
      // Reload bookmarks to get updated state
      final ids = await _dataSource.getBookmarkedIds();
      state = AsyncValue.data(ids.toSet());
      
      return isBookmarked;
    } catch (e, stack) {
      // Restore previous state and rethrow
      state = previousState;
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// ✅ FIXED: Added loading state during add operation
  Future<void> addBookmark(String vocabularyId) async {
    state = const AsyncValue.loading();
    
    try {
      await _dataSource.addBookmark(vocabularyId);
      final ids = await _dataSource.getBookmarkedIds();
      state = AsyncValue.data(ids.toSet());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// ✅ FIXED: Added loading state during remove operation
  Future<void> removeBookmark(String vocabularyId) async {
    state = const AsyncValue.loading();
    
    try {
      await _dataSource.removeBookmark(vocabularyId);
      final ids = await _dataSource.getBookmarkedIds();
      state = AsyncValue.data(ids.toSet());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

/// Provider for bookmark notifier
/// ✅ FIXED: Use ref.read instead of ref.watch for one-time dependency
final bookmarkNotifierProvider =
    StateNotifierProvider<BookmarkNotifier, AsyncValue<Set<String>>>((ref) {
      final dataSource = ref.read(bookmarkDataSourceProvider);
      return BookmarkNotifier(dataSource);
    });
