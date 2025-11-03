import 'package:flutter/material.dart';
import '../../../../arguments/learning_mode_config_args.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/page_header_widget.dart';
import '../widgets/learning_mode_card.dart';

class LearningModeSelectionPage extends StatefulWidget {
  const LearningModeSelectionPage({super.key});

  @override
  State<LearningModeSelectionPage> createState() => _LearningModeSelectionPageState();
}

class _LearningModeSelectionPageState extends State<LearningModeSelectionPage> {
  String? _level;
  String? _wordType;
  bool _argsExtracted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_argsExtracted) {
      final args = ModalRoute.of(context)!.settings.arguments as LearningModeConfigArgs?;
      if (args != null) {
        _level = args.level;
        _wordType = args.wordType;
        _argsExtracted = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Learning Mode'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageHeaderWidget(
                icon: Icons.settings_suggest,
                title: 'How do you want to learn?',
                subtitle: 'Choose your preferred card style',
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _LearningModeList(
                  level: _level ?? '',
                  wordType: _wordType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Separated widget for mode list to prevent unnecessary rebuilds
class _LearningModeList extends StatelessWidget {
  final String level;
  final String? wordType;

  const _LearningModeList({
    required this.level,
    required this.wordType,
  });

  void _navigateToConfigPage(BuildContext context) {
    // Navigate to the configuration page using named route
    Navigator.pushNamed(
      context,
      RouteNames.learningModeConfig,
      arguments: LearningModeConfigArgs(
        level: level,
        wordType: wordType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LearningModeCard(
          mode: 'recall',
          icon: Icons.psychology_rounded,
          title: 'Recall Mode',
          description: 'Test your memory! See Japanese word first, flip to recall Burmese meaning and reading.',
          color: AppTheme.primaryColor,
          features: const [
            'Quiz yourself',
            'Active recall',
            'Memory testing',
          ],
          onTap: () => _navigateToConfigPage(context),
        ),
        const SizedBox(height: 20),
        LearningModeCard(
          mode: 'absorb',
          icon: Icons.auto_stories_rounded,
          title: 'Absorb Mode',
          description: 'Absorb knowledge comprehensively! See all content together, flip for examples and usage.',
          color: AppTheme.secondaryColor,
          features: const [
            'Full content view',
            'Example sentences',
            'Comprehensive learning',
          ],
          onTap: () => _navigateToConfigPage(context),
        ),
      ],
    );
  }
}
