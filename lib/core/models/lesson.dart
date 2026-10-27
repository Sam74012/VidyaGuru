import 'teacher_avatar.dart';
import '../config/app_config.dart';

class LessonChapter {
  final int timestampSeconds;
  final String title;
  final String summary;

  const LessonChapter({
    required this.timestampSeconds,
    required this.title,
    required this.summary,
  });

  String get formattedTime {
    final minutes = timestampSeconds ~/ 60;
    final seconds = timestampSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class SubtitleItem {
  final int startSeconds;
  final int endSeconds;
  final String text;

  const SubtitleItem({
    required this.startSeconds,
    required this.endSeconds,
    required this.text,
  });
}

class DoubtItem {
  final String id;
  final String question;
  final String answerSummary;
  final String? videoAnswerUrl;
  final DateTime askedAt;

  const DoubtItem({
    required this.id,
    required this.question,
    required this.answerSummary,
    this.videoAnswerUrl,
    required this.askedAt,
  });
}

class Lesson {
  final String id;
  final String title;
  final String subject;
  final String grade;
  final TeacherAvatar teacherAvatar;
  final String languageCode;
  final String languageName;
  final TeachingStyle teachingStyle;
  final int durationSeconds;
  final String videoUrl;
  final String? thumbnailUrl;
  final List<LessonChapter> chapters;
  final List<String> keyPoints;
  final String scriptText;
  final List<SubtitleItem> subtitles;
  final DateTime createdAt;
  final bool isDownloaded;
  final double sizeMb;
  final int viewCount;
  final List<DoubtItem> doubts;

  const Lesson({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.teacherAvatar,
    required this.languageCode,
    required this.languageName,
    required this.teachingStyle,
    required this.durationSeconds,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.chapters,
    required this.keyPoints,
    required this.scriptText,
    required this.subtitles,
    required this.createdAt,
    this.isDownloaded = false,
    this.sizeMb = 14.5,
    this.viewCount = 1420,
    this.doubts = const [],
  });

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  Lesson copyWith({
    String? id,
    String? title,
    String? subject,
    String? grade,
    TeacherAvatar? teacherAvatar,
    String? languageCode,
    String? languageName,
    TeachingStyle? teachingStyle,
    int? durationSeconds,
    String? videoUrl,
    String? thumbnailUrl,
    List<LessonChapter>? chapters,
    List<String>? keyPoints,
    String? scriptText,
    List<SubtitleItem>? subtitles,
    DateTime? createdAt,
    bool? isDownloaded,
    double? sizeMb,
    int? viewCount,
    List<DoubtItem>? doubts,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      grade: grade ?? this.grade,
      teacherAvatar: teacherAvatar ?? this.teacherAvatar,
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
      teachingStyle: teachingStyle ?? this.teachingStyle,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      chapters: chapters ?? this.chapters,
      keyPoints: keyPoints ?? this.keyPoints,
      scriptText: scriptText ?? this.scriptText,
      subtitles: subtitles ?? this.subtitles,
      createdAt: createdAt ?? this.createdAt,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      sizeMb: sizeMb ?? this.sizeMb,
      viewCount: viewCount ?? this.viewCount,
      doubts: doubts ?? this.doubts,
    );
  }
}
