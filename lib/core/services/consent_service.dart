import '../models/consent.dart';

abstract class ConsentService {
  Future<bool> verifyAndRecordConsent(ConsentRecord consent);
  Future<List<ConsentRecord>> getAllConsents();
  Future<ConsentRecord?> getConsentForAvatar(String avatarId);
  Future<bool> revokeConsent({
    required String avatarId,
    required String reason,
  });
  Future<bool> isAvatarAuthorized(String avatarId);
}
