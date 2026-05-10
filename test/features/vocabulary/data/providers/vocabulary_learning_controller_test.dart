import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/block_progress_model.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/user_progress_model.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/vocabulary_filter.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/vocabulary_item_model.dart';
import 'package:myan_nihongo/features/vocabulary/data/providers/vocabulary_learning_controller.dart';
import 'package:myan_nihongo/features/vocabulary/data/providers/vocabulary_provider.dart';
import 'package:myan_nihongo/features/vocabulary/data/repositories/vocabulary_repository.dart';

const config = VocabularyLearningConfig(
  level: 'N5',
  learningMode: 'recall',
  startIndex: 0,
  batchSize: 2,
);

void main() {
  group('VocabularyLearningController', () {
    test('creates missing block progress on load', () async {
      final repository = _FakeVocabularyRepository();
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      final state = await _readLoaded(container);

      expect(state.viewingIndex, 0);
      expect(state.lastCompletedCount, 0);
      expect(repository.savedBlockProgress!.blockId, 'N5_all_1');
      expect(repository.savedBlockProgress!.totalWords, 2);
    });

    test('resumes an incomplete block from completed words', () async {
      final repository = _FakeVocabularyRepository(
        initialBlockProgress: _blockProgress(completedWords: 1),
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      final state = await _readLoaded(container);

      expect(state.viewingIndex, 1);
      expect(state.lastCompletedCount, 1);
    });

    test('goNext advances and persists completed count', () async {
      final repository = _FakeVocabularyRepository(
        initialBlockProgress: _blockProgress(),
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      final notifier = container.read(
        vocabularyLearningControllerProvider(config).notifier,
      );
      await _readLoaded(container);

      await notifier.goNext(2);

      final state = container
          .read(vocabularyLearningControllerProvider(config))
          .value!;

      expect(state.viewingIndex, 1);
      expect(state.lastCompletedCount, 1);
      expect(repository.savedBlockProgress!.completedWords, 1);
      expect(repository.savedBlockProgress!.isCompleted, isFalse);
    });

    test(
      'resetBlockProgress clears session state and repository progress',
      () async {
        final repository = _FakeVocabularyRepository(
          initialBlockProgress: _blockProgress(completedWords: 1),
        );
        final container = _createContainer(repository);
        addTearDown(container.dispose);

        final notifier = container.read(
          vocabularyLearningControllerProvider(config).notifier,
        );
        await _readLoaded(container);

        await notifier.resetBlockProgress();

        final state = container
            .read(vocabularyLearningControllerProvider(config))
            .value!;

        expect(repository.resetBlockIds, ['N5_all_1']);
        expect(state.viewingIndex, 0);
        expect(state.lastCompletedCount, 0);
        expect(state.hasPlayedCompletionSound, isFalse);
      },
    );
  });
}

ProviderContainer _createContainer(_FakeVocabularyRepository repository) {
  return ProviderContainer(
    overrides: [vocabularyRepositoryProvider.overrideWithValue(repository)],
  );
}

Future<VocabularyLearningState> _readLoaded(ProviderContainer container) async {
  final provider = vocabularyLearningControllerProvider(config);
  final current = container.read(provider);
  if (current.hasValue) return current.value!;

  final completer = Completer<VocabularyLearningState>();
  final subscription = container.listen<AsyncValue<VocabularyLearningState>>(
    provider,
    (_, next) {
      if (next.hasValue && !completer.isCompleted) {
        completer.complete(next.value!);
      } else if (next.hasError && !completer.isCompleted) {
        completer.completeError(next.error!, next.stackTrace);
      }
    },
    fireImmediately: true,
  );

  try {
    return await completer.future;
  } finally {
    subscription.close();
  }
}

BlockProgressModel _blockProgress({int completedWords = 0}) {
  return BlockProgressModel(
    blockId: 'N5_all_1',
    blockNumber: 1,
    level: 'N5',
    startIndex: 0,
    totalWords: 2,
    completedWords: completedWords,
    completionCount: 0,
    lastStudied: DateTime(2026),
    isCompleted: false,
  );
}

class _FakeVocabularyRepository implements VocabularyRepository {
  _FakeVocabularyRepository({BlockProgressModel? initialBlockProgress})
    : savedBlockProgress = initialBlockProgress;

  BlockProgressModel? savedBlockProgress;
  final resetBlockIds = <String>[];

  @override
  Future<BlockProgressModel?> getBlockProgress(String blockId) async {
    return savedBlockProgress;
  }

  @override
  Future<void> saveBlockProgress(BlockProgressModel progress) async {
    savedBlockProgress = progress;
  }

  @override
  Future<BlockProgressModel> updateBlockProgress(
    String blockId,
    String level,
    int blockNumber,
    int startIndex,
    int completedWords,
    int totalWords, {
    String? wordType,
    bool isCompleted = false,
  }) async {
    final progress = BlockProgressModel(
      blockId: blockId,
      blockNumber: blockNumber,
      level: level,
      wordType: wordType,
      startIndex: startIndex,
      totalWords: totalWords,
      completedWords: completedWords,
      completionCount: isCompleted ? 1 : 0,
      lastStudied: DateTime(2026),
      isCompleted: isCompleted,
    );
    savedBlockProgress = progress;
    return progress;
  }

  @override
  Future<void> resetBlockProgress(String blockId) async {
    resetBlockIds.add(blockId);
    savedBlockProgress = savedBlockProgress?.copyWith(
      completedWords: 0,
      isCompleted: false,
    );
  }

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevelAndType(
    VocabularyFilter filter,
  ) async => throw UnimplementedError();

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevel(String level) async =>
      throw UnimplementedError();

  @override
  Future<int> getVocabularyCountByLevel(String level) async =>
      throw UnimplementedError();

  @override
  Future<List<VocabularyItemModel>> getVocabularyByLevelWithRange(
    String level,
    int offset,
    int limit,
  ) async => throw UnimplementedError();

  @override
  Future<List<VocabularyItemModel>> getAllVocabulary() async =>
      throw UnimplementedError();

  @override
  Future<void> saveVocabulary(List<VocabularyItemModel> vocabulary) async =>
      throw UnimplementedError();

  @override
  Future<UserProgressModel?> getUserProgress(String vocabularyId) async =>
      throw UnimplementedError();

  @override
  Future<List<UserProgressModel>> getAllUserProgress() async =>
      throw UnimplementedError();

  @override
  Future<void> saveUserProgress(UserProgressModel progress) async =>
      throw UnimplementedError();

  @override
  Future<UserProgressModel> updateUserProgress(
    String vocabularyId,
    bool isCorrect,
  ) async => throw UnimplementedError();

  @override
  Future<List<BlockProgressModel>> getBlockProgressByLevelAndType(
    String level,
    String? wordType,
  ) async => throw UnimplementedError();
}
