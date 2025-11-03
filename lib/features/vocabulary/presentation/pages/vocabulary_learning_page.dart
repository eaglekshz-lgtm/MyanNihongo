import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/utils/logger.dart';

import '../../../../arguments/vocabulary_learning_args.dart';
import '../../data/models/block_progress_model.dart';
import '../../data/models/vocabulary_filter.dart';
import '../../data/models/vocabulary_item_model.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../constants/vocabulary_learning_constants.dart';
import '../widgets/learning/completion_screen.dart';
import '../widgets/learning/learning_screen.dart';

// Constants
const kDefaultLevel = 'N5';
const kCardGradientStartColor = Color(0xFF4DB8FF);
const kCardGradientEndColor = Color(0xFF2196F3);
const kCardBorderRadius = 28.0;
const kJapaneseFontSize = 62.0;
const kSuccessAnimationDuration = Duration(milliseconds: 1500);

class VocabularyLearningPage extends ConsumerStatefulWidget {
  const VocabularyLearningPage({super.key});

  @override
  ConsumerState<VocabularyLearningPage> createState() =>
      _VocabularyLearningPageState();
}

class _VocabularyLearningPageState extends ConsumerState<VocabularyLearningPage>
    with SingleTickerProviderStateMixin {
  // ============================================================================
  // State Variables
  // ============================================================================

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  late AnimationController _flipController;

  // Configuration from arguments
  String? _level;
  String? _wordType;
  String? _learningMode;
  int? _startIndex;
  int? _batchSize;

  // Learning progress
  bool showAnswer = false;
  bool hasPlayedCompletionSound = false;
  bool _hasLoadedCheckpoint = false;
  bool _isInitializing = true;
  int _lastCompletedCount = 0; // Track actual completed count
  int _viewingIndex = 0; // Track actual viewing position (separate from completion)
  bool _isFinishing = false; // Show success animation on last advance

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: VocabularyLearningConstants.flipDuration,
    );
    _initializeTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_level == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as VocabularyLearningArgs?;
      _level = args?.level ?? VocabularyLearningConstants.defaultLevel;
      _wordType = args?.wordType;
      _learningMode = args?.learningMode ?? VocabularyLearningConstants.defaultLearningMode;
      _startIndex = args?.startIndex;
      _batchSize = args?.batchSize;

      // Initialize block progress
      _initializeBlockProgress();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tts.stop();
    _flipController.dispose();
    super.dispose();
  }  // ============================================================================
  // Helper Methods
  // ============================================================================

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage(VocabularyLearningConstants.japaneseLanguage);
      await _tts.setSpeechRate(VocabularyLearningConstants.ttsSpeechRate);
      await _tts.setVolume(VocabularyLearningConstants.ttsVolume);
      await _tts.setPitch(VocabularyLearningConstants.ttsPitch);
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  // ============================================================================
  // UI Helper Methods
  // ============================================================================

  String _getAppBarTitle() {
    if (_startIndex != null && _batchSize != null) {
      final blockNumber = (_startIndex! / _batchSize!).floor() + 1;
      return 'Block $blockNumber - $_batchSize words';
    }
    return 'Vocabulary Learning';
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  // ============================================================================
  // Card Interaction Methods
  // ============================================================================

  /// Handle flip card tap - extracted for reusability
  void _handleFlipTap() {
    // Allow flipping for both 'flip' and 'simple' modes
    if (_flipController.status == AnimationStatus.dismissed ||
        _flipController.value == 0) {
      _flipController.forward();
      setState(() => showAnswer = true);
    } else if (_flipController.status == AnimationStatus.completed ||
        _flipController.value == 1) {
      _flipController.reverse();
      setState(() => showAnswer = false);
    } else {
      if (_flipController.value < 0.5) {
        _flipController.forward();
        setState(() => showAnswer = true);
      } else {
        _flipController.reverse();
        setState(() => showAnswer = false);
      }
    }
  }

  /// Show reset confirmation dialog
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Progress'),
          content: const Text(
            'Are you sure you want to restart this block from the beginning? Your current progress will be reset.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetBlockProgress();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  /// Reset block progress to start from beginning
  Future<void> _resetBlockProgress() async {
    if (_startIndex == null || _batchSize == null) return;

    final repository = ref.read(vocabularyRepositoryProvider);
    final blockNumber = (_startIndex! / _batchSize!).floor() + 1;
    final blockId = BlockProgressModel.generateBlockId(
      _level ?? 'N5',
      _wordType,
      blockNumber,
    );

    // Use repository method to reset block progress
    await repository.resetBlockProgress(blockId);

    // Invalidate the block progress provider to update UI
    ref.invalidate(blockProgressProvider);

    // Reset UI state
    setState(() {
      showAnswer = false;
      hasPlayedCompletionSound = false;
      _hasLoadedCheckpoint = true;
      _viewingIndex = 0;
      _lastCompletedCount = 0;
    });

    // Reset flip animation
    _flipController.reset();
  }

  // ============================================================================
  // Block Progress Management
  // ============================================================================

  Future<void> _initializeBlockProgress() async {
    if (_startIndex == null || _batchSize == null) return;

    final repository = ref.read(vocabularyRepositoryProvider);
    final blockNumber = (_startIndex! / _batchSize!).floor() + 1;
    final blockId = BlockProgressModel.generateBlockId(
      _level ?? 'N5',
      _wordType,
      blockNumber,
    );

    var blockProgress = await repository.getBlockProgress(blockId);

    if (blockProgress == null) {
      // Create new block progress using repository method
      blockProgress = await repository.updateBlockProgress(
        blockId,
        _level ?? 'N5',
        blockNumber,
        _startIndex!,
        0, // completedWords
        _batchSize!, // totalWords
        wordType: _wordType,
        isCompleted: false,
      );
    } else if (blockProgress.isCompleted) {
      // If block is completed, DON'T reset isCompleted or completedWords
      // Just update lastStudied - no progress tracking for completed blocks
      blockProgress = blockProgress.copyWith(lastStudied: DateTime.now());
      await repository.saveBlockProgress(blockProgress);
      setState(() {
        _viewingIndex = 0;
        _lastCompletedCount = 0;
        _hasLoadedCheckpoint = true;
      });
    } else if (!blockProgress.isCompleted &&
        blockProgress.completedWords > 0 &&
        !_hasLoadedCheckpoint) {
      // Resume from last checkpoint if block is in progress
      final checkpointIndex = blockProgress.completedWords;
      AppLogger.info(
        'Loading checkpoint: $checkpointIndex / ${blockProgress.totalWords}',
        'VocabLearning',
      );
      setState(() {
        // Resume viewing at the next-to-study card which equals completedWords (0-based)
        _viewingIndex = checkpointIndex;
        // Keep progress based on the completed count
        _lastCompletedCount = checkpointIndex;
        _hasLoadedCheckpoint = true; // Ensure we only load checkpoint once
      });
    } else {
      AppLogger.debug(
        'Starting fresh: isCompleted=${blockProgress.isCompleted}, completedWords=${blockProgress.completedWords}',
        'VocabLearning',
      );
    }

    // Mark initialization as complete
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _updateBlockProgress(int completedCount) async {
    if (_startIndex == null || _batchSize == null) return;

    final blockProgress = await _getBlockProgress();
    if (blockProgress == null) return;

    final updatedProgress = _calculateUpdatedProgress(
      blockProgress,
      completedCount,
      _batchSize!,
    );

    await _saveAndInvalidateProgress(updatedProgress);
  }

  Future<BlockProgressModel?> _getBlockProgress() async {
    final repository = ref.read(vocabularyRepositoryProvider);
    final blockNumber = (_startIndex! / _batchSize!).floor() + 1;
    final blockId = BlockProgressModel.generateBlockId(
      _level ?? kDefaultLevel,
      _wordType,
      blockNumber,
    );

    return await repository.getBlockProgress(blockId);
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
    } else if (!wasCompleted) {
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

  Future<void> _saveAndInvalidateProgress(BlockProgressModel progress) async {
    final repository = ref.read(vocabularyRepositoryProvider);
    await repository.saveBlockProgress(progress);
    ref.invalidate(blockProgressProvider);
  }

  Future<void> _playCompletionSound() async {
    try {
      debugPrint('Playing vocabulary completion sound');
      await _audioPlayer.play(AssetSource('audio/complete.wav'));
    } catch (e) {
      debugPrint('Completion sound error: $e');
    }
  }

  Future<void> _handleNext(VocabularyItemModel item, int totalVocabularyLength) async {
    // If this is the last card, play finish animation then go to completion
    if (_viewingIndex == totalVocabularyLength - 1) {
      setState(() {
        _isFinishing = true;
        showAnswer = false;
        _flipController.value = 0;
        _lastCompletedCount = totalVocabularyLength;
      });
      await _updateBlockProgress(_lastCompletedCount);
      Future.delayed(VocabularyLearningConstants.successAnimationDuration, () {
        if (!mounted) return;
        setState(() {
          _isFinishing = false;
          _viewingIndex++; // triggers completion screen
        });
      });
    } else {
      setState(() {
        _viewingIndex++;
        showAnswer = false;
        _flipController.value = 0;
      });
      // Update block progress after moving forward
      if (_viewingIndex > _lastCompletedCount) {
        _lastCompletedCount = _viewingIndex;
        await _updateBlockProgress(_lastCompletedCount);
      }
    }
  }

  // ============================================================================
  // Build Methods
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final vocabularyAsync = ref.watch(
      vocabularyByLevelAndTypeProvider(
        VocabularyFilter(level: _level ?? 'N5', wordType: _wordType ?? 'all'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to start',
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : vocabularyAsync.when(
              data: (allVocabulary) => _buildLearningContent(allVocabulary),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
    );
  }

  Widget _buildLearningContent(List<VocabularyItemModel> allVocabulary) {
    if (allVocabulary.isEmpty) {
      return const Center(child: Text('No vocabulary items available'));
    }

    final vocabulary = (_startIndex != null && _batchSize != null)
        ? allVocabulary.skip(_startIndex!).take(_batchSize!).toList()
        : allVocabulary;

    if (vocabulary.isEmpty) {
      return const Center(child: Text('No vocabulary items in this batch'));
    }

    if (_viewingIndex >= vocabulary.length) {
      return _buildCompletionScreen(vocabulary.length);
    }

    return _buildLearningScreen(vocabulary);
  }

  Widget _buildCompletionScreen(int totalCards) {
    final blockNumber = _startIndex != null && _batchSize != null
        ? (_startIndex! / _batchSize!).floor() + 1
        : null;

    return CompletionScreenWidget(
      level: _level ?? 'N5',
      wordType: _wordType,
      totalCards: totalCards,
      blockNumber: blockNumber,
      hasPlayedCompletionSound: hasPlayedCompletionSound,
      onSoundPlayed: () {
        if (!hasPlayedCompletionSound) {
          setState(() => hasPlayedCompletionSound = true);
          _playCompletionSound();
        }
      },
      onRestart: () {
        setState(() {
          _viewingIndex = 0;
          _lastCompletedCount = 0;
          showAnswer = false;
          hasPlayedCompletionSound = false;
        });
      },
      onExit: () => Navigator.pop(context),
    );
  }

  Widget _buildLearningScreen(List<VocabularyItemModel> vocabulary) {
    return LearningScreen(
      vocabulary: vocabulary,
      viewingIndex: _viewingIndex,
      lastCompletedCount: _lastCompletedCount,
      isFinishing: _isFinishing,
      level: _level,
      learningMode: _learningMode,
      flipController: _flipController,
      onSpeak: _speak,
      onFlipTap: _handleFlipTap,
      onBack: _handleBack,
      onNext: () => _handleNext(vocabulary[_viewingIndex], vocabulary.length),
    );
  }

  void _handleBack() {
    if (_viewingIndex > 0) {
      setState(() {
        _viewingIndex--;
        showAnswer = false;
        _flipController.value = 0;
      });
    }
  }
}
