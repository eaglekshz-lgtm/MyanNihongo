import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vocabulary_completion_screen.dart';

class LearningCompletionScreen extends ConsumerWidget {
  final int totalCards;
  final int? blockNumber;
  final bool hasPlayedCompletionSound;
  final VoidCallback onSoundPlayed;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const LearningCompletionScreen({
    super.key,
    required this.totalCards,
    this.blockNumber,
    required this.hasPlayedCompletionSound,
    required this.onSoundPlayed,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Play completion sound once
    if (!hasPlayedCompletionSound) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSoundPlayed();
      });
    }

    return VocabularyCompletionScreen(
      totalCards: totalCards,
      blockNumber: blockNumber,
      onRestart: onRestart,
      onExit: onExit,
    );
  }
}
