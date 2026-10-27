import 'teacher_avatar.dart';
import 'lesson.dart';
import '../config/app_config.dart';

enum PipelineStage {
  queued(
    id: 'queued',
    stepNumber: 0,
    title: 'Job Queued',
    subtitle: 'Preparing secure processing sandbox...',
  ),
  parsing(
    id: 'parsing',
    stepNumber: 1,
    title: 'Content Parser',
    subtitle: 'Extracting text, formulas, diagrams and audio concepts...',
  ),
  thinking(
    id: 'thinking',
    stepNumber: 2,
    title: 'Teacher\'s Brain (Pedagogy)',
    subtitle: 'Synthesizing key exam points and structuring regional script...',
  ),
  voice(
    id: 'voice',
    stepNumber: 3,
    title: 'Stage 1: Voice Cloner',
    subtitle: 'Synthesizing teacher cadence and regional Indic acoustic nuances...',
  ),
  face(
    id: 'face',
    stepNumber: 4,
    title: 'Stage 2: Face Swapper',
    subtitle: 'Mapping teacher facial landmarks onto base body template...',
  ),
  lipsync(
    id: 'lipsync',
    stepNumber: 5,
    title: 'Stage 3: Cinematic Lip-Sync',
    subtitle: 'Aligning phonemes to visemes at 60fps for ultra-natural speech...',
  ),
  compositing(
    id: 'compositing',
    stepNumber: 6,
    title: 'Stage 4: Composite Engine',
    subtitle: 'Merging multi-track audio, subtitles, diagrams & AI watermark...',
  ),
  done(
    id: 'done',
    stepNumber: 7,
    title: 'Explainer Ready',
    subtitle: 'Ready to stream and download for offline revision.',
  ),
  failed(
    id: 'failed',
    stepNumber: -1,
    title: 'Generation Error',
    subtitle: 'An issue occurred during pipeline rendering.',
  );

  final String id;
  final int stepNumber;
  final String title;
  final String subtitle;

  const PipelineStage({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });
}

class GenerationJob {
  final String id;
  final String title;
  final String subject;
  final String inputSourceName;
  final String? inputSnippet;
  final TeacherAvatar avatar;
  final RegionalLanguage language;
  final TeachingStyle teachingStyle;
  final PipelineStage currentStage;
  final double stageProgress; // 0.0 to 1.0 within current stage
  final double overallProgress; // 0.0 to 1.0 overall
  final String stageMessage;
  final int estimatedSecondsRemaining;
  final DateTime createdAt;
  final Lesson? completedLesson;
  final String? error;

  const GenerationJob({
    required this.id,
    required this.title,
    required this.subject,
    required this.inputSourceName,
    this.inputSnippet,
    required this.avatar,
    required this.language,
    required this.teachingStyle,
    required this.currentStage,
    required this.stageProgress,
    required this.overallProgress,
    required this.stageMessage,
    required this.estimatedSecondsRemaining,
    required this.createdAt,
    this.completedLesson,
    this.error,
  });

  bool get isCompleted => currentStage == PipelineStage.done;
  bool get isFailed => currentStage == PipelineStage.failed;
  bool get isInProgress => !isCompleted && !isFailed;

  GenerationJob copyWith({
    String? id,
    String? title,
    String? subject,
    String? inputSourceName,
    String? inputSnippet,
    TeacherAvatar? avatar,
    RegionalLanguage? language,
    TeachingStyle? teachingStyle,
    PipelineStage? currentStage,
    double? stageProgress,
    double? overallProgress,
    String? stageMessage,
    int? estimatedSecondsRemaining,
    DateTime? createdAt,
    Lesson? completedLesson,
    String? error,
  }) {
    return GenerationJob(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      inputSourceName: inputSourceName ?? this.inputSourceName,
      inputSnippet: inputSnippet ?? this.inputSnippet,
      avatar: avatar ?? this.avatar,
      language: language ?? this.language,
      teachingStyle: teachingStyle ?? this.teachingStyle,
      currentStage: currentStage ?? this.currentStage,
      stageProgress: stageProgress ?? this.stageProgress,
      overallProgress: overallProgress ?? this.overallProgress,
      stageMessage: stageMessage ?? this.stageMessage,
      estimatedSecondsRemaining:
          estimatedSecondsRemaining ?? this.estimatedSecondsRemaining,
      createdAt: createdAt ?? this.createdAt,
      completedLesson: completedLesson ?? this.completedLesson,
      error: error ?? this.error,
    );
  }
}
