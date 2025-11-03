import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/vocabulary_item_model.dart';
import '../../data/providers/bookmark_providers.dart';

class BookmarkedVocabularyPage extends ConsumerWidget {
  const BookmarkedVocabularyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedVocabularyAsync = ref.watch(bookmarkedVocabularyProvider);
    final bookmarkNotifier = ref.read(bookmarkNotifierProvider.notifier);
    final bookmarkCountAsync = ref.watch(bookmarkCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: bookmarkCountAsync.when(
          data: (count) => Text('Bookmarked Words ($count)'),
          loading: () => const Text('Bookmarked Words'),
          error: (_, __) => const Text('Bookmarked Words'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(bookmarkedVocabularyProvider);
              ref.invalidate(bookmarkCountProvider);
            },
          ),
          bookmarkedVocabularyAsync.when(
            data: (vocabulary) => vocabulary.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Clear all bookmarks',
                    onPressed: () => _showClearConfirmation(context, ref),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: bookmarkedVocabularyAsync.when(
        data: (vocabulary) {
          debugPrint('Bookmarked vocabulary count: ${vocabulary.length}');
          if (vocabulary.isEmpty) {
            return const _EmptyStateWidget();
          }
          return _VocabularyListWidget(
            vocabulary: vocabulary,
            bookmarkNotifier: bookmarkNotifier,
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading bookmarked words...'),
            ],
          ),
        ),
        error: (error, stack) {
          debugPrint('Error loading bookmarks: $error');
          debugPrint('Stack trace: $stack');
          return _ErrorStateWidget(error: error.toString());
        },
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks?'),
        content: const Text(
          'Are you sure you want to remove all bookmarked words? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Use repository method instead of direct data source access
              final repository = ref.read(bookmarkRepositoryProvider);
              await repository.clearAllBookmarks();
              
              // Invalidate providers to trigger UI updates
              ref.invalidate(allBookmarksProvider);
              ref.invalidate(bookmarkCountProvider);
              ref.invalidate(bookmarkedVocabularyProvider);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All bookmarks cleared'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text(
              'Clear All',
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Private Widget Classes

/// Empty state widget displayed when no bookmarks exist
class _EmptyStateWidget extends ConsumerWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debug info
    final bookmarkCount = ref.watch(bookmarkCountProvider);
    final allBookmarks = ref.watch(allBookmarksProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 120, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              'No Bookmarks Yet',
              style: AppTheme.headlineMedium.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Text(
              'Bookmark words while learning to review them later',
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Debug info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Info:',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  bookmarkCount.when(
                    data: (count) => Text(
                      'Bookmark count in DB: $count',
                      style: AppTheme.bodySmall,
                    ),
                    loading: () => const Text('Loading count...'),
                    error: (e, _) => Text('Count error: $e'),
                  ),
                  const SizedBox(height: 4),
                  allBookmarks.when(
                    data: (bookmarks) => Text(
                      'Bookmark IDs: ${bookmarks.map((b) => b.vocabularyId).join(', ')}',
                      style: AppTheme.bodySmall,
                    ),
                    loading: () => const Text('Loading IDs...'),
                    error: (e, _) => Text('IDs error: $e'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state widget displayed when bookmark loading fails
class _ErrorStateWidget extends ConsumerWidget {
  const _ErrorStateWidget({required this.error});

  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkCount = ref.watch(bookmarkCountProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              'Error Loading Bookmarks',
              style: AppTheme.titleLarge.copyWith(color: AppTheme.errorColor),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error Details:',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    style: AppTheme.bodySmall.copyWith(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 12),
                  bookmarkCount.when(
                    data: (count) => Text(
                      'Bookmarks in DB: $count',
                      style: AppTheme.bodySmall,
                    ),
                    loading: () => const Text('Loading...'),
                    error: (e, _) => Text('Count error: $e'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vocabulary list widget with header and scrollable items
class _VocabularyListWidget extends StatelessWidget {
  const _VocabularyListWidget({
    required this.vocabulary,
    required this.bookmarkNotifier,
  });

  final List<VocabularyItemModel> vocabulary;
  final BookmarkNotifier bookmarkNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with count
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.bookmark, color: Color(0xFFE53935), size: 24),
              const SizedBox(width: 12),
              Text(
                '${vocabulary.length} ${vocabulary.length == 1 ? 'Word' : 'Words'} Bookmarked',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        // List of vocabulary
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vocabulary.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = vocabulary[index];
              return _VocabularyCardWidget(
                item: item,
                bookmarkNotifier: bookmarkNotifier,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual vocabulary card widget with detailed information
class _VocabularyCardWidget extends StatelessWidget {
  const _VocabularyCardWidget({
    required this.item,
    required this.bookmarkNotifier,
  });

  final VocabularyItemModel item;
  final BookmarkNotifier bookmarkNotifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with category icon and info
            Row(
              children: [
                // Category icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.partOfSpeech),
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                // Part of speech label and JLPT level
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.partOfSpeech.toUpperCase(),
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // JLPT Level
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.infoColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getJLPTLevel(item.id),
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.infoColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Remove bookmark button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.bookmark, size: 20),
                    color: const Color(0xFFE53935),
                    onPressed: () =>
                        _removeBookmark(context, item.id, bookmarkNotifier),
                    tooltip: 'Remove bookmark',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Divider
            Container(height: 1, color: Colors.grey[200]),
            const SizedBox(height: 16),

            // Main content - Japanese word
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          item.word,
                          style: AppTheme.japaneseText.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.reading,
                          style: AppTheme.bodyMedium.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Translations section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // English meaning
                  Row(
                    children: [
                      const Icon(
                        Icons.translate,
                        size: 16,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.translations.english,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Divider
                  Container(height: 1, color: Colors.grey[200]),
                  const SizedBox(height: 12),
                  // Burmese translation
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        size: 16,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.translations.burmese,
                          style: AppTheme.burmeseText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'verb':
        return Icons.play_arrow_rounded;
      case 'adjective':
        return Icons.palette_rounded;
      case 'noun':
        return Icons.category_rounded;
      case 'adverb':
        return Icons.speed_rounded;
      case 'number':
        return Icons.numbers_rounded;
      case 'day':
        return Icons.calendar_today_rounded;
      case 'counter':
        return Icons.calculate_rounded;
      default:
        return Icons.text_fields_rounded;
    }
  }

  String _getJLPTLevel(int vocabularyId) {
    // Extract JLPT level from vocabulary ID range
    if (vocabularyId < 1000) {
      return 'N5';
    } else if (vocabularyId < 2000) {
      return 'N4';
    } else if (vocabularyId < 3000) {
      return 'N3';
    } else if (vocabularyId < 4000) {
      return 'N2';
    } else {
      return 'N1';
    }
  }

  void _removeBookmark(
    BuildContext context,
    int vocabularyId,
    BookmarkNotifier bookmarkNotifier,
  ) {
    bookmarkNotifier.removeBookmark(vocabularyId.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.bookmark_border, color: Colors.white),
            SizedBox(width: 8),
            Text('Removed from bookmarks'),
          ],
        ),
        backgroundColor: AppTheme.infoColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
