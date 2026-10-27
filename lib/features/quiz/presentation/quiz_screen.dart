import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/quiz.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const QuizScreen({super.key, required this.lessonId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  QuizData? _quizData;
  bool _isLoading = true;
  final Map<int, int> _selectedAnswers = {};
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final brain = ref.read(teacherBrainServiceProvider);
    final repo = ref.read(repositoryProvider);
    final lang = ref.read(currentLanguageProvider);
    final lesson = repo.getLessonById(widget.lessonId);

    final data = await brain.generateQuiz(
      lessonId: widget.lessonId,
      lessonTitle: lesson?.title ?? 'Newton\'s Laws',
      scriptText: lesson?.scriptText ?? '',
      languageCode: lang.code,
    );

    if (mounted) {
      setState(() {
        _quizData = data;
        _isLoading = false;
      });
    }
  }

  void _submitQuiz() {
    setState(() => _isSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exam Ready Quiz')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Auto-generating exam MCQs from lesson content...'),
            ],
          ),
        ),
      );
    }

    final quiz = _quizData!;
    final questions = quiz.questions;

    // Calculate score if submitted
    int score = 0;
    final List<String> weakTopics = [];
    final List<String> strongTopics = [];

    if (_isSubmitted) {
      for (int i = 0; i < questions.length; i++) {
        if (_selectedAnswers[i] == questions[i].correctOptionIndex) {
          score++;
          strongTopics.add(questions[i].topicTag);
        } else {
          weakTopics.add(questions[i].topicTag);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.lessonTitle, style: const TextStyle(fontSize: 15)),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: const Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _selectedAnswers.length < questions.length && !_isSubmitted
                ? null
                : () {
                    if (!_isSubmitted) {
                      _submitQuiz();
                    } else {
                      context.pop();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSubmitted ? AppColors.primary : AppColors.saffronDark,
              foregroundColor: Colors.white,
            ),
            child: Text(
              _isSubmitted
                  ? 'Return to Explainer Lesson'
                  : 'Submit Answers (${_selectedAnswers.length}/${questions.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Score Card Header if Submitted
          if (_isSubmitted) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    score >= (questions.length / 2) ? AppColors.emerald : AppColors.coral,
                    score >= (questions.length / 2) ? AppColors.emeraldDark : AppColors.error,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Quiz Evaluation Complete',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Score: $score / ${questions.length} (${((score / questions.length) * 100).toInt()}%)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (weakTopics.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tips_and_updates_rounded, color: Colors.amberAccent, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Focus revision on: ${weakTopics.toSet().join(', ')}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Question Cards
          ...questions.asMap().entries.map((entry) {
            final qIndex = entry.key;
            final q = entry.value;
            final userChoice = _selectedAnswers[qIndex];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Q${qIndex + 1}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            q.topicTag,
                            style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      q.question,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, height: 1.3),
                    ),
                    const SizedBox(height: 14),

                    // Options
                    ...q.options.asMap().entries.map((optEntry) {
                      final optIndex = optEntry.key;
                      final optText = optEntry.value;
                      final isSelected = userChoice == optIndex;

                      Color? optBg;
                      BorderSide border = const BorderSide(color: AppColors.borderLight);

                      if (_isSubmitted) {
                        if (optIndex == q.correctOptionIndex) {
                          optBg = AppColors.emeraldContainer;
                          border = const BorderSide(color: AppColors.emerald, width: 2);
                        } else if (isSelected && optIndex != q.correctOptionIndex) {
                          optBg = AppColors.errorContainer;
                          border = const BorderSide(color: AppColors.error, width: 2);
                        }
                      } else if (isSelected) {
                        optBg = AppColors.primaryContainer;
                        border = const BorderSide(color: AppColors.primary, width: 2);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: _isSubmitted
                              ? null
                              : () {
                                  setState(() {
                                    _selectedAnswers[qIndex] = optIndex;
                                  });
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: optBg ?? Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.fromBorderSide(border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.withOpacity(0.2),
                                  child: Text(
                                    String.fromCharCode(65 + optIndex),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    optText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (_isSubmitted && optIndex == q.correctOptionIndex)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 18),
                                if (_isSubmitted && isSelected && optIndex != q.correctOptionIndex)
                                  const Icon(Icons.cancel_rounded, color: AppColors.error, size: 18),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Explanation Box if submitted
                    if (_isSubmitted) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                q.explanation,
                                style: const TextStyle(fontSize: 11, height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
