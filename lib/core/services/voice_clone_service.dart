import '../config/app_config.dart';

class ClonedVoiceResult {
  final String audioUrl;
  final int durationSeconds;
  final double fidelityScore;
  final String speakerSampleId;
  final String languageCode;

  const ClonedVoiceResult({
    required this.audioUrl,
    required this.durationSeconds,
    required this.fidelityScore,
    required this.speakerSampleId,
    required this.languageCode,
  });
}

abstract class VoiceCloneService {
  Future<ClonedVoiceResult> cloneVoice({
    required String scriptText,
    required String voiceSampleUrl,
    required RegionalLanguage language,
    required TeachingStyle style,
    void Function(double progress)? onProgress,
  });
}
