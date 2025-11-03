import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../arguments/learning_mode_config_args.dart';
import '../../../../arguments/batch_selection_args.dart';
import '../../data/providers/vocabulary_provider.dart';
import '../../data/models/vocabulary_filter.dart';
import '../widgets/learning_config/header_section.dart';
import '../widgets/learning_config/card_style_section.dart';
import '../widgets/learning_config/summary_card.dart';
import '../widgets/learning_config/start_button.dart';

/// Configuration constants for better maintenance
const int kDefaultBlockSize = 20; // Fixed size of each block (always 20 words)
/// Learning Mode Configuration Page
/// Allows users to configure learning settings before starting
class LearningModeConfigPage extends ConsumerStatefulWidget {
  const LearningModeConfigPage({super.key});

  @override
  ConsumerState<LearningModeConfigPage> createState() => _LearningModeConfigPageState();
}

class _LearningModeConfigPageState extends ConsumerState<LearningModeConfigPage> {
  String? _level;
  String? _wordType;
  // Configuration state
  CardStyle _selectedCardStyle = CardStyle.recallMode;
  int _totalWords = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_level == null) {
      final args = ModalRoute.of(context)!.settings.arguments as LearningModeConfigArgs?;
      _level = args?.level ?? 'N5';
      _wordType = args?.wordType;
      _loadVocabularyCount();
    }
  }

  Future<void> _loadVocabularyCount() async {
    AppLogger.data(
      'Loading vocabulary count for level: $_level, wordType: $_wordType',
      operation: 'READ',
    );
    final vocabularyAsync = await ref.read(
      vocabularyByLevelAndTypeProvider(
        VocabularyFilter(
          level: _level ?? 'N5',
          wordType: _wordType ?? 'all',
        ),
      ).future,
    );
    
    AppLogger.info(
      'Retrieved ${vocabularyAsync.length} vocabulary items',
      'LearningModeConfig',
    );
    
    if (mounted) {
      setState(() {
        _totalWords = vocabularyAsync.length;
      });
      AppLogger.debug(
        'Updated UI with $_totalWords total words',
        'LearningModeConfig',
      );
    }
  }

  String _getBlocksCount() {
    if (_totalWords == 0) return 'Calculating...';
    
    // Calculate number of blocks based on fixed block size of 20
    final totalBlocks = (_totalWords / kDefaultBlockSize).ceil();
    return '$totalBlocks ${totalBlocks == 1 ? 'block' : 'blocks'}';
  }

  void _startLearning() async {
    final learningMode = _selectedCardStyle.code;

    // Always use fixed block size of 20 words
    Navigator.pushNamed(
      context,
      RouteNames.batchSelection,
      arguments: BatchSelectionArgs(
        level: _level ?? 'N5',
        wordType: _wordType,
        learningMode: learningMode,
        blockSize: kDefaultBlockSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Learning Settings'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    HeaderSection(
                      level: _level ?? 'N5',
                      wordType: _wordType,
                      totalWords: _totalWords,
                    ),
                    const SizedBox(height: 32),

                    // Card Style Selection
                    CardStyleSection(
                      selectedCardStyle: _selectedCardStyle,
                      onCardStyleChanged: (style) => setState(() => _selectedCardStyle = style),
                    ),
                    const SizedBox(height: 24),

                    // Summary Card (no batch size selection - always 20 words per block)
                    SummaryCard(
                      selectedCardStyle: _selectedCardStyle,
                      totalWords: _totalWords,
                      blocksCount: _getBlocksCount(),
                    ),
                  ],
                ),
              ),
            ),

            // Start Button
            StartButton(onPressed: _startLearning),
          ],
        ),
      ),
    );
  }

}


