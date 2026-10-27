import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/teacher_avatar.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';

class MockRepository {
  static final MockRepository _instance = MockRepository._internal();
  factory MockRepository() => _instance;
  MockRepository._internal() {
    _initData();
  }

  UserRole currentRole = UserRole.student;
  String currentLanguageCode = 'en'; // Default to English
  bool lowDataMode = false;
  String activeClassCode = 'BENGAL-STEM-2026';

  final List<TeacherAvatar> _avatars = [];
  final List<Lesson> _lessons = [];
  final Map<String, QuizResult> _quizResults = {};

  List<TeacherAvatar> get presetAvatars =>
      _avatars.where((a) => a.isPreset).toList();

  List<TeacherAvatar> get customAvatars =>
      _avatars.where((a) => a.isCustom).toList();

  List<TeacherAvatar> get allAvatars => List.unmodifiable(_avatars);

  List<Lesson> get allLessons => List.unmodifiable(_lessons);

  List<Lesson> get downloadedLessons =>
      _lessons.where((l) => l.isDownloaded).toList();

  TeacherAvatar? getAvatarById(String id) {
    try {
      return _avatars.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Lesson? getLessonById(String id) {
    try {
      return _lessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  void addAvatar(TeacherAvatar avatar) {
    _avatars.insert(0, avatar);
  }

  void revokeAvatar(String avatarId) {
    final index = _avatars.indexWhere((a) => a.id == avatarId);
    if (index != -1) {
      _avatars[index] = _avatars[index].copyWith(consentVerified: false);
    }
  }

  void addLesson(Lesson lesson) {
    _lessons.insert(0, lesson);
  }

  void toggleLessonDownload(String lessonId) {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index != -1) {
      _lessons[index] = _lessons[index].copyWith(
        isDownloaded: !_lessons[index].isDownloaded,
      );
    }
  }

  void saveQuizResult(String lessonId, QuizResult result) {
    _quizResults[lessonId] = result;
  }

  QuizResult? getQuizResult(String lessonId) => _quizResults[lessonId];

  void addDoubtToLesson(String lessonId, DoubtItem doubt) {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index != -1) {
      final updatedDoubts = List<DoubtItem>.from(_lessons[index].doubts)..add(doubt);
      _lessons[index] = _lessons[index].copyWith(doubts: updatedDoubts);
    }
  }

  void _initData() {
    _avatars.addAll([
      const TeacherAvatar(
        id: 'avatar_ananya',
        name: 'Dr. Ananya Roy',
        title: 'Senior Physics Faculty • State Board & JEE',
        specialty: 'Physics',
        photoUrl: 'assets/teachers/ananya.png',
        voiceSampleUrl: 'assets/voices/ananya_voice.wav',
        isPreset: true,
        isCustom: false,
        consentVerified: true,
        supportedLanguages: ['bn', 'en', 'hi'],
        rating: 4.96,
        lessonsCount: 340,
        themeColor: Color(0xFF1E3A8A),
        bio: 'Over 14 years teaching Physics to students across West Bengal and Tripura. Specializes in making complex vector mechanics simple and intuitive.',
      ),
      const TeacherAvatar(
        id: 'avatar_vikram',
        name: 'Prof. Rajesh Sharma',
        title: 'HOD Science & Kota JEE Coach',
        specialty: 'Physics & Math',
        photoUrl: 'assets/teachers/rajesh.png',
        voiceSampleUrl: 'assets/voices/rajesh_voice.wav',
        isPreset: true,
        isCustom: false,
        consentVerified: true,
        supportedLanguages: ['hi', 'en'],
        rating: 4.92,
        lessonsCount: 420,
        themeColor: Color(0xFFB45309),
        bio: 'Kota coaching veteran known for strict conceptual drill and rapid question-cracking shortcuts for board exams.',
      ),
      const TeacherAvatar(
        id: 'avatar_kavitha',
        name: 'Kavitha Swaminathan',
        title: 'NEET Botany & Zoology Specialist',
        specialty: 'Biology',
        photoUrl: 'assets/teachers/kavitha.png',
        voiceSampleUrl: 'assets/voices/kavitha_voice.wav',
        isPreset: true,
        isCustom: false,
        consentVerified: true,
        supportedLanguages: ['ta', 'en'],
        rating: 4.95,
        lessonsCount: 215,
        themeColor: Color(0xFF047857),
        bio: 'Passionate about botanical microscopy and genetics. Teaches in Tamil and English with high-yield memory mnemonics.',
      ),
      const TeacherAvatar(
        id: 'avatar_arjun',
        name: 'Arjun Bhaiya',
        title: 'Youth Science Mentor & Educator',
        specialty: 'General Science',
        photoUrl: 'assets/teachers/arjun.png',
        voiceSampleUrl: 'assets/voices/arjun_voice.wav',
        isPreset: true,
        isCustom: false,
        consentVerified: true,
        supportedLanguages: ['hi', 'en', 'bn'],
        rating: 4.88,
        lessonsCount: 180,
        themeColor: Color(0xFF2563EB),
        bio: 'IIT Kharagpur alumnus who believes education should feel like talking to an elder brother over chai.',
      ),
      const TeacherAvatar(
        id: 'avatar_meera',
        name: 'Dr. Meera Patel',
        title: 'Organic Chemistry Research Fellow',
        specialty: 'Chemistry',
        photoUrl: 'assets/teachers/meera.png',
        voiceSampleUrl: 'assets/voices/meera_voice.wav',
        isPreset: true,
        isCustom: false,
        consentVerified: true,
        supportedLanguages: ['gu', 'hi', 'en'],
        rating: 4.91,
        lessonsCount: 165,
        themeColor: Color(0xFF7C3AED),
        bio: 'Transforms dry reaction mechanisms into engaging stories and real-world chemical discoveries.',
      ),
      const TeacherAvatar(
        id: 'avatar_harpreet',
        name: 'Harpreet Singh',
        title: 'Vedic Math & Algebra Lead',
        specialty: 'Mathematics',
        photoUrl: 'assets/teachers/harpreet.png',
        voiceSampleUrl: 'assets/voices/harpreet_voice.wav',
        isPreset: true,
        isCustom: false,
        consentVerified: true,
        supportedLanguages: ['pa', 'en', 'hi'],
        rating: 4.90,
        lessonsCount: 140,
        themeColor: Color(0xFFEA580C),
        bio: 'Makes geometry and algebra lightning-fast with ancient shortcuts and engaging visual graphs.',
      ),
    ]);

    // Initial preloaded lessons for immediate interactive exploration
    final ananya = _avatars.first;
    final rajesh = _avatars[1];

    _lessons.addAll([
      Lesson(
        id: 'lesson_newton_bn',
        title: 'নিউটনের গতির সূত্রাবলী ও ভরবেগ সংরক্ষণ',
        subject: 'Physics',
        grade: 'Class 11 / WBCHSE & CBSE',
        teacherAvatar: ananya,
        languageCode: 'bn',
        languageName: 'বাংলা',
        teachingStyle: TeachingStyle.warmTeacher,
        durationSeconds: 160,
        videoUrl: 'https://vidyaguru.gov.in/demo/newton_laws_bn.mp4',
        thumbnailUrl: 'https://vidyaguru.gov.in/thumbs/newton.jpg',
        chapters: const [
          LessonChapter(
            timestampSeconds: 0,
            title: '১. সূচনা ও জড়তার ধারণা (Inertia)',
            summary: 'বস্তুর স্থিতিজড়তা ও গতিজড়তার বাস্তব পরীক্ষা।',
          ),
          LessonChapter(
            timestampSeconds: 45,
            title: '২. দ্বিতীয় সূত্র: বল ও ভরবেগ (F = ma)',
            summary: 'বলের পরিমাপ ও ক্রিকেট বল ক্যাচের ঘাত হ্রাস।',
          ),
          LessonChapter(
            timestampSeconds: 100,
            title: '৩. তৃতীয় সূত্র ও রৈখিক ভরবেগ সংরক্ষণ',
            summary: 'বন্দুকের রিকয়েল ও রকেট উৎক্ষেপণের সূত্র।',
          ),
        ],
        keyPoints: const [
          'ভরবেগের একক kg·m/s এবং বলের একক Newton (N)',
          'ক্রিয়া ও প্রতিক্রিয়া দুটি ভিন্ন বস্তুর ওপর যুগপৎ প্রযুক্ত হয়',
          'বন্দুকের পশ্চাদপসরণ বেগ: V = - (m_bullet * v_bullet) / M_gun',
          'বাহ্যিক বল শূন্য হলে রৈখিক ভরবেগ সর্বদাই সংরক্ষিত থাকে'
        ],
        scriptText:
            'নমস্কার স্নেহের শিক্ষার্থীরা! আমি ড. অনন্যা রায়। আজকে আমরা অত্যন্ত সহজ ভাষায় পদার্থবিজ্ঞানের মূল ভিত্তি—নিউটনের গতির সূত্র ও ভরবেগের সংরক্ষণ নিয়ম বুঝব। '
            'প্রথম সূত্র বলছে: কোনো বস্তুর ওপর বাইরে থেকে বল প্রয়োগ না করলে স্থির বস্তু স্থির থাকবে এবং গতিশীল বস্তু সমবেগে সরলরেখায় চলবে। '
            'দ্বিতীয় সূত্র বলছে: F = dp/dt = m*a। এখান থেকেই আমরা বলের মান নির্ণয় করি। '
            'আর তৃতীয় সূত্র: প্রত্যেক ক্রিয়ার সমান ও বিপরীত প্রতিক্রিয়া আছে। মনে রাখবে, ক্রিয়া ও প্রতিক্রিয়া কখনোই একই বস্তুর ওপর কাজ করে না!',
        subtitles: const [
          SubtitleItem(startSeconds: 0, endSeconds: 6, text: 'নমস্কার স্নেহের শিক্ষার্থীরা! আমি ড. অনন্যা রায়।'),
          SubtitleItem(startSeconds: 7, endSeconds: 16, text: 'আজকে আমরা নিউটনের গতির সূত্রাবলী ও ভরবেগ সংরক্ষণ শিখব।'),
          SubtitleItem(startSeconds: 17, endSeconds: 30, text: 'প্রথম সূত্র অনুযায়ী, বাহ্যিক বল শূন্য হলে ত্বরণ শূন্য হয়।'),
          SubtitleItem(startSeconds: 31, endSeconds: 50, text: 'দ্বিতীয় সূত্রে বল ও ভরবেগের সমীকরণ: F = dp/dt = m * a।'),
          SubtitleItem(startSeconds: 51, endSeconds: 70, text: 'ক্রিকেট বল ধরার সময় হাত পেছনে নিয়ে ঘাত বল কমানো হয়।'),
          SubtitleItem(startSeconds: 71, endSeconds: 95, text: 'ক্রিয়া এবং প্রতিক্রিয়া দুটি ভিন্ন বস্তুর ওপর কাজ করে!'),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        isDownloaded: true,
        sizeMb: 14.8,
        viewCount: 1840,
        doubts: [
          DoubtItem(
            id: 'doubt_1',
            question: 'ক্রিয়া ও প্রতিক্রিয়া বল কেন একে অপরকে কাটাকাটি (cancel) করে না?',
            answerSummary: 'কারণ তারা দুটি আলাদা বস্তুর ওপর প্রযুক্ত হয়, একই বস্তুর ওপর নয়।',
            askedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      Lesson(
        id: 'lesson_photo_hi',
        title: 'प्रकाश संश्लेषण एवं हरित लवक चक्र',
        subject: 'Biology',
        grade: 'Class 10 / NCERT',
        teacherAvatar: rajesh,
        languageCode: 'hi',
        languageName: 'हिन्दी',
        teachingStyle: TeachingStyle.strictCoaching,
        durationSeconds: 180,
        videoUrl: 'https://vidyaguru.gov.in/demo/photosynthesis_hi.mp4',
        thumbnailUrl: 'https://vidyaguru.gov.in/thumbs/photo.jpg',
        chapters: const [
          LessonChapter(
            timestampSeconds: 0,
            title: '१. प्रकाशिक अभिक्रिया (Light Reactions)',
            summary: 'थाइलेकोइड झिल्ली में एटीपी और एनएडीपीएच का निर्माण।',
          ),
          LessonChapter(
            timestampSeconds: 60,
            title: '२. कैल्विन चक्र (Dark Reactions)',
            summary: 'स्ट्रोमा में कार्बन स्थिरीकरण और ग्लूकोज संश्लेषण।',
          ),
        ],
        keyPoints: const [
          'समीकरण: 6CO2 + 12H2O + प्रकाश -> C6H12O6 + 6O2 + 6H2O',
          'ऑक्सीजन जल के विखंडन (Photolysis of water) से मुक्त होती है',
          'क्लोरोफिल सूर्य के लाल एवं नीले प्रकाश को सर्वाधिक अवशोषित करता है'
        ],
        scriptText:
            'नमस्ते छात्रों! मैं प्रोफेसर राजेश शर्मा। आज हम प्रकाश संश्लेषण के सबसे महत्वपूर्ण चरणों को समझेंगे। परीक्षा में बार-बार पूछा जाता है कि ऑक्सीजन कहाँ से निकलती है? याद रखें, यह जल के प्रकाशीय अपघटन से निकलती है, कार्बन डाइऑक्साइड से नहीं!',
        subtitles: const [
          SubtitleItem(startSeconds: 0, endSeconds: 6, text: 'नमस्ते छात्रों! मैं प्रोफेसर राजेश शर्मा।'),
          SubtitleItem(startSeconds: 7, endSeconds: 15, text: 'आज हम प्रकाश संश्लेषण की क्रियाविधि समझेंगे।'),
          SubtitleItem(startSeconds: 16, endSeconds: 30, text: 'क्लोरोप्लास्ट के थाइलेकोइड में प्रकाशिक अभिक्रिया होती है।'),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isDownloaded: false,
        sizeMb: 16.2,
        viewCount: 2450,
      ),
      Lesson(
        id: 'lesson_quadratic_en',
        title: 'Quadratic Equations & Nature of Roots',
        subject: 'Mathematics',
        grade: 'Class 10 / CBSE',
        teacherAvatar: ananya,
        languageCode: 'en',
        languageName: 'English',
        teachingStyle: TeachingStyle.friendlySibling,
        durationSeconds: 140,
        videoUrl: 'https://vidyaguru.gov.in/demo/quadratics_en.mp4',
        thumbnailUrl: 'https://vidyaguru.gov.in/thumbs/quadratics.jpg',
        chapters: const [
          LessonChapter(
            timestampSeconds: 0,
            title: '1. Standard Quadratic Form & Sridhar Acharya',
            summary: 'Derivation of ax² + bx + c = 0.',
          ),
          LessonChapter(
            timestampSeconds: 50,
            title: '2. The Discriminant (D = b² - 4ac)',
            summary: 'Predicting real, equal, or imaginary roots.',
          ),
        ],
        keyPoints: const [
          'If D > 0, roots are real and unequal',
          'If D = 0, roots are real and equal (-b / 2a)',
          'If D < 0, roots are complex conjugates'
        ],
        scriptText:
            'Hey friends! Today let\'s master Quadratic Equations in 3 minutes. The entire behavior of the curve is ruled by one single value: the Discriminant D = b² - 4ac!',
        subtitles: const [
          SubtitleItem(startSeconds: 0, endSeconds: 6, text: 'Hey friends! Let us master Quadratic Equations.'),
          SubtitleItem(startSeconds: 7, endSeconds: 20, text: 'The discriminant D = b² - 4ac reveals the nature of roots.'),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isDownloaded: false,
        sizeMb: 12.4,
        viewCount: 980,
      ),
    ]);
  }
}
