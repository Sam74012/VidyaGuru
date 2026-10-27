import '../config/app_config.dart';
import '../models/teacher_avatar.dart';
import '../models/quiz.dart';
import 'content_parser_service.dart';

class ScriptSection {
  final String title;
  final String scriptText;
  final int estimatedSeconds;
  final List<String> examPointers;
  final String visualCue;

  const ScriptSection({
    required this.title,
    required this.scriptText,
    required this.estimatedSeconds,
    required this.examPointers,
    required this.visualCue,
  });

  ScriptSection copyWith({
    String? title,
    String? scriptText,
    int? estimatedSeconds,
    List<String>? examPointers,
    String? visualCue,
  }) {
    return ScriptSection(
      title: title ?? this.title,
      scriptText: scriptText ?? this.scriptText,
      estimatedSeconds: estimatedSeconds ?? this.estimatedSeconds,
      examPointers: examPointers ?? this.examPointers,
      visualCue: visualCue ?? this.visualCue,
    );
  }
}

class GeneratedScript {
  final String title;
  final String fullText;
  final List<ScriptSection> sections;
  final List<String> highYieldExamPointers;
  final String languageCode;
  final TeachingStyle style;
  final int totalEstimatedDurationSeconds;

  const GeneratedScript({
    required this.title,
    required this.fullText,
    required this.sections,
    required this.highYieldExamPointers,
    required this.languageCode,
    required this.style,
    required this.totalEstimatedDurationSeconds,
  });

  GeneratedScript copyWith({
    String? title,
    String? fullText,
    List<ScriptSection>? sections,
    List<String>? highYieldExamPointers,
    String? languageCode,
    TeachingStyle? style,
    int? totalEstimatedDurationSeconds,
  }) {
    return GeneratedScript(
      title: title ?? this.title,
      fullText: fullText ?? this.fullText,
      sections: sections ?? this.sections,
      highYieldExamPointers:
          highYieldExamPointers ?? this.highYieldExamPointers,
      languageCode: languageCode ?? this.languageCode,
      style: style ?? this.style,
      totalEstimatedDurationSeconds:
          totalEstimatedDurationSeconds ?? this.totalEstimatedDurationSeconds,
    );
  }
}

class DoubtResponse {
  final String question;
  final String answerSummary;
  final String fullExplanation;
  final String regionalAudioOrVideoUrl;
  final List<String> relatedConcepts;

  const DoubtResponse({
    required this.question,
    required this.answerSummary,
    required this.fullExplanation,
    required this.regionalAudioOrVideoUrl,
    required this.relatedConcepts,
  });
}

abstract class TeacherBrainService {
  Future<GeneratedScript> generateScript({
    required ParsedContent content,
    required RegionalLanguage language,
    required TeachingStyle style,
    required TeacherAvatar avatar,
  });

  Future<GeneratedScript> refineScript({
    required GeneratedScript currentScript,
    required String prompt,
    required TeachingStyle targetStyle,
  });

  Future<QuizData> generateQuiz({
    required String lessonId,
    required String lessonTitle,
    required String scriptText,
    required String languageCode,
  });

  Future<DoubtResponse> solveDoubt({
    required String lessonId,
    required String doubtQuery,
    required TeacherAvatar avatar,
    required String languageCode,
    required TeachingStyle style,
  });
}
