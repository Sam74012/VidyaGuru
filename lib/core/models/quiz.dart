class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String topicTag;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.topicTag,
  });
}

class QuizData {
  final String id;
  final String lessonId;
  final String lessonTitle;
  final List<QuizQuestion> questions;

  const QuizData({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.questions,
  });
}

class QuizResult {
  final int score;
  final int totalQuestions;
  final Map<int, int> selectedAnswers;
  final List<String> weakTopics;
  final List<String> strongTopics;
  final DateTime completedAt;

  const QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.selectedAnswers,
    required this.weakTopics,
    required this.strongTopics,
    required this.completedAt,
  });

  double get percentage => totalQuestions == 0 ? 0 : (score / totalQuestions) * 100;
}
