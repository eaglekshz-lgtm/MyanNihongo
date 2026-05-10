import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';

import '../../../../core/routes/arguments/vocabulary_learning_args.dart';
import '../../data/models/vocabulary_filter.dart';
import '../../data/models/vocabulary_item_model.dart';
import '../../data/providers/vocabulary_learning_controller.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../constants/vocabulary_learning_constants.dart';
import '../widgets/learning/learning_completion_screen.dart';
import '../widgets/learning/learning_screen.dart';

class VocabularyLearningPage extends ConsumerStatefulWidget {
  const VocabularyLearningPage({super.key});

  @override
  ConsumerState<VocabularyLearningPage> createState() =>
      _VocabularyLearningPageState();
}

class _VocabularyLearningPageState extends ConsumerState<VocabularyLearningPage>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  late AnimationController _flipController;
  late AnimationController _flashController;
  Color? _flashColor;
  bool _isSwipeLeft = false;

  VocabularyLearningConfig? _config;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: VocabularyLearningConstants.flipDuration,
    );
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _initializeTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_config == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as VocabularyLearningArgs?;
      _config = VocabularyLearningConfig.fromArgs(args);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tts.stop();
    _flipController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage(VocabularyLearningConstants.japaneseLanguage);
      await _tts.setSpeechRate(VocabularyLearningConstants.ttsSpeechRate);
      await _tts.setVolume(VocabularyLearningConstants.ttsVolume);
      await _tts.setPitch(VocabularyLearningConstants.ttsPitch);
    } catch (e) {
      AppLogger.warning('TTS init error: $e', 'VocabLearning');
    }
  }

  String _getAppBarTitle(VocabularyLearningConfig config) {
    final blockNumber = config.blockNumber;
    if (blockNumber != null) {
      return 'Set $blockNumber · ${config.batchSize} words';
    }
    return 'Vocabulary Learning';
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      AppLogger.warning('TTS speak error: $e', 'VocabLearning');
    }
  }

  void _handleFlipTap() {
    if ((_config?.learningMode ?? 'recall') == 'recall') {
      if (_flipController.value < 1) {
        _flipController.forward();
      }
      return;
    }

    if (_flipController.status == AnimationStatus.dismissed ||
        _flipController.value == 0) {
      _flipController.forward();
    } else if (_flipController.status == AnimationStatus.completed ||
        _flipController.value == 1) {
      _flipController.reverse();
    } else {
      if (_flipController.value < 0.5) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  void _showResetDialog(BuildContext context, VocabularyLearningConfig config) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Progress'),
          content: const Text(
            'Are you sure you want to restart this set from the beginning? Your current progress will be reset.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetBlockProgress(config);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetBlockProgress(VocabularyLearningConfig config) async {
    await ref
        .read(vocabularyLearningControllerProvider(config).notifier)
        .resetBlockProgress();
    _flipController.reset();
  }

  Future<void> _playCompletionSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/complete.wav'));
    } catch (e) {
      AppLogger.warning('Completion sound error: $e', 'VocabLearning');
    }
  }

  void _triggerFlash(Color color, {bool swipeLeft = false}) {
    _flashColor = color;
    _isSwipeLeft = swipeLeft;
    _flashController.forward(from: 0.0);
  }

  /// Swipe Left = Hard, then advance.
  Future<void> _handleSwipeLeft(
    VocabularyLearningConfig config,
    VocabularyItemModel currentItem,
    int totalVocabularyLength,
  ) async {
    _triggerFlash(
      Theme.of(context).colorScheme.learningHardFlash,
      swipeLeft: true,
    );
    _flipController.value = 0;
    await ref
        .read(vocabularyLearningControllerProvider(config).notifier)
        .goNext(totalVocabularyLength);
  }

  /// Swipe Right = Easy, then advance.
  Future<void> _handleSwipeRight(
    VocabularyLearningConfig config,
    VocabularyItemModel currentItem,
    int totalVocabularyLength,
  ) async {
    _triggerFlash(
      Theme.of(context).colorScheme.learningEasyFlash,
      swipeLeft: false,
    );
    _flipController.value = 0;
    await ref
        .read(vocabularyLearningControllerProvider(config).notifier)
        .goNext(totalVocabularyLength);
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    if (config == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final vocabularyAsync = config.hasBlock
        ? ref.watch(
            vocabularyRangeProvider((
              level: config.level,
              offset: config.startIndex!,
              limit: config.batchSize!,
            )),
          )
        : ref.watch(
            vocabularyByLevelAndTypeProvider(
              VocabularyFilter(
                level: config.level,
                wordType: config.wordType ?? 'all',
              ),
            ),
          );

    if (config.hasBlock && vocabularyAsync.hasValue) {
      ref.watch(
        prefetchVocabularyRangeProvider((
          level: config.level,
          offset: config.startIndex! + config.batchSize!,
          limit: config.batchSize!,
        )),
      );
    }

    final learningAsync = ref.watch(
      vocabularyLearningControllerProvider(config),
    );

    final cs = Theme.of(context).colorScheme;
    final learningBackground = cs.learningPageScaffold;

    return Scaffold(
      backgroundColor: learningBackground,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(_getAppBarTitle(config)),
        centerTitle: true,
        titleTextStyle: AppTheme.headlineMedium.copyWith(
          color: cs.learningAppBarForeground,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: learningBackground,
        foregroundColor: cs.learningAppBarForeground,
        iconTheme: IconThemeData(color: cs.learningAppBarIcon),
        actionsIconTheme: IconThemeData(color: cs.learningAppBarIcon),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset to start',
            onPressed: () => _showResetDialog(context, config),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Base background
          Positioned.fill(child: Container(color: learningBackground)),
          SafeArea(child: _buildBody(config, vocabularyAsync, learningAsync)),
          // Flash overlay
          Positioned.fill(child: _buildFlashOverlay()),
        ],
      ),
    );
  }

  Widget _buildFlashOverlay() {
    return AnimatedBuilder(
      animation: _flashController,
      builder: (context, _) {
        if (!_flashController.isAnimating && _flashController.isDismissed) {
          return const SizedBox.shrink();
        }
        final flashColor =
            _flashColor ?? Theme.of(context).colorScheme.transparent;
        // Quick flash curve: peak at 15%, then fade out
        final t = _flashController.value;
        final double opacity;
        if (t < 0.15) {
          opacity = (t / 0.15) * 0.35;
        } else {
          opacity = (1.0 - ((t - 0.15) / 0.85)) * 0.35;
        }
        final clampedOpacity = opacity.clamp(0.0, 1.0);

        return IgnorePointer(
          child: Stack(
            children: [
              Container(
                color: flashColor.withValues(alpha: clampedOpacity * 0.05),
              ),
              Positioned(
                left: _isSwipeLeft ? 0 : null,
                right: _isSwipeLeft ? null : 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: flashColor.withValues(alpha: clampedOpacity),
                    boxShadow: [
                      BoxShadow(
                        color: flashColor.withValues(
                          alpha: clampedOpacity * 0.42,
                        ),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    VocabularyLearningConfig config,
    AsyncValue<List<VocabularyItemModel>> vocabularyAsync,
    AsyncValue<VocabularyLearningState> learningAsync,
  ) {
    if (vocabularyAsync.isLoading || learningAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final vocabularyError = vocabularyAsync.error;
    if (vocabularyError != null) {
      return Center(child: Text('Error: $vocabularyError'));
    }

    final learningError = learningAsync.error;
    if (learningError != null) {
      return Center(child: Text('Error: $learningError'));
    }

    final allVocabulary = vocabularyAsync.valueOrNull ?? const [];
    final learningState = learningAsync.valueOrNull;
    if (learningState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildLearningContent(config, allVocabulary, learningState);
  }

  Widget _buildLearningContent(
    VocabularyLearningConfig config,
    List<VocabularyItemModel> allVocabulary,
    VocabularyLearningState learningState,
  ) {
    if (allVocabulary.isEmpty) {
      return const Center(child: Text('No vocabulary items available'));
    }

    final vocabulary = allVocabulary;

    if (vocabulary.isEmpty) {
      return const Center(child: Text('No vocabulary items in this batch'));
    }

    if (learningState.viewingIndex >= vocabulary.length) {
      return _buildCompletionScreen(config, learningState, vocabulary.length);
    }

    return _buildLearningScreen(config, learningState, vocabulary);
  }

  Widget _buildCompletionScreen(
    VocabularyLearningConfig config,
    VocabularyLearningState learningState,
    int totalCards,
  ) {
    return LearningCompletionScreen(
      totalCards: totalCards,
      blockNumber: config.blockNumber,
      hasPlayedCompletionSound: learningState.hasPlayedCompletionSound,
      onSoundPlayed: () {
        if (!learningState.hasPlayedCompletionSound) {
          ref
              .read(vocabularyLearningControllerProvider(config).notifier)
              .markCompletionSoundPlayed();
          _playCompletionSound();
        }
      },
      onRestart: () {
        _flipController.reset();
        ref
            .read(vocabularyLearningControllerProvider(config).notifier)
            .restart();
      },
      onExit: () => Navigator.pop(context),
    );
  }

  Widget _buildLearningScreen(
    VocabularyLearningConfig config,
    VocabularyLearningState learningState,
    List<VocabularyItemModel> vocabulary,
  ) {
    return LearningScreen(
      vocabulary: vocabulary,
      viewingIndex: learningState.viewingIndex,
      lastCompletedCount: learningState.lastCompletedCount,
      isFinishing: learningState.isFinishing,
      level: config.level,
      learningMode: config.learningMode,
      flipController: _flipController,
      onSpeak: _speak,
      onFlipTap: _handleFlipTap,
      onSwipeLeft: () => _handleSwipeLeft(
        config,
        vocabulary[learningState.viewingIndex],
        vocabulary.length,
      ),
      onSwipeRight: () => _handleSwipeRight(
        config,
        vocabulary[learningState.viewingIndex],
        vocabulary.length,
      ),
    );
  }
}
