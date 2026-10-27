import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ailookalike_app/main.dart';
import 'package:ailookalike_app/core/config/app_config.dart';
import 'package:ailookalike_app/features/create_lesson/presentation/create_lesson_screen.dart';
import 'package:ailookalike_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:ailookalike_app/features/teacher_library/presentation/teacher_library_screen.dart';
import 'package:ailookalike_app/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('VidyaGuruApp smoke test and navigation verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VidyaGuruApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify App Name renders on Home screen
    expect(find.text(AppConfig.appName), findsWidgets);
    // Verify Create New Lesson action card is present in English
    expect(find.text('Create New Lesson'), findsOneWidget);
  });

  testWidgets('Create Lesson flow widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CreateLessonScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Stepper steps are present
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Teacher'), findsOneWidget);
    expect(find.text('Language & Tone'), findsOneWidget);

    // Verify input options exist
    expect(find.text('Upload PDF / Doc'), findsOneWidget);
    expect(find.text('Snap Page'), findsOneWidget);
    expect(find.text('Record Voice Note'), findsOneWidget);

    // Verify AI Parser button
    expect(find.text('Extract Concepts with AI Parser'), findsOneWidget);
  });

  testWidgets('Onboarding Screen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Onboarding header & CTA
    expect(find.text(AppConfig.appName), findsWidgets);
    expect(find.text('Mission Impact'), findsOneWidget);
    expect(find.text('Choose Your Role'), findsWidgets);
  });

  testWidgets('Teacher Library Screen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TeacherLibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify tabs and preset teachers
    expect(find.text('Teacher Avatars Library'), findsOneWidget);
    expect(find.text('Dr. Ananya Roy'), findsOneWidget);
    expect(find.text('Create Teacher Avatar'), findsOneWidget);
  });

  testWidgets('Settings Screen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify settings sections
    expect(find.text('Role & Profile'), findsOneWidget);
    expect(find.text('Language & Localization'), findsOneWidget);
    expect(find.text('Data Saver & Bandwidth'), findsOneWidget);
  });
}
