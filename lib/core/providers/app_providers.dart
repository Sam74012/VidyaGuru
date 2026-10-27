import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../config/app_config.dart';
import '../models/job.dart';
import '../models/lesson.dart';
import '../models/teacher_avatar.dart';
import '../services/content_parser_service.dart';
import '../services/teacher_brain_service.dart';
import '../services/consent_service.dart';
import '../mocks/mock_content_parser_service.dart';
import '../mocks/mock_teacher_brain_service.dart';
import '../mocks/mock_pipeline_services.dart';
import '../mocks/mock_consent_service.dart';
import '../mocks/mock_repository.dart';

// Services
final repositoryProvider = Provider<MockRepository>((ref) => MockRepository());

final contentParserServiceProvider = Provider<ContentParserService>((ref) {
  return MockContentParserService();
});

final teacherBrainServiceProvider = Provider<TeacherBrainService>((ref) {
  return MockTeacherBrainService();
});

final pipelineOrchestratorProvider = Provider<PipelineOrchestrator>((ref) {
  return PipelineOrchestrator();
});

final consentServiceProvider = Provider<ConsentService>((ref) {
  return MockConsentService();
});

// App Settings & Preferences
class UserRoleNotifier extends StateNotifier<UserRole> {
  final MockRepository _repo;
  UserRoleNotifier(this._repo) : super(_repo.currentRole);

  void setRole(UserRole role) {
    _repo.currentRole = role;
    state = role;
  }
}

final userRoleProvider = StateNotifierProvider<UserRoleNotifier, UserRole>((ref) {
  return UserRoleNotifier(ref.watch(repositoryProvider));
});

class CurrentLanguageNotifier extends StateNotifier<RegionalLanguage> {
  final MockRepository _repo;
  CurrentLanguageNotifier(this._repo)
      : super(AppLanguages.getByCode(_repo.currentLanguageCode));

  void setLanguage(RegionalLanguage language) {
    _repo.currentLanguageCode = language.code;
    state = language;
  }
}

final currentLanguageProvider =
    StateNotifierProvider<CurrentLanguageNotifier, RegionalLanguage>((ref) {
  return CurrentLanguageNotifier(ref.watch(repositoryProvider));
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class LowDataModeNotifier extends StateNotifier<bool> {
  final MockRepository _repo;
  LowDataModeNotifier(this._repo) : super(_repo.lowDataMode);

  void toggle() {
    _repo.lowDataMode = !_repo.lowDataMode;
    state = _repo.lowDataMode;
  }
}

final lowDataModeProvider = StateNotifierProvider<LowDataModeNotifier, bool>((ref) {
  return LowDataModeNotifier(ref.watch(repositoryProvider));
});

// Dynamic Data Lists
class LessonsNotifier extends StateNotifier<List<Lesson>> {
  final MockRepository _repo;
  LessonsNotifier(this._repo) : super(_repo.allLessons);

  void refresh() {
    state = List.from(_repo.allLessons);
  }

  void addLesson(Lesson lesson) {
    _repo.addLesson(lesson);
    state = List.from(_repo.allLessons);
  }

  void toggleDownload(String lessonId) {
    _repo.toggleLessonDownload(lessonId);
    state = List.from(_repo.allLessons);
  }

  void addDoubt(String lessonId, DoubtItem doubt) {
    _repo.addDoubtToLesson(lessonId, doubt);
    state = List.from(_repo.allLessons);
  }
}

final lessonsProvider = StateNotifierProvider<LessonsNotifier, List<Lesson>>((ref) {
  return LessonsNotifier(ref.watch(repositoryProvider));
});

class AvatarsNotifier extends StateNotifier<List<TeacherAvatar>> {
  final MockRepository _repo;
  AvatarsNotifier(this._repo) : super(_repo.allAvatars);

  void addAvatar(TeacherAvatar avatar) {
    _repo.addAvatar(avatar);
    state = List.from(_repo.allAvatars);
  }

  void revokeAvatar(String avatarId) {
    _repo.revokeAvatar(avatarId);
    state = List.from(_repo.allAvatars);
  }
}

final avatarsProvider = StateNotifierProvider<AvatarsNotifier, List<TeacherAvatar>>((ref) {
  return AvatarsNotifier(ref.watch(repositoryProvider));
});

// Stream Provider for Live Generation Job
final jobStreamProvider = StreamProvider.autoDispose.family<GenerationJob, String>((ref, jobId) {
  final orchestrator = ref.watch(pipelineOrchestratorProvider);
  return orchestrator.getJobStream(jobId);
});
