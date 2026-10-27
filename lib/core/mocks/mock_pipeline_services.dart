import 'dart:async';
import 'package:uuid/uuid.dart';
import '../config/app_config.dart';
import '../models/job.dart';
import '../models/lesson.dart';
import '../models/teacher_avatar.dart';
import '../services/teacher_brain_service.dart';
import '../services/voice_clone_service.dart';
import '../services/face_swap_service.dart';
import '../services/lip_sync_service.dart';
import '../services/composite_service.dart';

class MockVoiceCloneService implements VoiceCloneService {
  @override
  Future<ClonedVoiceResult> cloneVoice({
    required String scriptText,
    required String voiceSampleUrl,
    required RegionalLanguage language,
    required TeachingStyle style,
    void Function(double progress)? onProgress,
  }) async {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      onProgress?.call(i / 5.0);
    }
    return ClonedVoiceResult(
      audioUrl: 'https://vidyaguru.gov.in/audio/cloned_${language.code}_sample.m4a',
      durationSeconds: 160,
      fidelityScore: 0.96,
      speakerSampleId: voiceSampleUrl,
      languageCode: language.code,
    );
  }
}

class MockFaceSwapService implements FaceSwapService {
  @override
  Future<FaceSwapResult> swapFace({
    required String photoUrl,
    required String baseBodyTemplateId,
    void Function(double progress)? onProgress,
  }) async {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      onProgress?.call(i / 5.0);
    }
    return FaceSwapResult(
      renderedVideoBaseUrl: 'https://vidyaguru.gov.in/video/base_$baseBodyTemplateId.mp4',
      avatarId: photoUrl,
      frameCount: 4800,
      facialMeshAccuracy: 0.985,
    );
  }
}

class MockLipSyncService implements LipSyncService {
  @override
  Future<LipSyncResult> syncLips({
    required String videoBaseUrl,
    required String audioUrl,
    void Function(double progress)? onProgress,
  }) async {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      onProgress?.call(i / 5.0);
    }
    return const LipSyncResult(
      lipSyncedVideoUrl: 'https://vidyaguru.gov.in/video/lipsync_60fps.mp4',
      totalFrames: 4800,
      visemeConfidence: 0.97,
    );
  }
}

class MockCompositeService implements CompositeService {
  @override
  Future<CompositeResult> composite({
    required String lipSyncedVideoUrl,
    required String audioTrackUrl,
    required List<SubtitleItem> subtitles,
    required String watermarkBadgeText,
    void Function(double progress)? onProgress,
  }) async {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      onProgress?.call(i / 5.0);
    }
    return CompositeResult(
      finalVideoUrl: 'https://vidyaguru.gov.in/video/final_explainer_hd.mp4',
      thumbnailUrl: 'https://vidyaguru.gov.in/thumb/newton_laws.jpg',
      durationSeconds: 160,
      fileSizeMb: 14.8,
      hasWatermark: true,
      embeddedSubtitles: subtitles,
    );
  }
}

/// Orchestrator for simulated end-to-end video generation pipeline with live Stream updates.
class PipelineOrchestrator {
  static final PipelineOrchestrator _instance = PipelineOrchestrator._internal();
  factory PipelineOrchestrator() => _instance;
  PipelineOrchestrator._internal();

  final Map<String, StreamController<GenerationJob>> _jobControllers = {};
  final Map<String, GenerationJob> _activeJobs = {};

  Stream<GenerationJob> getJobStream(String jobId) {
    if (!_jobControllers.containsKey(jobId)) {
      _jobControllers[jobId] = StreamController<GenerationJob>.broadcast();
    }
    return _jobControllers[jobId]!.stream;
  }

  GenerationJob? getJob(String jobId) => _activeJobs[jobId];

  Future<GenerationJob> startJob({
    required String title,
    required String subject,
    required String inputSourceName,
    String? inputSnippet,
    required TeacherAvatar avatar,
    required RegionalLanguage language,
    required TeachingStyle teachingStyle,
    required GeneratedScript script,
  }) async {
    final jobId = const Uuid().v4();
    final controller = StreamController<GenerationJob>.broadcast();
    _jobControllers[jobId] = controller;

    var currentJob = GenerationJob(
      id: jobId,
      title: title,
      subject: subject,
      inputSourceName: inputSourceName,
      inputSnippet: inputSnippet,
      avatar: avatar,
      language: language,
      teachingStyle: teachingStyle,
      currentStage: PipelineStage.parsing,
      stageProgress: 0.1,
      overallProgress: 0.05,
      stageMessage: 'Extracting key formulas, concept graphs and diagrams...',
      estimatedSecondsRemaining: 24,
      createdAt: DateTime.now(),
    );

    _activeJobs[jobId] = currentJob;
    controller.add(currentJob);

    // Asynchronously progress through the pipeline stages
    _executePipeline(jobId, script);

    return currentJob;
  }

  void _emit(String jobId, GenerationJob updated) {
    _activeJobs[jobId] = updated;
    if (_jobControllers.containsKey(jobId) && !_jobControllers[jobId]!.isClosed) {
      _jobControllers[jobId]!.add(updated);
    }
  }

  Future<void> _executePipeline(String jobId, GeneratedScript script) async {
    var job = _activeJobs[jobId]!;

    try {
      // 1. Parsing -> Thinking
      await Future.delayed(const Duration(milliseconds: 1400));
      job = job.copyWith(
        currentStage: PipelineStage.thinking,
        stageProgress: 0.5,
        overallProgress: 0.15,
        stageMessage: 'Teacher\'s Brain synthesizing pedagogical script in ${job.language.nativeName}...',
        estimatedSecondsRemaining: 20,
      );
      _emit(jobId, job);

      // 2. Stage 1: Voice Cloner
      await Future.delayed(const Duration(milliseconds: 1600));
      job = job.copyWith(
        currentStage: PipelineStage.voice,
        stageProgress: 0.3,
        overallProgress: 0.28,
        stageMessage: 'Stage 1: Voice Cloner synthesizing ${job.avatar.name}\'s vocal cadence and Indic accents...',
        estimatedSecondsRemaining: 16,
      );
      _emit(jobId, job);

      await Future.delayed(const Duration(milliseconds: 1500));
      job = job.copyWith(
        stageProgress: 0.9,
        overallProgress: 0.45,
        stageMessage: 'Acoustic waveform synthesized (48kHz, lossless audio track generated)',
        estimatedSecondsRemaining: 12,
      );
      _emit(jobId, job);

      // 3. Stage 2: Face Swapper
      await Future.delayed(const Duration(milliseconds: 1500));
      job = job.copyWith(
        currentStage: PipelineStage.face,
        stageProgress: 0.4,
        overallProgress: 0.55,
        stageMessage: 'Stage 2: Face Swapper mapping facial landmarks of ${job.avatar.name} onto body template...',
        estimatedSecondsRemaining: 9,
      );
      _emit(jobId, job);

      await Future.delayed(const Duration(milliseconds: 1500));
      job = job.copyWith(
        stageProgress: 0.85,
        overallProgress: 0.70,
        stageMessage: '3D Mesh anchored with micro-expressions and natural gaze tracking',
        estimatedSecondsRemaining: 6,
      );
      _emit(jobId, job);

      // 4. Stage 3: Cinematic Lip-Sync
      await Future.delayed(const Duration(milliseconds: 1500));
      job = job.copyWith(
        currentStage: PipelineStage.lipsync,
        stageProgress: 0.5,
        overallProgress: 0.82,
        stageMessage: 'Stage 3: Cinematic Lip-Sync aligning phonemes to Indic visemes at 60fps...',
        estimatedSecondsRemaining: 4,
      );
      _emit(jobId, job);

      // 5. Stage 4: Composite Engine
      await Future.delayed(const Duration(milliseconds: 1500));
      job = job.copyWith(
        currentStage: PipelineStage.compositing,
        stageProgress: 0.7,
        overallProgress: 0.92,
        stageMessage: 'Stage 4: Composite Engine rendering watermark, subtitles & multi-track audio...',
        estimatedSecondsRemaining: 2,
      );
      _emit(jobId, job);

      // Final: Done
      await Future.delayed(const Duration(milliseconds: 1500));

      final chapters = [
        LessonChapter(
          timestampSeconds: 0,
          title: job.language.code == 'bn'
              ? 'সূচনা ও জড়তার ধারণা'
              : (job.language.code == 'hi' ? 'प्रस्तावना और जड़त्व' : 'Introduction & Inertia'),
          summary: 'Fundamental overview of inertia and Newton\'s First Law.',
        ),
        LessonChapter(
          timestampSeconds: 45,
          title: job.language.code == 'bn'
              ? 'দ্বিতীয় সূত্র: বল ও ত্বরণ (F = ma)'
              : (job.language.code == 'hi' ? 'द्वितीय नियम: बल एवं त्वरण' : 'Second Law: Force & Impulse'),
          summary: 'Mathematical breakdown of momentum change and impulse forces.',
        ),
        LessonChapter(
          timestampSeconds: 100,
          title: job.language.code == 'bn'
              ? 'তৃতীয় সূত্র ও রৈখিক ভরবেগ সংরক্ষণ'
              : (job.language.code == 'hi' ? 'तृतीय नियम एवं संवेग संरक्षण' : 'Third Law & Recoil Momentum'),
          summary: 'Action-reaction pairs, gun recoil velocity, and rocket propulsion.',
        ),
      ];

      final subtitles = [
        SubtitleItem(
          startSeconds: 0,
          endSeconds: 6,
          text: job.language.sampleGreeting,
        ),
        SubtitleItem(
          startSeconds: 7,
          endSeconds: 15,
          text: script.sections.first.scriptText.substring(0, script.sections.first.scriptText.length > 80 ? 80 : script.sections.first.scriptText.length),
        ),
        SubtitleItem(
          startSeconds: 16,
          endSeconds: 28,
          text: 'F = dp/dt = m * a • High yield formula for competitive exams.',
        ),
        SubtitleItem(
          startSeconds: 29,
          endSeconds: 45,
          text: 'Remember: Action and reaction act on two different bodies simultaneously.',
        ),
      ];

      final completedLesson = Lesson(
        id: 'lesson_$jobId',
        title: job.title,
        subject: job.subject,
        grade: 'Class 11 / CBSE & State Board',
        teacherAvatar: job.avatar,
        languageCode: job.language.code,
        languageName: job.language.nativeName,
        teachingStyle: job.teachingStyle,
        durationSeconds: script.totalEstimatedDurationSeconds,
        videoUrl: 'https://vidyaguru.gov.in/video/final_explainer_${job.language.code}.mp4',
        thumbnailUrl: 'https://vidyaguru.gov.in/thumb/newton_demo.jpg',
        chapters: chapters,
        keyPoints: script.highYieldExamPointers,
        scriptText: script.fullText,
        subtitles: subtitles,
        createdAt: DateTime.now(),
        isDownloaded: false,
        sizeMb: 14.8,
        viewCount: 1,
        doubts: [],
      );

      job = job.copyWith(
        currentStage: PipelineStage.done,
        stageProgress: 1.0,
        overallProgress: 1.0,
        stageMessage: 'Explainer video generated successfully!',
        estimatedSecondsRemaining: 0,
        completedLesson: completedLesson,
      );
      _emit(jobId, job);
    } catch (e) {
      job = job.copyWith(
        currentStage: PipelineStage.failed,
        stageMessage: 'Failed to process pipeline: $e',
        error: e.toString(),
      );
      _emit(jobId, job);
    }
  }
}
