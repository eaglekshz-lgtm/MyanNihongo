import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/arguments/vocabulary_learning_args.dart';
import '../../../../core/utils/logger.dart';
import '../../presentation/constants/vocabulary_learning_constants.dart';
import '../models/block_progress_model.dart';
import 'vocabulary_provider.dart';

class VocabularyLearningConfig extends Equatable {
  const VocabularyLearningConfig({
    required this.level,
    this.wordType,
    required this.learningMode,
    this.startIndex,
    this.batchSize,
  });

  factory VocabularyLearningConfig.fromArgs(VocabularyLearningArgs? args) {
    return VocabularyLearningConfig(
      level: args?.level ?? VocabularyLearningConstants.defaultLevel,
      wordType: args?.wordType,
      learningMode:
          args?.learningMode ?? VocabularyLearningConstants.defaultLearningMode,
      startIndex: args?.startIndex,
      batchSize: args?.batchSize,
    );
  }

  final String level;
  final String? wordType;
  final String learningMode;
  final int? startIndex;
  final int? batchSize;

  bool get hasBlock => startIndex != null && batchSize != null;

  int? get blockNumber {
    if (!hasBlock) return null;
    return (startIndex! / batchSize!).floor() + 1;
  }

  String? get blockId {
    final number = blockNumber;
    if (number == null) return null;
    return BlockProgressModel.generateBlockId(level, wordType, number);
  }

  @override
  List<Object?> get props => [
    level,
    wordType,
    learningMode,
    startIndex,
    batchSize,
  ];
}

class VocabularyLearningState extends Equatable {
  const VocabularyLearningState({
    required this.viewingIndex,
    required this.lastCompletedCount,
    required this.isFinishing,
    required this.hasPlayedCompletionSound,
  });

  const VocabularyLearningState.initial()
    : viewingIndex = 0,
      lastCompletedCount = 0,
      isFinishing = false,
      hasPlayedCompletionSound = false;

  final int viewingIndex;
  final int lastCompletedCount;
  final bool isFinishing;
  final bool hasPlayedCompletionSound;

  VocabularyLearningState copyWith({
    int? viewingIndex,
    int? lastCompletedCount,
    bool? isFinishing,
    bool? hasPlayedCompletionSound,
  }) {
    return VocabularyLearningState(
      viewingIndex: viewingIndex ?? this.viewingIndex,
      lastCompletedCount: lastCompletedCount ?? this.lastCompletedCount,
      isFinishing: isFinishing ?? this.isFinishing,
      hasPlayedCompletionSound:
          hasPlayedCompletionSound ?? this.hasPlayedCompletionSound,
    );
  }

  @override
  List<Object?> get props => [
    viewingIndex,
    lastCompletedCount,
    isFinishing,
    hasPlayedCompletionSound,
  ];
}

final vocabularyLearningControllerProvider = StateNotifierProvider.autoDispose
    .family<
      VocabularyLearningController,
      AsyncValue<VocabularyLearningState>,
      VocabularyLearningConfig
    >((ref, config) {
      return VocabularyLearningController(ref, config);
    });

class VocabularyLearningController
    extends StateNotifier<AsyncValue<VocabularyLearningState>> {
  VocabularyLearningController(this._ref, this._config)
    : super(const AsyncValue.loading()) {
    _initialize();
  }

  final Ref _ref;
  final VocabularyLearningConfig _config;

  Future<void> _initialize() async {
    try {
      var learningState = const VocabularyLearningState.initial();

      if (_config.hasBlock) {
        learningState = await _loadBlockCheckpoint();
      }

      state = AsyncValue.data(learningState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<VocabularyLearningState> _loadBlockCheckpoint() async {
    final blockId = _config.blockId!;
    final blockNumber = _config.blockNumber!;
    final repository = _ref.read(vocabularyRepositoryProvider);

    final blockProgress = await repository.getBlockProgress(blockId);

    if (blockProgress == null) {
      await repository.updateBlockProgress(
        blockId,
        _config.level,
        blockNumber,
        _config.startIndex!,
        0,
        _config.batchSize!,
        wordType: _config.wordType,
        isCompleted: false,
      );
      return const VocabularyLearningState.initial();
    }

    if (blockProgress.isCompleted) {
      await repository.saveBlockProgress(
        blockProgress.copyWith(lastStudied: DateTime.now()),
      );
      return const VocabularyLearningState.initial();
    }

    if (blockProgress.completedWords > 0) {
      AppLogger.info(
        'Loading checkpoint: ${blockProgress.completedWords} / ${blockProgress.totalWords}',
        'VocabLearning',
      );
      return VocabularyLearningState(
        viewingIndex: blockProgress.completedWords,
        lastCompletedCount: blockProgress.completedWords,
        isFinishing: false,
        hasPlayedCompletionSound: false,
      );
    }

    return const VocabularyLearningState.initial();
  }

  Future<void> resetBlockProgress() async {
    if (!_config.hasBlock) return;

    final repository = _ref.read(vocabularyRepositoryProvider);
    await repository.resetBlockProgress(_config.blockId!);
    _ref.invalidate(blockProgressProvider);

    state = const AsyncValue.data(VocabularyLearningState.initial());
  }

  void restart() {
    state = const AsyncValue.data(VocabularyLearningState.initial());
  }

  void markCompletionSoundPlayed() {
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    state = AsyncValue.data(
      currentState.copyWith(hasPlayedCompletionSound: true),
    );
  }

  void goBack() {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.viewingIndex <= 0) return;

    state = AsyncValue.data(
      currentState.copyWith(
        viewingIndex: currentState.viewingIndex - 1,
        isFinishing: false,
      ),
    );
  }

  Future<void> goNext(int totalVocabularyLength) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isFinishing) return;

    if (currentState.viewingIndex == totalVocabularyLength - 1) {
      state = AsyncValue.data(
        currentState.copyWith(
          isFinishing: true,
          lastCompletedCount: totalVocabularyLength,
        ),
      );
      await _updateBlockProgress(totalVocabularyLength);
      await Future.delayed(
        VocabularyLearningConstants.successAnimationDuration,
      );
      if (!mounted) return;

      state = AsyncValue.data(
        currentState.copyWith(
          viewingIndex: totalVocabularyLength,
          lastCompletedCount: totalVocabularyLength,
          isFinishing: false,
        ),
      );
      return;
    }

    final nextIndex = currentState.viewingIndex + 1;
    var nextState = currentState.copyWith(
      viewingIndex: nextIndex,
      isFinishing: false,
    );

    if (nextIndex > currentState.lastCompletedCount) {
      nextState = nextState.copyWith(lastCompletedCount: nextIndex);
      state = AsyncValue.data(nextState);
      await _updateBlockProgress(nextIndex);
      return;
    }

    state = AsyncValue.data(nextState);
  }

  Future<void> _updateBlockProgress(int completedCount) async {
    if (!_config.hasBlock) return;

    final repository = _ref.read(vocabularyRepositoryProvider);
    final blockProgress = await repository.getBlockProgress(_config.blockId!);
    if (blockProgress == null) return;

    await repository.saveBlockProgress(
      _calculateUpdatedProgress(
        blockProgress,
        completedCount,
        _config.batchSize!,
      ),
    );
    _ref.invalidate(blockProgressProvider);
  }

  BlockProgressModel _calculateUpdatedProgress(
    BlockProgressModel currentProgress,
    int completedCount,
    int batchSize,
  ) {
    final wasCompleted = currentProgress.isCompleted;
    final isCompleted = completedCount >= batchSize;

    if (wasCompleted && isCompleted) {
      return currentProgress.copyWith(
        completionCount: currentProgress.completionCount + 1,
        lastStudied: DateTime.now(),
      );
    }

    if (!wasCompleted) {
      return currentProgress.copyWith(
        completedWords: completedCount,
        completionCount: isCompleted
            ? currentProgress.completionCount + 1
            : currentProgress.completionCount,
        lastStudied: DateTime.now(),
        isCompleted: isCompleted,
      );
    }

    return currentProgress;
  }
}
