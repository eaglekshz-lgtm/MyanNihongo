import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/quiz_args.dart';
import '../../domain/models/quiz_result_args.dart';
import '../../data/providers/quiz_providers.dart';
import '../../data/providers/quiz_state_notifier.dart';
import '../../domain/entities/quiz_question.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  QuizArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments once
    _args ??= ModalRoute.of(context)?.settings.arguments as QuizArgs?;
  }

  @override
  Widget build(BuildContext context) {
    final args = _args ?? const QuizArgs(numberOfQuestions: 10);
    final quizConfig = QuizConfig(
      numberOfQuestions: args.numberOfQuestions,
      level: args.level,
    );

    final questionsAsync = ref.watch(quizQuestionsProvider(quizConfig));

    return questionsAsync.when(
      data: (questions) {
        if (questions.isEmpty) {
          return _buildEmptyState();
        }
        return _QuizContent(questions: questions, level: args.level);
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) {
        AppLogger.error(
          'Failed to load quiz questions',
          tag: 'QuizPage',
          stackTrace: stackTrace,
          error: error.toString(),
        );
        return _buildErrorState(error);
      },
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No questions available', style: AppTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different level',
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(Object error) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quiz content widget that manages quiz state with Riverpod
class _QuizContent extends ConsumerStatefulWidget {
  const _QuizContent({required this.questions, required this.level});

  final List<QuizQuestion> questions;
  final String? level;

  @override
  ConsumerState<_QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends ConsumerState<_QuizContent> {
  @override
  void initState() {
    super.initState();

    // ✅ BEST PRACTICE: Use ref.listen for side effects (navigation)
    // This runs once on initialization and listens for state changes
    Future.microtask(() {
      ref.listen<QuizState>(quizStateProvider(widget.questions), (
        previous,
        next,
      ) {
        // Navigate to results when quiz is completed
        if (next.isCompleted && context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.quizResult,
            arguments: QuizResultArgs(
              totalQuestions: widget.questions.length,
              correctAnswers: next.correctAnswers,
              level: widget.level,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIXED: Use .family provider instead of creating provider in initState
    final quizStateNotifier = quizStateProvider(widget.questions);
    final quizState = ref.watch(quizStateNotifier);

    // Show loading if quiz is completed (waiting for navigation)
    if (quizState.isCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = quizState.currentQuestion;
    if (currentQuestion == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No question available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Score: ${quizState.correctAnswers}',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _ProgressIndicatorWidget(
              currentQuestionIndex: quizState.currentQuestionIndex,
              totalQuestions: widget.questions.length,
            ),

            // Question card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question number
                    Text(
                      'Question ${quizState.currentQuestionIndex + 1} of ${widget.questions.length}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Question text
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor.withValues(alpha: 0.15),
                              AppTheme.secondaryColor.withValues(alpha: 0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            currentQuestion.question,
                            style: AppTheme.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options
                    ...List.generate(
                      currentQuestion.options.length,
                      (index) => _OptionCardWidget(
                        question: currentQuestion,
                        index: index,
                        selectedAnswerIndex: quizState.selectedAnswerIndex,
                        hasAnswered: quizState.hasAnswered,
                        onSelectAnswer: (answerIndex) {
                          // ✅ FIXED: Use proper family provider
                          ref
                              .read(quizStateNotifier.notifier)
                              .selectAnswer(answerIndex);
                        },
                      ),
                    ),

                    // Explanation (shown after answering)
                    if (quizState.hasAnswered) ...[
                      const SizedBox(height: 24),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  quizState.selectedAnswerIndex ==
                                      currentQuestion.correctAnswerIndex
                                  ? [
                                      AppTheme.successColor.withValues(
                                        alpha: 0.15,
                                      ),
                                      AppTheme.successColor.withValues(
                                        alpha: 0.08,
                                      ),
                                    ]
                                  : [
                                      AppTheme.errorColor.withValues(
                                        alpha: 0.15,
                                      ),
                                      AppTheme.errorColor.withValues(
                                        alpha: 0.08,
                                      ),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  quizState.selectedAnswerIndex ==
                                      currentQuestion.correctAnswerIndex
                                  ? AppTheme.successColor.withValues(alpha: 0.4)
                                  : AppTheme.errorColor.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      quizState.selectedAnswerIndex ==
                                              currentQuestion.correctAnswerIndex
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          quizState.selectedAnswerIndex ==
                                              currentQuestion.correctAnswerIndex
                                          ? AppTheme.successColor
                                          : AppTheme.errorColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      quizState.selectedAnswerIndex ==
                                              currentQuestion.correctAnswerIndex
                                          ? 'Correct!'
                                          : 'Incorrect',
                                      style: AppTheme.titleMedium.copyWith(
                                        color:
                                            quizState.selectedAnswerIndex ==
                                                currentQuestion
                                                    .correctAnswerIndex
                                            ? AppTheme.successColor
                                            : AppTheme.errorColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  currentQuestion.explanation,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.onSurfaceColor,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Next button (shown after answering)
            if (quizState.hasAnswered)
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(quizStateNotifier.notifier).nextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    quizState.currentQuestionIndex < widget.questions.length - 1
                        ? 'Next Question'
                        : 'Finish Quiz',
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Private Widget Classes

/// Progress indicator widget showing quiz completion percentage
class _ProgressIndicatorWidget extends StatelessWidget {
  const _ProgressIndicatorWidget({
    required this.currentQuestionIndex,
    required this.totalQuestions,
  });

  final int currentQuestionIndex;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((currentQuestionIndex / totalQuestions) * 100).toStringAsFixed(0)}%',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: currentQuestionIndex / totalQuestions,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Option card widget for quiz answers
class _OptionCardWidget extends StatelessWidget {
  const _OptionCardWidget({
    required this.question,
    required this.index,
    required this.selectedAnswerIndex,
    required this.hasAnswered,
    required this.onSelectAnswer,
  });

  final QuizQuestion question;
  final int index;
  final int? selectedAnswerIndex;
  final bool hasAnswered;
  final ValueChanged<int> onSelectAnswer;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedAnswerIndex == index;
    final isCorrect = index == question.correctAnswerIndex;

    Color? backgroundColor;
    Color? borderColor;

    if (hasAnswered) {
      if (isCorrect) {
        backgroundColor = AppTheme.successColor.withValues(alpha: 0.12);
        borderColor = AppTheme.successColor;
      } else if (isSelected) {
        backgroundColor = AppTheme.errorColor.withValues(alpha: 0.12);
        borderColor = AppTheme.errorColor;
      }
    } else if (isSelected) {
      backgroundColor = AppTheme.primaryColor.withValues(alpha: 0.12);
      borderColor = AppTheme.primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor ?? Colors.transparent, width: 2),
        ),
        child: InkWell(
          onTap: hasAnswered ? null : () => onSelectAnswer(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: hasAnswered && isCorrect
                        ? AppTheme.correctAnswerColor
                        : hasAnswered && isSelected
                        ? AppTheme.incorrectAnswerColor
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: AppTheme.bodyMedium.copyWith(
                        color: hasAnswered && (isCorrect || isSelected)
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    question.options[index],
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasAnswered && isCorrect)
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.correctAnswerColor,
                  ),
                if (hasAnswered && isSelected && !isCorrect)
                  const Icon(
                    Icons.cancel,
                    color: AppTheme.incorrectAnswerColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
