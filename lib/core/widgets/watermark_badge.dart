import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../theme/app_colors.dart';

/// Persistent transparent watermark overlay for AI-generated educational videos
class AiVideoWatermarkOverlay extends StatelessWidget {
  final String teacherName;
  final String languageName;

  const AiVideoWatermarkOverlay({
    super.key,
    required this.teacherName,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 14,
      left: 14,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'AI SYNTHESIZED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 1,
              height: 10,
              color: Colors.white24,
            ),
            const SizedBox(width: 6),
            Text(
              '${AppConfig.appName} • $languageName',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone pill badge for cards and previews
class AiGeneratedBadge extends StatelessWidget {
  final bool compact;

  const AiGeneratedBadge({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.aiBadgeBackground.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.aiBadgeBackground.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 13,
            color: AppColors.aiBadgeBackground,
          ),
          const SizedBox(width: 4),
          Text(
            compact ? 'AI Avatar' : 'AI-Synthesized Video',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.aiBadgeBackground,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
