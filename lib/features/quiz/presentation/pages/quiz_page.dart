import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/quiz_args.dart';
import '../../domain/models/quiz_result_args.dart';
import '../../data/providers/quiz_providers.dart';
import '../../data/providers/quiz_state_notifier.dart';
import '../../../../core/widgets/mesh_background.dart';
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.neutral400,
            ),
            const SizedBox(height: 16),
            Text('No questions available', style: AppTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different level',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
            Icon(
              Icons.error,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                  color: Theme.of(context).colorScheme.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: MeshBackground(
        child: SafeArea(
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
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15),
                                Theme.of(
                                  context,
                                ).colorScheme.secondary.withValues(alpha: 0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              currentQuestion.question,
                              style: AppTheme.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
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
                                        Theme.of(context).colorScheme.success
                                            .withValues(alpha: 0.15),
                                        Theme.of(context).colorScheme.success
                                            .withValues(alpha: 0.08),
                                      ]
                                    : [
                                        Theme.of(context).colorScheme.error
                                            .withValues(alpha: 0.15),
                                        Theme.of(context).colorScheme.error
                                            .withValues(alpha: 0.08),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    quizState.selectedAnswerIndex ==
                                        currentQuestion.correctAnswerIndex
                                    ? Theme.of(context).colorScheme.success
                                          .withValues(alpha: 0.4)
                                    : Theme.of(context).colorScheme.error
                                          .withValues(alpha: 0.4),
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
                                                currentQuestion
                                                    .correctAnswerIndex
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color:
                                            quizState.selectedAnswerIndex ==
                                                currentQuestion
                                                    .correctAnswerIndex
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.success
                                            : Theme.of(
                                                context,
                                              ).colorScheme.error,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        quizState.selectedAnswerIndex ==
                                                currentQuestion
                                                    .correctAnswerIndex
                                            ? 'Correct!'
                                            : 'Incorrect',
                                        style: AppTheme.titleMedium.copyWith(
                                          color:
                                              quizState.selectedAnswerIndex ==
                                                  currentQuestion
                                                      .correctAnswerIndex
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.success
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    currentQuestion.explanation,
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      quizState.currentQuestionIndex <
                              widget.questions.length - 1
                          ? 'Next Question'
                          : 'Finish Quiz',
                      style: AppTheme.titleMedium.copyWith(
                        color: Theme.of(context).colorScheme.fixedWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ), // MeshBackground
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
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: currentQuestionIndex / totalQuestions,
            backgroundColor: Theme.of(
              context,
            ).dividerColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
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
        backgroundColor = Theme.of(
          context,
        ).colorScheme.success.withValues(alpha: 0.12);
        borderColor = Theme.of(context).colorScheme.success;
      } else if (isSelected) {
        backgroundColor = Theme.of(
          context,
        ).colorScheme.error.withValues(alpha: 0.12);
        borderColor = Theme.of(context).colorScheme.error;
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.12);
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor ?? Theme.of(context).colorScheme.transparent,
            width: 2,
          ),
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
                        ? Theme.of(context).colorScheme.success
                        : hasAnswered && isSelected
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).dividerColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: AppTheme.bodyMedium.copyWith(
                        color: hasAnswered && (isCorrect || isSelected)
                            ? Theme.of(context).colorScheme.fixedWhite
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.success,
                  ),
                if (hasAnswered && isSelected && !isCorrect)
                  Icon(
                    Icons.cancel,
                    color: Theme.of(context).colorScheme.error,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
