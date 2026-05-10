import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/vocabulary_item_model.dart';
import '../../data/providers/bookmark_providers.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/widgets/glass_container.dart';

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
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.data_object_rounded),
                        tooltip: 'Extract Bookmarks',
                        onPressed: () => _showExtractDialog(context, vocabulary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        tooltip: 'Clear all bookmarks',
                        onPressed: () => _showClearConfirmation(context, ref),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: MeshBackground(
        child: bookmarkedVocabularyAsync.when(
          data: (vocabulary) {
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
          error: (error, stack) => _ErrorStateWidget(error: error.toString()),
        ),
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
              final repository = ref.read(bookmarkRepositoryProvider);
              await repository.clearAllBookmarks();

              ref.invalidate(allBookmarksProvider);
              ref.invalidate(bookmarkCountProvider);
              ref.invalidate(bookmarkedVocabularyProvider);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All bookmarks cleared'),
                    backgroundColor: Theme.of(context).colorScheme.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              'Clear All',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.fixedWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExtractDialog(BuildContext context, List<VocabularyItemModel> vocabulary) {
    final buffer = StringBuffer();
    for (final item in vocabulary) {
      buffer.writeln('- `${item.id}` **${item.word}** (${item.reading})');
    }
    final markdownContent = buffer.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extracted Bookmarks'),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: SingleChildScrollView(
            child: SelectableText(
              markdownContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: markdownContent));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onInverseSurface),
                      const SizedBox(width: 8),
                      const Text('Copied to clipboard'),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy All'),
          ),
        ],
      ),
    );
  }
}

// Private Widget Classes

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 120,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Bookmarks Yet',
              style: AppTheme.headlineMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bookmark words while learning to review them later',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
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

class _ErrorStateWidget extends StatelessWidget {
  const _ErrorStateWidget({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Bookmarks',
              style: AppTheme.titleLarge.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error Details',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    style: AppTheme.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
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
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.4),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.bookmarkActive,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '${vocabulary.length} ${vocabulary.length == 1 ? 'Word' : 'Words'} Bookmarked',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
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
    return GlassContainer(
      blur: 0.0,
      tintColor: Theme.of(context).colorScheme.primary,
      tintOpacity: 0.08,
      borderRadius: BorderRadius.circular(16),
      borderColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.15),
      borderWidth: 1.0,
      shadow: false,
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
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.partOfSpeech),
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
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
                          color: Theme.of(
                            context,
                          ).colorScheme.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getJLPTLevel(item.id),
                          style: AppTheme.bodySmall.copyWith(
                            color: Theme.of(context).colorScheme.info,
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
                    color: Theme.of(
                      context,
                    ).colorScheme.bookmarkActive.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.bookmark, size: 20),
                    color: Theme.of(context).colorScheme.bookmarkActive,
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
            Container(
              height: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            ),
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.reading,
                        style: AppTheme.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // English meaning
                  Row(
                    children: [
                      Icon(
                        Icons.translate,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.translations.english,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Divider
                  Container(
                    height: 1,
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 12),
                  // Burmese translation
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 16,
                        color: Theme.of(context).colorScheme.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.translations.burmese,
                          style: AppTheme.burmeseText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
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
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.bookmark_border,
              color: Theme.of(context).colorScheme.fixedWhite,
            ),
            const SizedBox(width: 8),
            const Text('Removed from bookmarks'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.info,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
