import '../models/consent.dart';
import '../services/consent_service.dart';

class MockConsentService implements ConsentService {
  static final MockConsentService _instance = MockConsentService._internal();
  factory MockConsentService() => _instance;
  MockConsentService._internal() {
    _initDefaultConsents();
  }

  final Map<String, ConsentRecord> _records = {};

  void _initDefaultConsents() {
    // Preset teacher verified consents
    final presets = [
      ConsentRecord(
        id: 'consent_ananya',
        avatarId: 'avatar_ananya',
        avatarName: 'Dr. Ananya Roy',
        legalFullName: 'Dr. Ananya Roy',
        teacherEmailOrPhone: 'ananya.roy.edu@vidyaguru.gov.in',
        organizationName: 'Jadavpur Higher Secondary & WBCHSE',
        timestamp: DateTime.now().subtract(const Duration(days: 45)),
        readAloudPhrase:
            'I, Dr. Ananya Roy, hereby authorize VidyaGuru to synthesize my facial likeness, voice timbre and pedagogical style exclusively for non-commercial educational instruction in regional languages.',
        audioVerificationPath: 'mock_audio_ananya_verified.wav',
        isAudioVerified: true,
        termsAccepted: true,
        privacyAccepted: true,
        educationalUseOnlyAccepted: true,
        accessPermission: 'public',
      ),
      ConsentRecord(
        id: 'consent_vikram',
        avatarId: 'avatar_vikram',
        avatarName: 'Prof. Rajesh Sharma',
        legalFullName: 'Rajesh K. Sharma',
        teacherEmailOrPhone: 'rajesh.sharma.kota@vidyaguru.gov.in',
        organizationName: 'Apex Science Institute, Kota',
        timestamp: DateTime.now().subtract(const Duration(days: 30)),
        readAloudPhrase:
            'I, Rajesh K. Sharma, hereby authorize VidyaGuru to synthesize my facial likeness and voice for STEM education.',
        audioVerificationPath: 'mock_audio_rajesh_verified.wav',
        isAudioVerified: true,
        termsAccepted: true,
        privacyAccepted: true,
        educationalUseOnlyAccepted: true,
        accessPermission: 'public',
      ),
    ];

    for (final c in presets) {
      _records[c.avatarId] = c;
    }
  }

  @override
  Future<bool> verifyAndRecordConsent(ConsentRecord consent) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Mandatory enforcement: must have audio verification & terms checked
    if (!consent.isAudioVerified ||
        !consent.termsAccepted ||
        !consent.privacyAccepted ||
        !consent.educationalUseOnlyAccepted) {
      return false;
    }

    _records[consent.avatarId] = consent;
    return true;
  }

  @override
  Future<List<ConsentRecord>> getAllConsents() async {
    return _records.values.toList();
  }

  @override
  Future<ConsentRecord?> getConsentForAvatar(String avatarId) async {
    return _records[avatarId];
  }

  @override
  Future<bool> revokeConsent({
    required String avatarId,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _records[avatarId];
    if (existing == null) return false;

    _records[avatarId] = existing.copyWith(
      isRevoked: true,
      revokedAt: DateTime.now(),
      revocationReason: reason,
    );
    return true;
  }

  @override
  Future<bool> isAvatarAuthorized(String avatarId) async {
    final record = _records[avatarId];
    if (record == null) return false;
    return record.isValid;
  }
}
