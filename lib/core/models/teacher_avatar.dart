import 'package:flutter/material.dart';

class TeacherAvatar {
  final String id;
  final String name;
  final String title;
  final String specialty;
  final String photoUrl;
  final String voiceSampleUrl;
  final bool isPreset;
  final bool isCustom;
  final String? ownerId;
  final String permissions; // 'public', 'class_only', 'private'
  final bool consentVerified;
  final DateTime? consentDate;
  final List<String> supportedLanguages;
  final double rating;
  final int lessonsCount;
  final Color themeColor;
  final String bio;

  const TeacherAvatar({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.photoUrl,
    required this.voiceSampleUrl,
    this.isPreset = true,
    this.isCustom = false,
    this.ownerId,
    this.permissions = 'public',
    this.consentVerified = true,
    this.consentDate,
    required this.supportedLanguages,
    this.rating = 4.9,
    this.lessonsCount = 124,
    this.themeColor = const Color(0xFF1B2A6B),
    required this.bio,
  });

  TeacherAvatar copyWith({
    String? id,
    String? name,
    String? title,
    String? specialty,
    String? photoUrl,
    String? voiceSampleUrl,
    bool? isPreset,
    bool? isCustom,
    String? ownerId,
    String? permissions,
    bool? consentVerified,
    DateTime? consentDate,
    List<String>? supportedLanguages,
    double? rating,
    int? lessonsCount,
    Color? themeColor,
    String? bio,
  }) {
    return TeacherAvatar(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      specialty: specialty ?? this.specialty,
      photoUrl: photoUrl ?? this.photoUrl,
      voiceSampleUrl: voiceSampleUrl ?? this.voiceSampleUrl,
      isPreset: isPreset ?? this.isPreset,
      isCustom: isCustom ?? this.isCustom,
      ownerId: ownerId ?? this.ownerId,
      permissions: permissions ?? this.permissions,
      consentVerified: consentVerified ?? this.consentVerified,
      consentDate: consentDate ?? this.consentDate,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      rating: rating ?? this.rating,
      lessonsCount: lessonsCount ?? this.lessonsCount,
      themeColor: themeColor ?? this.themeColor,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'specialty': specialty,
      'photoUrl': photoUrl,
      'voiceSampleUrl': voiceSampleUrl,
      'isPreset': isPreset,
      'isCustom': isCustom,
      'ownerId': ownerId,
      'permissions': permissions,
      'consentVerified': consentVerified,
      'consentDate': consentDate?.toIso8601String(),
      'supportedLanguages': supportedLanguages,
      'rating': rating,
      'lessonsCount': lessonsCount,
      'bio': bio,
    };
  }

  factory TeacherAvatar.fromJson(Map<String, dynamic> json) {
    return TeacherAvatar(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      specialty: json['specialty'] as String,
      photoUrl: json['photoUrl'] as String,
      voiceSampleUrl: json['voiceSampleUrl'] as String? ?? '',
      isPreset: json['isPreset'] as bool? ?? true,
      isCustom: json['isCustom'] as bool? ?? false,
      ownerId: json['ownerId'] as String?,
      permissions: json['permissions'] as String? ?? 'public',
      consentVerified: json['consentVerified'] as bool? ?? true,
      consentDate: json['consentDate'] != null
          ? DateTime.parse(json['consentDate'] as String)
          : null,
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['en', 'hi', 'bn'],
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      lessonsCount: json['lessonsCount'] as int? ?? 12,
      bio: json['bio'] as String? ?? '',
    );
  }
}
