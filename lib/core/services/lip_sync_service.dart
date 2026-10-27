class LipSyncResult {
  final String lipSyncedVideoUrl;
  final int totalFrames;
  final double visemeConfidence;

  const LipSyncResult({
    required this.lipSyncedVideoUrl,
    required this.totalFrames,
    required this.visemeConfidence,
  });
}

abstract class LipSyncService {
  Future<LipSyncResult> syncLips({
    required String videoBaseUrl,
    required String audioUrl,
    void Function(double progress)? onProgress,
  });
}
