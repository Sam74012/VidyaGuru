import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:ailookalike_app/core/config/app_config.dart';
import 'package:ailookalike_app/core/mocks/mock_content_parser_service.dart';
import 'package:ailookalike_app/core/mocks/mock_teacher_brain_service.dart';
import 'package:ailookalike_app/core/mocks/mock_pipeline_services.dart';
import 'package:ailookalike_app/core/mocks/mock_consent_service.dart';
import 'package:ailookalike_app/core/mocks/mock_repository.dart';
import 'package:ailookalike_app/core/models/consent.dart';
import 'package:ailookalike_app/core/models/job.dart';
import 'package:ailookalike_app/core/services/content_parser_service.dart';

void main() {
  group('VidyaGuru Architecture & Service Tests', () {
    late MockContentParserService parser;
    late MockTeacherBrainService brain;
    late MockConsentService consentService;
    late PipelineOrchestrator orchestrator;
    late MockRepository repo;

    setUp(() {
      parser = MockContentParserService();
      brain = MockTeacherBrainService();
      consentService = MockConsentService();
      orchestrator = PipelineOrchestrator();
      repo = MockRepository();
    });

    test('1. Content Parser extracts text and physics formulas', () async {
      final parsed = await parser.parseInput(
        type: InputContentType.pdf,
        languageHint: 'bn',
      );

      expect(parsed.title, contains('Newton'));
      expect(parsed.subject, 'Physics');
      expect(parsed.detectedFormulasOrConcepts.isNotEmpty, true);
      expect(parsed.extractedKeyTerms.isNotEmpty, true);
    });

    test('2. Teacher Brain synthesizes script in Bengali with warm style', () async {
      final parsed = await parser.parseInput(type: InputContentType.pdf);
      final avatar = repo.presetAvatars.first; // Dr. Ananya Roy
      final bengali = AppLanguages.getByCode('bn');

      final script = await brain.generateScript(
        content: parsed,
        language: bengali,
        style: TeachingStyle.warmTeacher,
        avatar: avatar,
      );

      expect(script.languageCode, 'bn');
      expect(script.sections.length, 3);
      expect(script.highYieldExamPointers.isNotEmpty, true);
      expect(script.fullText, contains(avatar.name));
    });

    test('3. Consent Service strictly blocks avatar creation without audio verification', () async {
      final invalidConsent = ConsentRecord(
        id: 'c_test_invalid',
        avatarId: 'avatar_test',
        avatarName: 'Test Teacher',
        legalFullName: 'Legal Name',
        teacherEmailOrPhone: 'teacher@test.in',
        organizationName: 'School',
        timestamp: DateTime(2026, 1, 1),
        readAloudPhrase: 'phrase',
        audioVerificationPath: '',
        isAudioVerified: false, // NOT verified!
        termsAccepted: true,
        privacyAccepted: true,
        educationalUseOnlyAccepted: true,
      );

      final accepted = await consentService.verifyAndRecordConsent(invalidConsent);
      expect(accepted, false); // Must be rejected!
    });

    test('4. End-to-End Pipeline progresses through all 4 architecture stages to done', () async {
      final parsed = await parser.parseInput(type: InputContentType.pdf);
      final avatar = repo.presetAvatars.first;
      final bengali = AppLanguages.getByCode('bn');

      final script = await brain.generateScript(
        content: parsed,
        language: bengali,
        style: TeachingStyle.warmTeacher,
        avatar: avatar,
      );

      final job = await orchestrator.startJob(
        title: parsed.title,
        subject: parsed.subject,
        inputSourceName: 'sample.pdf',
        avatar: avatar,
        language: bengali,
        teachingStyle: TeachingStyle.warmTeacher,
        script: script,
      );

      expect(job.currentStage, PipelineStage.parsing);

      // Listen to stream and collect stages
      final stages = <PipelineStage>[];
      final completer = Completer<GenerationJob>();

      final sub = orchestrator.getJobStream(job.id).listen((updatedJob) {
        if (!stages.contains(updatedJob.currentStage)) {
          stages.add(updatedJob.currentStage);
        }
        if (updatedJob.isCompleted) {
          if (!completer.isCompleted) completer.complete(updatedJob);
        }
      });

      final finalJob = await completer.future.timeout(const Duration(seconds: 25));
      await sub.cancel();

      expect(finalJob.isCompleted, true);
      expect(finalJob.completedLesson != null, true);
      expect(finalJob.completedLesson!.subtitles.isNotEmpty, true);
      expect(finalJob.completedLesson!.chapters.isNotEmpty, true);

      // Check all 4 pipeline stages were hit
      expect(stages.contains(PipelineStage.voice), true);
      expect(stages.contains(PipelineStage.face), true);
      expect(stages.contains(PipelineStage.lipsync), true);
      expect(stages.contains(PipelineStage.compositing), true);
      expect(stages.contains(PipelineStage.done), true);
    });
  });
}
