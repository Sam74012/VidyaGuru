import 'package:flutter/material.dart';

/// Central configuration for VidyaGuru application.
/// Allows rapid white-labeling and rebranding for education boards or state initiatives.
class AppConfig {
  AppConfig._();

  /// Easily rebrand the platform here
  static const String appName = 'VidyaGuru';
  static const String appNameIndic = 'विद्यागुरु';
  static const String appTagline = 'Personal AI Regional Explainer for Bharat';
  static const String appVersion = '1.0.0';
  
  /// Toggle between mock simulation services and live production AI endpoints
  static const bool useMockServices = true;

  /// High-priority government educational initiative badge
  static const String initiativeName = 'India Digital Education Mission';
}

/// Supported Indian Regional Languages with their native script representations.
class RegionalLanguage {
  final String code;
  final String englishName;
  final String nativeName;
  final String sampleGreeting;
  final String fontHint;

  const RegionalLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.sampleGreeting,
    required this.fontHint,
  });
}

class AppLanguages {
  AppLanguages._();

  static const List<RegionalLanguage> all = [
    RegionalLanguage(
      code: 'hi',
      englishName: 'Hindi',
      nativeName: 'हिन्दी',
      sampleGreeting: 'नमस्ते! आज हम समझेंगे...',
      fontHint: 'NotoSansDevanagari',
    ),
    RegionalLanguage(
      code: 'bn',
      englishName: 'Bengali',
      nativeName: 'বাংলা',
      sampleGreeting: 'নমস্কার! আজ আমরা সহজ ভাষায় শিখব...',
      fontHint: 'NotoSansBengali',
    ),
    RegionalLanguage(
      code: 'ta',
      englishName: 'Tamil',
      nativeName: 'தமிழ்',
      sampleGreeting: 'வணக்கம்! இன்று நாம் எளிதாக புரிந்துகொள்வோம்...',
      fontHint: 'NotoSansTamil',
    ),
    RegionalLanguage(
      code: 'te',
      englishName: 'Telugu',
      nativeName: 'తెలుగు',
      sampleGreeting: 'నమస్కారం! ఈరోజు మనం సులభంగా అర్థం చేసుకుందాం...',
      fontHint: 'NotoSansTelugu',
    ),
    RegionalLanguage(
      code: 'mr',
      englishName: 'Marathi',
      nativeName: 'मराठी',
      sampleGreeting: 'नमस्कार! आज आपण सोप्या भाषेत समजून घेऊ...',
      fontHint: 'NotoSansDevanagari',
    ),
    RegionalLanguage(
      code: 'gu',
      englishName: 'Gujarati',
      nativeName: 'ગુજરાતી',
      sampleGreeting: 'નમસ્તે! આજે આપણે સરળ ભાષામાં સમજીશું...',
      fontHint: 'NotoSansGujarati',
    ),
    RegionalLanguage(
      code: 'kn',
      englishName: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      sampleGreeting: 'ನಮಸ್ಕಾರ! ಇಂದು ನಾವು ಸುಲಭವಾಗಿ ಅರ್ಥಮಾಡಿಕೊಳ್ಳೋಣ...',
      fontHint: 'NotoSansKannada',
    ),
    RegionalLanguage(
      code: 'ml',
      englishName: 'Malayalam',
      nativeName: 'മലയാളം',
      sampleGreeting: 'നമസ്കാരം! ഇന്ന് നമുക്ക് എളുപ്പത്തിൽ പഠിക്കാം...',
      fontHint: 'NotoSansMalayalam',
    ),
    RegionalLanguage(
      code: 'pa',
      englishName: 'Punjabi',
      nativeName: 'ਪੰਜਾਬੀ',
      sampleGreeting: 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ! ਅੱਜ ਅਸੀਂ ਸੌਖੇ ਤਰੀਕੇ ਨਾਲ ਸਮਝਾਂਗੇ...',
      fontHint: 'NotoSansGurmukhi',
    ),
    RegionalLanguage(
      code: 'en',
      englishName: 'English',
      nativeName: 'English',
      sampleGreeting: 'Hello! Today we will understand...',
      fontHint: 'NotoSans',
    ),
  ];

  static RegionalLanguage getByCode(String code) {
    return all.firstWhere(
      (lang) => lang.code.toLowerCase() == code.toLowerCase(),
      orElse: () => all.first,
    );
  }
}

/// Teaching Styles supported by Teacher's Brain AI
enum TeachingStyle {
  warmTeacher(
    id: 'warm_teacher',
    label: 'Warm Teacher',
    indicLabel: 'স্নেহশীল শিক্ষক / स्नेही शिक्षक',
    description: 'Patient, encouraging, uses step-by-step clarity and positive reinforcement.',
    iconData: Icons.sentiment_very_satisfied_rounded,
    badgeColor: Color(0xFF10B981),
  ),
  strictCoaching(
    id: 'strict_coaching',
    label: 'Strict Coaching Sir / Ma\'am',
    indicLabel: 'কোচিং স্যার / सख्त कोचिंग सर',
    description: 'Exam-oriented, high-yield shortcuts, highlights traps, no-nonsense rigor.',
    iconData: Icons.military_tech_rounded,
    badgeColor: Color(0xFFEF4444),
  ),
  friendlySibling(
    id: 'friendly_sibling',
    label: 'Friendly Elder Sibling',
    indicLabel: 'বড় ভাই / दोस्त जैसा भैया-दीदी',
    description: 'Casual, relatable real-world analogies, youth-friendly, zero intimidation.',
    iconData: Icons.emoji_people_rounded,
    badgeColor: Color(0xFF3B82F6),
  ),
  storyMode(
    id: 'story_mode',
    label: 'Story Mode',
    indicLabel: 'গল্পের ছলে / कहानी विधा',
    description: 'Narrative storytelling, historical context, curiosity-driven exploration.',
    iconData: Icons.auto_stories_rounded,
    badgeColor: Color(0xFF8B5CF6),
  );

  final String id;
  final String label;
  final String indicLabel;
  final String description;
  final IconData iconData;
  final Color badgeColor;

  const TeachingStyle({
    required this.id,
    required this.label,
    required this.indicLabel,
    required this.description,
    required this.iconData,
    required this.badgeColor,
  });

  static TeachingStyle fromId(String id) {
    return TeachingStyle.values.firstWhere(
      (style) => style.id == id,
      orElse: () => TeachingStyle.warmTeacher,
    );
  }
}

/// User Roles in VidyaGuru
enum UserRole {
  student(
    id: 'student',
    title: 'Student',
    subtitle: 'Learn subjects in your regional language with personalized AI teacher videos',
    icon: Icons.school_rounded,
  ),
  teacher(
    id: 'teacher',
    title: 'Teacher / Educator',
    subtitle: 'Create & own your AI teaching avatar, share lessons with class codes, track student views',
    icon: Icons.record_voice_over_rounded,
  );

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const UserRole({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
