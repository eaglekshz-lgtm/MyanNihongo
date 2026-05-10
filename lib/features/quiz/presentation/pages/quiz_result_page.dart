import 'package:flutter/material.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../domain/models/quiz_result_args.dart';
import '../widgets/quiz_result_widgets.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({super.key});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with SingleTickerProviderStateMixin {
  static const _passingScore = 70;
  static const _defaultTotalQuestions = 10;

  int _totalQuestions = _defaultTotalQuestions;
  int _correctAnswers = 0;
  String? _level;
  bool _hasLoadedArgs = false;

  late final AnimationController _controller;
  late final Animation<double> _scoreAnimation;
  late final Animation<double> _fadeAnimation;

  int get _scorePercentage {
    if (_totalQuestions <= 0) return 0;
    return (_correctAnswers / _totalQuestions * 100).round();
  }

  bool get _isPassed => _scorePercentage >= _passingScore;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedArgs) return;

    final args = ModalRoute.of(context)!.settings.arguments as QuizResultArgs?;
    _totalQuestions = args?.totalQuestions ?? _defaultTotalQuestions;
    _correctAnswers = args?.correctAnswers ?? 0;
    _level = args?.level;
    _hasLoadedArgs = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Quiz Results',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: cs.transparent,
      ),
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildScrollableContent()),
              QuizResultActionBar(
                animation: _fadeAnimation,
                onRetakeQuiz: () => Navigator.pop(context),
                onBackHome: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.home,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuizResultScoreCircle(
            animation: _scoreAnimation,
            scorePercentage: _scorePercentage,
            isPassed: _isPassed,
          ),
          const SizedBox(height: 20),
          QuizResultMessageCard(
            animation: _fadeAnimation,
            isPassed: _isPassed,
            correctAnswers: _correctAnswers,
            totalQuestions: _totalQuestions,
          ),
          const SizedBox(height: 20),
          QuizResultInsightsHeader(animation: _fadeAnimation),
          const SizedBox(height: 16),
          QuizResultStatistics(
            animation: _fadeAnimation,
            scorePercentage: _scorePercentage,
            isPassed: _isPassed,
            level: _level,
          ),
        ],
      ),
    );
  }
}
