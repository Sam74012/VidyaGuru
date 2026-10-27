class FaceSwapResult {
  final String renderedVideoBaseUrl;
  final String avatarId;
  final int frameCount;
  final double facialMeshAccuracy;

  const FaceSwapResult({
    required this.renderedVideoBaseUrl,
    required this.avatarId,
    required this.frameCount,
    required this.facialMeshAccuracy,
  });
}

abstract class FaceSwapService {
  Future<FaceSwapResult> swapFace({
    required String photoUrl,
    required String baseBodyTemplateId,
    void Function(double progress)? onProgress,
  });
}
