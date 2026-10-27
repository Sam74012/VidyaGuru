class ConsentRecord {
  final String id;
  final String avatarId;
  final String avatarName;
  final String legalFullName;
  final String teacherEmailOrPhone;
  final String organizationName;
  final DateTime timestamp;
  final String readAloudPhrase;
  final String audioVerificationPath;
  final bool isAudioVerified;
  final bool termsAccepted;
  final bool privacyAccepted;
  final bool educationalUseOnlyAccepted;
  final String accessPermission; // 'public', 'class_only', 'private'
  final bool isRevoked;
  final DateTime? revokedAt;
  final String? revocationReason;

  const ConsentRecord({
    required this.id,
    required this.avatarId,
    required this.avatarName,
    required this.legalFullName,
    required this.teacherEmailOrPhone,
    required this.organizationName,
    required this.timestamp,
    required this.readAloudPhrase,
    required this.audioVerificationPath,
    required this.isAudioVerified,
    required this.termsAccepted,
    required this.privacyAccepted,
    required this.educationalUseOnlyAccepted,
    this.accessPermission = 'class_only',
    this.isRevoked = false,
    this.revokedAt,
    this.revocationReason,
  });

  bool get isValid =>
      termsAccepted &&
      privacyAccepted &&
      educationalUseOnlyAccepted &&
      isAudioVerified &&
      !isRevoked;

  ConsentRecord copyWith({
    String? id,
    String? avatarId,
    String? avatarName,
    String? legalFullName,
    String? teacherEmailOrPhone,
    String? organizationName,
    DateTime? timestamp,
    String? readAloudPhrase,
    String? audioVerificationPath,
    bool? isAudioVerified,
    bool? termsAccepted,
    bool? privacyAccepted,
    bool? educationalUseOnlyAccepted,
    String? accessPermission,
    bool? isRevoked,
    DateTime? revokedAt,
    String? revocationReason,
  }) {
    return ConsentRecord(
      id: id ?? this.id,
      avatarId: avatarId ?? this.avatarId,
      avatarName: avatarName ?? this.avatarName,
      legalFullName: legalFullName ?? this.legalFullName,
      teacherEmailOrPhone: teacherEmailOrPhone ?? this.teacherEmailOrPhone,
      organizationName: organizationName ?? this.organizationName,
      timestamp: timestamp ?? this.timestamp,
      readAloudPhrase: readAloudPhrase ?? this.readAloudPhrase,
      audioVerificationPath:
          audioVerificationPath ?? this.audioVerificationPath,
      isAudioVerified: isAudioVerified ?? this.isAudioVerified,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      educationalUseOnlyAccepted:
          educationalUseOnlyAccepted ?? this.educationalUseOnlyAccepted,
      accessPermission: accessPermission ?? this.accessPermission,
      isRevoked: isRevoked ?? this.isRevoked,
      revokedAt: revokedAt ?? this.revokedAt,
      revocationReason: revocationReason ?? this.revocationReason,
    );
  }
}
