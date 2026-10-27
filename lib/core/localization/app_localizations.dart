import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'VidyaGuru',
      'appTagline': 'Personal AI Regional Explainer for Bharat',
      'onboardingTitle1': 'Turn Any Study Material Into A Teacher Video',
      'onboardingDesc1': 'Upload PDFs, notes, or textbook photos. Get 3-minute personalized video explainers in seconds.',
      'onboardingTitle2': 'Learn in Your Mother Tongue',
      'onboardingDesc2': 'Hear lessons clearly in Bengali, Hindi, Tamil, Telugu, and 6 more Indian languages with authentic accents.',
      'onboardingTitle3': 'Learn From Your Favourite Educator',
      'onboardingDesc3': 'Realistic AI teacher avatars with dynamic facial expressions, cloned voices, and adaptable teaching styles.',
      'getStarted': 'Get Started',
      'selectLanguage': 'Select Preferred Language',
      'selectRole': 'Choose Your Role',
      'roleStudent': 'I am a Student',
      'roleTeacher': 'I am a Teacher / Educator',
      'continueText': 'Continue',
      'homeGreeting': 'Namaste, Student!',
      'homeSubtitle': 'What would you like to master today?',
      'createNewLesson': 'Create New Lesson',
      'quickDoubt': 'Ask a Quick Doubt',
      'recentLessons': 'Recent Lessons',
      'continueWatching': 'Continue Watching',
      'exploreSubjects': 'Explore Subjects',
      'all': 'All',
      'physics': 'Physics',
      'chemistry': 'Chemistry',
      'mathematics': 'Mathematics',
      'biology': 'Biology',
      'history': 'History',
      'stepInput': 'Input',
      'stepTeacher': 'Teacher',
      'stepStyle': 'Language & Style',
      'stepReview': 'Review',
      'uploadPdf': 'Upload PDF / Notes',
      'uploadPhoto': 'Snap Textbook Page',
      'recordVoice': 'Record Voice Query',
      'recordVideo': 'Upload Video Clip',
      'selectTeacherAvatar': 'Select Teacher Avatar',
      'createCustomTeacher': 'Create Custom Avatar',
      'teachingStyle': 'Teaching Style',
      'generateVideo': 'Generate Explainer Video',
      'generatingPipeline': 'Generating Your AI Explainer Video',
      'pipelineStage1': '1. Voice Cloner',
      'pipelineStage2': '2. Face Swapper',
      'pipelineStage3': '3. Cinematic Video Lip-Sync',
      'pipelineStage4': '4. Composite Engine',
      'estimatedTime': 'Estimated time remaining',
      'notifyInBackground': 'Run in background & notify me',
      'keyPoints': 'Key Exam Points',
      'chapters': 'Chapters',
      'transcript': 'Transcript',
      'askDoubt': 'Ask a Doubt',
      'takeQuiz': 'Take Quick Quiz',
      'downloadOffline': 'Download Offline',
      'shareLesson': 'Share Lesson',
      'reportMisuse': 'Report Misuse',
      'aiGeneratedBadge': 'AI-GENERATED TUTOR VIDEO',
      'watermarkText': 'VidyaGuru • AI-Assisted Learning',
      'myLibrary': 'My Library & Downloads',
      'teacherDashboard': 'Teacher Dashboard',
      'settings': 'Settings',
      'impactTitle': 'Why VidyaGuru Matters for Bharat',
    },
    'hi': {
      'appName': 'विद्यागुरु',
      'appTagline': 'भारत के लिए व्यक्तिगत एआई क्षेत्रीय व्याख्याकार',
      'onboardingTitle1': 'किसी भी अध्ययन सामग्री को शिक्षक वीडियो में बदलें',
      'onboardingDesc1': 'पीडीएफ, नोट्स या पाठ्यपुस्तक की फोटो अपलोड करें। सेकंडों में 3 मिनट का व्यक्तिगत वीडियो प्राप्त करें।',
      'onboardingTitle2': 'अपनी मातृभाषा में सीखें',
      'onboardingDesc2': 'हिंदी, बंगाली, तमिल और 10 भारतीय भाषाओं में प्रामाणिक लहजे के साथ पाठ सुनें।',
      'onboardingTitle3': 'अपने पसंदीदा शिक्षक से सीखें',
      'onboardingDesc3': 'चेहरे के भावों, क्लोन की गई आवाज़ और अनुकूल शिक्षण शैलियों वाले यथार्थवादी एआई शिक्षक अवतार।',
      'getStarted': 'शुरू करें',
      'selectLanguage': 'पसंदीदा भाषा चुनें',
      'selectRole': 'अपनी भूमिका चुनें',
      'roleStudent': 'मैं एक छात्र हूँ',
      'roleTeacher': 'मैं एक शिक्षक / शिक्षक हूँ',
      'continueText': 'आगे बढ़ें',
      'homeGreeting': 'नमस्ते, शिक्षार्थी!',
      'homeSubtitle': 'आज आप क्या समझना चाहेंगे?',
      'createNewLesson': 'नया पाठ बनाएं',
      'quickDoubt': 'तुरंत सवाल पूछें',
      'recentLessons': 'हाल के पाठ',
      'continueWatching': 'देखना जारी रखें',
      'exploreSubjects': 'विषय चुनें',
      'all': 'सभी',
      'physics': 'भौतिक विज्ञान',
      'chemistry': 'रसायन विज्ञान',
      'mathematics': 'गणित',
      'biology': 'जीव विज्ञान',
      'history': 'इतिहास',
      'stepInput': 'सामग्री इनपुट',
      'stepTeacher': 'शिक्षक चुनें',
      'stepStyle': 'भाषा और शैली',
      'stepReview': 'समीक्षा',
      'uploadPdf': 'पीडीएफ / नोट्स अपलोड करें',
      'uploadPhoto': 'किताब के पन्ने की फोटो लें',
      'recordVoice': 'आवाज़ रिकॉर्ड करें',
      'recordVideo': 'वीडियो क्लिप जोड़ें',
      'selectTeacherAvatar': 'शिक्षक अवतार चुनें',
      'createCustomTeacher': 'अपना शिक्षक बनाएं',
      'teachingStyle': 'पढ़ाने की शैली',
      'generateVideo': 'वीडियो बनाएं',
      'generatingPipeline': 'आपका एआई व्याख्या वीडियो तैयार हो रहा है',
      'pipelineStage1': '१. वॉइस क्लोनर (आवाज़ संश्लेषण)',
      'pipelineStage2': '२. फेस स्वैपर (चेहरा अनुकूलन)',
      'pipelineStage3': '३. लिप-सिंक इंजन (सिनेमैटिक)',
      'pipelineStage4': '४. कम्पोजिट इंजन (अंतिम संयोजन)',
      'estimatedTime': 'अनुमानित समय शेष',
      'notifyInBackground': 'बैकग्राउंड में चलाएं और सूचित करें',
      'keyPoints': 'मुख्य परीक्षा बिंदु',
      'chapters': 'अध्याय',
      'transcript': 'प्रतिलेख',
      'askDoubt': 'संदेह पूछें',
      'takeQuiz': 'प्रश्नोत्तरी दें',
      'downloadOffline': 'ऑफ़लाइन डाउनलोड करें',
      'shareLesson': 'पाठ साझा करें',
      'reportMisuse': 'दुरुपयोग की रिपोर्ट करें',
      'aiGeneratedBadge': 'एआई-जनित शिक्षक वीडियो',
      'watermarkText': 'विद्यागुरु • एआई शिक्षा मिशन',
      'myLibrary': 'मेरी लाइब्रेरी और डाउनलोड',
      'teacherDashboard': 'शिक्षक डैशबोर्ड',
      'settings': 'सेटिंग्स',
      'impactTitle': 'भारत के लिए विद्यागुरु क्यों महत्वपूर्ण है',
    },
    'bn': {
      'appName': 'বিদ্যাগুরু',
      'appTagline': 'ভারতের জন্য ব্যক্তিগত এআই আঞ্চলিক পাঠদান সহযোগী',
      'onboardingTitle1': 'যেকোনো পড়ার নোটকে নিমেষেই শিক্ষক ভিডিওতে রূপান্তর করুন',
      'onboardingDesc1': 'পিডিএফ, নোট বা বইয়ের পাতার ছবি আপলোড করুন। কয়েক সেকেন্ডেই পান শিক্ষকের ব্যক্তিগত ভিডিও ব্যাখ্যা।',
      'onboardingTitle2': 'নিজের মাতৃভাষায় সহজে বুঝুন',
      'onboardingDesc2': 'বাংলা, হিন্দি, তামিল সহ ১০টি ভারতীয় ভাষায় স্পষ্ট উচ্চারণে জটিল বিষয় শিখুন।',
      'onboardingTitle3': 'পছন্দের শিক্ষকের মুখ ও কণ্ঠে শিখুন',
      'onboardingDesc3': 'জীবন্ত মুখের ভাবভঙ্গি, স্বাভাবিক কণ্ঠস্বর এবং নিজস্ব বোঝানোর শৈলীর নিখুঁত এআই অবতার।',
      'getStarted': 'শুরু করুন',
      'selectLanguage': 'পছন্দের ভাষা বেছে নিন',
      'selectRole': 'আপনার ভূমিকা নির্বাচন করুন',
      'roleStudent': 'আমি একজন শিক্ষার্থী',
      'roleTeacher': 'আমি একজন শিক্ষক / শিক্ষিকা',
      'continueText': 'এগিয়ে যান',
      'homeGreeting': 'নমস্কার, শিক্ষার্থী!',
      'homeSubtitle': 'আজ তুমি কোন বিষয়টি সহজ করে বুঝতে চাও?',
      'createNewLesson': 'নতুন পাঠ তৈরি করুন',
      'quickDoubt': 'সরাসরি প্রশ্ন করুন',
      'recentLessons': 'সাম্প্রতিক পাঠসমূহ',
      'continueWatching': 'দেখা চালিয়ে যান',
      'exploreSubjects': 'বিষয়সমূহ',
      'all': 'সব',
      'physics': 'পদার্থবিজ্ঞান',
      'chemistry': 'রসায়ন',
      'mathematics': 'গণিত',
      'biology': 'জীববিজ্ঞান',
      'history': 'ইতিহাস',
      'stepInput': 'পড়ার উপাদান',
      'stepTeacher': 'শিক্ষক নির্বাচন',
      'stepStyle': 'ভাষা ও শৈলী',
      'stepReview': 'পর্যালোচনা',
      'uploadPdf': 'পিডিএফ / নোটস আপলোড',
      'uploadPhoto': 'বইয়ের পাতার ছবি তুলুন',
      'recordVoice': 'ভয়েস নোট রেকর্ড করুন',
      'recordVideo': 'ভিডিও ক্লিপ দিন',
      'selectTeacherAvatar': 'শিক্ষক অবতার বেছে নিন',
      'createCustomTeacher': 'কাস্টম শিক্ষক অবতার তৈরি',
      'teachingStyle': 'পড়ানোর ধরণ (স্টাইল)',
      'generateVideo': 'ভিডিও তৈরি করুন',
      'generatingPipeline': 'আপনার এআই ব্যাখ্যামূলক ভিডিও তৈরি হচ্ছে',
      'pipelineStage1': '১. ভয়েস ক্লোনার (কণ্ঠ প্রতিস্থাপন)',
      'pipelineStage2': '২. ফেস সোয়াপার (মুখাবয়ব ম্যাপিং)',
      'pipelineStage3': '৩. লিপ-সিঙ্ক ইঞ্জিন (ঠোঁট মেলানো)',
      'pipelineStage4': '৪. কম্পোজিট ইঞ্জিন (চূড়ান্ত সংযোজন)',
      'estimatedTime': 'আনুমানিক বাকি সময়',
      'notifyInBackground': 'ব্যাকগ্রাউন্ডে চালান ও সমাপ্ত হলে জানান',
      'keyPoints': 'পরীক্ষার জন্য প্রধান বিষয়সমূহ',
      'chapters': 'অধ্যায় ও সময়চিহ্ন',
      'transcript': 'লিপ্যন্তর (স্ক্রিপ্ট)',
      'askDoubt': 'প্রশ্ন জিজ্ঞাসা করুন',
      'takeQuiz': 'কুইজে অংশ নিন',
      'downloadOffline': 'অফলাইনে সেভ করুন',
      'shareLesson': 'পাঠ শেয়ার করুন',
      'reportMisuse': 'অনুপযুক্ত বিষয়ের অভিযোগ',
      'aiGeneratedBadge': 'এআই দ্বারা প্রস্তুতকৃত শিক্ষক ভিডিও',
      'watermarkText': 'বিদ্যাগুরু • ভারতের ডিজিটাল শিক্ষা উদ্যোগ',
      'myLibrary': 'আমার লাইব্রেরি ও ডাউনলোড',
      'teacherDashboard': 'শিক্ষক ড্যাশবোর্ড',
      'settings': 'সেটিংস',
      'impactTitle': 'ভারতের জন্য বিদ্যাগুরু কেন অত্যন্ত প্রয়োজনীয়',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appName => translate('appName');
  String get appTagline => translate('appTagline');
  String get onboardingTitle1 => translate('onboardingTitle1');
  String get onboardingDesc1 => translate('onboardingDesc1');
  String get onboardingTitle2 => translate('onboardingTitle2');
  String get onboardingDesc2 => translate('onboardingDesc2');
  String get onboardingTitle3 => translate('onboardingTitle3');
  String get onboardingDesc3 => translate('onboardingDesc3');
  String get getStarted => translate('getStarted');
  String get selectLanguage => translate('selectLanguage');
  String get selectRole => translate('selectRole');
  String get roleStudent => translate('roleStudent');
  String get roleTeacher => translate('roleTeacher');
  String get continueText => translate('continueText');
  String get homeGreeting => translate('homeGreeting');
  String get homeSubtitle => translate('homeSubtitle');
  String get createNewLesson => translate('createNewLesson');
  String get quickDoubt => translate('quickDoubt');
  String get recentLessons => translate('recentLessons');
  String get continueWatching => translate('continueWatching');
  String get exploreSubjects => translate('exploreSubjects');
  String get all => translate('all');
  String get physics => translate('physics');
  String get chemistry => translate('chemistry');
  String get mathematics => translate('mathematics');
  String get biology => translate('biology');
  String get history => translate('history');
  String get stepInput => translate('stepInput');
  String get stepTeacher => translate('stepTeacher');
  String get stepStyle => translate('stepStyle');
  String get stepReview => translate('stepReview');
  String get uploadPdf => translate('uploadPdf');
  String get uploadPhoto => translate('uploadPhoto');
  String get recordVoice => translate('recordVoice');
  String get recordVideo => translate('recordVideo');
  String get selectTeacherAvatar => translate('selectTeacherAvatar');
  String get createCustomTeacher => translate('createCustomTeacher');
  String get teachingStyle => translate('teachingStyle');
  String get generateVideo => translate('generateVideo');
  String get generatingPipeline => translate('generatingPipeline');
  String get pipelineStage1 => translate('pipelineStage1');
  String get pipelineStage2 => translate('pipelineStage2');
  String get pipelineStage3 => translate('pipelineStage3');
  String get pipelineStage4 => translate('pipelineStage4');
  String get estimatedTime => translate('estimatedTime');
  String get notifyInBackground => translate('notifyInBackground');
  String get keyPoints => translate('keyPoints');
  String get chapters => translate('chapters');
  String get transcript => translate('transcript');
  String get askDoubt => translate('askDoubt');
  String get takeQuiz => translate('takeQuiz');
  String get downloadOffline => translate('downloadOffline');
  String get shareLesson => translate('shareLesson');
  String get reportMisuse => translate('reportMisuse');
  String get aiGeneratedBadge => translate('aiGeneratedBadge');
  String get watermarkText => translate('watermarkText');
  String get myLibrary => translate('myLibrary');
  String get teacherDashboard => translate('teacherDashboard');
  String get settings => translate('settings');
  String get impactTitle => translate('impactTitle');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'bn', 'ta', 'te', 'mr', 'gu', 'kn', 'ml', 'pa']
          .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
