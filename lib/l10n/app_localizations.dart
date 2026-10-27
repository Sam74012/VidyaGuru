import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'VidyaGuru'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Personal AI Regional Explainer for Bharat'**
  String get appTagline;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Turn Any Study Material Into A Teacher Video'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Upload PDFs, notes, or textbook photos. Get 3-minute personalized video explainers in seconds.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Learn in Your Mother Tongue'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Hear lessons clearly in Bengali, Hindi, Tamil, Telugu, and 6 more Indian languages with authentic accents.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Learn From Your Favourite Educator'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Realistic AI teacher avatars with dynamic facial expressions, cloned voices, and adaptable teaching styles.'**
  String get onboardingDesc3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Preferred Language'**
  String get selectLanguage;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get selectRole;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'I am a Student'**
  String get roleStudent;

  /// No description provided for @roleTeacher.
  ///
  /// In en, this message translates to:
  /// **'I am a Teacher / Educator'**
  String get roleTeacher;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaste, Student!'**
  String get homeGreeting;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to master today?'**
  String get homeSubtitle;

  /// No description provided for @createNewLesson.
  ///
  /// In en, this message translates to:
  /// **'Create New Lesson'**
  String get createNewLesson;

  /// No description provided for @quickDoubt.
  ///
  /// In en, this message translates to:
  /// **'Ask a Quick Doubt'**
  String get quickDoubt;

  /// No description provided for @recentLessons.
  ///
  /// In en, this message translates to:
  /// **'Recent Lessons'**
  String get recentLessons;

  /// No description provided for @continueWatching.
  ///
  /// In en, this message translates to:
  /// **'Continue Watching'**
  String get continueWatching;

  /// No description provided for @exploreSubjects.
  ///
  /// In en, this message translates to:
  /// **'Explore Subjects'**
  String get exploreSubjects;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physics;

  /// No description provided for @chemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get chemistry;

  /// No description provided for @mathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get mathematics;

  /// No description provided for @biology.
  ///
  /// In en, this message translates to:
  /// **'Biology'**
  String get biology;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @stepInput.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get stepInput;

  /// No description provided for @stepTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get stepTeacher;

  /// No description provided for @stepStyle.
  ///
  /// In en, this message translates to:
  /// **'Language & Style'**
  String get stepStyle;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// No description provided for @uploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF / Notes'**
  String get uploadPdf;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Snap Textbook Page'**
  String get uploadPhoto;

  /// No description provided for @recordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record Voice Query'**
  String get recordVoice;

  /// No description provided for @recordVideo.
  ///
  /// In en, this message translates to:
  /// **'Upload Video Clip'**
  String get recordVideo;

  /// No description provided for @selectTeacherAvatar.
  ///
  /// In en, this message translates to:
  /// **'Select Teacher Avatar'**
  String get selectTeacherAvatar;

  /// No description provided for @createCustomTeacher.
  ///
  /// In en, this message translates to:
  /// **'Create Custom Avatar'**
  String get createCustomTeacher;

  /// No description provided for @teachingStyle.
  ///
  /// In en, this message translates to:
  /// **'Teaching Style'**
  String get teachingStyle;

  /// No description provided for @generateVideo.
  ///
  /// In en, this message translates to:
  /// **'Generate Explainer Video'**
  String get generateVideo;

  /// No description provided for @generatingPipeline.
  ///
  /// In en, this message translates to:
  /// **'Generating Your AI Explainer Video'**
  String get generatingPipeline;

  /// No description provided for @pipelineStage1.
  ///
  /// In en, this message translates to:
  /// **'1. Voice Cloner'**
  String get pipelineStage1;

  /// No description provided for @pipelineStage2.
  ///
  /// In en, this message translates to:
  /// **'2. Face Swapper'**
  String get pipelineStage2;

  /// No description provided for @pipelineStage3.
  ///
  /// In en, this message translates to:
  /// **'3. Cinematic Video Lip-Sync'**
  String get pipelineStage3;

  /// No description provided for @pipelineStage4.
  ///
  /// In en, this message translates to:
  /// **'4. Composite Engine'**
  String get pipelineStage4;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time remaining'**
  String get estimatedTime;

  /// No description provided for @notifyInBackground.
  ///
  /// In en, this message translates to:
  /// **'Run in background & notify me'**
  String get notifyInBackground;

  /// No description provided for @keyPoints.
  ///
  /// In en, this message translates to:
  /// **'Key Exam Points'**
  String get keyPoints;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// No description provided for @askDoubt.
  ///
  /// In en, this message translates to:
  /// **'Ask a Doubt'**
  String get askDoubt;

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Quick Quiz'**
  String get takeQuiz;

  /// No description provided for @downloadOffline.
  ///
  /// In en, this message translates to:
  /// **'Download Offline'**
  String get downloadOffline;

  /// No description provided for @shareLesson.
  ///
  /// In en, this message translates to:
  /// **'Share Lesson'**
  String get shareLesson;

  /// No description provided for @reportMisuse.
  ///
  /// In en, this message translates to:
  /// **'Report Misuse'**
  String get reportMisuse;

  /// No description provided for @aiGeneratedBadge.
  ///
  /// In en, this message translates to:
  /// **'AI-GENERATED TUTOR VIDEO'**
  String get aiGeneratedBadge;

  /// No description provided for @watermarkText.
  ///
  /// In en, this message translates to:
  /// **'VidyaGuru • AI-Assisted Learning'**
  String get watermarkText;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library & Downloads'**
  String get myLibrary;

  /// No description provided for @teacherDashboard.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacherDashboard;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @impactTitle.
  ///
  /// In en, this message translates to:
  /// **'Why VidyaGuru Matters for Bharat'**
  String get impactTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
