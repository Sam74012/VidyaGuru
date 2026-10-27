import 'package:flutter/material.dart';
import '../models/teacher_avatar.dart';
import '../theme/app_colors.dart';

class AvatarCircle extends StatelessWidget {
  final TeacherAvatar avatar;
  final double radius;
  final bool showVerifiedBadge;
  final bool isSelected;

  const AvatarCircle({
    super.key,
    required this.avatar,
    this.radius = 28,
    this.showVerifiedBadge = true,
    this.isSelected = false,
  });

  String _getInitials(String name) {
    final clean = name.replaceAll('Dr. ', '').replaceAll('Prof. ', '');
    final parts = clean.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first.substring(0, parts.first.length > 2 ? 2 : parts.first.length).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(avatar.name);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                avatar.themeColor,
                avatar.themeColor.withOpacity(0.8),
                AppColors.saffron.withOpacity(0.9),
              ],
            ),
            border: Border.all(
              color: isSelected ? AppColors.saffron : Colors.white,
              width: isSelected ? 3.0 : 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: avatar.themeColor.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: radius * 0.72,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        if (showVerifiedBadge && avatar.consentVerified)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
          ),
        if (!avatar.consentVerified)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
