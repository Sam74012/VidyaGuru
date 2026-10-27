import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/create_lesson/presentation/create_lesson_screen.dart';
import '../../features/teacher_library/presentation/teacher_library_screen.dart';
import '../../features/script_editor/presentation/script_editor_screen.dart';
import '../../features/generation_progress/presentation/generation_progress_screen.dart';
import '../../features/video_player/presentation/video_player_screen.dart';
import '../../features/doubt_solver/presentation/doubt_solver_screen.dart';
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/teacher_dashboard/presentation/teacher_dashboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/impact/presentation/impact_screen.dart';
import '../../features/trust/presentation/trust_safety_screen.dart';
import '../config/app_config.dart';
import '../providers/app_providers.dart';
import '../widgets/main_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final userRole = ref.watch(userRoleProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Stateful Shell with 5 bottom tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: Create Lesson Stepper
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/create-lesson',
                builder: (context, state) => const CreateLessonScreen(),
              ),
            ],
          ),
          // Tab 2: Teachers
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/teachers',
                builder: (context, state) => const TeacherLibraryScreen(),
              ),
            ],
          ),
          // Tab 3: Downloads & Library
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          // Tab 4: Teacher Dashboard or Settings (Role sensitive)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account-hub',
                builder: (context, state) {
                  return userRole == UserRole.teacher
                      ? const TeacherDashboardScreen()
                      : const SettingsScreen();
                },
              ),
            ],
          ),
        ],
      ),

      // Standalone Fullscreen Routes
      GoRoute(
        path: '/script-editor',
        builder: (context, state) => const ScriptEditorScreen(),
      ),
      GoRoute(
        path: '/generation-progress/:jobId',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId'] ?? '';
          return GenerationProgressScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: '/video/:lessonId',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId'] ?? '';
          return VideoPlayerScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/doubt-solver',
        builder: (context, state) => const DoubtSolverScreen(),
      ),
      GoRoute(
        path: '/quiz/:lessonId',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId'] ?? '';
          return QuizScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/teacher-dashboard',
        builder: (context, state) => const TeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/impact',
        builder: (context, state) => const ImpactScreen(),
      ),
      GoRoute(
        path: '/trust-safety',
        builder: (context, state) => const TrustSafetyScreen(),
      ),
    ],
  );
});
