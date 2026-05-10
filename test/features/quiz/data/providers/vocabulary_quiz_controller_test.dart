import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myan_nihongo/features/quiz/data/providers/vocabulary_quiz_controller.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/block_progress_model.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/user_progress_model.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/vocabulary_filter.dart';
import 'package:myan_nihongo/features/vocabulary/data/models/vocabulary_item_model.dart';
import 'package:myan_nihongo/features/vocabulary/data/providers/vocabulary_provider.dart';
import 'package:myan_nihongo/features/vocabulary/data/repositories/vocabulary_repository.dart';

const config = VocabularyQuizConfig(
  level: 'N5',
  numberOfQuestions: 2,
  showBurmeseMeaning: false,
  quizType: kKanjiToHiraganaQuizType,
);

void main() {
  group('VocabularyQuizController', () {
    test('loads valid questions and toggles meaning language', () async {
      final container = _createContainer(vocabulary: _vocabularyItems());
      addTearDown(container.dispose);

      final state = await _readLoaded(container);

      expect(state.questions, hasLength(2));
      expect(state.showBurmeseMeaning, isFalse);

      container
          .read(vocabularyQuizControllerProvider(config).notifier)
          .toggleMeaningLanguage();

      final updated = container
          .read(vocabularyQuizControllerProvider(config))
          .value!;

      expect(updated.showBurmeseMeaning, isTrue);
    });

    test('selectAnswer scores once and saves progress', () async {
      final repository = _FakeVocabularyRepository();
      final container = _createContainer(
        vocabulary: _vocabularyItems(),
        repository: repository,
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        vocabularyQuizControllerProvider(config).notifier,
      );
      final loaded = await _readLoaded(container);
      final answer = loaded.currentQuestion!.correctAnswer;

      final isCorrect = await notifier.selectAnswer(answer);
      await notifier.selectAnswer('wrong');

      final state = container
          .read(vocabularyQuizControllerProvider(config))
          .value!;

      expect(isCorrect, isTrue);
      expect(state.hasAnswered, isTrue);
      expect(state.correctAnswers, 1);
      expect(state.wrongAnswers, 0);
      expect(repository.updatedVocabularyIds, [
        state.currentQuestion!.item.id.toString(),
      ]);
    });

    test('goToNextQuestion advances and reports completion', () async {
      final container = _createContainer(
        vocabulary: [_vocabularyItems().first],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        vocabularyQuizControllerProvider(config).notifier,
      );
      final loaded = await _readLoaded(container);

      await notifier.selectAnswer(loaded.currentQuestion!.correctAnswer);
      final isCompleted = notifier.goToNextQuestion();

      final state = container
          .read(vocabularyQuizControllerProvider(config))
          .value!;

      expect(isCompleted, isTrue);
      expect(state.isCompleted, isTrue);
      expect(state.selectedAnswer, isNull);
    });
  });
}

Future<VocabularyQuizState> _readLoaded(ProviderContainer container) async {
  final provider = vocabularyQuizControllerProvider(config);
  final current = container.read(provider);
  if (current.hasValue) return current.value!;

  final completer = Completer<VocabularyQuizState>();
  final subscription = container.listen<AsyncValue<VocabularyQuizState>>(
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

ProviderContainer _createContainer({
  required List<VocabularyItemModel> vocabulary,
  _FakeVocabularyRepository? repository,
}) {
  return ProviderContainer(
    overrides: [
      allVocabularyProvider.overrideWith((ref) async => vocabulary),
      vocabularyRepositoryProvider.overrideWithValue(
        repository ?? _FakeVocabularyRepository(),
      ),
    ],
  );
}

List<VocabularyItemModel> _vocabularyItems() {
  return [
    _vocabularyItem(id: 1, word: '学校', reading: 'がっこう', correctAnswer: 'がっこう'),
    _vocabularyItem(id: 2, word: '先生', reading: 'せんせい', correctAnswer: 'せんせい'),
  ];
}

VocabularyItemModel _vocabularyItem({
  required int id,
  required String word,
  required String reading,
  required String correctAnswer,
}) {
  return VocabularyItemModel(
    id: id,
    word: word,
    reading: reading,
    partOfSpeech: 'noun',
    translations: const TranslationModel(
      english: 'English meaning',
      burmese: 'Burmese meaning',
    ),
    exampleSentences: const [],
    quizzes: QuizDataModel(
      kanjiToHiragana: QuizQuestionModel(
        question: word,
        options: {
          correctAnswer: true,
          'wrong 1': false,
          'wrong 2': false,
          'wrong 3': false,
        },
      ),
    ),
    tag: 'N5',
  );
}

class _FakeVocabularyRepository implements VocabularyRepository {
  final updatedVocabularyIds = <String>[];

  @override
  Future<UserProgressModel> updateUserProgress(
    String vocabularyId,
    bool isCorrect,
  ) async {
    updatedVocabularyIds.add(vocabularyId);
    return UserProgressModel(
      vocabularyId: vocabularyId,
      timesViewed: 1,
      timesAnsweredCorrectly: isCorrect ? 1 : 0,
      timesAnsweredIncorrectly: isCorrect ? 0 : 1,
      lastReviewed: DateTime(2026),
      isMastered: false,
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
  Future<List<BlockProgressModel>> getBlockProgressByLevelAndType(
    String level,
    String? wordType,
  ) async => throw UnimplementedError();

  @override
  Future<BlockProgressModel?> getBlockProgress(String blockId) async =>
      throw UnimplementedError();

  @override
  Future<void> saveBlockProgress(BlockProgressModel progress) async =>
      throw UnimplementedError();

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
  }) async => throw UnimplementedError();

  @override
  Future<void> resetBlockProgress(String blockId) async =>
      throw UnimplementedError();
}
