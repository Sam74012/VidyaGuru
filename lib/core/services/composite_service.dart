import '../models/lesson.dart';

class CompositeResult {
  final String finalVideoUrl;
  final String thumbnailUrl;
  final int durationSeconds;
  final double fileSizeMb;
  final bool hasWatermark;
  final List<SubtitleItem> embeddedSubtitles;

  const CompositeResult({
    required this.finalVideoUrl,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.fileSizeMb,
    required this.hasWatermark,
    required this.embeddedSubtitles,
  });
}

abstract class CompositeService {
  Future<CompositeResult> composite({
    required String lipSyncedVideoUrl,
    required String audioTrackUrl,
    required List<SubtitleItem> subtitles,
    required String watermarkBadgeText,
    void Function(double progress)? onProgress,
  });
}
